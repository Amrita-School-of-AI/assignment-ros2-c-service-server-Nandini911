cmake_minimum_required(VERSION 3.8)
project(ros2_service)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(example_interfaces REQUIRED)

add_executable(server_node src/server_node.cpp)

ament_target_dependencies(
  server_node
  rclcpp
  example_interfaces
)

install(TARGETS
  server_node
  DESTINATION lib/${PROJECT_NAME}
)

ament_package()

