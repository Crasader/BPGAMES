bit_tools={}

bit_tools.oper={1}
for i=2,32,1 do
    bit_tools.oper[i]=bit_tools.oper[i-1]*2
end

--拆分为二级制表(全拆)
function bit_tools.split(param_num)
    local l_num=clone(param_num)
    local l_bit_list={}
    local l_max_id=-1
    local l_bit_cnt=0
    for i=32,1,-1 do
        if bit_tools.oper[i]<=l_num then
            l_num=l_num-bit_tools.oper[i]
            l_bit_list[i]=1
            l_bit_cnt=l_bit_cnt+1
            if l_max_id==-1 then
                l_max_id=clone(i)
            end
        else
            l_bit_list[i]=0
        end
    end
    return l_bit_list,l_max_id,l_bit_cnt
end
--根据最高位拆分
function bit_tools.splitByMaxID(param_num,param_maxid)
    local l_num=clone(param_num)
    local l_max_id=clone(param_maxid)
    local l_bit_list={}
    local l_bit_cnt=0
    for i=l_max_id,1,-1 do
        if bit_tools.oper[i]<=l_num then
            l_num=l_num-bit_tools.oper[i]
            l_bit_list[i]=1
        else
            l_bit_list[i]=0
        end
    end
    return l_bit_list
end

function bit_tools._and(param_num1,param_num2)
    local l_num1,l_num2=clone(param_num1),clone(param_num2)
    if l_num1==-1 then
        return l_num2
    elseif l_num2==-1 then
        return l_num1
    elseif l_num1==0 or l_num2==0 then
        --有0直接返回
        return 0
    elseif l_num1==l_num2 then
        --相同值直接返回
        return l_num1
    else
        --保证num1为大值
        if l_num2>l_num1 then 
            l_num1,l_num2=l_num2,l_num1 
        end

        local l_bit_list,l_max_id,l_bit_cnt=bit_tools.split(l_num2)
        if l_max_id<32 then
            l_num1=l_num1%(bit_tools.oper[l_max_id+1])
        end
        if l_bit_cnt==1 then
            if l_num1>=l_num2 then
                return l_num2
            else
                return 0
            end
        else
            local l_bit_list1=bit_tools.splitByMaxID(l_num1,l_max_id)
            local l_result=0
            for i=l_max_id,1,-1 do
                if l_bit_list[i]==1 and l_bit_list1[i]==1 then
                    l_result=l_result+bit_tools.oper[i]
                end
            end
            return l_result
        end
    end
end

function bit_tools._or(param_num1,param_num2)
    local l_num1,l_num2=clone(param_num1),clone(param_num2)
    if l_num1==-1 then
        return l_num2
    elseif l_num2==-1 then
        return l_num1
    elseif l_num1==0  then
        --有0直接返回
        return l_num1
    elseif l_num2==0 then
        --有0直接返回
        return l_num2
    elseif l_num1==l_num2 then
        --相同值直接返回
        return l_num1
    else
        --保证num1为大值
        if l_num2>l_num1 then 
            l_num1,l_num2=l_num2,l_num1 
        end
        local l_bit_list,l_max_id,l_bit_cnt=bit_tools.split(l_num2)
        local l_result=clone(l_num1)
        if l_max_id<32 then
            l_num1=l_num1%(bit_tools.oper[l_max_id+1])
        end
        if l_bit_cnt==1 then
            if l_num1>=l_num2 then
                return l_result
            else
                return l_result+l_num2
            end
        else
            local l_bit_list1=bit_tools.splitByMaxID(l_num1,l_max_id)
            for i=l_max_id,1,-1 do
                if l_bit_list[i]==1 and l_bit_list1[i]==0 then
                    l_result=l_result+bit_tools.oper[i]
                end
            end
            return l_result
        end
    end
end

function bit_tools._not(param_num)
    local l_num=clone(param_num)
    local l_bit_list=bit_tools.split(l_num)
    local l_result=0
    for i=1,32,1 do
        if l_bit_list[i]==0 then
            l_result=l_result+bit_tools.oper[i]
        end
    end
    return l_result
end

