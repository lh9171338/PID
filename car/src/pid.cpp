//
// Created by lihao on 19-7-12.
//

#include "pid.h"


namespace pc{

void Pid::InitPid(PidParam pidparam)
{
    InitPid(pidparam.KP, pidparam.KI, pidparam.KD, pidparam.duration, pidparam.windup);
}

void Pid::InitPid(double _KP, double _KI, double _KD, double _duration, double _windup)
{
    KP = _KP;
    KI = _KI;
    KD = _KD;
    duration = _duration;
    windup = _windup;

    PItem = 0;
    IItem = 0;
    DItem = 0;
    last_error = 0;
    output = 0;

    current_time = ros::Time::now().toSec();
    last_time = current_time;
}

double Pid::CalcPid(double input, double target)
{
    // Calculate delta time
    current_time = ros::Time::now().toSec();
    double delta_time = current_time - last_time;

    if(delta_time >= duration)
    {
        // Calculate P item
        double error = target - input;
        PItem = error;
        ROS_INFO("error: %f", error);
        // Calculate I item
        IItem = IItem + error * delta_time;
        if(IItem > windup)
        {
            IItem = windup;
        }
        else if(IItem < -windup)
        {
            IItem = -windup;
        }
        // Calculate D item
        DItem = (error - last_error) / delta_time;

        // Calculate output
        output = KP * PItem + KI * IItem + KD * DItem;

        // Update
        last_error = error;
        last_time = current_time;
    }

    return output;
}

}