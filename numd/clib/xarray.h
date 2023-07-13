#ifndef xarray_ffi_H // include guard
#define xarray_ffi_H

#include <vector>
#include <iostream>
#include <xtensor/xarray.hpp>
#include <xtensor/xhistogram.hpp>
#include <xtensor/xio.hpp>

#include <xtensor-fftw/basic.hpp>   // rfft, irfft
#include <xtensor-fftw/helper.hpp>  // rfftscale 

typedef xt::xarray<double> xarray;

struct slice{
    int64_t start;
    int64_t stop;
    bool noRange;
};

struct histogram_pointers{
    void* count;
    void* bin_edges;
};

extern "C" {
    void* create_xarray(int ndim, int64_t* shape, double fill);
    void delete_xarray(void* ptr);

    int get_ndim(void* array);
    int get_size(void* array);
    void get_shape(void* array, int64_t* shape);

    void* slice_array(void* array, slice* slices, int n_slices);
    void assign_array_to_slice(void* array, void* other_array, slice* slices, int n_slices);
    void assign_double_to_slice(void* array, double value, slice* slices, int n_slices);

    void* transpose(void* array);
    void* add_arrays(void* array_1, void* array_2);
    void* add_double(void* array, double value);

    void* substract_arrays(void* array_1, void* array_2);
    void* substract_double(void* array, double value);

    void* multiply_arrays(void* array_1, void* array_2);
    void* multiply_double(void* array, double value);

    void* divide_arrays(void* array_1, void* array_2);
    void* divide_double(void* array, double value);

    void assign_flat(void* ptr, int idx, double value);
    double return_flat(void* ptr, int idx);

    void* mean(void* array, int64_t* axis, int n_axis);
    void* min(void* array, int64_t* axis, int n_axis);
    void* max(void* array, int64_t* axis, int n_axis);
    void* normalize(void* array);

    void* rfft(void* array);
    void* rfft2(void* array);
    void* rfftfreq(int64_t n, double d);

    histogram_pointers histogram(void* array, int nbins);

    
    void print_array(void* array);
}

#endif