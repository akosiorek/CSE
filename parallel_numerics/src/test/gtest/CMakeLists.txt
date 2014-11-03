project(gtest CXX C)
cmake_minimum_required(VERSION 2.6.2)

set(gtest_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../)
set(gtest_INCLUDE_DIR ${gtest_INCLUDE_DIR} PARENT_SCOPE)
include_directories(${gtest_INCLUDE_DIR})

find_package(Threads)

add_library(gtest gtest-all.cpp)
target_link_libraries(gtest 
    ${CMAKE_THREAD_LIBS_INIT}
    ${GLOG_LIBRARIES}
)


add_library(gtest_main gtest_main.cc)
target_link_libraries(gtest_main gtest)