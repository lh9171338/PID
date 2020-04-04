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


%% 参数检查
narginchk(3,3);
nargoutchk(2,2);

%% PID调节
% 计算误差及其积分、微分
last_error = pid.last_error;
current_error = target - input;
sigma_error = pid.sigma_error + current_error * pid.duration;  % 积分
delta_error = (current_error - last_error) / pid.duration;     % 微分
if isinf(delta_error)
    delta_error = 0;
end
% 获取PID参数
KP = pid.param.KP;
KI = pid.param.KI;
KD = pid.param.KD;
% 计算PID输出
output = KP * current_error + KI * sigma_error + KD * delta_error;
% 跟新状态
pid.last_error = current_error;
pid.sigma_error = sigma_error;


