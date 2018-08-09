function [motion_offset, worm_pos] = ImageConvert(Folder,OutputFolder)
% Convert .bin format image (generated  by WormTracker) into Tiff
%
% Input parameters:
% Folder and OutputFolder: inputed and outputed folder for .bin data
% 
% Output Parameters:
% motion_offset: the compensation of state for current image
% worm_pos: worm positions (ROI center of worm) in ground coordinate

image_seq = GetImageSeq(Folder,'.bin');
image_time = image_seq.image_time;
image_name_prefix = image_seq.image_name_prefix;

motion_offset = zeros(length(image_time),2);
for i=1:length(image_time)
    image_name = [Folder image_name_prefix num2str(image_time(i)) '.bin'];
    disp(['Converting ' image_name_prefix num2str(image_time(i)) '.bin']);
    
    fid = fopen(image_name,'rb');
    rows = fread(fid,1,'int');
    cols = fread(fid,1,'int');
    point = fread(fid,2,'double');% format [x,y], need to be [y,x]
    motion_offset(i,:) = [point(2) point(1)] - [256 256];
    img = zeros(rows,cols);
    for r = 1:rows
        img(r,:) = fread(fid,cols,'uchar');
    end
    fclose(fid);
    
    % imwrite image into file
    imwrite(uint8(img),[OutputFolder num2str(i-1) '.tiff']);
end
worm_pos = cumsum(motion_offset);
worm_pos = worm_pos - repmat(worm_pos(1,:),length(image_time),1);
end