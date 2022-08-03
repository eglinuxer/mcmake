cmake_minimum_required(VERSION 3.23 FATAL_ERROR)

project(study_cmake
    VERSION 0.0.1
    DESCRIPTION "cmake study project"
    HOMEPAGE_URL "公众号: eglinux"
    LANGUAGES CXX
)

# need pass arg --log-context to cmake
list(APPEND CMAKE_MESSAGE_CONTEXT Top)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR
      "\n"
      "In-source builds are not allowed.\n"
      "Instead, provide a path to build tree like so:\n"
      "cmake -S . -B <destination>\n"
      "\n"
      "To remove files you accidentally created execute:\n"
      "please delete CMakeFiles and CMakeCache.txt\n"
    )
endif()

# Set globle c++ standard.
# You can override it on a per-target basis if needed, like so:
# set_property(TARGET <target> PROPERTY CXX_STANDARD <standard>)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# If your compiler supports interprocedural optimization
# set CMAKE_INTERPROCEDURAL_OPTIMIZATION to True
include(CheckIPOSupported) 
check_ipo_supported(RESULT ipo_supported)
if(ipo_supported)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION True)
endif()