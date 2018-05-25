function reverse_centerline(CenterlineFolder,reverse_index)
% 注：reverse_index是按照图像次序，处理时必须清楚！

num = length(reverse_index);
for i=1:num
    image_index = reverse_index(i);
    curve_file = [CenterlineFolder num2str(image_index) '.mat'];
    data = load(curve_file);
    
    % reverse and save centerline
    centerline = data.centerline(end:-1:1,:);
    save([CenterlineFolder num2str(image_index) '.mat'],'centerline');
end
end