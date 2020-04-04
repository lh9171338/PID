%% myPD_demo
clear,clc;
close all;

%% 初始化无人机
drone = struct('F', 0, 'v', 0, 'z', 0, 'm', 1, 'duration', 0.01);

%% 初始化PID
pid.param = struct('KP', 5, 'KI', 0, 'KD', 4);
pid.last_error = inf;
pid.sigma_error = 0;
pid.duration = 0.1;

%% 记录测试结果
T = 10;
t = 0:pid.duration:T;
n = length(t);
output = zeros(1, n);
target = zeros(1, n);

%% 目标位置
targetpose = 5; 

%% 利用PID调节控制小车前往指定位置
for i=1:n
    %% PID controller
    [pid, drone.F] = myPID(pid, drone.z, targetpose);
    
    %% Save result
    output(i) = drone.z;
    target(i) = targetpose;
    %% Moving drone
    for j=1:pid.duration / drone.duration
        drone = myDroneMoving(drone);
    end
end

%% 显示PID调节结果
figure;
plot(t, output, 'b.-', t, target, 'r.-');
title(['KP: ', num2str(pid.param.KP), ' KI: ', num2str(pid.param.KI), ' KD: ', num2str(pid.param.KD)]);
figure;
plot(t, target - output, 'g.-');
title(['KP: ', num2str(pid.param.KP), ' KI: ', num2str(pid.param.KI), ' KD: ', num2str(pid.param.KD)]);
