function DrawHeadBendAngle(data,frame_rate)
% Draw head bending angle

pos_index = find(data >= eps);
neg_index = find(data < -eps);

% find all the cross points and insert points (corss_point_x,0)
cross_index = union(intersect(pos_index+1, neg_index), intersect(pos_index-1,neg_index));
pos_data = zeros(1, length(data));
pos_data(pos_index) = data(pos_index);
neg_data = zeros(1, length(data));
neg_data(neg_index) = data(neg_index);
x = 1:length(data);

% disp(cross_index);
if ~isempty(cross_index)
    len = 0;
    for i=1:length(cross_index)
        index = cross_index(i);
        if index > 1 && index <= length(data)
            % 两个if用来处理正-负-正的情况
            if index > 1 && (data(index) < -eps && data(index-1) >= eps)
                cross_point = index-1 + (-data(index-1))/(data(index) - data(index-1) + eps); 
                insert_index = index + len -1;
                len = len + 1;
                x = [x(1:insert_index) cross_point x(insert_index+1:end)];
                pos_data = [pos_data(1:insert_index) 0 pos_data(insert_index+1:end)];
                neg_data = [neg_data(1:insert_index) 0 neg_data(insert_index+1:end)];
            end
            if  index < length(data) && (data(index) < -eps && data(index+1) >= eps)
                cross_point = index + (-data(index))/(data(index+1) - data(index) + eps);
                insert_index = index + len;
                len = len + 1;
                x = [x(1:insert_index) cross_point x(insert_index+1:end)];
                pos_data = [pos_data(1:insert_index) 0 pos_data(insert_index+1:end)];
                neg_data = [neg_data(1:insert_index) 0 neg_data(insert_index+1:end)];
            end
        end
    end
end
x = x/frame_rate;

% draw data
pos_color = [1,0,0];
neg_color = [0,0,1];
font_size = 14;

figure; hold on;
% the following fill function can draw region between two curves
% fill([x,fliplr(x)],[zeros(size(pos_data)),fliplr(pos_data)], pos_color);
area(x,pos_data,'FaceColor',pos_color);
area(x,neg_data,'FaceColor',neg_color);
hold off;
ylabel('Head Bend Angle (Deg)');
xlabel('Time (s)');
set(gca, 'fontsize', font_size);

end

