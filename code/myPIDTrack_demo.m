%% myPIDTrack_demo
clear,clc;
close all;

%% 初始化小车
selfcar.pose = struct('x', 0, 'y', 0, 'theta', 0);
selfcar.velocity = struct('x', 0, 'y', 0, 'theta', 0);
selfcar.duration = 0.001;
selfcar.draw = struct('position', true, 'attitude', true);

targetcar.pose = struct('x', 5, 'y', 0, 'theta', 0);
targetcar.velocity = struct('x', 4, 'y', 0, 'theta', 1);
targetcar.duration = 0.001;
targetcar.draw = struct('position', true, 'attitude', true);

%% 初始化PID
KP = 5;
KI = 0.05;
KD = 0;
duration = 0.1;
pidX.param = struct('KP', KP, 'KI', KI, 'KD', KD);
pidX.last_error = inf;
pidX.sigma_error = 0;
pidX.duration = duration;
pidY.param = struct('KP', KP, 'KI', KI, 'KD', KD);
pidY.last_error = inf;
pidY.sigma_error = 0;
pidY.duration = duration;

%% 利用PID调节控制小车追踪另一小车
figure;
axes = gca;
while true
    if ~isvalid(axes)
        break;
    end
    %% PID controller
    [pidX, selfcar.velocity.x] = myPID(pidX, selfcar.pose.x, targetcar.pose.x);
    [pidY, selfcar.velocity.y] = myPID(pidY, selfcar.pose.y, targetcar.pose.y);

    %% Draw car
    for j=1:pidX.duration / selfcar.duration
        selfcar = myCarMoving(selfcar);
        targetcar = myCarMoving(targetcar);
    end
    [shp, sha] = myDrawCar(axes, selfcar);
    hold on;
    [thp, tha] = myDrawCar(axes, targetcar);
    xlim([-10, 20]);
    ylim([-10, 20]);
    axis square;
    grid on;
    hold on;
    
    %% Pause
    pause(selfcar.duration);
    if isvalid(sha)
        delete(sha);
    end
    if isvalid(tha)
        delete(tha);
    end    
end
