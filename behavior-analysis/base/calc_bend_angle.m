function angle = calc_bend_angle(centerline)
% Calculate worm bend angle by centerline
% Input parameters:
% centerline: nx2 array, format: [y,x]
%
% Output parameters:
% angle: the clockwise angle from head to tail

mid_index = floor(length(centerline)/2);
head = centerline(1,:);
tail = centerline(length(centerline),:);
mid = centerline(mid_index,:);

mid_head = atan2(-(head(1)-mid(1)), head(2)-mid(2));
mid_tail = atan2(-(tail(1)-mid(1)), tail(2)-mid(2));
angle = mid_head - mid_tail;
angle = abs(angle*180/pi);

if angle > 180
    angle = 360 - angle;
end
end