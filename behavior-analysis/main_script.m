% Script Template
% Folder strcuture:
% Data_Folder
% .... images\      : Image Folder
% .... worm_region\ : Worm region Folder
% .... centerline\  : Centerline Folder
% .... backbone\    : Backbone Folder

% Read video
Read_Video;

% Segment worm region
Image_Folder = '';
Worm_Thres = 120;
Worm_Area = 7000;
Output_Folder = '';
Image_Num = length(dir([Image_Folder '*.tiff']));

worm_seg(Image_Folder, Worm_Thres, Worm_Area, Output_Folder);

% Calcuate and get worm centerline
WormRegion_Folder = '';
Backbone_Folder = '';
start_index = 0;
end_index = Image_Num-1;
Data_Folder = '';

Calcuate_Centerline(WormRegion_Folder, Backbone_Folder, start_index, end_index);
Get_Centerline(Data_Folder);

% Check centerline
DrawCenterline(Data_Folder);

% Data analysis
Centerline_Folder = '';
Frame_Rate = 10;

% %Load data
worm_pos_data = load([Data_Folder 'WormRegionPos.mat']);
worm_pos = worm_pos_data.worm_pos;
delta_time = 1/Frame_Rate;

% % calculate curvatures
curvatures = Worm_Curvatures(Centerline_Folder);
save([Data_Folder 'curvatures.mat'],'curvatures');

% Forward/Backward/Pause 识别及数据统计
head_direction = calc_head_direction(DataFolder);
[FB, STATE] = Find_FB_V1(worm_pos, head_direction, app.FRAME_RATE);
            [forward_stat, backward_stat, pause_stat] = Analyze_FB(FB,STATE);
save([Data_Folder 'forward_backward_pause_states.mat'],...
                'FB', 'STATE', 'delta_time', 'head_direction', 'worm_pos', ...
                'forward_stat', 'backward_stat', 'pasue_stat');
            
%  % calculate bending
bends = zeros(Image_Num,1);
for i=1:Image_Num
    data = load([Centerline_Folder num2str(i-1) '.mat']);
    centerline = data.centerline;
    bends(i) = CalculateWormBend(centerline);
end
save([Data_Folder 'bendings.mat'],'bends');

% % omega angle
[omega_angles,omega_state] = calc_omega_angle(Centerline_Folder, Frame_Rate);
save([Data_Folder 'omega_angles.mat'],'omega_angles','omega_state');

% % worm speed
worm_speed = sqrt(sum((worm_pos(2:end,:) - worm_pos(1:end-1,:)).^2,2))/delta_time;
backward_state = (FB == STATE.BACKWARD);
worm_speed(backward_state) = -worm_speed(backward_state);
save([Data_Folder 'worm_speed'], 'worm_speed');