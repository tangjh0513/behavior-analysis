function worm_pos = WormPos_Filtering(pos)
% Filtering worm pos, that is, remove some errors in worm position data
% 

% Load configure files
config;

worm_pos = pos;

% Worm motion must be continous. If the offset between of two consecutive position is large
% remove the later one. Be default, the worm pos in first image must be TRUE!!!

Num = length(worm_pos);
for i=2:Num
	if (sum((worm_pos(i,:) - worm_pos(i-1,:)).^2,2) > MAX_LENGTH^2)
		worm_pos(i,:) = worm_pos(i-1,:);
	end
end

end