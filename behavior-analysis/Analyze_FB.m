function [forward_stat, backward_stat, pause_stat] = Analyze_FB(motion_state,STATE)
% Analyze the forward and backward time
% Input parameters:
% motion state: states of motion, that is, the sequence of forward,
% backward and pause
% STATE: indicator for forward, backward and pause
% 
% Output parameters:
% forward/backward/pause stat: contain 3 element, that is, duration(time),
% frequency, and percentage

FORWARD = STATE.FORWARD;
BACKWARD =STATE.BACKWARD;
PAUSE = STATE.PAUSE;

forward_num = 0;
backward_num = 0;
pause_num = 0;
Total_Num = length(motion_state);

for i=1:Total_Num-1
    if motion_state(i) == FORWARD && motion_state(i+1) ~= FORWARD
        forward_num = forward_num + 1;
    elseif motion_state(i) == BACKWARD && motion_state(i+1) ~= BACKWARD
        backward_num = backward_num + 1;
    elseif motion_state(i) == PAUSE && motion_state(i+1) ~= PAUSE
        pause_num = pause_num + 1;
    end
end

forward = zeros(forward_num+1,3);
backward = zeros(backward_num+1,3);
pause = zeros(pause_num+1,3);

forward_index = 0;
forward_time = 0;
backward_index = 0;
backward_time = 0;
pause_index = 0;
pause_time = 0;

for i=1:Total_Num
    if motion_state(i) == FORWARD
        forward_time = forward_time + 1;
        if (i == Total_Num) || (i < Total_Num && motion_state(i+1) ~= FORWARD)
            forward_index = forward_index + 1;
            forward(forward_index,1) = i - forward_time + 1;
            forward(forward_index,2) = i;
            forward(forward_index,3) = forward_time;
            forward_time = 0;
        end
    elseif motion_state(i) == BACKWARD
        backward_time = backward_time + 1;
        if (i == Total_Num) || (i < Total_Num && motion_state(i+1) ~= BACKWARD)
            backward_index = backward_index + 1;
            backward(backward_index,1) = i - backward_time + 1;
            backward(backward_index,2) = i;
            backward(backward_index,3) = backward_time;
            backward_time = 0;
        end
    elseif motion_state(i) == PAUSE
        pause_time = pause_time + 1;
        if (i == Total_Num) || (i < Total_Num && motion_state(i+1) ~= PAUSE)
            pause_index = pause_index + 1;
            pause(pause_index,1) = i - pause_time + 1;
            pause(pause_index,2) = i;
            pause(pause_index,3) = pause_time;
            pause_time = 0;
        end
    end
end
forward = forward(1:forward_index,:);
backward = backward(1:backward_index,:);
pause = pause(1:pause_index,:);

% calculate forward/backward/pause statistics
forward_stat.duration = forward(:,3);
forward_stat.percentage = sum(forward(:,3))/Total_Num;
forward_stat.freq = length(forward(:,3))/Total_Num;

backward_stat.duration = backward(:,3);
backward_stat.percentage = sum(backward(:,3))/Total_Num;
backward_stat.freq = length(backward(:,3))/Total_Num;

pause_stat.duration = pause(:,3);
pause_stat.percentage = sum(pause(:,3))/Total_Num;
pause_stat.freq = length(pause(:,3))/Total_Num;
end