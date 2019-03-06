function curvature = Compute_Curvature(centerline)
% Calculate normalized curvature of worm centerline

centerline_num = length(centerline);
centerline_length = sum(sqrt(sum((centerline(2:end,:) - centerline(1:end-1,:)).^2,2)));
curvature = zeros(length(centerline),1);

x = centerline(:,2);
y = centerline(:,1);
diff_x = diff(x,1);
diff_y = diff(y,1);
diff2_x = -diff(diff_x,1);
diff2_y = -diff(diff_y,1);
diff_x = diff_x(1:end-1);
diff_y = diff_y(1:end-1);
curvature(2:end-1) = (diff_x.*diff2_y - diff2_x.*diff_y)./(diff_x.^2 + diff_y.^2).^1.5;
curvature(1) = curvature(2);
curvature(end) = curvature(end-1);

curvature = smooth(curvature,floor(0.05*centerline_num));

% nomalize the curvature with the centerline length
curvature = curvature * centerline_length;

% plot(curvature,'b.-');hold on;
% plot(smooth_curvature,'r.-');hold off;

end
