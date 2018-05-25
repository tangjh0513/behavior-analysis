function is_changed = State_Changed(Last_State_Struc, Current_State_Struc)
is_changed = false;
if size(Last_State_Struc,1) ~= size(Current_State_Struc,1)
    is_changed = true;
else
    tmp = sum(sum(abs(Last_State_Struc(:,1:2) - Current_State_Struc(:,1:2))));
    if tmp > 0
        is_changed = true;
    end
end
end