class_tools = {}

function class_tools.string_indent(parma_string, parma_length)
    if parma_length == nil then
        parma_length = 5
    end
end

function class_tools.get_level_data(long_gold)
    local the_level_data = {}
    if long_gold >= 80000000 then
        the_level_data._int_level = 19
        the_level_data._str_level_name = ('玉皇大帝')
        the_level_data._long_next_level_gold = -1
    elseif long_gold >= 40000000 then
        the_level_data._int_level = 18
        the_level_data._str_level_name = ('王母娘娘')
        the_level_data._long_next_level_gold = 80000000
    elseif long_gold >= 20000000 then
        the_level_data._int_level = 17
        the_level_data._str_level_name = ('天将')
        the_level_data._long_next_level_gold = 40000000
    elseif long_gold >= 10000000 then
        the_level_data._int_level = 16
        the_level_data._str_level_name = ('天兵')
        the_level_data._long_next_level_gold = 20000000
    elseif long_gold >= 8000000 then
        the_level_data._int_level = 15
        the_level_data._str_level_name = ('皇帝')
        the_level_data._long_next_level_gold = 10000000
    elseif long_gold >= 4000000 then
        the_level_data._int_level = 14
        the_level_data._str_level_name = ('一品侍卫')
        the_level_data._long_next_level_gold = 8000000
    elseif long_gold >= 2000000 then
        the_level_data._int_level = 13
        the_level_data._str_level_name = ('二品将军')
        the_level_data._long_next_level_gold = 4000000
    elseif long_gold >= 1000000 then
        the_level_data._int_level = 12
        the_level_data._str_level_name = ('三品参将')
        the_level_data._long_next_level_gold = 2000000
    elseif long_gold >= 800000 then
        the_level_data._int_level = 11
        the_level_data._str_level_name = ('四品都司')
        the_level_data._long_next_level_gold = 1000000
    elseif long_gold >= 400000 then
        the_level_data._int_level = 10
        the_level_data._str_level_name = ('五品守备')
        the_level_data._long_next_level_gold = 800000
    elseif long_gold >= 200000 then
        the_level_data._int_level = 9
        the_level_data._str_level_name = ('六品中军')
        the_level_data._long_next_level_gold = 400000
    elseif long_gold >= 100000 then
        the_level_data._int_level = 8
        the_level_data._str_level_name = ('七品军门')
        the_level_data._long_next_level_gold = 200000
    elseif long_gold >= 80000 then
        the_level_data._int_level = 7
        the_level_data._str_level_name = ('八品县令')
        the_level_data._long_next_level_gold = 100000
    elseif long_gold >= 60000 then
        the_level_data._int_level = 6
        the_level_data._str_level_name = ('九品班头')
        the_level_data._long_next_level_gold = 80000
    elseif long_gold >= 40000 then
        the_level_data._int_level = 5
        the_level_data._str_level_name = ('嚣张衙役')
        the_level_data._long_next_level_gold = 60000
    elseif long_gold >= 20000 then
        the_level_data._int_level = 4
        the_level_data._str_level_name = ('潇洒镖头')
        the_level_data._long_next_level_gold = 40000
    elseif long_gold >= 10000 then
        the_level_data._int_level = 3
        the_level_data._str_level_name = ('二逼镖师')
        the_level_data._long_next_level_gold = 20000
    elseif long_gold >= 5000 then
        the_level_data._int_level = 2
        the_level_data._str_level_name = ('愣头护院')
        the_level_data._long_next_level_gold = 10000
    else
        the_level_data._int_level = 1
        the_level_data._str_level_name = ('小小家丁')
        the_level_data._long_next_level_gold = 5000
    end

    return the_level_data
end
--不允许出现! @ # > ? 空格 等特殊字符，允许出现中文等信息
function class_tools.have_special_characters(str_value)
    for i=1, #str_value  do 
        
        local  char_value = string.byte(str_value,i)

        if char_value>=0 and char_value<=127 then 
            if (char_value >= 48 and char_value <= 57) then 
            elseif (char_value >= 65 and char_value <= 90) then 
            elseif (char_value >= 97 and char_value <= 122) then 
            else
                return true;
            end     
        end
    end
    return false;
end
--数字或字母组成
function  class_tools.is_simple_characters(str_value)
    for i=1, #str_value  do 
        
        local  char_value = string.byte(str_value,i)
		if (char_value >= 48 and char_value <= 57) then 
			
        elseif (char_value >= 65 and char_value <= 90) then 
			
        elseif (char_value >= 97 and char_value <= 122) then 
        
        else
            print("hjjlog>>simple:",char_value);
            
            return false;
        end     
    end
    return true;
end
--校验手机
function  class_tools.is_phone_characters(str_value)
	if #str_value~=11 then 
        return false;
    end
    for i=1,#str_value do 
        local char_value=string.byte(str_value,i)
        if (char_value >= 48 and char_value <= 57) then
        else
            return false;
        end
    end
	return true;
end
function class_tools.get_vip()
    local l_data=bp_get_self_prop_status(0)
    local user_prop_status=json.decode(l_data)

    local l_max_vip=0;
    for k,v in pairs(user_prop_status) do
        if v.time>os.time() then  
            if l_max_vip< v.id then 
                l_max_vip=v.id
            end
        end
    end
    return l_max_vip
end
