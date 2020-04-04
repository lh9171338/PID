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

%% �������
narginchk(1,1);
nargoutchk(1,1);

%% С���˶�
% ��ȡ��һʱ��С��λ��
x = car.pose.x;
y = car.pose.y;
theta = car.pose.theta;

% ��ȡС����ǰ�ٶ�
vx = car.velocity.x;
vy = car.velocity.y;
vth = car.velocity.theta;

% ����С���˶�����
dt = car.duration;
dx = (vx * cos(theta) - vy * sin(theta)) * dt;
dy = (vx * sin(theta) + vy * cos(theta)) * dt;
dth = vth * dt;

% ����С����ǰλ��
car.pose.x = x + dx;
car.pose.y = y + dy;
car.pose.theta = mod(theta + dth, 2 * pi);

