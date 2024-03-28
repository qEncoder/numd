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



struct slice{
    int64_t start;
    int64_t stop;
    bool noRange;
};

typedef struct slice slice;

#ifdef __cplusplus
extern "C" {
#endif
    FFI_PLUGIN_EXPORT void* create_xarray(int ndim, int64_t* shape, double fill);
    FFI_PLUGIN_EXPORT void delete_xarray(void* ptr);

    FFI_PLUGIN_EXPORT int get_ndim(void* array);
    FFI_PLUGIN_EXPORT int get_size(void* array);
    FFI_PLUGIN_EXPORT void get_shape(void* array, int64_t* shape);

    FFI_PLUGIN_EXPORT void reshape(void* array, int64_t* shape, int ndim);
    FFI_PLUGIN_EXPORT void* swapaxes(void* array, int axis1, int axis2);
    FFI_PLUGIN_EXPORT void* flip(void* array, int axis);
    
    FFI_PLUGIN_EXPORT void* slice_array(void* array, slice* slices, int n_slices);
    FFI_PLUGIN_EXPORT void assign_array_to_slice(void* array, void* other_array, slice* slices, int n_slices);
    FFI_PLUGIN_EXPORT void assign_double_to_slice(void* array, double value, slice* slices, int n_slices);

    FFI_PLUGIN_EXPORT void* transpose(void* array);
    FFI_PLUGIN_EXPORT void* add_arrays(void* array_1, void* array_2);
    FFI_PLUGIN_EXPORT void* add_double(void* array, double value);

    FFI_PLUGIN_EXPORT void* substract_arrays(void* array_1, void* array_2);
    FFI_PLUGIN_EXPORT void* substract_double(void* array, double value);

    FFI_PLUGIN_EXPORT void* multiply_arrays(void* array_1, void* array_2);
    FFI_PLUGIN_EXPORT void* multiply_double(void* array, double value);

    FFI_PLUGIN_EXPORT void* divide_arrays(void* array_1, void* array_2);
    FFI_PLUGIN_EXPORT void* divide_double(void* array, double value);

    FFI_PLUGIN_EXPORT void assign_flat(void* ptr, int idx, double value);
    FFI_PLUGIN_EXPORT double return_flat(void* ptr, int idx);

    FFI_PLUGIN_EXPORT void* mean(void* array, int64_t* axis, int n_axis);
    FFI_PLUGIN_EXPORT void* min(void* array, int64_t* axis, int n_axis);
    FFI_PLUGIN_EXPORT void* max(void* array, int64_t* axis, int n_axis);
    FFI_PLUGIN_EXPORT void* nanmean(void* array, int64_t* axis, int n_axis);
    FFI_PLUGIN_EXPORT void* nanmin(void* array, int64_t* axis, int n_axis);
    FFI_PLUGIN_EXPORT void* nanmax(void* array, int64_t* axis, int n_axis);
    FFI_PLUGIN_EXPORT void* normalize(void* array);

    FFI_PLUGIN_EXPORT void* rfft(void* array);
    FFI_PLUGIN_EXPORT void* rfft2(void* array);
    FFI_PLUGIN_EXPORT void* rfftfreq(int64_t n, double d);

    FFI_PLUGIN_EXPORT void* histogram_bin_edges(void* array, int nbins);
    FFI_PLUGIN_EXPORT void* histogram_count(void* data, void* bin_edges);
    FFI_PLUGIN_EXPORT void* histogram_count_lin_bins(void* data, double min, double max, int nbins);

    FFI_PLUGIN_EXPORT void print_array(void* array);
#ifdef __cplusplus
}
#endif

#endif