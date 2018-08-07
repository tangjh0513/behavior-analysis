function worm_seg(Image_Folder,Worm_Thres,Worm_Area,OutputFolder)
% segment worm region

config;

WormRegionFolder = [OutputFolder 'worm_region\'];
width = 512;
height = 512;

image_format = '.tiff';
image_names = dir([Image_Folder, '*' image_format]);
Start_Index = 0;
End_Index = length(image_names)-1;
Skip_List= zeros(length(image_names),1);
Skip_List_Index = 0;
Init_Worm_Area = Worm_Area;

worm_pos = zeros(length(image_names),2);
worm_regions = zeros(length(image_names),4);

for i=Start_Index:End_Index
    disp(['Processing image ' num2str(i)]);
	img = double(imread([Image_Folder num2str(i) image_format]));

	if i == Start_Index
		[image_height, image_width] = size(img);
		if image_height < height || image_width < width
			disp('Desired height/width is invalid');
			return;
		end
	end

	[binary_worm_region, Worm_Area, pos, worm_region] = worm_seg_single(img, Worm_Thres, Worm_Area);
    if abs(Init_Worm_Area - Worm_Area) > Frame_Skip_Thres
        Skip_List_Index = Skip_List_Index + 1;
        Skip_List(Skip_List_Index) = i;
        Worm_Area = Init_Worm_Area;
    end
	worm_pos(i-Start_Index+1,:) = pos;
	worm_regions(i-Start_Index+1,:) = worm_region;

    % save the binary worm region
	imwrite(binary_worm_region*255, [WormRegionFolder num2str(i) image_format]);
end

Skip_List = Skip_List(1:Skip_List_Index);
raw_worm_pos = worm_pos;
worm_pos = WormPos_Filtering(worm_pos);

% save worm regions and positions
save([OutputFolder 'WormRegionPos.mat'],'worm_pos','worm_regions','raw_worm_pos','Skip_List');

% write skip list into backbone folder
if ~isempty(Skip_List)
    file = fopen([OutputFolder 'backbone\skiplist.txt']);
    for i=1:length(Skip_List)
        fprintf(file,'%d\n',Skip_List(i));
    end
    fclose(file);
end

end