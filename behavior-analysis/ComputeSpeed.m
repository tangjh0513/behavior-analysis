delta_time=0.1;
worm_speed = sqrt(sum((worm_pos(2:end,:) - worm_pos(1:end-1,:)).^2,2))/delta_time;
plot(worm_speed);