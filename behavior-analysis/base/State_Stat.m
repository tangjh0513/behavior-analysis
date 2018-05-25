function stat = State_Stat(Move_Dir)
% 统计某个状态信息。
% Input parameters:
% Move_Dir: state状态，1表示存在该状态，0表示不存在

State_Num = 50;
stat = zeros(State_Num,3);
state_start = false;
state_index = 0;
for i=1:length(Move_Dir)-1
    if i==1
        continue;
    elseif (Move_Dir(i)==1) && (Move_Dir(i-1)==0) && (state_start == false)
        state_start = true;
        state_index = state_index+1;
        stat(state_index,1) = i;
    elseif (Move_Dir(i)==0) && (Move_Dir(i-1)==1) && (state_start == true)
        stat(state_index,2) = i;
        stat(state_index,3) =  stat(state_index,2)- stat(state_index,1);
        state_start = false;
    end
end
stat = stat(1:state_index,:);
end