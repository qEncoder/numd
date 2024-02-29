# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "numd_c_libs")
project(${PROJECT_NAME} LANGUAGES CXX)

# Invoke the build for native code shared with the other target platforms.
# This can be changed to accommodate different builds.
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")

set(numd_c_libs_bundled_libraries
  $<TARGET_FILE:numd_c_libs> "${CMAKE_CURRENT_SOURCE_DIR}/../src/c_lib/fftw/3.5.5/lib/libfftw3-3.dll"
  PARENT_SCOPE
)