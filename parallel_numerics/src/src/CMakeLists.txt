cmake_minimum_required(VERSION 2.8)
project( mpi_test )

find_package(MPI REQUIRED)
include_directories(${MPI_INCLUDE_PATH})

set(FILES
	test1 
	test2 
	test3 
	tutorial3_ex5
	tutorial4_ex4
	tutorial4_ex5
)

foreach(file ${FILES})
    add_executable(${file} ${file}.cpp)
    target_link_libraries(${file} ${GLOG_LIBRARIES} ${MPI_LIBRARIES})
endforeach()
