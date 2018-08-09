function [omega_angles,omega_state] = calc_omega_angle(Centerline_Folder,Frame_Rate)
% Calculate omega angle by centerline

OMEGA_THRES = 45; % if the worm bend angle is less than this thrshold, worm is omega
time = 1; %s
OMEGA_INTERVAL = floor(time*Frame_Rate);
OMEGA_COMBINE = OMEGA_INTERVAL;
CRAWL_INTERVAL = 2*Frame_Rate;

% Calculate worm bend angle
% centerline's name is xxx.mat, xxx is image index starting from 0
start_index = 0;
num = length(dir([Centerline_Folder '*.mat']));
end_index = num-1;
worm_angles = zeros(num,1);
crawling_angles = zeros(num,1);

for i = start_index:end_index
    % before calculate worm bend angle, make sure all centerlines are correct
    centerline_name = [Centerline_Folder num2str(i) '.mat'];
    if ~exist(centerline_name,'file')
        crawling_angles(i-start_index+1) = crawling_angles(i-start_index);
        continue;
    end
    
    data = load(centerline_name);
    centerline = data.centerline;
    worm_angles(i-start_index+1) = calc_bend_angle(centerline);
    crawling_angles(i-start_index+1) = calc_crawl_angle(centerline);
end

% identify omega state
omega_state = zeros(num,1);
omega_state(worm_angles <= OMEGA_THRES) = 1; % omega states

% remove/combine single omega states
omega_state = State_Filtering(omega_state,OMEGA_INTERVAL,OMEGA_COMBINE);

% calculating worm crawling angle
Omega_Struc = State_Stat(omega_state);
omega_num = size(Omega_Struc,1);
if omega_num > 0
    omega_angles = zeros(omega_num,1);
    for i=1:omega_num
        % calculate the angle from pre-omege-state to after-omega-state
        s1 = max(1,Omega_Struc(i,1)-CRAWL_INTERVAL);
        s2 = max(1,Omega_Struc(i,1)-1);
        t1 = min(num,Omega_Struc(i,2)+1);
        t2 = min(num,Omega_Struc(i,2)+CRAWL_INTERVAL);
        omega_angles(i) = mean(crawling_angles(s1:s2)) - mean(crawling_angles(t1:t2));
    end
else
    omega_angles = [];
end
end