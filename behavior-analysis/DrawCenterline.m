function DrawCenterline(Folder)
% Draw centerline and worm position and make video

close all;

Image_Folder = [Folder 'images\'];
Centerline_Folder = [Folder 'centerline\'];
worm_pos = load([Folder 'WormRegionPos.mat']);
worm_region = worm_pos.worm_regions;
worm_centroid = worm_pos.worm_pos;
frame_rate = 10;
video_name = [Folder 'processed'];

% Parameters setting
image_format = '.tiff';
image_names = dir([Image_Folder, '*' image_format]);
Start_Index = 0;
End_Index = length(image_names)-1;

% figure paramters
line_width = 1.5;
marker_size = 5;

% make video
writerObj = VideoWriter([video_name '.mp4'],'MPEG-4');
writerObj.FrameRate = frame_rate;
open(writerObj);
% range = [85,31,512,512];

for i=Start_Index:End_Index
    image_name = [Image_Folder num2str(i) image_format];
    image = imread(image_name);

    centerline_name = [Centerline_Folder num2str(i) '.mat'];
    if ~exist(centerline_name, 'file')
        disp(['Image ' num2str(i) ' has no centerline data']);
        continue;
    end
    data = load(centerline_name);
    centerline = data.centerline;
    
%     % add worm region to centerline
%     centerline = centerline + ...
%         repmat([worm_region(i-Start_Index+1,1) worm_region(i-Start_Index+1,3)], length(centerline),1);
    image = image(worm_region(i-Start_Index+1,1):worm_region(i-Start_Index+1,2),...
                    worm_region(i-Start_Index+1,3):worm_region(i-Start_Index+1,4));
                
    points_num = length(centerline);
    imshow(image);colormap(gray);axis image;axis off;hold on;
    plot(centerline(:,2),centerline(:,1),'b-','LineWidth',line_width);
    plot(centerline(1,2),centerline(1,1),'ro','MarkerSize',marker_size,'LineWidth',line_width);
%     plot(worm_centroid(i-Start_Index+1,2), worm_centroid(i-Start_Index+1,1),...
%         'gs','MarkerSize',marker_size,'LineWidth',line_width);
%     plot(centerline(points_num,2),centerline(points_num,1),'go','MarkerSize',marker_size,...
%         'LineWidth',line_width);
    title(['Image ' num2str(i)]);
    hold off;
    %saveas(gcf,['Centerline\Fig_' num2str(i) '.fig']);

    % write this frame into video
    current_figure = getframe(gcf);
    region = current_figure.cdata;
%     region = region(range(2):range(2)+range(4)-1,range(1):range(1)+range(3)-1,:);
    writeVideo(writerObj,region);
end
% set(gcf,'Resize','on');
close(writerObj);
end

