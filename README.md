# CMakeUtils
Helpful macros for CMake

##append_sources(), get_sources():
Add source files in subdirectories to the target.
No need to create temporary static libraries or object libraries.
File list is specified in the CMakeLists.txt of each subdirectory.

##generate_groups()
Call source_group for the files collected with append_sources to get a nice tree structure in a solution view

![Source Groups](https://raw.github.com/aldn/CMakeUtils/master/docs/CmakeUtilVSSolutionExplorer.png)
