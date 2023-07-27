# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(numd_library VERSION 0.0.1 LANGUAGES CXX C)

# header files for xtensor on OS X installed via brew.
include_directories(/usr/local/Cellar/xtensor/0.24.6/include)
include_directories(/usr/local/Cellar/fftw/3.3.10_1/include)
link_directories(/usr/local/Cellar/fftw/3.3.10_1/lib)
# hearder file for xtensor-fftw are installed here
include_directories(~/.local/include/)

find_package(xtl REQUIRED)
find_package(xtensor REQUIRED)


add_library(numd SHARED
  "numd.cpp"
)

target_link_libraries(numd xtensor xtensor::optimize)
target_link_libraries(numd fftw3)

set_target_properties(numd PROPERTIES
  LINKER_LANGUAGE CXX
  PUBLIC_HEADER numd.h
  OUTPUT_NAME "numd"
)

target_compile_definitions(numd PUBLIC DART_SHARED_LIB)
