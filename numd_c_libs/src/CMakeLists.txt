cmake_minimum_required(VERSION 3.15)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_OSX_DEPLOYMENT_TARGET "10.11" CACHE STRING "Minimum macOS deployment version")
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
endif()

if(APPLE)
  set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64" CACHE STRING "Build architectures for macOS" FORCE)
endif()

project(numd_c_libs_library VERSION 0.0.1 LANGUAGES CXX C)

set(XTENSOR_VERSION "0.24.6")
set(XTL_VERSION "0.7.4")
set(FFTW_VERSION "3.5.5")

set(LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/c_lib")

if(WIN32)
  set(FFTW_LIB_NAME "${LIB_DIR}/fftw/${FFTW_VERSION}/lib/libfftw3-3.lib")
  list(APPEND CMAKE_PREFIX_PATH "${LIB_DIR}/xtl/${XTL_VERSION}/share/cmake/xtl"
                                "${LIB_DIR}/xtensor/${XTENSOR_VERSION}/share/cmake/xtensor")
elseif(APPLE)
  set(FFTW_LIB_NAME "${CMAKE_CURRENT_SOURCE_DIR}/fftw/lib/libfftw3.a")
else()
  set(FFTW_LIB_NAME "fftw3")
endif()

# Find required packages
find_package(xtl ${XTL_VERSION} REQUIRED)
find_package(xtensor ${XTENSOR_VERSION} REQUIRED COMPONENTS optimize)

# Create main library target
add_library(numd_c_libs SHARED numd.cpp)
# add_executable(numd_c_libs test.cpp)

# Define include directories
set(INCLUDE_DIRS
  ${LIB_DIR}/xtensor/${XTENSOR_VERSION}/include
  ${LIB_DIR}/xtl/${XTL_VERSION}/include
  ${LIB_DIR}/fftw/${FFTW_VERSION}/include
)

# Set the include directories for the target
target_include_directories(numd_c_libs PRIVATE ${INCLUDE_DIRS})

target_link_libraries(numd_c_libs
  PRIVATE
    xtensor
    xtensor::optimize
    ${FFTW_LIB_NAME}
)

# Set compile features and options
target_compile_features(numd_c_libs PRIVATE cxx_std_17)
target_compile_definitions(numd_c_libs PRIVATE DART_SHARED_LIB)

# what does this do?
if(MSVC)
  target_compile_options(numd_c_libs PRIVATE /W4)
else()
  target_compile_options(numd_c_libs PRIVATE -Wall -Wextra -Wpedantic)
endif()

set_target_properties(numd_c_libs PROPERTIES
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED ON
  CXX_EXTENSIONS OFF
  POSITION_INDEPENDENT_CODE ON
  PUBLIC_HEADER numd.h
  OUTPUT_NAME "numd_c_libs"
)

if(APPLE)
  set_target_properties(numd_c_libs PROPERTIES
    MACOSX_RPATH OFF
    BUILD_WITH_INSTALL_RPATH OFF
  )
endif()

# Custom clean targets
add_custom_target(extra_clean
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles
    COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_CURRENT_BINARY_DIR}/CMakeCache.txt
    COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_CURRENT_BINARY_DIR}/Makefile
    COMMAND ${CMAKE_COMMAND} -E remove ${CMAKE_CURRENT_BINARY_DIR}/cmake_install.cmake
)

add_custom_target(full_clean
    COMMAND ${CMAKE_COMMAND} -E echo "Performing full clean..."
    COMMAND ${CMAKE_COMMAND} --build . --target clean
    COMMAND ${CMAKE_COMMAND} --build . --target extra_clean
)