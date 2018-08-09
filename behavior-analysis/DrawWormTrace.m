function DrawWormTrace( worm_pos )
% Draw worm trajectory
%
% Input parameters:
% worm_pos: nx2 array, format [y,x] indicates the position of worm, unit is
% pixel       

line_width = 1.5;
font_size = 12;

% since y axis in image coordinates is opposite to y axis in 
% Cartesian coordinates, so I set the first column of worm_pos (y axis in image)
% to be negative to present the intuitive understanding of worm trajectory
plot(worm_pos(:,2),-worm_pos(:,1),'LineWidth',line_width);hold on;
plot(worm_pos(1,2), -worm_pos(1,1),'ro');
text(worm_pos(1,2), -worm_pos(1,1)-5,'start');
axis equal;
hold off;
xlabel('X (pixel)');
ylabel('Y (pixel)');
set(gca,'FontSize',font_size);

end

