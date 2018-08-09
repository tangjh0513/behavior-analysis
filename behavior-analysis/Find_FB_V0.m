function [FB,STATE] = Find_FB_V0(curvatures, worm_pos, Frame_Rate)
% using curvature to identify backward and forward

FORWARD = 0;
BACKWARD = 1;
PAUSE = 2;
PAUSE_THRESHOLD = 1; %pixels

% Set state
STATE.FORWARD = FORWARD;
STATE.BACKWARD = BACKWARD;
STATE.PAUSE = PAUSE;
STATE.PAUSE_THRESHOLD = PAUSE_THRESHOLD;

[Total_Num,~] = size(curvatures);
FB = zeros(Total_Num,1);
FB(:) = FORWARD;

% parameters setting
Time = 3;
window_size = floor(0.3*Frame_Rate);
Interval = 2*ceil(Time*Frame_Rate/2)+1;
BACKWARD_INTERVAL = Interval;
BACKWARD_COMBINE = 3*Interval;

% 采用Local的窗口计算该时间段内线虫的运动情况
for i=1:Interval:Total_Num-Interval
    lc = curvatures(i:i+Interval,:);
    fft_lc = abs(fftshift(fft2(lc)));
    [height,width] = size(fft_lc);
    fft_lc_window = fft_lc(floor(height/2)-window_size:floor(height/2)+window_size,...
        floor(width/2)-window_size:floor(width/2)+window_size);
    sorted_fft_lc = sort(fft_lc_window(:),'descend');
    [py,px] = find(fft_lc_window > sorted_fft_lc(6)+eps);
    p = polyfit(px,py,1);
    if p(1)>1.0e-3
        FB(i:i+Interval-1) = BACKWARD; %backward
    end
end

% backward 数据合并
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
pause_state = Find_Pause_State(worm_pos,Frame_Rate,PAUSE_THRESHOLD);
FB(pause_state == 1) = PAUSE;
end