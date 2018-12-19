--------------------------------------------------------------------------------
-- 举报界面
--------------------------------------------------------------------------------
local UIControl = require("bpsrc/ui_control")
local UIReport = class("UIReport", UIControl)

local g_path = BPRESOURCE("bpres/report/")

--------------------------------------------------------------------------------
-- 常量
--------------------------------------------------------------------------------
local ChooseKind = {name = 1, abuse = 2, cheat = 3}
local report_kind_count = 3
local max_player_count = 8

ptr_report_info = nil
--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function UIReport:ctor()
    self.super:ctor(self)
    self.choose_btn_tbl = {}
    self.choose_status_tbl = {}
    self.choose_img_tbl = {}
    self.choose_user_btn_tbl = {}
    self.user_name_tbl = {}

    self.choose_kind = 1
    self.user_id_tbl = {}

	self:init()
end
-- 初始化
function UIReport:init()
    -- 背景框
    self:set_bg(g_path .. "gui.png")
    self:set_title(g_path .. "title.png")
    self:hide_choose()

    self.info_bg = self:get_gui()
    self.the_size = self.info_bg:getContentSize()

    for i=1, report_kind_count do
    	local choose_btn = control_tools.newBtn({normal = g_path .. "report_kind_bg.png", anchor = cc.p(0, 0.5)})
    	self.info_bg:addChild(choose_btn)
    	table.insert(self.choose_btn_tbl, choose_btn)
    	local pos = i < 3 and cc.p(50, self.info_bg:getContentSize().height - 55*i) or cc.p(8 + self.info_bg:getContentSize().width/2, self.info_bg:getContentSize().height - 55)
    	choose_btn:setPosition(pos)
    	choose_btn:addTouchEventListener(function (sender, eventType) self:on_btn_choose_kind(sender, eventType) end)
    	choose_btn:setZoomScale(0)
    	choose_btn:setOpacity(0)
    	choose_btn.tag = i

    	local choose_status_bg = control_tools.newImg({path = g_path .. "choose_status_bg.png"})
    	self.info_bg:addChild(choose_status_bg)
    	choose_status_bg:setPosition(cc.p(choose_btn:getPositionX() + 25, choose_btn:getPositionY() + 1))

    	local choose_status = control_tools.newImg({path = g_path .. "choose_status.png"})
    	choose_status_bg:addChild(choose_status)
    	choose_status:setPosition(cc.p(choose_status:getContentSize().width/2, choose_status:getContentSize().height/2))
    	table.insert(self.choose_status_tbl, choose_status)
    	choose_status:setVisible(false)

    	local report_kind = control_tools.newImg({path = g_path .. "report_kind_" .. i .. ".png", anchor = cc.p(0, 0.5)})
    	self.info_bg:addChild(report_kind)
    	report_kind:setPosition(cc.p(choose_btn:getPositionX() + 45, choose_btn:getPositionY() + 1))
    end

    -- 提示
    local report_tips = control_tools.newLabel({str = "注：合伙作弊至少选择两名玩家", color = cc.c3b(223, 55, 22), font = 22})
	self.info_bg:addChild(report_tips)
	report_tips:setPosition(cc.p(self.info_bg:getContentSize().width/2, self.info_bg:getContentSize().height*2/3 - 8))

	-- 玩家底
	local user_bg = control_tools.newImg({path = g_path .. "user_info_bg.png"})
	self.info_bg:addChild(user_bg)
	user_bg:setPosition(cc.p(self.info_bg:getContentSize().width/2, user_bg:getContentSize().height/2 + 92))
    
    -- 拖动层
    self.drag_prop = control_tools.newScrollView({size = cc.size(567, 162)})
    user_bg:addChild(self.drag_prop)
    self.drag_prop:setScrollBarAutoHideEnabled(false)
    self.drag_prop:setPosition(cc.p(0, 4)) 

	for i=1, max_player_count do
		local choose_user_btn = control_tools.newBtn({size = cc.size(200, 45), normal = g_path .. "test_green.png", anchor = cc.p(0, 0.5)})
		self.drag_prop:addChild(choose_user_btn)
    	choose_user_btn:addTouchEventListener(function (sender, eventType) self:on_btn_choose_user(sender, eventType) end)
		table.insert(self.choose_user_btn_tbl, choose_user_btn)
		choose_user_btn.tag = i

		local choose_user_bg = control_tools.newImg({path = g_path .. "choose_user_bg.png", anchor = cc.p(0, 0.5)})
		choose_user_btn:addChild(choose_user_bg)
		choose_user_bg:setPosition(cc.p(2, choose_user_btn:getContentSize().height/2-1))

		local choose_img = control_tools.newImg({path = g_path .. "choose_img.png", anchor = cc.p(0, 0.5)})
		choose_user_bg:addChild(choose_img)
		choose_img:setPosition(cc.p(0, choose_img:getContentSize().height/2))
		table.insert(self.choose_img_tbl, choose_img)
		choose_img:setVisible(false)

		local user_name = control_tools.newLabel({str = "贝加尔湖畔", font = 28, color = cc.c3b(105, 62, 33), anchor = cc.p(0, 0.5), ex = true})
		choose_user_bg:addChild(user_name)
		user_name:setPosition(cc.p(45, 21))
		table.insert(self.user_name_tbl, user_name)
	end

	self.btn_report = control_tools.newBtn({normal = g_path .. "btn_report.png"})
	self.info_bg:addChild(self.btn_report)
	self.btn_report:setPosition(cc.p(self.info_bg:getContentSize().width/2, self.btn_report:getContentSize().height/2 + 5))
	self.btn_report:addTouchEventListener(function (sender, eventType) self:on_btn_report(sender, eventType) end )

    self:back_ground_activate(true)
end
-- 选择举报类型
function UIReport:on_btn_choose_kind(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return 
	end

	if sender:getOpacity() == 255 then return end

	self.choose_kind = sender.tag
	for i=1, report_kind_count do
		self.choose_btn_tbl[i]:setOpacity(sender.tag == i and 255 or 0)
		self.choose_status_tbl[i]:setVisible(sender.tag == i)
	end
end
-- 选择玩家
function UIReport:on_btn_choose_user(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return 
	end

	self.choose_img_tbl[sender.tag]:setVisible(not self.choose_img_tbl[sender.tag]:isVisible())
end
-- 举报
function UIReport:on_btn_report(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return 
	end

	local choose_count = 0
	local choose_user = {}
	for i=1, max_player_count do
		if self.choose_user_btn_tbl[i]:isVisible() == true and self.choose_img_tbl[i]:isVisible() == true then
			table.insert(choose_user, self.user_id_tbl[i])
			choose_count = choose_count + 1
		end
	end

	local report_tbl = {}
	report_tbl.userid = choose_user
	report_tbl.count = choose_count
	report_tbl.kind = self.choose_kind

	if self.choose_kind == ChooseKind.cheat then
		if choose_count < 2 then
			bp_show_hinting("合伙作弊至少选择两名玩家")
			return
		end
	else
		if choose_count ~= 1 then
			return
		end
	end

	if bind_function.send_user_report(report_tbl) ~= 0 then
		self:ShowGui(false)
		bp_show_hinting("举报成功，感谢您的反馈和帮助!")
	end
end
-- 显示举报界面详情
function UIReport:show_report_layer(self_data, user_data)
	-- 椅子数
	local chair_count = bind_function.get_room_data().chaircount
	local tmp_size = chair_count > 6 and cc.size(567, 214) or cc.size(567, 162)
	if chair_count > 6 then
		self.drag_prop:setInnerContainerSize(cc.size(567, 164))
	else
		self.drag_prop:setInnerContainerSize(tmp_size)
	end
	-- 显示的人数
	self.user_id_tbl = {}
	local temp_count = 1
	for i=1, max_player_count do
		self.choose_user_btn_tbl[i]:setVisible(false)
		self.choose_user_btn_tbl[i]:setPosition(cc.p(i % 2 == 1 and 14 or 13 + tmp_size.width/2, tmp_size.height - 50 * math.floor((i-1)/2 + 1) + 18))
		if i <= chair_count then
			local tmp_data = bind_function.get_user_data_by_chair_id(bind_function.switch_to_chair_id(i))
			if not (tmp_data == nil or tmp_data == {} or tmp_data == "") then
				if tmp_data.dwUserID ~= self_data.dwUserID then
					table.insert(self.user_id_tbl, tmp_data.dwUserID)
					self.user_name_tbl[temp_count]:setTextEx(bp_gbk2utf(tmp_data.szName), 140)
					self.choose_user_btn_tbl[temp_count]:setVisible(true)
					temp_count = temp_count + 1
				end
			end
		end
	end
    self.drag_prop:jumpToTop()

	-- 默认显示第一个类型
	for i=1, report_kind_count do
		self.choose_btn_tbl[i]:setOpacity(i == 1 and 255 or 0)
		self.choose_status_tbl[i]:setVisible(i == 1)
	end

	self:ShowGui(true)
end
-- 显示举报界面
function UIReport.ShowReportLayer(self_data, user_data)
    if ptr_report_info == nil  then 
        local main_layout = bp_get_main_layout()
        ptr_report_info = UIReport:create()
        main_layout:addChild(ptr_report_info)
    end

    ptr_report_info:show_report_layer(self_data, user_data)
    return ptr_report_info
end
-- 创建实例
function UIReport.Instance()
    if ptr_report_info == nil then 
        local main_layout = bp_get_main_layout()
        ptr_report_info = UIReport:create()
        main_layout:addChild(ptr_report_info)
    end
    return ptr_report_info
end

function UIReport:destory()
    
end

return UIReport
