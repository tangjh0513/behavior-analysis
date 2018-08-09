function curvatures = Worm_Curvatures(Centerline_Folder,Num,SkipList)
% scalculate worm curvature

for i = 1:Num
    if ~isempty(find(SkipList == (i-1), 1))
        centerline_num = size(curvatures,2); % assume the first iisn't in skiplist
        curvatures(i,:) = nan(1,centerline_num);
        continue;
    end
    
	centerline_data = load([Centerline_Folder num2str(i-1) '.mat']);
    centerline = centerline_data.centerline;
	if i==1
		curvatures = zeros(Num,length(centerline)); % allocate spaces
	end
	curvatures(i,:) = Compute_Curvature(centerline);
end
% % save worm regions and positions
% save('WormCurvature.mat','curvatures');
end