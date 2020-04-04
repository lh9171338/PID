//
// Created by lihao on 19-7-12.
//

//
// Created by lihao on 19-7-12.
//

#include <iostream>
#include <ros/ros.h>
#include <tf/tf.h>
#include <nav_msgs/Odometry.h>
#include <geometry_msgs/Pose2D.h>
#include <geometry_msgs/Twist.h>
#include <geometry_msgs/Quaternion.h>
#include "pid.h"


using namespace std;

//------------------------------- Global variable -------------------------------//
geometry_msgs::Pose2D pose;
geometry_msgs::Pose2D target;
pc::PidParam pidparam0;
pc::PidParam pidparam1;
pc::PidParam pidparam2;
pc::Pid pid0;
pc::Pid pid1;
pc::Pid pid2;
double duration;

//------------------------------- Callback function -------------------------------//
void OdomCallback(const nav_msgs::Odometry& msg)
{
    double roll, pitch, yaw;
    geometry_msgs::Quaternion q = msg.pose.pose.orientation;
    tf::Quaternion quat(q.x, q.y, q.z, q.w); // x, y, z, w
    tf::Matrix3x3(quat).getRPY(roll, pitch, yaw);

    pose.x = msg.pose.pose.position.x;
    pose.y = msg.pose.pose.position.y;
    pose.theta = yaw;
}

void TargetCallback(const geometry_msgs::PoseStamped& msg)
{
    double roll, pitch, yaw;
    geometry_msgs::Quaternion q = msg.pose.orientation;
    tf::Quaternion quat(q.x, q.y, q.z, q.w); // x, y, z, w
    tf::Matrix3x3(quat).getRPY(roll, pitch, yaw);


    target.x = msg.pose.position.x;
    target.y = msg.pose.position.y;
    target.theta = yaw;
}

//------------------------------- Main function -------------------------------//
int main(int argc, char * argv[])
{
    // Initial node
    ros::init(argc, argv, "pidcontrol");
    ros::NodeHandle nh;
    ros::NodeHandle nh_priv("~");
    ROS_INFO("Setup pidcontrol node!");

    // Parameter
    nh_priv.param<double>("duration", duration, 0.1);
    nh_priv.param<double>("KP0", pidparam0.KP, 0);
    nh_priv.param<double>("KI0", pidparam0.KI, 0);
    nh_priv.param<double>("KD0", pidparam0.KD, 0);
    nh_priv.param<double>("KP1", pidparam1.KP, 0);
    nh_priv.param<double>("KI1", pidparam1.KI, 0);
    nh_priv.param<double>("KD1", pidparam1.KD, 0);
    nh_priv.param<double>("KP2", pidparam2.KP, 0);
    nh_priv.param<double>("KI2", pidparam2.KI, 0);
    nh_priv.param<double>("KD2", pidparam2.KD, 0);
    pidparam0.duration = pidparam1.duration = pidparam2.duration = duration;

    // Initial CPid
    pid0.InitPid(pidparam0);
    pid1.InitPid(pidparam1);
    pid2.InitPid(pidparam2);

    // Subscribe topics
    ros::Subscriber odom_sub = nh.subscribe("odom", 10, OdomCallback);
    ros::Subscriber target_sub = nh.subscribe("move_base_simple/goal", 10, TargetCallback);

    // Advertise odometry topic
    ros::Publisher vel_pub = nh.advertise<geometry_msgs::Twist>("cmd_vel", 10);

    // Loop
    while(ros::ok())
    {
        geometry_msgs::Twist twist;
        twist.linear.x = pid0.CalcPid(pose.x, target.x);
        twist.linear.y = pid1.CalcPid(pose.y, target.y);
        twist.angular.z = pid2.CalcPid(pose.theta, target.theta);

        vel_pub.publish(twist);

        // Sleep and wait for callback
        ros::Duration(duration).sleep();
        ros::spinOnce();
    }

    return 0;
}
