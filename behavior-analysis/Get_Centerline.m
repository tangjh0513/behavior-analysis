function Get_Centerline(Folder, Head_Pos)
% Read backbone data and convert to centerline
%

image_names = dir([Folder, 'backbone\*.bin']);
Start_Index = 0;
End_Index = length(image_names)-1;
is_reverse = 0;

for i=Start_Index:End_Index
	backbone_name = [Folder 'backbone\backbone_' num2str(i) '.bin'];
	backbone = LoadCenterlineResults(backbone_name);

	if ~backbone.length_error
		centerline = backbone.current_backbone;
    else
        centerline = backbone.last_backbone;
		disp(['Error backbone ' num2str(i)]);
    end

    if i == Start_Index && ~isnan(Head_Pos(1)) 
    	head_dist = sum((centerline(1,:) - Head_Pos).^2,2);
	    tail_dist = sum((centerline(length(centerline),:) - Head_Pos).^2,2);
	    if (tail_dist < head_dist)
	        is_reverse = 1;
	    end
    end
    if is_reverse
    	centerline = centerline(end:-1:1,:);
	end

    centerline_name = [Folder 'centerline\' num2str(i) '.mat'];
    save(centerline_name, 'centerline');
end

end