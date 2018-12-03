function worm_seg(Image_Folder,Worm_Thres,Worm_Area,OutputFolder)
% segment worm region and determine whether skip this image by comparing
% the area with the first image

config;

WormRegionFolder = [OutputFolder 'worm_region\'];
desired_width = 512;
desired_height = 512;

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
        if image_height < desired_height || image_width < desired_width
            disp('Desired height/width is invalid');
			return;
        end
        worm_region = [1,image_height,1,image_width];
    end
    
	[binary_worm_region, Worm_Area, pos, new_worm_region] = worm_seg_single(img, Worm_Thres, worm_region, Worm_Area);
    desired_worm_region = GetDesireImageRegion(pos, [desired_height,desired_width],[image_height,image_width]);
    
    % crop a desired image size (heigth, width)
    if i > Start_Index && abs(Init_Worm_Area - Worm_Area) > Init_Worm_Area*Frame_Skip_Thres
        % the first image must be correct!
        disp(['Skip image: ' num2str(i)]);
        Skip_List_Index = Skip_List_Index + 1;
        Skip_List(Skip_List_Index) = i;
        Worm_Area = Init_Worm_Area;
        worm_pos(i-Start_Index+1,:) = worm_pos(i-Start_Index,:);
    else
        worm_pos(i-Start_Index+1,:) = pos;
    end
        
    % update worm region and get desired binary image
    worm_region = new_worm_region;
    whole_binary_img = false(size(img));
    whole_binary_img(worm_region(1):worm_region(2),worm_region(3):worm_region(4)) = binary_worm_region;
	binary_worm_region = ...
        whole_binary_img(desired_worm_region(1):desired_worm_region(2),desired_worm_region(3):desired_worm_region(4));
    worm_regions(i-Start_Index+1,:) = desired_worm_region;
    
    % save the binary worm region
	imwrite(binary_worm_region*255, [WormRegionFolder num2str(i) image_format]);
end

Skip_List = Skip_List(1:Skip_List_Index);
raw_worm_pos = worm_pos;
% worm_pos = WormPos_Filtering(worm_pos);

% save worm regions and positions
save([OutputFolder 'WormRegionPos.mat'],'worm_pos','worm_regions','raw_worm_pos','Skip_List');

% write skip list into backbone folder
file = fopen([OutputFolder 'backbone\skiplist.txt'],'wt');
    for i=1:length(Skip_List)
        fprintf(file,'%d\n',Skip_List(i));
    end
fclose(file);

end

function worm_region = GetDesireImageRegion(worm_pos, desired_size, original_size)
%% crop new worm region with width and height

height = desired_size(1);
width = desired_size(2);
img_height = original_size(1);
img_width = original_size(2);

pos = round(worm_pos);
row_min = max(1,pos(1)-height/2);
row_max = min(pos(1) + height/2 - 1, img_height);
col_min = max(1, pos(2)-width/2);
col_max = min(img_width, pos(2)+width/2 - 1);

if (row_max - row_min) ~= height
    if row_max == img_height
        row_min = img_height - height + 1;
    else
        row_max = row_min + height - 1;
    end
end

if (col_max - col_min) ~= width
    if col_max == img_width
        col_min = img_width - width + 1;
    else
        col_max = col_min + width - 1;
    end
end
worm_region = [row_min, row_max, col_min, col_max];

end
