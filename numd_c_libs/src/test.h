#define NOMINMAX before #include "windows.h"

#ifndef xarray_ffi_H // include guard
#define xarray_ffi_H

#include<stdint.h>
#include<stdbool.h>

#if _WIN32
#include <windows.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif


typedef struct {
    double real;
    double imag;
} ComplexDouble;

typedef enum {
   DOUBLE,
   FLOAT,
   INT32,
   INT64,
   COMPLEX_DOUBLE
} DataType;

typedef struct {
    void* data;        // Pointer to the xarray data
    DataType type;    // Type of the xarray
} XArrayHandle;

typedef union {
    double d;
    float f;
    int32_t i32;
    int64_t i64;
    ComplexDouble cd;
} Number;

struct slice{
    int64_t start;
    int64_t stop;
    int64_t step;
    bool singleValue;
};

typedef struct slice slice;

#ifdef __cplusplus
extern "C" {
#endif
    FFI_PLUGIN_EXPORT XArrayHandle* create_xarray(int ndim, int64_t* shape, Number fill, DataType type);
    FFI_PLUGIN_EXPORT void delete_xarray(XArrayHandle* ptr);

    FFI_PLUGIN_EXPORT int get_ndim(XArrayHandle* array);
#ifdef __cplusplus
}
#endif

#endif
