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

%% �������
narginchk(1,1);
nargoutchk(1,1);

%% ���˻��˶�
% ������ٶ�
drone.a = drone.F / drone.m;
% ���ٶȻ���
drone.v = drone.v + drone.a * drone.duration;
% �ٶȻ���
drone.z = drone.z + drone.v * drone.duration;

