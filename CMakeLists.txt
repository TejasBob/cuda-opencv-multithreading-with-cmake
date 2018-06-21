cmake_minimum_required(VERSION 3.8)
message(STATUS "CMake version: ${CMAKE_VERSION}")

project(test C CXX)

option(USE_CUDA "Use CUDA" ON)

file(GLOB cpu_source_files "${CMAKE_SOURCE_DIR}/src/*.cc")
file(GLOB gpu_source_files "${CMAKE_SOURCE_DIR}/src/*.cu")


# set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules)

add_compile_options(-std=c++11)
# add_compile_options(-pthread)

find_package(OpenCV HINTS "/home" "/home/joker/opencv-3.0.0/build/")

include_directories( ${OpenCV_INCLUDE_DIRS} )

if( ("${CMAKE_VERSION}" VERSION_EQUAL 3.8) OR
        ("${CMAKE_VERSION}" VERSION_GREATER 3.8) )
   
    message(STATUS "USING MODERN_CMAKE")

    # Modern CMake
    if(USE_CUDA)
        enable_language("CUDA")
        add_executable(test ${cpu_source_files} ${gpu_source_files})
        target_link_libraries(test ${OpenCV_LIBS})
    else()
        add_executable(test ${cpu_source_files} )
        target_link_libraries(test ${OpenCV_LIBS})
    endif()
else()
    # Old CMake
    add_executable(test ${cpu_source_files})
    if(USE_CUDA)
        find_package(CUDA 7.0)
        if(NOT CUDA_FOUND)
            message(STATUS "CUDA not found")
            set(USE_CUDA OFF)
        else()
            CUDA_ADD_LIBRARY(test_gpu ${gpu_source_files} )
            target_link_libraries(test test_gpu ${OpenCV_LIBS})
        endif()
    endif()
endif()

message(STATUS "USE_CUDA: ${USE_CUDA}")
if(USE_CUDA)
    add_definitions(-DUSE_CUDA)
endif()
