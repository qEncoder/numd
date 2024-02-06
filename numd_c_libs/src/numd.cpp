#include "numd.h"

#include <vector>
#include <iostream>
#include <xtensor/xarray.hpp>
#include <xtensor/xhistogram.hpp>
#include <xtensor/xio.hpp>

#include <xtensor-fftw/basic.hpp>   // rfft, irfft
#include <xtensor-fftw/helper.hpp>  // rfftscale 

typedef xt::xarray<double> xarray;


FFI_PLUGIN_EXPORT void* create_xarray(int ndim, int64_t* shape, double fill){
    std::vector<size_t> _shape = {};
    for (size_t i = 0; i < ndim; i++){
        _shape.push_back(shape[i]);
    }

    xarray* new_arr = new xarray;
    *new_arr = xt::xarray<double>(_shape);
    new_arr->fill(fill);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void delete_xarray(void* ptr){
    xt::xarray<double>* xarray_ptr = static_cast<xt::xarray<double>*>(ptr);
    delete xarray_ptr;
}

FFI_PLUGIN_EXPORT int get_ndim(void* array){
    xarray* _array = static_cast<xarray *>(array);
    return _array->dimension();
}

FFI_PLUGIN_EXPORT int get_size(void* array){
    xarray* _array = static_cast<xarray *>(array);
    return _array->size();
}

FFI_PLUGIN_EXPORT void get_shape(void* array, int64_t* shape){
    xarray* _array = static_cast<xarray *>(array);

    for (size_t i = 0; i < _array->dimension(); i++){
        shape[i] = _array->shape(i);
    }
}

FFI_PLUGIN_EXPORT xt::xstrided_slice_vector generate_array_slices(slice* slices, int n_slices){
    xt::xstrided_slice_vector sv;
    for (size_t i = 0; i < n_slices; i++){
        if(slices[i].noRange == true){
            sv.push_back(slices[i].start);
        }else if (slices[i].start == 0 && slices[i].stop==-1) {
            sv.push_back( xt::all());
        }else{
            sv.push_back( xt::range(slices[i].start, slices[i].stop));
        }
    }
    return sv;
}

FFI_PLUGIN_EXPORT void reshape(void* array, int64_t* shape, int ndim){
    xarray* _array = static_cast<xarray *>(array);

    std::vector<size_t> new_shape = {};
    for (size_t i = 0; i < ndim; i++){
        new_shape.push_back(shape[i]);
    }

    _array->reshape(new_shape);
}

FFI_PLUGIN_EXPORT void* swapaxes(void* array, int axis1, int axis2){
    xarray* _array = static_cast<xarray *>(array);
    
    xarray* new_arr = new xarray;
    *new_arr = xt::swapaxes(*_array, axis1, axis2);
    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* flip(void* array, int axis){
    xarray* _array = static_cast<xarray *>(array);
    
    xarray* new_arr = new xarray;
    *new_arr = xt::flip(*_array, axis);
    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* slice_array(void* array, slice* slices, int n_slices){
    xarray* _array = static_cast<xarray *>(array);

    xt::xstrided_slice_vector sv = generate_array_slices(slices, n_slices);
    xarray* new_arr = new xarray;
    *new_arr = xt::strided_view(*_array, sv) + 0.0;

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void assign_array_to_slice(void* array, void* other_array, slice* slices, int n_slices){
    xarray* _array = static_cast<xarray *>(array);
    xarray* _other_array = static_cast<xarray *>(other_array);

    xt::xstrided_slice_vector sv = generate_array_slices(slices, n_slices);
    auto sliced_arr = xt::strided_view(*_array, sv);

    auto shape = sliced_arr.shape();
    if(std::equal(shape.begin(), shape.end(), _other_array->shape().begin()) ){
        std::copy(_other_array->begin(), _other_array->end(), sliced_arr.begin());
    }else{
        throw std::runtime_error("size of the array do not match");
    }

}

FFI_PLUGIN_EXPORT void assign_double_to_slice(void* array, double value, slice* slices, int n_slices){
    xarray* _array = static_cast<xarray *>(array);

    xt::xstrided_slice_vector sv = generate_array_slices(slices, n_slices);
    auto sliced_arr = xt::strided_view(*_array, sv);
    sliced_arr = value;
}

FFI_PLUGIN_EXPORT void* transpose(void* array){
    xarray* _array = static_cast<xarray *>(array);
    auto tranposed_array = xt::transpose(*_array);

    xarray* new_arr = new xarray;
    *new_arr = tranposed_array+0;

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* add_arrays(void* array_1, void* array_2){
    xarray* _array_1 = static_cast<xarray *>(array_1);
    xarray* _array_2 = static_cast<xarray *>(array_2);

    xarray* new_arr = new xarray;
    *new_arr = (*_array_1) + (*_array_2);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* add_double(void* array, double value){
    xarray* _array = static_cast<xarray *>(array);

    xarray* new_arr = new xarray;
    *new_arr = (*_array) + value;

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* substract_arrays(void* array_1, void* array_2){
    xarray* _array_1 = static_cast<xarray *>(array_1);
    xarray* _array_2 = static_cast<xarray *>(array_2);

    xarray* new_arr = new xarray;
    *new_arr = (*_array_1) - (*_array_2);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* substract_double(void* array, double value){
    xarray* _array = static_cast<xarray *>(array);

    xarray* new_arr = new xarray;
    *new_arr = (*_array) - value;

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* multiply_arrays(void* array_1, void* array_2){
    xarray* _array_1 = static_cast<xarray *>(array_1);
    xarray* _array_2 = static_cast<xarray *>(array_2);

    xarray* new_arr = new xarray;
    *new_arr = (*_array_1) * (*_array_2);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* multiply_double(void* array, double value){
    xarray* _array = static_cast<xarray *>(array);

    xarray* new_arr = new xarray;
    *new_arr = (*_array) * value;

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* divide_arrays(void* array_1, void* array_2){
    xarray* _array_1 = static_cast<xarray *>(array_1);
    xarray* _array_2 = static_cast<xarray *>(array_2);

    xarray* new_arr = new xarray;
    *new_arr = (*_array_1) / (*_array_2);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* divide_double(void* array, double value){
    xarray* _array = static_cast<xarray *>(array);

    xarray* new_arr = new xarray;
    *new_arr = (*_array) / value;

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void assign_flat(void* ptr, int idx, double value){
    xarray* xarray_ptr = static_cast<xarray*>(ptr);
    xarray_ptr->flat(idx) = value;
}

FFI_PLUGIN_EXPORT double return_flat(void* ptr, int idx){
    xarray* xarray_ptr = static_cast<xarray*>(ptr);
    return xarray_ptr->flat(idx);
}

FFI_PLUGIN_EXPORT void* mean(void* array, int64_t* axis, int n_axis){
    xarray* _array = static_cast<xarray *>(array);
    
    std::vector<int> myvec;
    for (size_t i = 0; i < n_axis; i++)
        myvec.push_back(axis[i]);

    xarray* new_arr = new xarray;
    *new_arr = xt::nanmean(*_array, myvec);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* min(void* array, int64_t* axis, int n_axis){
    xarray* _array = static_cast<xarray *>(array);
    
    std::vector<int> myvec;
    for (size_t i = 0; i < n_axis; i++)
        myvec.push_back(axis[i]);

    xarray* new_arr = new xarray;
    *new_arr = xt::amin(*_array, myvec);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* max(void* array, int64_t* axis, int n_axis){
    xarray* _array = static_cast<xarray *>(array);
    
    std::vector<int> myvec;
    for (size_t i = 0; i < n_axis; i++)
        myvec.push_back(axis[i]);

    xarray* new_arr = new xarray;
    *new_arr = xt::amax(*_array, myvec);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* nanmin(void* array, int64_t* axis, int n_axis){
    xarray* _array = static_cast<xarray *>(array);
    
    std::vector<int> myvec;
    for (size_t i = 0; i < n_axis; i++)
        myvec.push_back(axis[i]);

    xarray* new_arr = new xarray;
    *new_arr = xt::nanmin(*_array, myvec);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* nanmax(void* array, int64_t* axis, int n_axis){
    xarray* _array = static_cast<xarray *>(array);
    
    std::vector<int> myvec;
    for (size_t i = 0; i < n_axis; i++)
        myvec.push_back(axis[i]);

    xarray* new_arr = new xarray;
    *new_arr = xt::nanmax(*_array, myvec);

    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* normalize(void* array){
    xarray* _array = static_cast<xarray *>(array);
    xarray min = xt::nanmin(*_array);
    xarray max = xt::nanmax(*_array);

    double minVal = min.flat(0);
    double maxVal = max.flat(0);

    xarray* new_arr = new xarray;

    if (maxVal == minVal) {
        *new_arr = (*_array) - minVal;
    }else{
        *new_arr = ((*_array) - minVal) / (maxVal - minVal);
    }
    return static_cast<void *>(new_arr);
}
 
FFI_PLUGIN_EXPORT void* rfft(void* array){
    xarray* _array = static_cast<xarray *>(array);
    auto output = xt::fftw::rfft(*_array);

    xarray* new_arr = new xarray;
    *new_arr = xt::real(output);
    
    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* rfft2(void* array){
    xarray* _array = static_cast<xarray *>(array);
    auto output = xt::fftw::rfft2(*_array);

    xarray* new_arr = new xarray;
    *new_arr = xt::real(output);
    
    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void* rfftfreq(int64_t n, double d){
    xarray* new_arr = new xarray;
    *new_arr = xt::fftw::fftfreq(n, d);
    
    return static_cast<void *>(new_arr);
}

FFI_PLUGIN_EXPORT void print_array(void* array){
    xarray* _array = static_cast<xarray *>(array);
    std::cout << "contents of array" << std::endl;
    std::cout << *_array << std::endl;
}

FFI_PLUGIN_EXPORT histogram_pointers histogram(void* array, int nbins){
    xarray* _array = static_cast<xarray *>(array);

    xarray* count = new xarray;
    *count = xt::histogram(*_array, std::size_t(nbins));
    xarray* bin_edges = new xarray;
    *bin_edges = xt::histogram_bin_edges(*_array, std::size_t(nbins));

    histogram_pointers hist_pointers = histogram_pointers();
    hist_pointers.count = static_cast<void *>(count);
    hist_pointers.bin_edges = static_cast<void *>(bin_edges);

    return hist_pointers;
}