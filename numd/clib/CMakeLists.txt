# xtensor needs c++ > 17!
set (CMAKE_CXX_STANDARD 17) 

cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(xtensor_dart_ffi VERSION 0.0.1 LANGUAGES CXX C)

# header files for xtensor on OS X installed via brew.
include_directories(/usr/local/Cellar/xtensor/0.24.6/include)

include_directories(~/.local/include/)


find_package(xtl REQUIRED)
find_package(xtensor REQUIRED)

add_library(xtensor_dart_ffi
    SHARED
    xarray.cpp)

target_link_libraries(xtensor_dart_ffi xtensor xtensor::optimize)
target_link_libraries(xtensor_dart_ffi fftw3)

set_target_properties(xtensor_dart_ffi PROPERTIES
    LINKER_LANGUAGE CXX
    PUBLIC_HEADER xarray.h
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    OUTPUT_NAME "xtensor_dart_ffi"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Hex_Identity_ID_Goes_Here"
)