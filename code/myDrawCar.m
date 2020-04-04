function [hp, ha] = myDrawCar(axes, car)
%MYDRAWCAR - Draw car's pose
%
%   myDrawCar(car)
%   [hp, ha] = myDrawCar(axes, car)
%
%   car(struct): 
%       'pose': 'x', 'y', 'theta'       (unit: m or rad)
%       'velocity': 'x', 'y', 'theta'   (uint: m/s or rad/s)       
%       'duration'                      (uint: s)
%       'draw': 'position', 'attitude'

%% 绘制小车位置矢量
if ~isvalid(axes)
    return;
end
hp = [];
ha = [];

x = car.pose.x;
y = car.pose.y;
theta = car.pose.theta;
length = 1;
u = length * cos(theta);
v = length * sin(theta);

if car.draw.position
    hp = plot(x, y, 'b.', 'MarkerSize', 10);
end
hold on;
if car.draw.attitude
    ha = quiver(axes, x, y, u, v, 'Color', [1,0,0], 'LineWidth',2);
end
hold off;


