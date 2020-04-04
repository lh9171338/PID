%% myCar_demo
clear,clc;
close all;

%% ��ʼ��С��
car.pose = struct('x', 0, 'y', 0, 'theta', 0);
car.velocity = struct('x', 0.5, 'y', 0, 'theta', 0.5);
car.duration = 0.1;
car.draw = struct('position', true, 'attitude', true);

%% ����С���˶������ƹ켣
figure;
axes = gca;
hp = [];
ha = [];
while true
    if ~isvalid(axes)
        break;
    end
    car = myCarMoving(car);
    [hp, ha] = myDrawCar(axes, car);
    xlim([-5, 5]);
    ylim([-5, 5]);
    axis square;
    grid on;
    hold on;
    pause(car.duration);
    if isvalid(ha)
        delete(ha);
    end
end
