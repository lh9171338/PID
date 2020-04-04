function drone = myDroneMoving(drone)
%MYCARMOVING - Car movement simulaition
%
%   drone = myDroneMoving(drone)
%
%   car(struct): 
%       'F':        (unit: N)
%       'a':        (uint: m/s^2)    
%       'v':        (uint: m/s)  
%       'z':        (uint: m)  
%       'm':        (uint: kg)    
%       'duration': (uint: s)

%% 参数检查
narginchk(1,1);
nargoutchk(1,1);

%% 无人机运动
% 计算加速度
drone.a = drone.F / drone.m;
% 加速度积分
drone.v = drone.v + drone.a * drone.duration;
% 速度积分
drone.z = drone.z + drone.v * drone.duration;

