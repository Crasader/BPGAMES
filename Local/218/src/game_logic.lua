game_logic=class("game_logic")

--获取正数金币的显示格式
function game_logic.getGoldText(param_gold)
    local gold = param_gold
    if param_gold < 100000 then
        gold = param_gold
    elseif param_gold < 1000000 then
        gold =  math.modf(param_gold/10000)
        local num_1 = math.modf(param_gold%10000 / 1000)
        local num_2 = math.modf(param_gold%1000 / 100)
        if num_1 == 0 and num_2 == 0 then
            num_1 = ""
        else 
            num_1 = "."..num_1
        end
        if num_2 == 0 then
            num_2 = ""
        end
        gold = gold .. num_1..num_2.."万"
    elseif param_gold < 10000000 then
        gold =  math.modf(param_gold/10000)
        local num_1 = math.modf(param_gold%10000 / 1000)
        if num_1 == 0 then
            num_1 = ""
        else 
            num_1 = "."..num_1
        end
         gold = gold ..num_1.."万"     
    else 
        gold =  math.modf(param_gold/10000)
        gold = gold.."万"           
    end
    return gold 
end

function game_logic.setNameText(param_label, param_str, param_width)
local id=1
    local table_text={}
    while id<=#param_str do
    	local byte_value=string.byte(string.sub(param_str,id,id))
    	if byte_value>=0xF0 then
    		table.insert(table_text,string.sub(param_str,id,id+3))
            id=id+4
    	elseif byte_value>=0xE0 then
    		table.insert(table_text,string.sub(param_str,id,id+2))
            id=id+3
    	elseif byte_value>=0xC0 then
    		table.insert(table_text,string.sub(param_str,id,id+1))
            id=id+2
    	else
    		table.insert(table_text,string.sub(param_str,id,id))
            id=id+1
    	end
    end

    local text_size=param_label:getSystemFontSize()
    local str_value=""
    local now_str=""
    for i=1,#table_text,1 do
    	param_label:setString(now_str..table_text[i])
    	if param_label:getContentSize().width > param_width-30 then
			str_value=str_value..now_str
			now_str=table_text[i]
			if i~=#table_text then
				str_value=str_value.."..."
                break
            else
                str_value=str_value..now_str
			end
		else
			now_str=now_str..table_text[i]
			if i==#table_text then
				str_value=str_value..now_str
			end
		end
    end
    param_label:setString(str_value)
end

function game_logic.get_card_color(card_value)
    return math.modf(tonumber(card_value)/16) 
end

function game_logic.get_card_size(card_value)
    return tonumber(card_value)%16
end

function game_logic.get_logic_card_size(card_size)
    if card_size == CardSize.a or card_size == CardSize[2] then
        return card_size+13
    elseif card_size == CardSize.bjoker or card_size == CardSize.rjoker then
        return card_size+2
    else
        return card_size
    end
end

function game_logic.get_fact_card_size(card_size)
    if card_size == 14 or card_size == 15 then
        return card_size-13
    elseif card_size == 16 or card_size == 17 then
        return card_size-2
    else
        return card_size
    end
end

function game_logic.cards_value_to_counts(cards_value, cards_count)
     local cards = {}
    for k,v in pairs(cards_value) do
        table.insert(cards,v)
    end
    local counts = {}
    for i=1,17 do
        table.insert(counts,0)
    end
    for i=1,cards_count do
        counts[game_logic.get_card_size(cards_value[i])] = counts[game_logic.get_card_size(cards_value[i])] + 1
    end
    return counts
end

--找出最小的牌值（除财神外最小值）
function game_logic.get_min_card_from_cards(cards_value, cards_count)
    local min_size = 0xff
    for i= 1,cards_count do
        local tmp_size = game_logic.get_card_size(cards_value[i])
        if game_logic.get_logic_card_size(tmp_size) < game_logic.get_logic_card_size(min_size) then
            min_size = tmp_size
        end
    end
    if min_size == 0xff then
        min_size = 0
    end
    return min_size
end

--找出最大牌值（除财神外）
function game_logic.get_max_card_from_cards(cards_value, cards_count)
    local max_size = 0
    for i=1, cards_count do
        local tmp_size = game_logic.get_card_size(cards_value[i])
        
        if tmp_size < 3 and tmp_size+13 > max_size then
            max_size = tmp_size
        elseif tmp_size > max_size and tmp_size > 2 and tmp_size < 14 and max_size ~= 1 and max_size ~= 2 then
            max_size = tmp_size
        end
    end
    return max_size 
end

--找出最小牌值（考虑财神变牌情况，传入牌值需已经过sort_outing_cards排序）
function game_logic.get_fact_min_size(cards_value, cards_count, cards_type)
    local min_size = game_logic.get_min_card_from_cards(cards_value, cards_count)

    local pos = 0
    for i=cards_count,1,-1 do
        if game_logic.get_card_size(cards_value[i]) == min_size then
            pos = cards_count - i + 1
            break;
        end
    end
    if cards_type == CardsType.stright_s then
        return min_size - pos + 1
    elseif cards_type == CardsType.stright_d then
        return min_size - math.floor((pos-1)/2)
    elseif cards_type == CardsType.stright_t then
        return min_size - math.floor((pos-1)/3)
    end
    return min_size
end

--根据大小排序
function game_logic.sort_cards_by_size(cards_value, cards_count)
    local cards = {}
    for k,v in pairs(cards_value) do
        table.insert(cards,v)
    end
    local function sort_func(v1,v2)
        if (game_logic.get_card_size(v1) == 1 or game_logic.get_card_size(v1) == 2 or game_logic.get_card_size(v1) == 14 or game_logic.get_card_size(v1) == 15 ) and 
            game_logic.get_card_size(v2) ~= 1 and game_logic.get_card_size(v2) ~= 2 and game_logic.get_card_size(v2) ~= 14 and game_logic.get_card_size(v2) ~= 15 then
            return game_logic.get_card_size(v1)+13 > game_logic.get_card_size(v2)
        elseif (game_logic.get_card_size(v2) == 1 or game_logic.get_card_size(v2) == 2 or game_logic.get_card_size(v2) == 14 or game_logic.get_card_size(v2) == 15 ) and 
            game_logic.get_card_size(v1) ~= 1 and game_logic.get_card_size(v1) ~= 2 and game_logic.get_card_size(v1) ~= 14 and game_logic.get_card_size(v1) ~= 15 then
            return game_logic.get_card_size(v1) > game_logic.get_card_size(v2)+13
        elseif game_logic.get_card_size(v1) == game_logic.get_card_size(v2) then
            return v1 > v2
        end

        return game_logic.get_card_size(v1) > game_logic.get_card_size(v2)
    end
    table.sort(cards, sort_func)
    return cards
end
--根据花色排序
function game_logic.sort_cards_by_color(cards_value, cards_count)
    local cards = {}
    for k,v in pairs(cards_value) do
        table.insert(cards,v)
    end
    local function sort_func(v1,v2)
        if (game_logic.get_card_size(v1) == 1 or game_logic.get_card_size(v1) == 2 or game_logic.get_card_size(v1) == 14 or game_logic.get_card_size(v1) == 15 ) and 
            game_logic.get_card_size(v2) ~= 1 and game_logic.get_card_size(v2) ~= 2 and game_logic.get_card_size(v2) ~= 14 and game_logic.get_card_size(v2) ~= 15 then
            return v1+13 > v2
        elseif (game_logic.get_card_size(v2) == 1 or game_logic.get_card_size(v2) == 2 or game_logic.get_card_size(v2) == 14 or game_logic.get_card_size(v2) == 15 ) and 
            game_logic.get_card_size(v1) ~= 1 and game_logic.get_card_size(v1) ~= 2 and game_logic.get_card_size(v1) ~= 14 and game_logic.get_card_size(v1) ~= 15 then
            return v1 > v2+13
        end

        return v1 > v2
    end
    table.sort(cards, sort_func)
    return cards
end
--根据数量排序
function game_logic.sort_cards_by_count(cards_value, cards_count)
    local cards = {}
    for k,v in pairs(cards_value) do
        table.insert(cards,v)
    end
    local counts = game_logic.cards_value_to_counts(cards, cards_count)

    local function sort_func(v1,v2)
        
        if counts[game_logic.get_card_size(v1)] ~= counts[game_logic.get_card_size(v2)] then
            return counts[game_logic.get_card_size(v1)] > counts[game_logic.get_card_size(v2)]
        else
            if (game_logic.get_card_size(v1) == 1 or game_logic.get_card_size(v1) == 2 or game_logic.get_card_size(v1) == 14 or game_logic.get_card_size(v1) == 15 ) and 
                game_logic.get_card_size(v2) ~= 1 and game_logic.get_card_size(v2) ~= 2 and game_logic.get_card_size(v2) ~= 14 and game_logic.get_card_size(v2) ~= 15 then
                return game_logic.get_card_size(v1)+13 > game_logic.get_card_size(v2)
            elseif (game_logic.get_card_size(v2) == 1 or game_logic.get_card_size(v2) == 2 or game_logic.get_card_size(v2) == 14 or game_logic.get_card_size(v2) == 15 ) and 
                game_logic.get_card_size(v1) ~= 1 and game_logic.get_card_size(v1) ~= 2 and game_logic.get_card_size(v1) ~= 14 and game_logic.get_card_size(v1) ~= 15 then
                return game_logic.get_card_size(v1) > game_logic.get_card_size(v2)+13
            elseif game_logic.get_card_size(v1) == game_logic.get_card_size(v2) then
                return v1 > v2
            end
            return game_logic.get_card_size(v1)>game_logic.get_card_size(v2)
        end

    end
    table.sort(cards, sort_func)
    return cards
end

--判断是否是对子
function game_logic.judgeDouble(counts, cards_count)
    if cards_count ~= 2 then
        return false
    end
    for i =1,15 do
        if counts[i] == 2 then
            return true
        end
    end
    if isVariable and counts[CardSize.rjoker] == 1 and counts[CardSize.bjoker] == 0 then
       return true
    end
    return false
end
--判断是否是三条
function game_logic.judgeThree(counts, cards_count)
    if cards_count ~= 3 then
        return false
    end
    for i = 1, 13 do
        if counts[i] == 3 then
            return true
        elseif counts[i] == 2 and counts[CardSize.rjoker] == 1 and isVariable then
            return true
        elseif counts[i] == 1 and counts[CardSize.rjoker] == 2 and isVariable then
            return true
        end
    end
    return false
end
--判断是否是顺子
function game_logic.judgeStrightS(counts, cards_count)
    if cards_count < 5 then
        return false
    end
    local is_start_count  = false
    local already_count = 0
    local lack = 0 --需要财神数
    for i = 3, 14 do
        local tmp = i
        if i == 14 then
            tmp = 1
        end
        if counts[tmp] == 1 then
            is_start_count = true
            already_count = already_count + 1
        elseif counts[tmp] == 0 and is_start_count and already_count < cards_count then
            lack = lack + 1 
            already_count = already_count + 1
        end
    end

    if lack == 0 and already_count == cards_count then
        return true
    elseif lack <= counts[CardSize.rjoker] and counts[CardSize.rjoker] - lack == cards_count - already_count and isVariable then --顺子最多3-A
        return true
    end
    return false
end
--判断是否为连对
function game_logic.judgeStrightD(counts, cards_count)
    if cards_count < 6 or cards_count%2 ~= 0  then
        return false
    end
    local is_start_count  = false
    local already_count = 0
    local lack = 0 --需要财神数
    for i = 3, 14 do
        local tmp = i
        if i == 14 then
            tmp = 1
        end
        if counts[tmp] == 2 then
            is_start_count = true
            already_count = already_count + 2
        elseif counts[tmp] == 1 then
            is_start_count = true
            lack = lack + 1
            already_count = already_count + 2
        elseif counts[tmp] == 0 and is_start_count and already_count < cards_count then
            lack = lack + 2
            already_count = already_count + 2
        end
    end
    if lack == 0 and already_count == cards_count then
        return true
    elseif lack <= counts[CardSize.rjoker] and counts[CardSize.rjoker] - lack == cards_count - already_count and isVariable then --连对最多3-A
        return true
    end
    return false
end
--判断是否是连三条
function game_logic.judgeStrightT(counts, cards_count)
    if cards_count < 9 or cards_count%3 ~= 0  then
        return false
    end 
    local is_start_count  = false
    local already_count = 0
    local lack = 0 --需要财神数
    for i = 3, 14 do
        local tmp = i
        if i == 14 then
            tmp = 1
        end
        if counts[tmp] == 3 then
            is_start_count = true
            already_count = already_count + 3
        elseif counts[tmp] == 2 then
            is_start_count = true
            lack = lack + 1
            already_count = already_count + 3
        elseif counts[tmp] == 1 then
            is_start_count = true
            lack = lack + 2
            already_count = already_count + 3
        elseif counts[tmp] == 0 and is_start_count and already_count < cards_count then
            lack = lack + 3
            already_count = already_count + 3
        end
    end
    if lack == 0 and already_count == cards_count then
        return true
    elseif lack <= counts[CardSize.rjoker] and counts[CardSize.rjoker] - lack == cards_count - already_count and isVariable then
        return true
    end
    return false
end
--判断是否是炸弹
function game_logic.judgeBomb(counts, cards_count)
    if cards_count < 4 then
        return false
    end
    for i = 1, 13 do
        if counts[i] == cards_count then
            return true
        elseif counts[i] + counts[CardSize.rjoker] == cards_count and isVariable then
            return true
        end
    end
    return false
end
--判断是否是王炸
function game_logic.judgeJokerBomb(counts, cards_count)
    if cards_count ~=3 and cards_count ~=4 then
        return false
    end
    if counts[CardSize.rjoker] + counts[CardSize.bjoker] == cards_count and isVariable then
        return true
    end
    return false
end

--判断是否是连炸
function game_logic.judgeStrightBomb(counts, cards_count, unit_length)
    if cards_count < 12 or cards_count % unit_length ~= 0 or cards_count/unit_length < 3 then
        return false
    end
    local is_start_count  = false
    local already_count = 0
    local lack = 0 --需要财神数
    for i = 3, 14 do
        local tmp = i
        if i == 14 then
            tmp = 1
        end
        if counts[tmp] == unit_length then
            is_start_count = true
            already_count = already_count + unit_length
        elseif counts[tmp] < unit_length and counts[tmp] > 0 then
            is_start_count = true
            lack = lack + unit_length - counts[tmp]
            already_count = already_count + unit_length
        elseif counts[tmp] == 0 and is_start_count and already_count < cards_count then
            lack = lack + unit_length
            already_count = already_count + unit_length
        end
    end
    if lack == 0 and already_count == cards_count then
        return true
    elseif lack <= counts[CardSize.rjoker] and counts[CardSize.rjoker] - lack == cards_count - already_count and isVariable then
        return true
    end
    return false
end


--获取牌的类型
function game_logic.get_cards_type(cards_value, cards_count)
    if cards_count == 0 then
        return CardsType.null
    end

    local counts = game_logic.cards_value_to_counts(cards_value, cards_count)

    if cards_count == 1 then
        return CardsType.single, 1
    elseif game_logic.judgeDouble(counts, cards_count) then
        return CardsType.double, 2
    elseif game_logic.judgeThree(counts, cards_count) then
        return CardsType.three, 3
    elseif game_logic.judgeStrightS(counts, cards_count) then
        return CardsType.stright_s, 1
    elseif game_logic.judgeStrightD(counts, cards_count) then
        return CardsType.stright_d, 2
    elseif game_logic.judgeStrightT(counts, cards_count) then
        return CardsType.stright_t, 3
    elseif game_logic.judgeBomb(counts, cards_count) then
        return CardsType["bomb_"..cards_count], cards_count
    elseif game_logic.judgeJokerBomb(counts, cards_count) then
        return CardsType["bomb_joker_"..cards_count], cards_count
    else 
        --连炸   
        for i=4, 8 do
            if game_logic.judgeStrightBomb(counts, cards_count, i) then
                local length = math.floor(cards_count/i)
                return (i+length)*5, i
            end
        end
        return CardsType.null
    end
end
--比较两个牌的大小（判断前面的牌是否比后面的牌大）
function game_logic.compare_two_cards(selected_cards_value, selected_cards_count, last_outing_cards_value, last_outing_cards_count)
    local selected_cards_type, selected_cards_unit_length = game_logic.get_cards_type(selected_cards_value, selected_cards_count)
    local outing_cards_type, outing_cards_unit_length = game_logic.get_cards_type(last_outing_cards_value, last_outing_cards_count)
    
    if outing_cards_type == CardsType.null then
        return true
    end

    if selected_cards_type == outing_cards_type then
        --牌型相同时，先看单位长度，单位长度长的大
        if selected_cards_unit_length > outing_cards_unit_length then
            return true
        --单位长度一致时，这里比较牌中最小的值，最小值大的牌大
        elseif selected_cards_count == last_outing_cards_count then
            --这里的最小值暂时没有考虑大王百变的情况
            local selected_min_card = game_logic.get_min_card_from_cards(selected_cards_value, selected_cards_count)
            local outing_min_card = game_logic.get_min_card_from_cards(last_outing_cards_value, last_outing_cards_count)
            if game_logic.get_logic_card_size(selected_min_card) > game_logic.get_logic_card_size(outing_min_card) then
                return true
            end
        end
    --牌型不同，且选择的牌型为炸弹，则选择牌大
    elseif selected_cards_type > outing_cards_type and selected_cards_type >= CardsType.bomb_4 then
        return true
    end

    return false
end
--将大王放到顺子、连对、连三条正确的位置上（建立在cards_value符合顺的条件下）
function game_logic.put_rjoker_into_stright_right_pos(cards_value, counts, stright_unit_length)
    local cards = {}
    for k,v in pairs(cards_value) do
        table.insert(cards, v)
    end
    local insert_rjoker_pos = {}
    local min_card = game_logic.get_min_card_from_cards(cards, #cards)
    local max_card = min_card+math.floor(#cards/stright_unit_length)- 1
    local rest_joker = counts[CardSize.rjoker]
     for i= max_card, min_card, -1 do
        if i < 14 then
            for j = 1,stright_unit_length-counts[i] do  
                table.insert(insert_rjoker_pos, (max_card-i)*stright_unit_length+1+rest_joker)
                rest_joker = rest_joker - 1
            end
        elseif i== 14 then
            for j = 1,stright_unit_length-counts[CardSize.a] do  
                table.insert(insert_rjoker_pos, (i-min_card)*stright_unit_length+1+rest_joker)
                rest_joker = rest_joker - 1
            end
        elseif i > 14 then
            for j=1,stright_unit_length do
                 table.insert(insert_rjoker_pos,#cards+1)
            end
        else
            for j=1,stright_unit_length do
                 table.insert(insert_rjoker_pos,1)
            end
        end
     end
     for i =1, #insert_rjoker_pos do
        table.insert(cards, insert_rjoker_pos[i], cards[1])
        table.remove(cards, 1)
     end
     return cards
end

--将出的牌进行排序
function game_logic.sort_outing_cards(cards_value, cards_count)
    local function sort_func(v1,v2)
        if (game_logic.get_card_size(v1) == 1 or game_logic.get_card_size(v1) == 2 or game_logic.get_card_size(v1) == 14 or game_logic.get_card_size(v1) == 15 ) and 
            game_logic.get_card_size(v2) ~= 1 and game_logic.get_card_size(v2) ~= 2 and game_logic.get_card_size(v2) ~= 14 and game_logic.get_card_size(v2) ~= 15 then
            return game_logic.get_card_size(v1)+13 > game_logic.get_card_size(v2)
        elseif (game_logic.get_card_size(v2) == 1 or game_logic.get_card_size(v2) == 2 or game_logic.get_card_size(v2) == 14 or game_logic.get_card_size(v2) == 15 ) and 
            game_logic.get_card_size(v1) ~= 1 and game_logic.get_card_size(v1) ~= 2 and game_logic.get_card_size(v1) ~= 14 and game_logic.get_card_size(v1) ~= 15 then
            return game_logic.get_card_size(v1) > game_logic.get_card_size(v2)+13
        elseif game_logic.get_card_size(v1) == game_logic.get_card_size(v2) then
            return v1 > v2
        end

        return game_logic.get_card_size(v1) > game_logic.get_card_size(v2)
    end  

    local cards = {}
    local is_Rjoker_exist = false
    for i=1,cards_count do
        if type(cards_value[i]) == "table" then
            for j=1,#cards_value[i] do
                table.insert(cards, cards_value[i][j])
                if game_logic.get_card_size(cards_value[i][j]) == CardSize.rjoker then
                    is_Rjoker_exist = true
                end
            end
        elseif type(cards_value[i]) == "number" then
            table.insert(cards, cards_value[i])
            if game_logic.get_card_size(cards_value[i]) == CardSize.rjoker then
                is_Rjoker_exist = true
            end
        end
    end
    table.sort(cards,sort_func)
    if is_Rjoker_exist then
        local counts = game_logic.cards_value_to_counts(cards, #cards)

        if game_logic.judgeStrightS(counts, #cards) then
            return  game_logic.put_rjoker_into_stright_right_pos(cards, counts, 1)
        elseif game_logic.judgeStrightD(counts, #cards) then
            return  game_logic.put_rjoker_into_stright_right_pos(cards, counts, 2)
        elseif game_logic.judgeStrightT(counts, #cards) then 
            return  game_logic.put_rjoker_into_stright_right_pos(cards, counts, 3)
        end
    end

    return cards
end

--获取手牌中 大于 值为last_outing_min_size的unit_length张牌
function game_logic.get_bigger_unit_length_cards(cards_value, counts, last_outing_min_size, unit_length)
    local ret = {}
    --大于last_outing_min_size unit_length张牌
    local tmp_max_size = game_logic.get_logic_card_size(CardSize[2]) 
    if unit_length == 1 or unit_length == 2 then
        --单张和对子情况下，考虑单王和对王
        tmp_max_size = game_logic.get_logic_card_size(CardSize.rjoker)
    end
    for i = 3, tmp_max_size do
        local tmp_ret = {}
        if counts[game_logic.get_fact_card_size(i)] == unit_length and i > game_logic.get_logic_card_size(last_outing_min_size) then
            for j=1,#cards_value do
                if game_logic.get_card_size(cards_value[j]) == game_logic.get_fact_card_size(i) then
                    table.insert(tmp_ret, cards_value[j])
                end
            end
            table.insert(ret, tmp_ret)
        end
    end
    --若有大王的话，寻找是否存在加上大王数量可以符合的牌
    if counts[CardSize.rjoker] > 0 then
        for i = 3, 15 do
            local tmp_ret = {}
            if counts[game_logic.get_fact_card_size(i)] + counts[CardSize.rjoker] >= unit_length and i > game_logic.get_logic_card_size(last_outing_min_size) then 
                for j=1,#cards_value do
                    if game_logic.get_card_size(cards_value[j]) == game_logic.get_fact_card_size(i) then
                        table.insert(tmp_ret, cards_value[j])
                    end
                end
                if #tmp_ret > 0 then
                    local added_joker_count = 0
                    for j=1,#cards_value do
                        if game_logic.get_card_size(cards_value[j]) == CardSize.rjoker then
                            table.insert(tmp_ret, cards_value[j])
                            added_joker_count = added_joker_count + 1
                        end
                        if added_joker_count == unit_length - counts[game_logic.get_fact_card_size(i)] then
                            table.insert(ret, tmp_ret)
                            break
                        end
                    end
                end
            end
        end
    end

    --若是单张、对子、三条，则拆多的牌
    if unit_length < 4 then
        for k=1, 9 do
            for i = 3, tmp_max_size do
                local tmp_ret = {}
                if counts[game_logic.get_fact_card_size(i)] - unit_length == k and i > game_logic.get_logic_card_size(last_outing_min_size) then 
                    for j=1,#cards_value do
                        if game_logic.get_card_size(cards_value[j]) == game_logic.get_fact_card_size(i) then
                            table.insert(tmp_ret, cards_value[j])
                        end
                        if #tmp_ret == unit_length then
                            table.insert(ret, tmp_ret)
                            break
                        end
                    end
                end
            end
        end
    end

    return ret
end

--获取最小值为min_size，总长度为length，单位长度为unit_length的顺子
function game_logic.get_stright(cards_value, counts, min_size, length, unit_length)
    local need_joker = 0
    local ret = {}
    --若第一张牌不存在，则不存在（财神默认最大，不能放在第一位）
    if counts[min_size] == 0 then
        return ret
    end
    --判断这组牌是否存在
    for i = min_size, min_size+math.floor(length/unit_length)-1 do
        local tmp_size = i
        if tmp_size == 14 then
            tmp_size = 1
        end
        if counts[tmp_size] < unit_length then
            need_joker = need_joker + unit_length - counts[tmp_size]
        end
    end
    --存在，则在手牌中找出，放入ret
    if need_joker <= counts[CardSize.rjoker] then
        for i = min_size, min_size+math.floor(length/unit_length)-1 do
            local tmp_size = i
            if tmp_size == 14 then
                tmp_size = 1
            end
            local added_count = 0
            for j=1,#cards_value do
                if game_logic.get_card_size(cards_value[j]) == tmp_size then
                    table.insert(ret, cards_value[j])
                    added_count = added_count + 1
                end
                if added_count == unit_length then
                    break;
                end
            end
            --牌数不够财神来凑
            if added_count < unit_length then
                local added_joker_count = 0
                for j=1,#cards_value do
                    if game_logic.get_card_size(cards_value[j]) == CardSize.rjoker then
                        table.insert(ret, cards_value[j])
                        added_joker_count = added_joker_count +1
                    end
                    if added_joker_count == unit_length - added_count then
                        break;
                    end
                end
            end
        end
    end
    return ret
end
--获取手牌中 大于 最小值为last_outing_min_size 单位长度为unit_length，总长度为last_out_cards_count 的顺子
function game_logic.get_bigger_unit_length_stright(cards_value, counts, last_out_cards_count, last_outing_min_size, unit_length)
    local ret = {}
    if last_outing_min_size + math.floor(last_out_cards_count/unit_length) - 1 >= 14 then
        return ret
    end

    for i = last_outing_min_size+1, 15-math.floor(last_out_cards_count/unit_length) do
        local tmp_ret = game_logic.get_stright(cards_value, counts, i, last_out_cards_count, unit_length)
        if #tmp_ret > 0 then
            table.insert(ret, tmp_ret)
        end
    end
    return ret
end
--获取王炸
function game_logic.get_joker_bomb(cards_value, counts, length)
    local ret = {}
    if counts[CardSize.bjoker] + counts[CardSize.rjoker] < length then
        return ret
    end
    local added_joker_count = 0
    local tmp_ret = {}
    for i=1,#cards_value do
        if game_logic.get_card_size(cards_value[i]) >= CardSize.bjoker then
            table.insert(tmp_ret, cards_value[i])
            added_joker_count = added_joker_count + 1
        end
        if added_joker_count == length then
            table.insert(ret, tmp_ret)
            break
        end
    end
    return ret
end

--提示结果中插入炸弹提示
function game_logic.add_bomb_hint(ret, cards_type, unit_length, hand_cards_value, counts)
    --4炸
    if cards_type < CardsType.bomb_4 then
        local tmp_ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, 0, 4)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
     --5炸
    if cards_type < CardsType.bomb_5 then
        local tmp_ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, 0, 5)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end    
    --6炸
    if cards_type < CardsType.bomb_6 then
        local tmp_ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, 0, 6)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
   --三王炸
    if cards_type < CardsType.bomb_joker_3 then
        local tmp_ret = game_logic.get_joker_bomb(hand_cards_value, counts, 3)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
     --7线连炸
    if cards_type < CardsType.bomb_7 then
        local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, 4*3, 2, 4)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
    --7炸
    if cards_type < CardsType.bomb_joker_4 and unit_length < 7 then
        local tmp_ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, 0, 7)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
    --天王炸
    if cards_type < CardsType.bomb_joker_4 then
        local tmp_ret = game_logic.get_joker_bomb(hand_cards_value, counts, 4)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
    --8线连炸
    if cards_type < CardsType.bomb_8 then
        for i=4, 8 do
            for j= 3,6 do
                if i*j < 27 and i+j == 8 then
                    local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, i*j, 2, i)
                    for k,v in pairs(tmp_ret) do
                        table.insert(ret, v)
                    end
                end
            end
        end
    end
    --8炸
    if cards_type < CardsType.bomb_9 and unit_length < 8 then    
        local tmp_ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, 0, 8)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
    --9线连炸
    if cards_type < CardsType.bomb_9 then
        for i=4, 8 do
            for j= 3,6 do
                if i*j < 27 and i+j == 9 then
                    local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, i*j, 2, i)
                    for k,v in pairs(tmp_ret) do
                        table.insert(ret, v)
                    end
                end
            end
        end
    end
    --9炸
    if cards_type < CardsType.bomb_10 and unit_length < 9 then
        local tmp_ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, 0, 9)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
    if cards_type < CardsType.bomb_10 then 
        --10线连炸
        for i=4, 8 do
            for j= 3,6 do
                if i*j < 27 and i+j == 10 then
                    local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, i*j, 2, i)
                    for k,v in pairs(tmp_ret) do
                        table.insert(ret, v)
                    end
                end
            end
        end
    end
    --10炸
    if cards_type < CardsType.bomb_11 and unit_length < 10 then
        local tmp_ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, 0, 10)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
    --11线连炸
    if cards_type < CardsType.bomb_11 then
        
        local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, 8*3, 2, 8)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
end


--提示
function game_logic.hint(hand_cards_value, hand_cards_count, last_out_cards_value, last_out_cards_count)
    local ret = {}
    local last_out_type, last_out_unit_length = game_logic.get_cards_type(last_out_cards_value, last_out_cards_count)
    local tmp_last_out_cards = game_logic.sort_outing_cards(last_out_cards_value, last_out_cards_count)
    local last_outing_min_size = game_logic.get_fact_min_size(last_out_cards_value, last_out_cards_count, last_out_type)
    local counts = game_logic.cards_value_to_counts(hand_cards_value, hand_cards_count)

    if last_out_type == CardsType.single then
        ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 1)
        --插入炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.double then
        ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 2)
        --插入炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.three then
        ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 3)
        --插入炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.stright_s then
        ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, last_out_cards_count, last_outing_min_size, 1)
        --插入炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.stright_d then
        ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, last_out_cards_count, last_outing_min_size, 2)
        --插入炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.stright_t then
        ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, last_out_cards_count, last_outing_min_size, 3)
        --插入炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_4 then
        ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 4)
        --插入更大炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_5 then
        ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 5)
        --插入更大炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_joker_3 then
        --插入更大炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_6 then
        ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 6)
        --插入更大炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_7 then
        if last_out_unit_length < 7 then
            ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, 4*3, last_outing_min_size, 4)
        else
            ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 7)
        end
        --插入更大炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_joker_4 then
        --插入更大炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_8 then
        if last_out_unit_length < 8 then
            --last_out_unit_length单位长度，最小值大于last_outing_min_size的8线 连炸
            local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, last_out_unit_length*(8-last_out_unit_length), last_outing_min_size, last_out_unit_length)
            for k,v in pairs(tmp_ret) do
                table.insert(ret, v)
            end
            --大于last_out_unit_length单位长度的8线 连炸
            for i=last_out_unit_length+1, 8 do
                for j= 3,6 do
                    if i*j < 27 and i+j == 8 then
                        local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, i*j, 2, i)
                        for k,v in pairs(tmp_ret) do
                            table.insert(ret, v)
                        end
                    end
                end
            end
        else
        --最小值大于last_outing_min_size 的8炸
            ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 8)
        end
        --插入更大炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_9 then
        if last_out_unit_length < 9 then
            --last_out_unit_length单位长度，最小值大于last_outing_min_size的9线 连炸
            local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, last_out_unit_length*(9-last_out_unit_length), last_outing_min_size, last_out_unit_length)
            for k,v in pairs(tmp_ret) do
                table.insert(ret, v)
            end
            --大于last_out_unit_length单位长度的8线 连炸
            for i=last_out_unit_length+1, 8 do
                for j= 3,6 do
                    if i*j < 27 and i+j == 9 then
                        local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, i*j, 2, i)
                        for k,v in pairs(tmp_ret) do
                            table.insert(ret, v)
                        end
                    end
                end
            end
        else
        --最小值大于last_outing_min_size 的9炸
            ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 9)
        end
        --插入更大炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_10 then
        if last_out_unit_length < 10 then
            --last_out_unit_length单位长度，最小值大于last_outing_min_size的10线 连炸
            local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, last_out_unit_length*(10-last_out_unit_length), last_outing_min_size, last_out_unit_length)
            for k,v in pairs(tmp_ret) do
                table.insert(ret, v)
            end
            --大于last_out_unit_length单位长度的8线 连炸
            for i=last_out_unit_length+1, 8 do
                for j= 3,6 do
                    if i*j < 27 and i+j == 10 then
                        local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, i*j, 2, i)
                        for k,v in pairs(tmp_ret) do
                            table.insert(ret, v)
                        end
                    end
                end
            end
        else
        --最小值大于last_outing_min_size 的10炸
            ret = game_logic.get_bigger_unit_length_cards(hand_cards_value, counts, last_outing_min_size, 10)
        end
       --插入更大炸弹
        game_logic.add_bomb_hint(ret, last_out_type, last_out_unit_length, hand_cards_value, counts)
    elseif last_out_type == CardsType.bomb_11 then
        local tmp_ret = game_logic.get_bigger_unit_length_stright(hand_cards_value, counts, 24, last_outing_min_size, 8)
        for k,v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end
    --规避提示出现错误牌型，之后还需再找一下bug
    if #ret > 0 then
        local tmp_ret = {}
        for k, v in pairs(ret) do
            local ret_type = game_logic.get_cards_type(v, #v)
            if ret_type ~= CardsType.null then
                table.insert(tmp_ret, v)
            end
        end
        ret = {}
        for k, v in pairs(tmp_ret) do
            table.insert(ret, v)
        end
    end

    return ret
end

--选择的牌中最小值与最大值 在手牌中这样一个最大最小值的顺子牌，则返回这个顺子
function game_logic.auto_get_stright(hand_cards_value, hand_cards_count, selected_cards_value, selected_cards_count)
    if selected_cards_count > 2 then
        return {}
    end

    local selected_min_size = game_logic.get_min_card_from_cards(selected_cards_value, selected_cards_count)
    local selected_max_size = game_logic.get_max_card_from_cards(selected_cards_value, selected_cards_count)
    local counts = game_logic.cards_value_to_counts(hand_cards_value, hand_cards_count)

    if (selected_max_size == CardSize.a and selected_min_size <= 10 and selected_min_size >=3) then
        return game_logic.get_stright(hand_cards_value, counts, selected_min_size, 14 - selected_min_size+1, 1)
    elseif selected_max_size <= 13 and (selected_max_size - selected_min_size +1) >=5 then 
        return game_logic.get_stright(hand_cards_value, counts, selected_min_size, selected_max_size - selected_min_size+1, 1)
    end
    return {}
end

function game_logic.test()
    local last_out_cards = {}
    local hand_cards = {0x4f, 0x32, 0x22, 0x21, 0x2d, 0x0d, 0x0d, 0x3c, 0x1c, 0x3b, 0x2b, 0x1b,
							0x3a, 0x2a, 0x19, 0x28, 0x18, 0x37, 0x17, 0x07, 0x36, 0x35, 0x25,
							0x34, 0x24, 0x14, 0x04}

    local ret = game_logic.hint(hand_cards, #hand_cards, last_out_cards, #last_out_cards)
--    local cards_value = {0x4f,0x4f,0x09,0x09,0x08,0x07,0x07,0x06,0x06,0x05,0x04,0x04,0x03,0x03}
--    local ret = game_logic.sort_outing_cards(cards_value, 14)
    return ret
end