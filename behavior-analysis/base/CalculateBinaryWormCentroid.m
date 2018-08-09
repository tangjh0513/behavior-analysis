function centroid = CalculateBinaryWormCentroid(binary_img)
% Calculate worm centroid

[y,x] = find(binary_img > 0);
centroid = [mean(y), mean(x)];

end