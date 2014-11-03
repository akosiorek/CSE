project(Test)

# Compile gtest
add_subdirectory(gtest)
include_directories( ${gtest_INCLUDE_DIR} )

message(${gtest_INCLUDE_DIR})
message(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(test test.cpp)
target_link_libraries(test gtest_main)
add_custom_command(TARGET test POST_BUILD COMMAND test)
