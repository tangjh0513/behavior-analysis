function rename_images(Folder,OutFolder)

image_format = '.tiff';
image_names = dir([Folder '*' image_format]);

for i=0:length(image_names)-1
    copyfile([Folder image_names(i+1).name],[OutFolder num2str(i) '.tiff']);
end
end