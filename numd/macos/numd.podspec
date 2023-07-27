#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint numd.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'numd'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license  = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # s.library = 'c++'
  s.pod_target_xcconfig = {
       'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
       'HEADER_SEARCH_PATHS' => "/usr/local/Cellar/xtensor/0.24.6/include /usr/local/Cellar/fftw/3.3.10_1/include /Users/stephan/.local/include/",
       'LIBRARY_SEARCH_PATHS' => "/usr/local/Cellar/fftw/3.3.10_1/lib",
       'ARCHS' => "x86_64",
       'DEFINES_MODULE' => 'YES' 
  }
  s.libraries =  "fftw3"

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '13.00'
  # s.pod_target_xcconfig = {}
  s.swift_version = '5.0'
end
