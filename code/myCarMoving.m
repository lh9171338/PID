function car = myCarMoving(car)
%MYCARMOVING - Car movement simulaition
%
%   car = myCarMoving(car)
%
%   car(struct): 
%       'pose': 'x', 'y', 'theta'       (unit: m or rad)
%       'velocity': 'x', 'y', 'theta'   (uint: m/s or rad/s)       
%       'duration'                      (uint: s)
%       'draw': 'position', 'attitude'

%% 参数检查
narginchk(1,1);
nargoutchk(1,1);

%% 小车运动
% 获取上一时刻小车位置
x = car.pose.x;
y = car.pose.y;
theta = car.pose.theta;

% 获取小车当前速度
vx = car.velocity.x;
vy = car.velocity.y;
vth = car.velocity.theta;

% 计算小车运动增量
dt = car.duration;
dx = (vx * cos(theta) - vy * sin(theta)) * dt;
dy = (vx * sin(theta) + vy * cos(theta)) * dt;
dth = vth * dt;

% 计算小车当前位置
car.pose.x = x + dx;
car.pose.y = y + dy;
car.pose.theta = mod(theta + dth, 2 * pi);

