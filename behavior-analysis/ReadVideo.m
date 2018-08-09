F = 'G:\behvaior-analysis\Data-3\';

video_name = [F '1.avi'];
readObj = VideoReader(video_name);
folder = [F 'images\'];
k = 0;
while hasFrame(readObj)
    img = readFrame(readObj);
    if size(img,3) > 1
        img = rgb2gray(img);
    end
    imwrite(img, [folder num2str(k) '.tiff']);
    k = k+1;
end