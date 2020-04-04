//
// Created by lihao on 19-7-12.
//


#include <iostream>
#include <ros/ros.h>
#include <nav_msgs/Odometry.h>
#include <geometry_msgs/Pose2D.h>
#include <geometry_msgs/Twist.h>
#include "pid.h"


using namespace std;

//------------------------------- Global variable -------------------------------//
geometry_msgs::Pose2D SelfPosition;
geometry_msgs::Pose2D TargetPosition;
pc::PidParam pidparam;
pc::Pid pidX;
pc::Pid pidY;

//------------------------------- Callback function -------------------------------//
void SelfPositionCallback(const nav_msgs::Odometry& msg)
{
    SelfPosition.x = msg.pose.pose.position.x;
    SelfPosition.y = msg.pose.pose.position.y;
}

void TargetPositionCallback(const nav_msgs::Odometry& msg)
{
    TargetPosition.x = msg.pose.pose.position.x;
    TargetPosition.y = msg.pose.pose.position.y;
}

//------------------------------- Main function -------------------------------//
int main(int argc, char * argv[])
{
    // Initial node
    ros::init(argc, argv, "pidtrack");
    ros::NodeHandle nh;
    ros::NodeHandle nh_priv("~");
    ROS_INFO("Setup pidtrack node!");

    // Parameter
    nh_priv.param<double>("KP", pidparam.KP, 0);
    nh_priv.param<double>("KI", pidparam.KI, 0);
    nh_priv.param<double>("KD", pidparam.KD, 0);
    nh_priv.param<double>("duration", pidparam.duration, 0.1);
    nh_priv.param<double>("windup", pidparam.windup, 20);

    // Initial Pid
    pidX.InitPid(pidparam);
    pidY.InitPid(pidparam);

    // Subscribe topics
    ros::Subscriber selfpos_sub = nh.subscribe("self/odom", 10, SelfPositionCallback);
    ros::Subscriber targetpos_sub = nh.subscribe("target/odom", 10, TargetPositionCallback);

    // Advertise odometry topic
    ros::Publisher vel_pub = nh.advertise<geometry_msgs::Twist>("self/cmd_vel", 10);

    // Loop 
    ros::Duration loop_duration(pidparam.duration);
    while(ros::ok())
    {
        geometry_msgs::Twist twist;
        twist.linear.x = pidX.CalcPid(SelfPosition.x, TargetPosition.x);
        twist.linear.y = pidY.CalcPid(SelfPosition.y, TargetPosition.y);
        twist.angular.z = 0;

        vel_pub.publish(twist);

        // Sleep and wait for callback
        loop_duration.sleep();
        ros::spinOnce();
    }

    return 0;
}
