function [binary_worm_region, worm_area, worm_pos, new_worm_region] = ...
    worm_seg_single(original_img, Worm_Thres, worm_region_range, worm_area)
% segment worm region
% 
% Input paramters:
% img: gray-level worm image
% Worm_Thres: binary threshold for determining worm image
% Worm Area: 
%
% Output parameters:
% binary_worm_region: segmented worm image
% area: updated worm area
% worm_pos: the centroid of worm
% worm_region: a rectangle indicating worm
%

% load configuration parameters
config;
Grad_Threshold = 5;

%% determine the probable worm region image
[original_img_height, original_img_width] = size(original_img);
motion_interval = 50 + BoundaryWidth;
min_row = max(1,worm_region_range(1)-motion_interval);
max_row = min(original_img_height, worm_region_range(2)+motion_interval);
min_col = max(1, worm_region_range(3)-motion_interval);
max_col = min(original_img_width, worm_region_range(4)+motion_interval);
img = double(original_img(min_row:max_row, min_col:max_col));
[image_height,image_width] = size(img);

%% compute coarse worm area and judge the whether it is a worm
binary_whole_img = (img < Worm_Thres & img > Low_Binary_Thres);
% segment worm region and remove boundary
new_binary_img = zeros(size(binary_whole_img));
new_binary_img(BoundaryWidth+1:image_height-BoundaryWidth, BoundaryWidth+1:image_width-BoundaryWidth) = ...
    binary_whole_img(BoundaryWidth+1:image_height-BoundaryWidth, BoundaryWidth+1:image_width-BoundaryWidth);
% get worm region
[binary_image,region_range] = Denoise_And_Worm_Locate(new_binary_img, worm_area); 
% pre-compute the worm area
area = sum(binary_image(:));

if size(binary_image,1) < original_img_height && abs(area - worm_area) > 0.45*worm_area
    % current region does not contain worm, search worm in the whole image
    img = double(original_img);
    [image_height,image_width] = size(img);
    min_row = 1; min_col = 1; max_row = image_height; max_col = image_width; % initialize region parameters
    binary_whole_img = (img < Worm_Thres & img > Low_Binary_Thres);
    new_binary_img = zeros(size(binary_whole_img));
    new_binary_img(BoundaryWidth+1:image_height-BoundaryWidth, BoundaryWidth+1:image_width-BoundaryWidth) = ...
        binary_whole_img(BoundaryWidth+1:image_height-BoundaryWidth, BoundaryWidth+1:image_width-BoundaryWidth);
    
    % get worm region
    [binary_image,region_range] = Denoise_And_Worm_Locate(new_binary_img, worm_area); 
end

worm_img = img(region_range(1):region_range(2),region_range(3):region_range(4)); 
binary_worm_region = binary_image(region_range(1):region_range(2),region_range(3):region_range(4));

%% use gradient method to improve segmentation region
sobel_h = fspecial('sobel');
grad = (imfilter(worm_img,sobel_h,'replicate').^2 + ...
        imfilter(worm_img,sobel_h','replicate').^2).^0.5;
grad(~binary_worm_region) = 0;

se = strel('disk',5);
grad_binary_img = grad > Grad_Threshold;
grad_binary_img = imclose(grad_binary_img,se); % do double close operations
binary_worm_region = imclose(grad_binary_img,se);
binary_worm_region = ~bwareaopen(~binary_worm_region,floor(Hole_Ratio*worm_area),8); % fill the holes

%% calculate worm position and update worm region
new_worm_region = region_range + [min_row min_row min_col min_col] - 1;

% worm_pos = CalculateBinaryWormCentroid(binary_worm_region) + [region_range(1) region_range(3)];
worm_pos = CalculateWormCentroid(double(worm_img.*binary_worm_region)) +...
           [region_range(1)+min_row-1 region_range(3)+min_col-1];
worm_area = sum(binary_worm_region(:)); % update worm area

end