function curvatures = Worm_Curvatures(Centerline_Folder,SkipList)
% scalculate worm curvature

centerline_files = dir([Centerline_Folder '*.mat']);
frame_num = length(centerline_files);
for i = 1:frame_num
    if ~isempty(find(SkipList == (i-1), 1))
        centerline_num = size(curvatures,2); % assume the first iisn't in skiplist
        curvatures(i,:) = nan(1,centerline_num);
        continue;
    end
    
	centerline_data = load([Centerline_Folder num2str(i-1) '.mat']);
    centerline = centerline_data.centerline;
	if i==1
		curvatures = zeros(frame_num, length(centerline)); % allocate spaces
	end
	curvatures(i,:) = Compute_Curvature(centerline);
end
% % save worm regions and positions
% save('WormCurvature.mat','curvatures');
end