
set(TARGET library)

append_sources(${TARGET}
   Lib.h
)

add_subdirectory(moduleA)
add_subdirectory(moduleB)

get_sources(${TARGET} SRCS)

generate_groups(${SRCS})

add_library(${TARGET} ${SRCS} )

