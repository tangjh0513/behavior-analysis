function worm_speed = ComputeSpeed_ByCenterline(Folder,frame_seq,centerline_point,delta_time)
% Compute wrom speed
% Input paramters:
% centerline_point: [0,1] indicates the centerline position, 0 is head and
% 1 is tail
% 

Centerline_Folder = [Folder 'centerline\'];
worm_regions = load([Folder 'WormRegionPos.mat']);
worm_regions = worm_regions.worm_regions;

worm_pos = zeros(length(frame_seq),2);
for i=1:length(frame_seq)
    centerline_name = [Centerline_Folder num2str(frame_seq(i)) '.mat'];
    if ~exist(centerline_name,'file')
        worm_pos(i,:) = worm_pos(i-1,:);
        continue;
    end
    
    data = load(centerline_name);
    centerline = data.centerline;
    if i==1
        centerline_length = length(centerline);
        centerline_index = floor(centerline_length*centerline_point);
        if centerline_index == 0
            centerline_index = 1;
        end
    end
    worm_pos(i,:) = centerline(centerline_index,:) + [worm_regions(i,1) worm_regions(i,3)];
end
worm_speed = sqrt(sum((worm_pos(2:end,:) - worm_pos(1:end-1,:)).^2,2))/delta_time;
end

