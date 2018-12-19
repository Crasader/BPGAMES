
ui_tools = ui_tools or {}

-- 点击区域转换
function ui_tools.hitTest(sender, pos)
    local width = sender:getContentSize().width * sender:getScale()
    local height = sender:getContentSize().height * sender:getScale()

    local posx = sender:getPositionX()
    local posy = sender:getPositionY()
    
    local rect = cc.rect(posx - width/2, posy - height/2, width, height)
    
    return cc.rectContainsPoint(rect, pos)
end

--随机打乱一个数组
function ui_tools.randArrary(param_table)
	math.randomseed(os.time()) 

	--新的数组  和对应的原数组位置
	local new_table, new_index = {}, {}
	local table_size = #param_table
	local run_count = clone(table_size)
	for i=1, run_count do
		local n = math.random(1, table_size)
		while param_table[n] == nil do
			n = math.random(1, table_size)
		end
		new_table[i] = clone(param_table[n])
		new_index[i] = n
		param_table[n] = nil
	end
	return new_table, new_index
end
