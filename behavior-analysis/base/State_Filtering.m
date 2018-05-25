function state = State_Filtering(state,INTERVAL,COMBINE)
% 对state数据进行滤波,存在该state表示1，否则表示0

% state 数据合并
% case 1： 如果相邻的两个state间隔小于interval，则合并该state
% case 2： 删除孤立且时常小于Interval的state
while (1)
    State_Struc = State_Stat(state);
    state_num = size(State_Struc,1);
    if state_num > 1
        for i=1:state_num-1
            % 分析case 1
            if (State_Struc(i+1,1) - State_Struc(i,2)) < COMBINE
                 state(State_Struc(i,2):State_Struc(i+1,1)) = 1;
            end
        end
    end
    Current_State_Struc = State_Stat(state);
    if ~State_Changed(State_Struc, Current_State_Struc)
        break;
    else
        State_Struc = Current_State_Struc;
    end
end
% processing case2
for i=1:size(State_Struc,1)
    if State_Struc(i,3) < INTERVAL
        state(State_Struc(i,1):State_Struc(i,2)) = 0;
    end
end

end