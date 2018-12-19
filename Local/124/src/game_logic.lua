--------------------------------------------------------------------------------
-- 二人斗地主游戏逻辑
--------------------------------------------------------------------------------
game_logic = game_logic or {}

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------

function game_logic.get_real_card_size(card)
    if card == nil then
        print("game_logic.get_real_card_size ... wrong card value")
    end
    return card % 16
end

function game_logic.get_card_color(card)
    if card == nil then
        print("UIHelper.get_card_color ... wrong card value")
    end
    return math.floor(card / 16)
end

function game_logic.search_auto_outcards(cards, count, target_tbl)
	local same_count = 1
	local temp_count = 1
	local cards_temp = game_logic.analyse_cards(cards, count)
	local have_king = false
	if count >= 2 and game_logic.get_card_size(cards[1]) == 17 and game_logic.get_card_size(cards[2]) == 16 then
		have_king = true
	end
	local need_count = have_king and count - 2 or count
	for i=1, need_count do
		if i >= temp_count then
			local card = game_logic.get_card_size(cards[count-(i-1)])
			local tbl = {}
			tbl.hintcards_data = {}
			tbl.hintcards_type = 0
			tbl.hintcards_count = 0
			same_count = 1
			table.insert(tbl.hintcards_data, cards[count-(i-1)])
			for j=i+1, count do
				if (game_logic.get_card_size(cards[count-(j-1)]) == card) then
					table.insert(tbl.hintcards_data, cards[count-(j-1)])
					same_count = same_count + 1
				else
					break
				end
			end
			temp_count = temp_count + same_count
			if same_count == 1 then
				tbl.hintcards_type = KindCards.cards_1
			elseif same_count == 2 then
				tbl.hintcards_type = KindCards.cards_2
			elseif same_count == 3 then
				if (have_king == false and cards_temp.type_count[1] ~= 0) or (have_king == true and cards_temp.type_count[1] > 2) then
					table.insert(tbl.hintcards_data, cards_temp.cards_data[1][cards_temp.type_count[1]])
					tbl.hintcards_type = KindCards.cards_3_1
				elseif cards_temp.type_count[2] ~= 0 then
					table.insert(tbl.hintcards_data, cards_temp.cards_data[2][cards_temp.type_count[2]*2])
					table.insert(tbl.hintcards_data, cards_temp.cards_data[2][cards_temp.type_count[2]*2-1])
					tbl.hintcards_type = KindCards.cards_3_2
				else
					tbl.hintcards_type = KindCards.cards_3
				end
			elseif same_count == 4 then
				tbl.hintcards_type = KindCards.cards_bomb
			end
			tbl.hintcards_count = same_count
			table.insert(target_tbl, tbl)
		end
	end
end

function game_logic.search_kind_cards_1(cards, count, max_cards, max_count, max_type, target_tbl)
	local temp_cards = game_logic.sort_cards_by_count(max_cards, max_count)
	local card = game_logic.get_card_size(temp_cards[1])
	local cards_temp = game_logic.analyse_cards(cards, count)
	for i=1, 4 do
		if i >= max_count then
			for j=1, cards_temp.type_count[i] do
				local tbl = {}
				tbl.hintcards_data = {}
				tbl.hintcards_count = max_count
				tbl.hintcards_type = max_type
				local index = (cards_temp.type_count[i] - j + 1)*i
				if game_logic.get_card_size(cards_temp.cards_data[i][index]) > card then
					for i,v in ipairs(cards_temp.cards_data[i]) do
						if i <= index and i >= index-max_count+1 then
							table.insert(tbl.hintcards_data, v)
						end
					end
					table.insert(target_tbl, tbl)
				end
			end
		end
	end
end

function game_logic.search_kind_cards_2(cards, count, max_cards, max_count, max_type, target_tbl)
	local temp_cards = game_logic.sort_cards_by_count(max_cards, max_count)
	local card = game_logic.get_card_size(temp_cards[1])
	for i=max_count, count do
		local card_value = game_logic.get_card_size(cards[count-i+1])
		if max_count > 1 and card_value >= 15 then
			break
		end
		if card_value > card then
			local tbl = {}
			tbl.hintcards_data = {}
			tbl.hintcards_count = max_count
			tbl.hintcards_type = max_type
			local line_count = 0
			for j = count-i+1, count do
				if (game_logic.get_card_size(cards[j]) + line_count) == card_value then
					if #target_tbl ~= 0 and line_count == 0 then
						local cards_temp = target_tbl[#target_tbl]
						local value =game_logic.get_card_size(cards_temp.hintcards_data[1])
						if value == card_value then
							break
						end
					end
					table.insert(tbl.hintcards_data, cards[j])
					line_count = line_count + 1
					if line_count == max_count then
						table.insert(target_tbl, tbl)
						break
					end
				end
			end
		end
	end
end

function game_logic.search_kind_cards_3(cards, count, max_cards, max_count, max_type, target_tbl)
	local temp_cards = game_logic.sort_cards_by_count(max_cards, max_count)
	local card = game_logic.get_card_size(temp_cards[1])
	for i=max_count, count do
		local card_value = game_logic.get_card_size(cards[count-i+1])
		if max_count > 1 and card_value >= 15 then
			break
		end
		if card_value > card then
			local tbl = {}
			tbl.hintcards_data = {}
			tbl.hintcards_count = max_count
			tbl.hintcards_type = max_type
			local line_count = 0
			for j = count-i+1, count - 1 do
				if (game_logic.get_card_size(cards[j]) + line_count) == card_value and 
				(game_logic.get_card_size(cards[j+1]) + line_count) == card_value then
					if #target_tbl ~= 0 and line_count == 0 then
						local cards_temp = target_tbl[#target_tbl]
						local value =game_logic.get_card_size(cards_temp.hintcards_data[1])
						if value == card_value then
							break
						end
					end
					table.insert(tbl.hintcards_data, cards[j])
					table.insert(tbl.hintcards_data, cards[j+1])
					line_count = line_count + 1
					if line_count*2 == max_count then
						table.insert(target_tbl, tbl)
						break
					end
				end			
			end
		end
	end
end

function game_logic.search_kind_cards_4(cards, count, max_cards, max_count, max_type, target_tbl)
	local temp_cards = game_logic.sort_cards_by_count(max_cards, max_count)
	local card = game_logic.get_card_size(temp_cards[1])

	local line_count_tag = 0
	if max_type == KindCards.cards_3_1 or 
		(max_type == KindCards.cards_plane and max_count % 4 == 0)then
		line_count_tag = max_count / 4
	elseif max_type == KindCards.cards_3_2 or
		(max_type == KindCards.cards_plane and max_count % 5 == 0) then
		line_count_tag = max_count / 5
	elseif max_type == KindCards.cards_shunzi_3 then
		line_count_tag = max_count / 3
	end

	for i=line_count_tag*3, count do
		local card_value = game_logic.get_card_size(cards[count-i+1])
		if line_count_tag > 1 and card_value >= 15 then
			break
		end
		if card_value > card then
			local tbl = {}
			tbl.hintcards_data = {}
			tbl.hintcards_count = max_count
			tbl.hintcards_type = max_type
			local line_count = 0
			for j = count - i+1, count - 2 do
				if (game_logic.get_card_size(cards[j]) + line_count) == card_value and 
					(game_logic.get_card_size(cards[j+1]) + line_count) == card_value and 
					(game_logic.get_card_size(cards[j+2]) + line_count) == card_value then
					if #target_tbl ~= 0 and line_count == 0 then
						local cards_temp = target_tbl[#target_tbl]
						local value =game_logic.get_card_size(cards_temp.hintcards_data[1])
						if value == card_value then
							break
						end
					end
					table.insert(tbl.hintcards_data, cards[j])
					table.insert(tbl.hintcards_data, cards[j+1])
					table.insert(tbl.hintcards_data, cards[j+2])
					line_count = line_count + 1
					if line_count == line_count_tag then
						local left_count = max_count - line_count * 3
						local cards_temp = game_logic.analyse_cards(cards, #cards)
						if left_count / line_count_tag == 1 then
							if left_count ~= 0 then
								for i=1, cards_temp.type_count[1] do
									local index = cards_temp.type_count[1] + 1 - i
									if game_logic.get_card_size(cards_temp.cards_data[1][index]) ~= game_logic.get_card_size(tbl.hintcards_data[1]) then
										table.insert(tbl.hintcards_data, cards_temp.cards_data[1][index])
										left_count = left_count - 1
										if left_count == 0 then
											break
										end
									end
								end
							end
							if left_count ~= 0 then
								for i=1, cards_temp.type_count[2]*2 do
									local index = cards_temp.type_count[2]*2 + 1 - i
									if game_logic.get_card_size(cards_temp.cards_data[2][index]) ~= game_logic.get_card_size(tbl.hintcards_data[1]) then
										table.insert(tbl.hintcards_data, cards_temp.cards_data[2][index])
										left_count = left_count - 1
										if left_count == 0 then
											break
										end
									end
								end
							end
							if left_count ~= 0 then
								for i=1, cards_temp.type_count[3]*3 do
									local index = cards_temp.type_count[3]*3 + 1 - i
									local is_same = false
									for j=1, line_count_tag do
										if game_logic.get_card_size(cards_temp.cards_data[3][index]) == game_logic.get_card_size(tbl.hintcards_data[3*(j-1)+1]) then
											is_same = true
											break
										end
									end
									if not is_same then
										table.insert(tbl.hintcards_data, cards_temp.cards_data[3][index])
										left_count = left_count - 1
										if left_count == 0 then
											break
										end
									end
								end
							end
						elseif left_count / line_count_tag == 2 then
							if left_count ~= 0 then
								for i=1, cards_temp.type_count[2] do
									local index = (cards_temp.type_count[2] - i)*2 + 1
									if game_logic.get_card_size(cards_temp.cards_data[2][index]) ~= game_logic.get_card_size(tbl.hintcards_data[1]) then
										table.insert(tbl.hintcards_data, cards_temp.cards_data[2][index])
										table.insert(tbl.hintcards_data, cards_temp.cards_data[2][index+1])
										left_count = left_count - 2
										if left_count == 0 then
											break
										end
									end
								end
							end
							if left_count ~= 0 then
								for i=1, cards_temp.type_count[3] do
									local index = (cards_temp.type_count[3] - i)*3 + 1
									local is_same = false
									for j=1, line_count_tag do
										if game_logic.get_card_size(cards_temp.cards_data[3][index]) == game_logic.get_card_size(tbl.hintcards_data[3*(j-1)+1]) then
											is_same = true
											break
										end
									end
									if not is_same then
										table.insert(tbl.hintcards_data, cards_temp.cards_data[3][index])
										table.insert(tbl.hintcards_data, cards_temp.cards_data[3][index+1])
										left_count = left_count - 2
										if left_count == 0 then
											break
										end
									end
								end
							end
						end
						if left_count == 0 then
							table.insert(target_tbl, tbl)
							break
						end
					end
				end
			end
		end
	end
end

function game_logic.search_kind_cards_5(cards, count, max_cards, max_count, max_type, target_tbl)
	local temp_cards = game_logic.sort_cards_by_count(max_cards, max_count)
	local card = game_logic.get_card_size(temp_cards[1])
	for i=4, count do
		local card_value = game_logic.get_card_size(cards[count-i+1])
		if card_value > 15 then
			break
		end
		if card_value > card then
			local tbl = {}
			tbl.hintcards_data = {}
			tbl.hintcards_count = max_count
			tbl.hintcards_type = max_type
			for j = count - i+1, count - 3 do
				if game_logic.get_card_size(cards[j]) == card_value and 
					game_logic.get_card_size(cards[j+1]) == card_value and 
					game_logic.get_card_size(cards[j+2]) == card_value and
					game_logic.get_card_size(cards[j+3]) == card_value then
					if #target_tbl ~= 0 and line_count == 0 then
						local cards_temp = target_tbl[#target_tbl]
						local value = game_logic.get_card_size(cards_temp.hintcards_data[1])
						if value == card_value then
							break
						end
					end
					table.insert(tbl.hintcards_data, cards[j])
					table.insert(tbl.hintcards_data, cards[j+1])
					table.insert(tbl.hintcards_data, cards[j+2])
					table.insert(tbl.hintcards_data, cards[j+3])

					local left_count = max_count - 4
					local cards_temp = game_logic.analyse_cards(cards, #cards)							
					if max_type == KindCards.cards_4_2 then
						if left_count ~= 0 then
							for i=1, cards_temp.type_count[1] do
								local index = cards_temp.type_count[1] + 1 - i
								if game_logic.get_card_size(cards_temp.cards_data[1][index]) ~= game_logic.get_card_size(tbl.hintcards_data[1]) then
									table.insert(tbl.hintcards_data, cards_temp.cards_data[1][index])
									left_count = left_count - 1
									if left_count == 0 then
										break
									end
								end
							end
						end
						if left_count ~= 0 then
							for i=1, cards_temp.type_count[2]*2 do
								local index = cards_temp.type_count[2]*2 + 1 - i
								if game_logic.get_card_size(cards_temp.cards_data[2][index]) ~= game_logic.get_card_size(tbl.hintcards_data[1]) then
									table.insert(tbl.hintcards_data, cards_temp.cards_data[2][index])
									left_count = left_count - 1
									if left_count == 0 then
										break
									end
								end
							end
						end
						if left_count ~= 0 then
							for i=1, cards_temp.type_count[3]*3 do
								local index = cards_temp.type_count[3]*3 + 1 - i
								if game_logic.get_card_size(cards_temp.cards_data[3][index]) ~= game_logic.get_card_size(tbl.hintcards_data[1]) then
									table.insert(tbl.hintcards_data, cards_temp.cards_data[3][index])
									left_count = left_count - 1
									if left_count == 0 then
										break
									end
								end
							end
						end
						if left_count == 0 then
							table.insert(target_tbl, tbl)
							break
						end
					elseif max_type == KindCards.cards_4_4 then
						if left_count ~= 0 then
							for i=1, cards_temp.type_count[2] do
								local index = (cards_temp.type_count[2] - i)*2 + 1
								if game_logic.get_card_size(cards_temp.cards_data[2][index]) ~= game_logic.get_card_size(tbl.hintcards_data[1]) then
									table.insert(tbl.hintcards_data, cards_temp.cards_data[2][index])
									table.insert(tbl.hintcards_data, cards_temp.cards_data[2][index+1])
									left_count = left_count - 2
									if left_count == 0 then
										break
									end
								end
							end
						end
						if left_count ~= 0 then
							for i=1, cards_temp.type_count[3] do
								local index = (cards_temp.type_count[3] - i)*3 + 1
								if game_logic.get_card_size(cards_temp.cards_data[3][index]) ~= game_logic.get_card_size(tbl.hintcards_data[1]) then
									table.insert(tbl.hintcards_data, cards_temp.cards_data[3][index])
									table.insert(tbl.hintcards_data, cards_temp.cards_data[3][index+1])
									left_count = left_count - 2
									if left_count == 0 then
										break
									end
								end
							end
						end
						if left_count == 0 then
							table.insert(target_tbl, tbl)
							break
						end
					end
				end
			end
		end
	end
end

function game_logic.search_kind_cards_6(cards, count, max_type, target_tbl)
	if max_type ~= KindCards.cards_bomb and count >= 4 then
		for i=4, count do
			if count-i+1 <= 0 then
				break
			end
			local card = game_logic.get_card_size(cards[count-i+1])
			if card > 15 then
				break
			end
			for j=count-i+1, count - 3 do
				if game_logic.get_card_size(cards[j]) == card and
					game_logic.get_card_size(cards[j + 1]) == card and
					game_logic.get_card_size(cards[j + 2]) == card and
					game_logic.get_card_size(cards[j + 3]) == card then
					local tbl = {}
					tbl.hintcards_data = {}
					tbl.hintcards_type = KindCards.cards_bomb
					tbl.hintcards_count = 4
					table.insert(tbl.hintcards_data, cards[j])
					table.insert(tbl.hintcards_data, cards[j+1])
					table.insert(tbl.hintcards_data, cards[j+2])
					table.insert(tbl.hintcards_data, cards[j+3])

					table.insert(target_tbl, tbl)
				end
			end
		end
	end
end

function game_logic.search_kind_cards_7(cards, count, target_tbl)
	if count >= 2 and game_logic.get_card_size(cards[1]) == 17 and game_logic.get_card_size(cards[2]) == 16 then
		local tbl = {}
		tbl.hintcards_data = {}
		tbl.hintcards_type = KindCards.cards_king
		tbl.hintcards_count = 2
		table.insert(tbl.hintcards_data, cards[1])
		table.insert(tbl.hintcards_data, cards[2])

		table.insert(target_tbl, tbl)
	end
end

function game_logic.cards_compare(cards1, count1, cards2, count2)
	local type1 = game_logic.get_outcards_type(cards1, count1)
	local type2 = game_logic.get_outcards_type(cards2, count2)

	if type2 == KindCards.cards_error then
		return false
	elseif type2 == KindCards.cards_king then
		return true
	end

	if type1 == KindCards.cards_bomb and type2 ~= KindCards.cards_bomb then
		return false
	end

	if type1 ~= KindCards.cards_bomb and type2 == KindCards.cards_bomb then
		return true
	end

	if count1 ~= count2 or type1 ~= type2 then
		return false
	end
     
	if type2 == KindCards.cards_3_1 or type2 == KindCards.cards_3_2 then
		local temp_cards1 = game_logic.analyse_cards(cards1, count1)
		local temp_cards2 = game_logic.analyse_cards(cards2, count2)
		return game_logic.get_card_size(temp_cards2.cards_data[3][1]) > game_logic.get_card_size(temp_cards1.cards_data[3][1])
	elseif type2 == KindCards.cards_plane then
		local temp_cards1 = game_logic.analyse_cards(cards1, count1)
		local temp_cards2 = game_logic.analyse_cards(cards2, count2)

		local cards_1 = game_logic.get_card_size(temp_cards1.cards_data[3][1])
		local cards_2 = game_logic.get_card_size(temp_cards2.cards_data[3][1])
		if cards_1 == 15 then
			cards_1 = game_logic.get_card_size(temp_cards1.cards_data[3][4])
		end
		if cards_2 == 15 then
			cards_2 = game_logic.get_card_size(temp_cards2.cards_data[3][4])
		end

		if temp_cards1.type_count[4] ~= 0 then
			for i=1, temp_cards1.type_count[4] do
				if temp_cards1.cards_data[4][i*4] > cards_1 then
					cards_1 = temp_cards1.cards_data[4][i*4]
				end
			end
		end
		if temp_cards2.type_count[4] ~= 0 then
			for i=1, temp_cards2.type_count[4] do
				if temp_cards2.cards_data[4][i*4] > cards_1 then
					cards_2 = temp_cards2.cards_data[4][i*4]
				end
			end
		end

		return cards_2 > cards_1
	elseif type2 == KindCards.cards_4_2 or type2 == KindCards.cards_4_4 then
		local temp_cards1 = game_logic.analyse_cards(cards1, count1)
		local temp_cards2 = game_logic.analyse_cards(cards2, count2)
		return game_logic.get_card_size(temp_cards2.cards_data[4][1]) > game_logic.get_card_size(temp_cards1.cards_data[4][1])
	else
		return game_logic.get_card_size(cards2[1]) > game_logic.get_card_size(cards1[1])
	end
end

function game_logic.get_cards_3_count(cards, count)
	local temp_count = 0
	for i=1, count do
		if game_logic.get_card_size(cards[1]) ~= (game_logic.get_card_size(cards[i*3-2]) + i - 1) then
			break
		else
			temp_count = temp_count + 1
		end
	end
	return temp_count
end

function game_logic.is_cards_plane(cards, count)
	game_logic.sort_cards_by_size(cards.cards_data[3], cards.type_count[3]*3)
	if cards.type_count[3] < 2 and cards.type_count[4] == 0 then
		return false
	end
	local temp_count = game_logic.get_cards_3_count(cards.cards_data[3], cards.type_count[3])
	if cards.type_count[3] ~= 0 then
		if game_logic.get_card_size(cards.cards_data[3][1]) >= 15 then
			if cards.type_count[3] < 4 and cards.type_count[4] == 0 then
				return false
			else
				temp_count = temp_count - 1
			end
		end
	else
		return false
	end
	if game_logic.get_card_size(cards.cards_data[3][1]) < 3 then
		return false
	end
	if cards.type_count[1] == temp_count and (cards.type_count[1]+temp_count*3) == count then
		return true
	elseif cards.type_count[2] == temp_count and (cards.type_count[2]*2+temp_count*3) == count then
		return true
	elseif cards.type_count[2]*2 == temp_count and (cards.type_count[2]*2+temp_count*3) == count then
		return true
	elseif temp_count == cards.type_count[2] + 2*cards.type_count[4] and (cards.type_count[2]*2+cards.type_count[4]*4+temp_count*3) == count then
		return true
	elseif temp_count == count - 3*temp_count then
		return true
	end
	for i=temp_count, 2, -1 do
		if i == count - 3*i then
			return true
		end
	end
	if cards.type_count[4] ~= 0 then
		for i=1, cards.type_count[4] do
			for j,v in ipairs(cards.cards_data[4]) do
				if game_logic.get_card_size(v) < 3 then
					return false
				end
				if game_logic.get_card_size(v) < 15 then
					if j%4 > 0 then
						table.insert(cards.cards_data[3], v)
						if j%4 == 3 then
							cards.type_count[3] = cards.type_count[3] + 1
							game_logic.sort_cards_by_size(cards.cards_data[3], cards.type_count[3]*3)
							temp_count = game_logic.get_cards_3_count(cards.cards_data[3], cards.type_count[3])
							if temp_count == count - 3*temp_count then
								return true
							end
						end
					else
						table.insert(cards.cards_data[1], v)
						cards.type_count[1] = cards.type_count[1] + 1
					end
				end
			end
		end
	end
	return false
end

function game_logic.is_cards_shunzi_3(cards, count)
	game_logic.sort_cards_by_size(cards.cards_data[3], count)
	if cards.type_count[3] < 2 then
		return false
	end
	if cards.type_count[3] ~= count/3 then
		return false
	end
	for i=1, cards.type_count[3] do
		if game_logic.get_card_size(cards.cards_data[3][1]) ~= (game_logic.get_card_size(cards.cards_data[3][i*3-2]) + i -1) then
			return false
		end
	end
	if game_logic.get_card_size(cards.cards_data[3][1]) >= 15 or 
		game_logic.get_card_size(cards.cards_data[3][1]) < 4 then
		return false
	end
	return true
end

function game_logic.is_cards_shunzi_2(cards, count)
	game_logic.sort_cards_by_size(cards.cards_data[2], count)
	if cards.type_count[2] < 3 then
		return false
	end
	if cards.type_count[2] ~= count/2 then
		return false
	end
	for i=1, cards.type_count[2] do
		if game_logic.get_card_size(cards.cards_data[2][1]) ~= (game_logic.get_card_size(cards.cards_data[2][i*2-1])+i-1) then
			return false
		end
	end
	if game_logic.get_card_size(cards.cards_data[2][1]) >= 15 or 
		game_logic.get_card_size(cards.cards_data[2][1]) < 5 then
		return false
	end
	return true
end

function game_logic.is_cards_shunzi_1(cards, count)
	game_logic.sort_cards_by_size(cards.cards_data[1], count)
	if cards.type_count[1] ~= count then
		return false
	end

	for i=1, cards.type_count[1] do
		if game_logic.get_card_size(cards.cards_data[1][1]) ~= (game_logic.get_card_size(cards.cards_data[1][i])+i-1) then
			return false
		end 
	end
	if game_logic.get_card_size(cards.cards_data[1][1]) >= 15 or
		game_logic.get_card_size(cards.cards_data[1][1]) < 7 then
		return false
	end
	return true
end

function game_logic.is_cards_4_4(cards, count)
	if count ~= 8 then
		return false
	end
	if cards.type_count[4] ~= 1 then
		return false
	end
	if cards.type_count[2] ~= 2 then
		return false
	end
	if game_logic.is_cards_valid(cards.cards_data[4][1]) == false or 
		game_logic.is_cards_valid(cards.cards_data[2][1]) == false or 
		game_logic.is_cards_valid(cards.cards_data[2][3]) == false then
		return false
	end
	return true
end

function game_logic.is_cards_4_2(cards, count)
	if count ~= 6 then
		return false
	end
	if cards.type_count[4] ~= 1 then
		return false
	end
	if game_logic.is_cards_valid(cards.cards_data[4][1]) == false then 
		return false
	end
	if cards.type_count[1] == count - cards.type_count[4] then
		if game_logic.is_cards_valid(cards.cards_data[1][1]) == false or 
			game_logic.is_cards_valid(cards.cards_data[1][2]) == false then
			return false
		end
	elseif cards.type_count[2] * 2 ==  count - cards.type_count[4] then
		if game_logic.is_cards_valid(cards.cards_data[2][1]) == false then
			return false
		end
	end
	return true
end

function game_logic.is_cards_3_2(cards, count)
	if count ~= 5 then
		return false
	end
	if cards.type_count[3] ~= 1 then
		return false
	end
	if cards.type_count[2] ~= 1 then
		return false
	end
	if game_logic.is_cards_valid(cards.cards_data[3][1]) == false or 
		game_logic.is_cards_valid(cards.cards_data[2][1]) == false then
		return false
	end
	return true
end

function game_logic.is_cards_3_1(cards, count)
	local temp_cards = game_logic.analyse_cards(cards, count) 
	if temp_cards.type_count[3] ~= 1 then
		return false
	end
	if game_logic.is_cards_valid(temp_cards.cards_data[3][1]) == false or 
		game_logic.is_cards_valid(temp_cards.cards_data[1][1]) == false then
		return false
	end
	return true
end

function game_logic.is_cards_bomb(cards, count)
	local temp_cards = game_logic.analyse_cards(cards, count) 
	if temp_cards.type_count[4] ~= 1 then
		return false
	end
	return game_logic.is_cards_valid(temp_cards.cards_data[4][1])
end

function game_logic.is_cards_3(cards, count)
	if game_logic.get_card_size(cards[1]) ~= game_logic.get_card_size(cards[2]) or
		game_logic.get_card_size(cards[1]) ~= game_logic.get_card_size(cards[3]) then
		return false
	end 
	return game_logic.is_cards_valid(cards[1])
end

function game_logic.is_cards_king(cards, count)
	if game_logic.get_card_size(cards[1]) ~= 17 then
		return false
	end
	if game_logic.get_card_size(cards[2]) ~= 16 then
		return false
	end
	if game_logic.is_cards_valid(cards[1]) == false or
		game_logic.is_cards_valid(cards[2]) == false then
		return false
	end 
	return true
end

function game_logic.is_cards_2(cards, count)
	if game_logic.get_card_size(cards[1]) ~= game_logic.get_card_size(cards[2]) then
		return false
	end
	return game_logic.is_cards_valid(cards[1])
end

function game_logic.is_cards_1(cards, count)
	return game_logic.is_cards_valid(cards[1])
end

function game_logic.is_cards_valid(card)
	if game_logic.get_card_size(card) <= 0 or game_logic.get_card_size(card) > 17 then
		return false
	end
	return true
end

function game_logic.get_outcards_count(cards)
	local count = 0
	if cards ~= nil then
		for k,v in pairs(cards) do
			if v then
				count = count + 1
			end
		end
	end
	return count
end

function game_logic.get_outcards_type(cards, count)
	if count <= 0 or count > 20 then
		return KindCards.cards_error
	elseif count == 1 then
		if game_logic.is_cards_1(cards, count) == false then
			return KindCards.cards_error
		end
		return KindCards.cards_1
	elseif count == 2 then
		if game_logic.is_cards_2(cards, count) == true then
			return KindCards.cards_2
		elseif game_logic.is_cards_king(cards, count) == true then
			return KindCards.cards_king
		else
			return KindCards.cards_error
		end
	elseif count == 3 then
		if game_logic.is_cards_3(cards, count) == false then
			return KindCards.cards_error
		end
		return KindCards.cards_3
	elseif count == 4 then
		if game_logic.is_cards_bomb(cards, count) == true then
			return KindCards.cards_bomb
		elseif game_logic.is_cards_3_1(cards, count) == true then
			return KindCards.cards_3_1
		else
			return KindCards.cards_error
		end
	elseif count >= 5 then
		cards = game_logic.analyse_cards(cards, count)
		if game_logic.is_cards_3_2(cards, count) == true then
			return KindCards.cards_3_2
		elseif game_logic.is_cards_4_2(cards, count) == true then
			return KindCards.cards_4_2
		elseif game_logic.is_cards_4_4(cards, count) == true then
			return KindCards.cards_4_4
		elseif game_logic.is_cards_shunzi_1(cards, count) == true then
			return KindCards.cards_shunzi_1
		elseif game_logic.is_cards_shunzi_2(cards, count) == true then
			return KindCards.cards_shunzi_2
		elseif game_logic.is_cards_shunzi_3(cards, count) == true then
			return KindCards.cards_shunzi_3
		elseif game_logic.is_cards_plane(cards, count) == true then
			return KindCards.cards_plane
		else
			return KindCards.cards_error
		end
	end
end

function game_logic.analyse_cards(cards, count)
	local same_count = 1
	local temp_count = 1
	local tbl_result = {}
	tbl_result.cards_data = {[1]= {}, [2]={}, [3]={}, [4]={}}
	tbl_result.type_count = {0, 0, 0, 0}
	for i=1, count do
		local tbl = {}
		if i >= temp_count then
			same_count = 1
			table.insert(tbl, cards[i])
			for j=i+1, count do
				if game_logic.get_card_size(cards[j]) ~= game_logic.get_card_size(cards[i]) then
					break
				end
				same_count = same_count + 1
				table.insert(tbl, cards[j])			
			end
			if same_count > 4 or same_count < 1 then
				break
			end
			temp_count = temp_count + same_count
			for k,v in pairs(tbl) do
				if v and v ~= nil then
					table.insert(tbl_result.cards_data[same_count], v)
				end
			end
			tbl_result.type_count[same_count] = tbl_result.type_count[same_count] + 1
		end
	end
	
	return tbl_result
end

function game_logic.get_card_size(card)
	if game_logic.get_real_card_size(card) == 1 then
		return 14
	elseif game_logic.get_real_card_size(card) == 2 then
		return 15
	elseif game_logic.get_real_card_size(card) == 14 then
		return 16
	elseif game_logic.get_real_card_size(card) == 15 then
		return 17
	else
		return game_logic.get_real_card_size(card)
	end
end

function game_logic.sort_cards_by_size(cards, count)
	if count == 0 then
		return
	end
	local i = count - 1
	local j = 0
	for i=count, 1, -1 do
		for j=1, i do
			if cards[j] ~= 0 and cards[j+1] ~= 0 and cards[j] ~= nil and cards[j+1] ~= nil then
				local card1 = game_logic.get_card_size(cards[j])
				local card2 = game_logic.get_card_size(cards[j+1])
				if card1 < card2 then
					local temp_card = cards[j]
					cards[j] = cards[j+1]
					cards[j+1] = temp_card
				elseif card1 == card2 then
					if game_logic.get_card_color(cards[j]) < game_logic.get_card_color(cards[j+1]) then
						local temp_card = cards[j]
						cards[j] = cards[j+1]
						cards[j+1] = temp_card
					end
				end
			end
		end
	end
end

function game_logic.sort_cards_by_count(cards, count)
	local need_count = count
	local need_cards = cards or {}

	game_logic.sort_cards_by_size(need_cards, need_count)
	local tbl = game_logic.analyse_cards(need_cards, need_count)
	local temp_cards = {}
	for i = 4 , 1 , -1 do
		for k,v in pairs(tbl.cards_data[i]) do
			table.insert(temp_cards, v)
		end
	end

	return temp_cards
end
