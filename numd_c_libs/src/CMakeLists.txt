cmake_minimum_required(VERSION 3.10)

set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "" FORCE)

project(numd_c_libs_library VERSION 0.0.1 LANGUAGES CXX C)

# header files for xtensor on OS X installed via brew.
include_directories(/opt/homebrew/opt/xtensor/include)
include_directories(/opt/homebrew/opt/fftw/include)

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

add_library(numd_c_libs SHARED "numd.cpp")

target_link_libraries(numd_c_libs xtensor xtensor::optimize)
if(WIN32)
  target_link_libraries(numd_c_libs libfftw3-3)
else()
  if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # make static link, easier for distribution in apple store.
    target_link_libraries(numd_c_libs ${CMAKE_CURRENT_SOURCE_DIR}/fftw/lib/libfftw3.a)
  else()
    target_link_libraries(numd_c_libs fftw3)
  endif()
  
endif()

target_compile_features (numd_c_libs PUBLIC cxx_std_17)

set_target_properties(numd_c_libs PROPERTIES
  LINKER_LANGUAGE CXX
  PUBLIC_HEADER numd.h
  OUTPUT_NAME "numd_c_libs"
)

target_compile_definitions(numd_c_libs PUBLIC DART_SHARED_LIB)

