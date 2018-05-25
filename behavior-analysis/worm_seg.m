function worm_seg(Image_Folder,Worm_Thres,Worm_Area,OutputFolder)
% segment worm region

% Worm_Thres = 225; % the gray intensity to segment worm
% Worm_Area = 2000;
Low_Thres = 30;
Grad_Threshold = 5;
BoundaryWidth = 50;
WormRegionFolder = [OutputFolder 'worm_region\'];

image_format = '.tiff';
image_names = dir([Image_Folder, '*' image_format]);
Start_Index = 0;
End_Index = length(image_names)-1;

worm_pos = zeros(length(image_names),2);
worm_regions = zeros(length(image_names),4);

width = 512;
height = 512;
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

	% segment worm region and remove boundary
	binary_whole_img = (img < Worm_Thres & img > Low_Thres);
    new_binary_img = zeros(size(binary_whole_img));
    new_binary_img(BoundaryWidth+1:image_height-BoundaryWidth, BoundaryWidth+1:image_width-BoundaryWidth) = ...
        binary_whole_img(BoundaryWidth+1:image_height-BoundaryWidth, BoundaryWidth+1:image_width-BoundaryWidth);
    
    % get worm region
	[binary_image,region_range,Worm_Area] =...
	    Denoise_And_Worm_Locate(new_binary_img, Worm_Area);
    
	% calculate worm position by worm centroid. Position: [y,x]
	% worm_pos(i-Start_Index+1,:) = CalculateBinaryWormCentroid(worm_region) + [region_range(1) region_range(3)];
    worm_region = img(region_range(1):region_range(2),region_range(3):region_range(4)); 
    binary_worm_region = binary_image(region_range(1):region_range(2),region_range(3):region_range(4));
    
    sobel_h = fspecial('sobel');
    grad = (imfilter(worm_region,sobel_h,'replicate').^2 + ...
            imfilter(worm_region,sobel_h','replicate').^2).^0.5;
    gaussian_h = fspecial('gaussian',[5,5],1);
    grad_smooth = imfilter(grad,gaussian_h,'replicate');
    grad_smooth(~binary_worm_region) = 0;
    
    se = strel('disk',3);
    grad_binary_img = grad_smooth > Grad_Threshold;
    grad_binary_img = imclose(grad_binary_img,se);
    binary_worm_region = imclose(grad_binary_img,se);
    binary_worm_region = ~bwareaopen(~binary_worm_region,floor(0.03*Worm_Area),8);
    
    binary_image(region_range(1):region_range(2),region_range(3):region_range(4)) = binary_worm_region;
    worm_pos(i-Start_Index+1,:) = CalculateBinaryWormCentroid(binary_worm_region) + [region_range(1) region_range(3)];
    
%     % draw the centroid (testing)
%     imagesc(img);axis image;colormap(gray);hold on;
%     plot(worm_pos(i-Start_Index+1,2),worm_pos(i-Start_Index+1,1),'gs');hold off;
%     pause(0.5);
    
	% crop new worm region with width and height
	pos = round(worm_pos(i-Start_Index+1,:));
	row_min = max(1,pos(1)-height/2);
	row_max = min(pos(1) + height/2 - 1, image_height);
	col_min = max(1, pos(2)-width/2);
	col_max = min(image_width, pos(2)+width/2 - 1);

	if (row_max - row_min) ~= height
		if row_max == image_height
			row_min = image_height - height + 1;
		else
			row_max = row_min + height - 1;
		end
	end

	if (col_max - col_min) ~= width
	if col_max == image_width
		col_min = image_width - width + 1;
	else
		col_max = col_min + width - 1;
	end

	binary_worm_region = binary_image(row_min:row_max,col_min:col_max);
	worm_regions(i-Start_Index+1,:) = [row_min, row_max, col_min, col_max];

	% save the binary worm region
	imwrite(binary_worm_region*255, [WormRegionFolder num2str(i) image_format]);
end

% save worm regions and positions
save([OutputFolder 'WormRegionPos.mat'],'worm_pos','worm_regions');

end