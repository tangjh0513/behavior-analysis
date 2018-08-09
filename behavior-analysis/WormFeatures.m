function [worm_speed, bends, orientation, curvatures] = WormFeatures()
% calculate worm speed, orientaion angle and bend
%
% Input paramters:
% worm_pos: worm positions (unit: pixel)
% Centerline_Folder: 
%
% Output parameters:
% worm_speed: the value of speed vector, ignoring its direction (forward/backward), pixels/s
% bends: the bending degree
% orientation: the angle between worm body and the horizon

close all;

Centerline_Folder = 'centerline\';
worm_pos = load('WormRegionPos.mat');%load worm position
worm_pos = worm_pos.worm_pos;
frame_rate = 10;

delta_time = 1/frame_rate;
frame_num = length(worm_pos);
bends = zeros(frame_num,1);
orientation = zeros(frame_num,1);
curvatures = zeros(length(worm_pos),99);

% calculate the worm speed
worm_speed = sqrt(sum((worm_pos(2:end,:) - worm_pos(1:end-1,:)).^2,2))/delta_time;

% calculate worm bend and orientation
for i = 1:frame_num
	data = load([Centerline_Folder num2str(i-1) '.mat']);
    centerline = data.centerline;
    curvatures(i,:) = Compute_Curvature(centerline);
	bends(i) = CalculateWormBend(centerline);
	orientation(i) = CalculateWormOrientation(centerline);
end
time = (1:frame_num)*delta_time;

% Draw results
font_size = 12;
line_width = 2;

% worm velocity
figure;plot(time(2:end),worm_speed,'b-','LineWidth',line_width);hold on;
xlabel('Time (s)', 'FontSize', font_size);
ylabel('Velocity (pixel/s)', 'FontSize', font_size);
set(gca,'FontSize',font_size);
hold off;
print(1, '-djpeg', '-r200', 'worm_speed');

% worm bends
figure;plot(time,bends,'b-','LineWidth',line_width);hold on;
xlabel('Time (s)', 'FontSize', font_size);
ylabel('Bending', 'FontSize', font_size);
set(gca,'FontSize',font_size);
hold off;
print(2, '-djpeg', '-r200', 'worm_bend');

% worm orientation
figure;plot(time,orientation,'b-','LineWidth',line_width);hold on;
xlabel('Time (s)', 'FontSize', font_size);
ylabel('\theta', 'FontSize', font_size);
set(gca,'FontSize',font_size);
hold off;
print(3, '-djpeg', '-r200', 'worm_orientation');

end