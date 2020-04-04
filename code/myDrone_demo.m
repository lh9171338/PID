%% myDrone_demo
clear,clc;
close all;

%% 初始化无人机
drone = struct('F', 1, 'v', 0, 'z', 0, 'm', 1, 'duration', 0.1);

%% 控制无人机运动
T = 5;
t = 0:drone.duration:T;
n = length(t);
z = zeros(1, n);
for i=1:n
    drone = myDroneMoving(drone);
    z(i) = drone.z;
end

%% 绘制结果
figure;
plot(zeros(1, n), z, 'r.', t, z, 'b.');
