function [FB,STATE] = Find_FB_V1(worm_pos, head_direction, PAUSE_THRESHOLD, frame_rate)
% Find forward and backward by worm positions and heading direction
% Input parameters:
% worm_pos: nx2 array, worm positions. Each line is the position in one
% image, the position format is [y,x]
% head_direction: nx2 array, worm headding direction. Each line is the head
% direction in one image, the format is [\delta y, \delta x]
% PAUSE_THRESHOLD: pixels/s

FORWARD = 0;
BACKWARD = 1;
PAUSE = 2;

% Set state
STATE.FORWARD = FORWARD;
STATE.BACKWARD = BACKWARD;
STATE.PAUSE = PAUSE;
STATE.PAUSE_THRESHOLD = PAUSE_THRESHOLD;

% Get image frames
N = length(worm_pos);
crawl_direction = worm_pos(2:end,:) - worm_pos(1:end-1,:);
FB = zeros(N,1);% forward-backward state

Interval = 2*ceil(frame_rate/2)+1;
BACKWARD_COMBINE = Interval;
BACKWARD_INTERVAL = 2*Interval;

for i=1:N-1
    if sum(head_direction(i,:) .* crawl_direction(i,:)) > -eps
        FB(i+1) = FORWARD;
    else
        FB(i+1) = BACKWARD;
    end
end
FB(1) = FB(2);

% Filtering forward and backward state
% case 1： 如果相邻的两个backward间隔小于interval，则合并该backward
% case 2： 删除孤立且时常小于Interval的backward
while (1)
    Backward_Struc = State_Stat(FB);
    backward_num = size(Backward_Struc,1);
    if backward_num > 1
        for i=1:backward_num-1
            % 分析case 1
            if (Backward_Struc(i+1,1) - Backward_Struc(i,2)) < BACKWARD_COMBINE
                 FB(Backward_Struc(i,2):Backward_Struc(i+1,1)) = BACKWARD;
            end
        end
    end
    Current_Backward_Struc = State_Stat(FB);
    if ~State_Changed(Backward_Struc, Current_Backward_Struc)
        break;
    else
        Backward_Struc = Current_Backward_Struc;
    end
end
% processing case2
for i=1:size(Backward_Struc,1)
    if Backward_Struc(i,3) < BACKWARD_INTERVAL
        FB(Backward_Struc(i,1):Backward_Struc(i,2)) = FORWARD;
    end
end

% analyzing the state of pause. If the worm crawling length per second is less than
% several pixels, then we assume the worm pauses
pause_state = Find_Pause_State(worm_pos,frame_rate,PAUSE_THRESHOLD);
FB(pause_state == 1) = PAUSE;

end