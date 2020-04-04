########### 版本要求
cmake_minimum_required(VERSION 2.8.3)

########### 项目名称
project(drawpath)

########### 添加系统库
find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  geometry_msgs
  tf
  nav_msgs
)

catkin_package()

########### 添加头文件
include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)

########### 编译可执行文件
add_executable(drawpath src/main.cpp src/path.cpp)
target_link_libraries(drawpath ${catkin_LIBRARIES})