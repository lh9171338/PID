//
// Created by lihao on 19-7-12.
//

#ifndef PROJECT_PID_H
#define PROJECT_PID_H

#include <iostream>
#include <ros/ros.h>

using namespace std;

namespace pc{

struct PidParam{
    double KP, KI, KD;
    double duration;
    double windup;
};

class Pid{

public: // Interface function
    void InitPid(PidParam pidparam);
    void InitPid(double _KP, double _KI, double _KD, double _duration, double _windup = 100.0);
    double CalcPid(double input, double target);

private: // Internal function

private: // Private variable
    double KP, KI, KD;
    double duration;
    double windup;

    double PItem, IItem, DItem;
    double last_error;
    double output;
    
    double current_time, last_time;
};
}


#endif //PROJECT_PID_H
