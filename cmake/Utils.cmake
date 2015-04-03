#  Copyright (C) 2015 Oleksandr Dunayevskyy
#
#  This software is provided 'as-is', without any express or implied
#  warranty.  In no event will the authors be held liable for any damages
#  arising from the use of this software.
#
#  Permission is granted to anyone to use this software for any purpose,
#  including commercial applications, and to alter it and redistribute it
#  freely, subject to the following restrictions:
#
#  1. The origin of this software must not be misrepresented; you must not
#     claim that you wrote the original software. If you use this software
#     in a product, an acknowledgment in the product documentation would be
#     appreciated but is not required.
#  2. Altered source versions must be plainly marked as such, and must not be
#     misrepresented as being the original software.
#  3. This notice may not be removed or altered from any source distribution.


macro(GET_SOURCES target var)
   set(propName ${target}_SRCS)
   get_property(${var} GLOBAL PROPERTY ${propName})
endmacro()

macro(APPEND_SOURCES target )
   set(absoluteSrcs)
   foreach(itr ${ARGN})
      list(APPEND absoluteSrcs ${CMAKE_CURRENT_SOURCE_DIR}/${itr})
   endforeach()
   set(propName ${target}_SRCS)
   set_property(GLOBAL APPEND PROPERTY ${propName}  ${absoluteSrcs})
endmacro()

macro(GENERATE_GROUPS)
   set(kTop "[top]")      
   foreach(itr ${ARGN})
      set(pathOnly ${itr})
      
      # remove last slash and file name
      get_filename_component(pathOnly ${pathOnly} DIRECTORY)
      
      if(NOT pathOnly) # our item is only a filename
         set(pathOnly ${kTop})
      else()
         # replace current directory with kTop
         string(REPLACE ${CMAKE_CURRENT_SOURCE_DIR} ${kTop} pathOnly ${pathOnly})
      endif()
            
      # replace forward slashes with backward
      string(REPLACE "/" "\\" pathOnly ${pathOnly})
      
      #message(${itr}--- ${pathOnly})
      source_group(${pathOnly} FILES ${itr})
   endforeach()
endmacro()



# get the list of cpp files only from the list of sources
function(GetCppList resultVar)
  set(result)
  foreach(ITR ${ARGN})  # ARGN holds all arguments to function after last named one
    if(ITR MATCHES ".+cpp$")
      list(APPEND result ${ITR})
    endif()
  endforeach()
  set(${resultVar} ${result} PARENT_SCOPE)
endfunction()



macro(ADD_MSVC_PRECOMPILED_HEADER PrecompiledHeader PrecompiledSource SourcesVar)
   IF(MSVC)
      get_filename_component(PrecompiledBasename ${PrecompiledHeader} NAME_WE)
      set(PrecompiledBinary "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${PrecompiledBasename}.pch")
      GetCppList(Sources ${${SourcesVar}} )

      set_source_files_properties(${PrecompiledSource}
                                 PROPERTIES COMPILE_FLAGS "/Yc\"${PrecompiledHeader}\" /Fp\"${PrecompiledBinary}\""
                                 OBJECT_OUTPUTS "${PrecompiledBinary}")
      set_source_files_properties(${Sources}
                                 PROPERTIES COMPILE_FLAGS "/Yu\"${PrecompiledHeader}\" /FI\"${PrecompiledBinary}\" /Fp\"${PrecompiledBinary}\""
                                 OBJECT_DEPENDS "${PrecompiledBinary}")  
      # Add precompiled header to SourcesVar
      list(APPEND ${SourcesVar} ${PrecompiledSource})
   endif()
endmacro()  


macro(PRINT_LIST)
   foreach(itr ${ARGN})
      message(${itr})
   endforeach()
endmacro()

macro(LS)
   file(GLOB_RECURSE srcs ${ARGN}/*.h ${ARGN}/*.cpp )
   foreach(itr ${srcs})
      # strip absolute path
      string(REPLACE "${ARGN}/"  "" relativePath ${itr} )
      message(${relativePath})
   endforeach()
endmacro()

