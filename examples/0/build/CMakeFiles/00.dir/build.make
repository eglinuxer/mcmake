# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.23

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /Applications/CMake.app/Contents/bin/cmake

# The command to remove a file.
RM = /Applications/CMake.app/Contents/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/eg/file/code/github/mcmake/examples/0

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/eg/file/code/github/mcmake/examples/0/build

# Include any dependencies generated for this target.
include CMakeFiles/00.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/00.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/00.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/00.dir/flags.make

CMakeFiles/00.dir/00.cpp.o: CMakeFiles/00.dir/flags.make
CMakeFiles/00.dir/00.cpp.o: ../00.cpp
CMakeFiles/00.dir/00.cpp.o: CMakeFiles/00.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/eg/file/code/github/mcmake/examples/0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/00.dir/00.cpp.o"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/00.dir/00.cpp.o -MF CMakeFiles/00.dir/00.cpp.o.d -o CMakeFiles/00.dir/00.cpp.o -c /Users/eg/file/code/github/mcmake/examples/0/00.cpp

CMakeFiles/00.dir/00.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/00.dir/00.cpp.i"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/eg/file/code/github/mcmake/examples/0/00.cpp > CMakeFiles/00.dir/00.cpp.i

CMakeFiles/00.dir/00.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/00.dir/00.cpp.s"
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/eg/file/code/github/mcmake/examples/0/00.cpp -o CMakeFiles/00.dir/00.cpp.s

# Object files for target 00
00_OBJECTS = \
"CMakeFiles/00.dir/00.cpp.o"

# External object files for target 00
00_EXTERNAL_OBJECTS =

00: CMakeFiles/00.dir/00.cpp.o
00: CMakeFiles/00.dir/build.make
00: CMakeFiles/00.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/eg/file/code/github/mcmake/examples/0/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable 00"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/00.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/00.dir/build: 00
.PHONY : CMakeFiles/00.dir/build

CMakeFiles/00.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/00.dir/cmake_clean.cmake
.PHONY : CMakeFiles/00.dir/clean

CMakeFiles/00.dir/depend:
	cd /Users/eg/file/code/github/mcmake/examples/0/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/eg/file/code/github/mcmake/examples/0 /Users/eg/file/code/github/mcmake/examples/0 /Users/eg/file/code/github/mcmake/examples/0/build /Users/eg/file/code/github/mcmake/examples/0/build /Users/eg/file/code/github/mcmake/examples/0/build/CMakeFiles/00.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/00.dir/depend
