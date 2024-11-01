#include "test.h"

#include <vector>
#include <cmath>
#include <iostream>
#include <xtensor/xarray.hpp>
#include <xtensor/xhistogram.hpp>
#include <xtensor/xio.hpp>
#include <complex>
#include <stdexcept>

#include <xtensor-fftw/basic.hpp>   // rfft, irfft
#include <xtensor-fftw/helper.hpp>  // rfftscale 

template<typename T>
struct TypeToDataType;

template<>
struct TypeToDataType<double> { static constexpr DataType value = DataType::DOUBLE; };

template<>
struct TypeToDataType<float> { static constexpr DataType value = DataType::FLOAT; };

template<>
struct TypeToDataType<int32_t> { static constexpr DataType value = DataType::INT32; };

template<>
struct TypeToDataType<int64_t> { static constexpr DataType value = DataType::INT64; };

template<>
struct TypeToDataType<std::complex<double>> { static constexpr DataType value = DataType::COMPLEX_DOUBLE; };

template <typename T>
xt::xarray<T>* handle_to_xarray_ptr(XArrayHandle* handle) {
    if (!handle || !handle->data) {
        throw std::runtime_error("Null handle or data in handle_to_xarray_ptr");
    }
    if (handle->type != TypeToDataType<T>::value) {
        throw std::runtime_error("Type mismatch in handle_to_xarray_ptr");
    }
    return static_cast<xt::xarray<T>*>(handle->data);
}

template <typename T>
XArrayHandle* xarray_ptr_to_handle(xt::xarray<T>* xarray_ptr) {
    XArrayHandle* handle = new XArrayHandle;
    handle->data = static_cast<void *>(xarray_ptr);
    handle->type = TypeToDataType<T>::value;
    return handle;
}

template <typename T>
XArrayHandle* create_xarray_templated(int ndim, int64_t* shape, T fill){
    std::vector<size_t> _shape(shape, shape + ndim);
    xt::xarray<T>* new_arr = new xt::xarray<T>;
    *new_arr = xt::xarray<T>(_shape);
    new_arr->fill(fill);

    return xarray_ptr_to_handle<T>(new_arr);
}

FFI_PLUGIN_EXPORT XArrayHandle* create_xarray(int ndim, int64_t* shape, Number fill, DataType type){
    switch (type){
        case DataType::DOUBLE: return create_xarray_templated<double>(ndim, shape, fill.d);
        case DataType::FLOAT: return create_xarray_templated<float>(ndim, shape, fill.f);
        case DataType::INT32: return create_xarray_templated<int32_t>(ndim, shape, fill.i32);
        case DataType::INT64: return create_xarray_templated<int64_t>(ndim, shape, fill.i64);
        case DataType::COMPLEX_DOUBLE:
            return create_xarray_templated<std::complex<double>>(ndim, shape, std::complex<double>(fill.cd.real, fill.cd.imag));
        default:
            throw std::runtime_error("Unsupported number type");
    }
}

template <typename T>
void delete_xarray_templated(XArrayHandle* handle){
    xt::xarray<T>* xarray_ptr = handle_to_xarray_ptr<T>(handle);
    delete xarray_ptr;
    delete handle;
}

FFI_PLUGIN_EXPORT void delete_xarray(XArrayHandle* handle){
    switch (handle->type){
        case DataType::DOUBLE: delete_xarray_templated<double>(handle);
        case DataType::FLOAT: delete_xarray_templated<float>(handle);
        case DataType::INT32: delete_xarray_templated<int32_t>(handle);
        case DataType::INT64: delete_xarray_templated<int64_t>(handle);
        case DataType::COMPLEX_DOUBLE: delete_xarray_templated<std::complex<double>>(handle);
    }
}

template <typename T>
int get_ndim_templated(XArrayHandle* handle){
    xt::xarray<T>* xarray_ptr = handle_to_xarray_ptr<T>(handle);
    return xarray_ptr->dimension();
}

FFI_PLUGIN_EXPORT int get_ndim(XArrayHandle* handle){
    switch (handle->type){
        case DataType::DOUBLE: return get_ndim_templated<double>(handle);
        case DataType::FLOAT: return get_ndim_templated<float>(handle);
        case DataType::INT32: return get_ndim_templated<int32_t>(handle);
        case DataType::INT64: return get_ndim_templated<int64_t>(handle);
        case DataType::COMPLEX_DOUBLE: return get_ndim_templated<std::complex<double>>(handle);
    }
}

template <typename T1, typename T2>
XArrayHandle* add_arrays_template_T1_T2(XArrayHandle* handle_1,  XArrayHandle* handle_2){
    using ResultType = typename std::common_type<T1, T2>::type;

    xt::xarray<T1>* array_1 = handle_to_xarray_ptr<T1>(handle_1);
    xt::xarray<T2>* array_2 = handle_to_xarray_ptr<T2>(handle_2);

    xt::xarray<ResultType>* new_arr = new xt::xarray<ResultType>((*array_1) + (*array_2));

    return xarray_ptr_to_handle<ResultType>(new_arr);
}

template <typename T1>
XArrayHandle* add_arrays_template_T1(XArrayHandle* handle_1,  XArrayHandle* handle_2){
    switch (handle_2->type){
        case DataType::DOUBLE: return add_arrays_template_T1_T2<T1, double>(handle_1, handle_2);
        case DataType::FLOAT: return add_arrays_template_T1_T2<T1, float>(handle_1, handle_2);
        case DataType::INT32: return add_arrays_template_T1_T2<T1, int32_t>(handle_1, handle_2);
        case DataType::INT64: return add_arrays_template_T1_T2<T1, int64_t>(handle_1, handle_2);
        case DataType::COMPLEX_DOUBLE: return add_arrays_template_T1_T2<T1, std::complex<double>>(handle_1, handle_2);
    }
}

FFI_PLUGIN_EXPORT XArrayHandle* add_arrays(XArrayHandle* handle_1,  XArrayHandle* handle_2){
    switch (handle_1->type){
        case DataType::DOUBLE: return add_arrays_template_T1<double>(handle_1, handle_2);
        case DataType::FLOAT: return add_arrays_template_T1<float>(handle_1, handle_2);
        case DataType::INT32: return add_arrays_template_T1<int32_t>(handle_1, handle_2);
        case DataType::INT64: return add_arrays_template_T1<int64_t>(handle_1, handle_2);
        case DataType::COMPLEX_DOUBLE: return add_arrays_template_T1<std::complex<double>>(handle_1, handle_2);
    }
}

// make main function to test the library

// Function definition
void greetUser(const std::string& name) {
    std::cout << "Hello, " << name << "! Welcome to the C++ program." << std::endl;
}


int main(int argc, char* argv[]) {
    // Check if a name was provided as a command-line argument
    // if (argc < 2) {
    //     std::cerr << "Usage: " << argv[0] << " <name>" << std::endl;
    //     return 1; // Return a non-zero value to indicate an error
    // }

    Number number;
    number.d = 3.14;

    int ndim = 1;
    auto shape = new int64_t[ndim];
    shape[0] = 5;

    xt::xarray<std::complex<float>>> a1 = {{1., 2., 3.}, {4., 5., 6.}};
    xt::xarray<int> a2 = {{1, 2, 3}, {1, 5, 6}};

    auto a3 = a1 + a2;
    std::cout << a3 << std::endl;


    using ResultType = typename std::common_type<int, std::complex<float>>::type;
    std::cout << typeid(ResultType).name() << std::endl;
    std::cout << typeid(std::complex<double>).name() << std::endl;


    // XArrayHandle* arr = create_xarray(1, shape, number, DataType::DOUBLE);
    // std::cout << "got array of type: " << arr->type << std::endl;
    // std::cout << get_ndim(arr) << std::endl;
    // std::cout << get_ndim(arr) << std::endl;
    // DataType type = DataType::DOUBLE;

    // double value = _convert_number_to_cpp_type(number, type);

    // std::cout << "Converted value: " << value << std::endl;

    // // Capture the user's name from command-line arguments
    // std::string name = argv[1];

    // // Call a function to greet the user
    // greetUser(name);

    return 0; // Indicate successful execution
}