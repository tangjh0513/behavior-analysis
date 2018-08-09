function pause_state = Find_Pause_State(worm_pos,frame_rate,PAUSE_THRESHOLD)
% Recognize pause state

Interval = 2*frame_rate;
PAUSE_INTERVAL = Interval;
PAUSE_COMBINE = Interval;

% recognize the pause state
pause_state = zeros(length(worm_pos),1);
crawl_direction = worm_pos(2:end,:) - worm_pos(1:end-1,:);
crawl_speed = sqrt(sum(crawl_direction.^2,2)) * frame_rate;
pause_state(crawl_speed <= PAUSE_THRESHOLD) = 1;

% filtering pause state
pause_state = State_Filtering(pause_state, PAUSE_INTERVAL, PAUSE_COMBINE);

end