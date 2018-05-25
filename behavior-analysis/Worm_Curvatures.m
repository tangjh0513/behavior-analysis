function curvatures = Worm_Curvatures(Centerline_Folder)
% segment worm region

centerline_files = dir([Centerline_Folder '*.mat']);
frame_num = length(centerline_files);
for i = 1:frame_num
	centerline_data = load([Centerline_Folder num2str(i-1) '.mat']);
    centerline = centerline_data.centerline;
	if i==1
		% allocate spaces
		curvatures = zeros(frame_num, length(centerline)-2);
	end
	curvatures(i,:) = Compute_Curvature(centerline);
end
% % save worm regions and positions
% save('WormCurvature.mat','curvatures');
end