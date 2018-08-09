function angle = calc_crawl_angle(centerline)
% Calculate the orientation of worm cralwing
% point format [y,x]

head = centerline(1,:);
tail = centerline(length(centerline),:);
% x,y are coordinates in image
angle = atan2(-(head(1) - tail(1)), head(2) - tail(2));% atan2(Y,X)
angle = angle*180/pi;
end