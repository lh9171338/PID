function [pid, output] = myPID(pid, input, target)
%MYPID - PID controller
%
%   [pid, output] = myPID(pid, input, target)
%
%   pid(struct): 
%       'param': 'KP', 'KI', 'KD'       
%       'last_error'     
%       'sigma_error'
%       'duration'


%% �������
narginchk(3,3);
nargoutchk(2,2);

%% PID����
% ����������֡�΢��
last_error = pid.last_error;
current_error = target - input;
sigma_error = pid.sigma_error + current_error * pid.duration;  % ����
delta_error = (current_error - last_error) / pid.duration;     % ΢��
if isinf(delta_error)
    delta_error = 0;
end
% ��ȡPID����
KP = pid.param.KP;
KI = pid.param.KI;
KD = pid.param.KD;
% ����PID���
output = KP * current_error + KI * sigma_error + KD * delta_error;
% ����״̬
pid.last_error = current_error;
pid.sigma_error = sigma_error;


