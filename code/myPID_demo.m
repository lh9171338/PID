%% myPID_demo
clear,clc;
close all;

%% ��ʼ��С��
car.pose = struct('x', 0, 'y', 0, 'theta', 0);
car.velocity = struct('x', 0, 'y', 0, 'theta', 0);
car.duration = 0.1;
car.draw = struct('position', true, 'attitude', true);

%% ��ʼ��PID
pid.param = struct('KP', 1, 'KI', 0.5, 'KD', 0);
pid.last_error = inf;
pid.sigma_error = 0;
pid.duration = 0.1;

%% ��¼���Խ��
T = 10;
t = 0:pid.duration:T;
n = length(t);
output = zeros(1, n);
target = zeros(1, n);

%% Ŀ��λ��
targetpose = 1 * t + 1;
% targetpose(1:round(n / 2)) = targetpose(round(n / 2));

%% ����PID���ڿ���С��ǰ��ָ��λ��
figure;
axes = gca;
hp = [];
ha = [];
for i=1:n
    if ~isvalid(axes)
        break;
    end
    %% PID controller
    [pid, car.velocity.x] = myPID(pid, car.pose.x, targetpose(i));
    
    %% Save result
    output(i) = car.pose.x;
    target(i) = targetpose(i);
%     fprintf('time: %fs, pose: %f, %f, %f, velocity: %f, %f, %f\n', t(i), ...
%        car.pose.x, car.pose.y, car.pose.theta, ...
%        car.velocity.x, car.velocity.y, car.velocity.theta);
    %% Draw car
    for j=1:pid.duration / car.duration
        car = myCarMoving(car);
    end
%     [hp, ha] = myDrawCar(axes, car);
%     xlim([-5, 5]);
%     ylim([-5, 5]);
%     axis square;
%     grid on;
%     hold on;
%     
%     %% Pause
%     pause(car.duration);
%     if isvalid(ha)
%         delete(ha);
%     end
end

%% ��ʾPID���ڽ��
figure;
plot(t, output, 'b.-', t, target, 'r.-');
title(['KP: ', num2str(pid.param.KP), ' KI: ', num2str(pid.param.KI), ' KD: ', num2str(pid.param.KD)]);
figure;
plot(t, target - output, 'g.-');
title(['KP: ', num2str(pid.param.KP), ' KI: ', num2str(pid.param.KI), ' KD: ', num2str(pid.param.KD)]);