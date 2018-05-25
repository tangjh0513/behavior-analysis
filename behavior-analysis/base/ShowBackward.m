function ShowBackward(Move_Dir,Frame_Rate)
% œ‘ æbackward
close all;
font_size = 16;

% laser_time = 4700/Frame_Rate;
% laser_time = nan;
t = (1:length(Move_Dir))/Frame_Rate;
figure;plot(t,Move_Dir);hold on;
fill(t,Move_Dir,'r','EdgeColor','none');
% plot([laser_time laser_time],[0,1],'b--','LineWidth',2);
xlabel('Time (s)','FontSize',font_size);
set(gca,'YTick',[]);
set(gca,'FontSize',font_size);
axis([0 max(t) 0 1]);
hold off;
end