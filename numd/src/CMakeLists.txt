cmake_minimum_required(VERSION 3.10)

project(numd_library VERSION 0.0.1 LANGUAGES CXX C)

# header files for xtensor on OS X installed via brew.
include_directories(/usr/local/Cellar/xtensor/0.24.6/include)
include_directories(/usr/local/Cellar/fftw/3.3.10_1/include)
link_directories(/usr/local/Cellar/fftw/3.3.10_1/lib)

IF (WIN32)
  link_directories(${CMAKE_CURRENT_SOURCE_DIR}/c_lib/fftw/3.5.5/lib)

  include_directories(${CMAKE_CURRENT_SOURCE_DIR}/c_lib/xtensor/0.24.6/include)
  include_directories(${CMAKE_CURRENT_SOURCE_DIR}/c_lib/xtl/0.7.4/include)
  include_directories(${CMAKE_CURRENT_SOURCE_DIR}/c_lib/fftw/3.5.5/include)

  set(
      xtl_DIR
      ${CMAKE_CURRENT_SOURCE_DIR}/c_lib/xtl/0.7.4/share/cmake/xtl
      CACHE STRING "" FORCE
  )

  set(
      xtensor_DIR
      ${CMAKE_CURRENT_SOURCE_DIR}/c_lib/xtensor/0.24.6/share/cmake/xtensor
      CACHE STRING "" FORCE
  )


else()
  # hearder file for xtensor-fftw are installed here
  include_directories(~/.local/include/)
ENDIF()


find_package(xtl REQUIRED)
find_package(xtensor REQUIRED)

add_library(numd SHARED "numd.cpp")

target_link_libraries(numd xtensor xtensor::optimize)
if(WIN32)
  target_link_libraries(numd libfftw3-3)
else()
  target_link_libraries(numd fftw3)
endif()

target_compile_features (numd PUBLIC cxx_std_17)

set_target_properties(numd PROPERTIES
  LINKER_LANGUAGE CXX
  PUBLIC_HEADER numd.h
  OUTPUT_NAME "numd"
)

target_compile_definitions(numd PUBLIC DART_SHARED_LIB)
