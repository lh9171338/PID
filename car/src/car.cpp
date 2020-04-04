//
// Created by lihao on 19-7-12.
//

#include <iostream>
#include <cmath>
#include <ros/ros.h>
#include <tf/tf.h>
#include <geometry_msgs/Pose2D.h>
#include <geometry_msgs/Twist.h>
#include <nav_msgs/Odometry.h>


using namespace std;


//------------------------------- Define -------------------------------//
#define C_PI (double) 3.141592653589793
#define DEG2RAD(DEG) ((DEG)*((C_PI)/(180.0)))
#define RAD2DEG(RAD) ((RAD)*((180.0)/(C_PI)))


//------------------------------- Define object -------------------------------//
struct Car{
    geometry_msgs::Pose2D pose;
    geometry_msgs::Pose2D velocity;
    double duration;
};

//------------------------------- Global variable -------------------------------//
Car car;
string odom_frame;
string base_frame;

//------------------------------- Callback function -------------------------------//
void VelCallback(const geometry_msgs::Twist& msg)
{
    car.velocity.x = msg.linear.x;
    car.velocity.y = msg.linear.y;
    car.velocity.theta = msg.angular.z;
}

//------------------------------- Main function -------------------------------//
int main(int argc, char * argv[])
{
    // Initial node
    ros::init(argc, argv, "car");
    ros::NodeHandle nh;
    ros::NodeHandle nh_priv("~");
    ROS_INFO("Setup car node!");

    // Parameter
    nh_priv.param<string>("odom_frame", odom_frame, "odom");
    nh_priv.param<string>("base_frame", base_frame, "base_link");
    nh_priv.param<double>("x", car.pose.x, 0);      // Initial pose of car
    nh_priv.param<double>("y", car.pose.y, 0);
    nh_priv.param<double>("theta", car.pose.theta, 0);
    nh_priv.param<double>("vx", car.velocity.x, 0); // Initial velocity of car
    nh_priv.param<double>("vy", car.velocity.y, 0);
    nh_priv.param<double>("vth", car.velocity.theta, 0);
    nh_priv.param<double>("duration", car.duration, 0);

    // Subscribe velocity topic
    ros::Subscriber vel_sub = nh.subscribe("cmd_vel", 10, VelCallback);

    // Advertise odometry topic
    ros::Publisher odom_pub = nh.advertise<nav_msgs::Odometry>("odom", 10);

    // Loop
    while(ros::ok())
    {
        // Calculate the pose of the car
        double vx = car.velocity.x;
        double vy = car.velocity.y;
        double vth = car.velocity.theta;

        double dt = car.duration;

        double dx = (vx * cos(car.pose.theta) - vy * sin(car.pose.theta)) * dt;
        double dy = (vx * sin(car.pose.theta) + vy * cos(car.pose.theta)) * dt;
        double dth = vth * dt;

        car.pose.x += dx;
        car.pose.y += dy;
        car.pose.theta += dth;
        car.pose.theta = fmod(car.pose.theta, 2 * C_PI);

        // Publish odometry topic
        nav_msgs::Odometry odom;
        odom.header.stamp = ros::Time::now();
        odom.header.frame_id = odom_frame;

        odom.pose.pose.position.x = car.pose.x;
        odom.pose.pose.position.y = car.pose.y;
        odom.pose.pose.position.z = 0.0;
        odom.pose.pose.orientation =  tf::createQuaternionMsgFromYaw(car.pose.theta);

        odom.child_frame_id = base_frame;
        odom.twist.twist.linear.x = vx;
        odom.twist.twist.linear.y = vy;
        odom.twist.twist.angular.z = vth;

        odom_pub.publish(odom);

        // Sleep and wait for callback
        ros::Duration(car.duration).sleep();
        ros::spinOnce();
    }

    return 0;
}
