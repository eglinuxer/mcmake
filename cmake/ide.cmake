# ---------------------------------------------------------------------------------------
# IDE friendly
# ---------------------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.23 FATAL_ERROR)

set(MCMAKE_HEADERS_DIR "${CMAKE_CURRENT_LIST_DIR}/../include")

file(GLOB MCMAKE_TOP_HEADERS "${MCMAKE_HEADERS_DIR}/mcmake/*.h")
file(GLOB MCMAKE_INTERNAL_HEADERS "${MCMAKE_HEADERS_DIR}/mcmake/internal/*.h")

set(MCMAKE_ALL_HEADERS ${MCMAKE_TOP_HEADERS} ${MCMAKE_INTERNAL_HEADERS})

source_group("Header Files\\mcmake" FILES ${MCMAKE_TOP_HEADERS})
source_group("Header Files\\mcmake\\internal" FILES ${MCMAKE_INTERNAL_HEADERS})