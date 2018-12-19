--------------------------------------------------------------------------------
-- 玩法信息界面
--------------------------------------------------------------------------------
local UIControl = require("src/ui_control")
local UIRule = class("UIRule", UIControl)

local g_path = BPRESOURCE("res/rule/")

ptr_rule_info = nil
--------------------------------------------------------------------------------
-- 属性
--------------------------------------------------------------------------------
local Z_Order = { rule_btn = 1, rule_info = 2, game_btn = 3}
local g_game_tbl = { 207, 124, 114}

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function UIRule:ctor()
    print("DY Log >> UIRule")
    self.super:ctor(self)
    self.game_btn_btl = {}
    self.sleep_game_btn_tbl = {}
    self.rule_btn_tbl = {}
    self.game_list = {}
    self.sleep_rule_info = {}
    self.rule_info = {}
    self.ptr_img_point = nil
    self:init()
end
-- 初始化
function UIRule:init()
    self:set_bg(g_path .. "gui.png")
    self:set_title(g_path .. "title_rule.png")

	local rule_bg = self:get_gui()
	local rule_bg_size = rule_bg:getContentSize()

    -- 详情按钮
    local img_tbl = {{normal = g_path .. "btn_detail_1.png", pressed = g_path .. "btn_detail_2.png", anchor = cc.p(0.5, 0)}, 	-- 基本规则button
					{normal = g_path .. "btn_result_1.png", pressed = g_path .. "btn_result_2.png", anchor = cc.p(0.5, 0)}, 	-- 结算button
					{normal = g_path .. "btn_times_1.png", pressed = g_path .. "btn_times_2.png", anchor = cc.p(0.5, 0)}, 		-- 基本番型button
					{normal = g_path .. "btn_special_1.png", pressed = g_path .. "btn_special_2.png", anchor = cc.p(0.5, 0)}}	-- 特殊规则button
	local posX, posY = 232, rule_bg:getContentSize().height - 40
    for i=1, 4 do
    	local rule_btn = control_tools.newBtn(img_tbl[i])
		rule_bg:addChild(rule_btn, Z_Order.rule_btn)

		posX = i == 1 and posX + rule_btn:getContentSize().width/2 or posX + 128
		rule_btn:setPosition(cc.p(posX, posY - rule_btn:getContentSize().height/2))
		rule_btn.tag = i
		
		rule_btn:addTouchEventListener(function (sender, eventType) self:on_btn_rule(sender, eventType) end)
		table.insert(self.rule_btn_tbl, rule_btn)
    end

    -- 玩法拖动层
    self.drag_rule = control_tools.newScrollView({size = cc.size(535, 410)})
    rule_bg:addChild(self.drag_rule)
    self.drag_rule:setScrollBarAutoHideEnabled(false)
    self.drag_rule:setPosition(cc.p(255, 20)) 

	-- 左边游戏id btn列表
    -- 游戏btn拖动层
    self.drag_btn = control_tools.newScrollView({size = cc.size(240, 450)})
    rule_bg:addChild(self.drag_btn, Z_Order.game_btn)
    self.drag_btn:setScrollBarAutoHideEnabled(false)
    self.drag_btn:setPosition(cc.p(20, 20)) 
end
-- 游戏button
function UIRule:on_btn_game(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return 
	end

	AudioEngine.playEffect(BPRESOURCE("res/sound/click.mp3"))

    self:switch_choose_button(sender.tag)

    self.choose_game_id = self.game_list[sender.tag]

	self:show_rule_btn(1)
end
-- 转换选定game button显示
function UIRule:switch_choose_button(tag)
    for i,v in ipairs(self.game_btn_btl) do
        v:setBright(i ~= tag)
        v:setTouchEnabled(i ~= tag)
    end
end
-- 游戏详情切换button
function UIRule:on_btn_rule(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return 
	end

	AudioEngine.playEffect(BPRESOURCE("res/sound/click.mp3"))

    self:switch_rule_button(sender.tag)

	self:show_rule_btn(sender.tag)
end
-- 转换选定rule button显示
function UIRule:switch_rule_button(tag)
    for i,v in ipairs(self.rule_btn_tbl) do
        v:setBright(i ~= tag)
        v:setTouchEnabled(i ~= tag)
    end
end
-- 创建帮助详情
function UIRule:create_rule_info(file_name)
    local rule_img = nil
    if #self.sleep_rule_info > 0 then
        rule_img = self.sleep_rule_info[#self.sleep_rule_info]
        table.remove(self.sleep_rule_info, #self.sleep_rule_info)

        rule_img:loadTexture(file_name, 0)
        rule_img:setScale(535/rule_img:getContentSize().width)
        rule_img:setVisible(true)
    else
        rule_img = control_tools.newImg({path = file_name, anchor = cc.p(0.5, 0)})
        self.drag_rule:addChild(rule_img)
    end
    local scale = 535/rule_img:getContentSize().width
    rule_img:setScale(scale)

    return rule_img, scale
end
-- 显示游戏详情
function UIRule:show_rule_btn(index)
	local file_info = cc.FileUtils:getInstance():getStringFromFile(g_path .. self.choose_game_id .. "/config.json")
    if file_info == nil then return end
    
    local table_json = json.decode(file_info)
    if table_json == nil then return end

    local show_control = { table_json.show_detail, table_json.show_result, table_json.show_times, table_json.show_special }
    local rule_count = { table_json.detail_count, table_json.result_count, table_json.result_count, table_json.special_count }
	-- 游戏详情button
    for i,v in ipairs(self.rule_btn_tbl) do
    	v:setVisible(show_control[i])
    	v:setBright(i ~= index)
    	v:setTouchEnabled(i ~= index and show_control[i])
    end

    -- 清除数据
    for i,v in ipairs(self.rule_info) do
        table.insert(self.sleep_rule_info, v)
        v:setVisible(false)
    end
    self.rule_info = {}

    -- 显示帮助详情
    local tmp_height = 0
    for i = rule_count[index], 1, -1 do
        local rule_img, scale = self:create_rule_info(g_path .. self.choose_game_id .. "/" .. index .. "/rule_" .. i .. ".png")
		rule_img:setPosition(cc.p(self.drag_rule:getContentSize().width/2, tmp_height))

		tmp_height = tmp_height + rule_img:getContentSize().height*scale
        table.insert(self.rule_info, rule_img)
    end

    self.drag_rule:setInnerContainerSize(cc.size(535, tmp_height))
	self.drag_rule:jumpToTop()
end
-- 创建button
function UIRule:create_game_btn(file_name1, file_name2)
    local btn = nil
    if #self.sleep_game_btn_tbl > 0 then
        btn = self.sleep_game_btn_tbl[#self.sleep_game_btn_tbl]
        table.remove(self.sleep_game_btn_tbl, #self.sleep_game_btn_tbl)

        btn:loadTextures(file_name1, file_name1, file_name2, 0)
    else
        btn = control_tools.newBtn({normal = file_name1, pressed = file_name2})
        self.drag_btn:addChild(btn)
    end
    return btn
end
-- 显示游戏id列表button
function UIRule:show_game_btn(index)
    local btn_size = cc.size(240, 80)
    local total_height = #self.game_list*80
    local drag_height = self.drag_btn:getContentSize().height

    local need_height = total_height < drag_height and drag_height or total_height
    self.drag_btn:setInnerContainerSize(cc.size(240, need_height))

    -- 清除残留数据
    for i,v in ipairs(self.game_btn_btl) do
        table.insert(self.sleep_game_btn_tbl, v)
        v:setVisible(false)
    end
    self.game_btn_btl = {}

    -- 显示游戏id列表
    for i,v in ipairs(self.game_list) do
    	local btn = self:create_game_btn(g_path .. tostring(v) .. "/btn_1.png", g_path .. tostring(v) .. "/btn_2.png")

    	btn:setPosition(cc.p(btn_size.width/2, need_height - btn_size.height/2 - btn_size.height * (i - 1)))
    	btn:addTouchEventListener(function (sender, eventType) self:on_btn_game(sender, eventType) end)

    	btn.tag = i
    	table.insert(self.game_btn_btl, btn)

        btn:setVisible(true)
    	btn:setBright(i ~= index)
    	btn:setTouchEnabled(i ~= index)
    end
    self.drag_btn:jumpToTop()
end
-- 寻找游戏id并集
function UIRule:get_all_game()
	-- 游戏列表
    local game_list = json.decode(bp_get_game_list())

    -- 游戏列表并集
    local total_game = {}
    for k, v in pairs(game_list) do
    	for _, value in pairs(v.list) do
    		local bool_find = false
    		for m, n in pairs(total_game) do
    			if value == n then
    				bool_find = true
    				break
    			end
    		end
    		if bool_find == false then
    			table.insert(total_game, value)
    		end
    	end
    end

    -- 游戏列表交集（取理论上需要显示的游戏id集和有资源的游戏id集 的交集 --> 可以显示的游戏id集）
    self.game_list = {}
    for i,v in ipairs(g_game_tbl) do
        local bool_find = false
        for m, n in pairs(total_game) do
            if v == n then
                bool_find = true
                break
            end
        end
        if bool_find == true then
            table.insert(self.game_list, v)
        end
    end
end
-- 帮助详情界面
function UIRule:show_rule_info()
	-- 获取游戏列表
	self:get_all_game()

	if self.game_list == nil or self.game_list == {} then return end

    -- 左边列表显示游戏id button
    local default_index = 1
    self.choose_game_id = self.game_list[default_index]
    self:show_game_btn(default_index)

    -- 右边显示默认游戏详情
    self:show_rule_btn(default_index)

	self:ShowGui(true)
end
-- 显示帮助详情界面
function UIRule.ShowRuleInfo()
    if ptr_rule_info == nil  then 
        local main_layout = bp_get_main_layout()
        ptr_rule_info = UIRule:create()
        main_layout:addChild(ptr_rule_info)
    end

    ptr_rule_info:show_rule_info()
    return ptr_rule_info
end
-- 创建实例
function UIRule.Instance()
    if ptr_rule_info == nil then 
        local main_layout = bp_get_main_layout()
        ptr_rule_info = UIRule:create()
        main_layout:addChild(ptr_rule_info)
    end
    return ptr_rule_info
end

function UIRule:destory()

end

return UIRule
