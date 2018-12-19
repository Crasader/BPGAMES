print("=====UIActivityDial=====")
require("bptools/action_tools")
sptr_activity_dial=nil
---------------------------------------------------------------------------------
-- 转盘活动界面
---------------------------------------------------------------------------------
local UIActivityDial = class("UIActivityDial", function() return ccui.Layout:create() end)

local g_path = BPRESOURCE("res/activity_dial/")
local GetRunnerApi="https://demoopen.bookse.cn/api.svc/Api?{\"head\":{\"FunctionCode\":\"NewSignInTwo\",\"session\":\"{SESSION}\"},\"reqdata\":{\"userid\":{USERID},\"password\":\"{PASSWORDMD5}\",\"areaid\":\"{AREAID}\",\"kindid\":\"{KINDID}\",\"channel\":\"{CHANNELID}\",\"version\":\"{VERSION}\"}}"
local StartRunnerApi="https://demoopen.bookse.cn/api.svc/Api?{\"head\":{\"FunctionCode\":\"DoSignIn\",\"session\":\"{SESSION}\"},\"reqdata\":{\"userid\":{USERID},\"password\":\"{PASSWORDMD5}\",\"areaid\":\"{AREAID}\",\"kindid\":\"{KINDID}\",\"channel\":\"{CHANNELID}\",\"version\":\"{VERSION}\"}}"
local GetContinueAward="https://demoopen.bookse.cn/api.svc/Api?{\"head\":{\"FunctionCode\":\"ContinueAwardNew\",\"session\":\"{SESSION}\"},\"reqdata\":{\"userid\":{USERID},\"password\":\"{PASSWORDMD5}\",\"areaid\":\"{AREAID}\",\"kindid\":\"{KINDID}\",\"channel\":\"{CHANNELID}\",\"version\":\"{VERSION}\","
local VipSignApi="https://demoopen.bookse.cn/api.svc/Api?{\"head\":{\"FunctionCode\":\"VipAward\",\"session\":\"{SESSION}\"},\"reqdata\":{\"userid\":{USERID},\"password\":\"{PASSWORDMD5}\",\"areaid\":\"{AREAID}\",\"kindid\":\"{KINDID}\",\"channel\":\"{CHANNELID}\",\"version\":\"{VERSION}\"}}"

---------------------------------------------------------------------------------
-- 常量
---------------------------------------------------------------------------------
local BtnIndex = {
  start = 1,
  signin = 2,
  shop = 3,
  award_1 = 4,
  award_2 = 5,
  award_3 = 6,
  award_4 = 7,
  close = 8,
}
local HttpIndex = {
  GetSignData = 1,
  VipSign = 2,
  ContinueAward = 3,
}
local award_config = {
  { num = 2,
    award_1 = {name = "踢人卡*1", path = "award_6.png"},
    award_2 = {name = "奖券*1", path = "award_5.png"},
  },
  { num = 2,
    award_1 = {name = "踢人卡*1", path = "award_6.png"},
    award_2 = {name = "奖券*2", path = "award_5.png"},
  },
  { num = 3,
    award_1 = {name = "踢人卡*2", path = "award_6.png"},
    award_2 = {name = "奖券*5", path = "award_5.png"},
    award_3 = {name = "小喇叭*1", path = "award_4.png"},
  },
  { num = 3,
    award_1 = {name = "踢人卡*2", path = "award_6.png"},
    award_2 = {name = "奖券*10",  path = "award_5.png"},
    award_3 = {name = "小喇叭*5", path = "award_4.png"},
  }
}
local runner_config = {
  {name = "100万金币", award = "1:1000000"}, {name = "1张魅力清零卡", award = "1019:1"},
  {name = "888金币", award = "1:888"}, {name = "5个鸡蛋", award = "1011:5"},
  {name = "1888金币", award = "1:1888"}, {name = "1个积分护身符", award = "1018:1"},
  {name = "3888金币", award = "1:3888"}, {name = "1张双倍积分卡", award = "1017:1"},
  {name = "5个拖鞋", award = "1012:5"}, {name = "2张奖券", award = "1002:2"},
  {name = "5个大拇指", award = "1015:5"}, {name = "5个炸弹", award = "1013:5"},
}
local view_size = CCDirector:getInstance():getWinSize()

---------------------------------------------------------------------------------
-- 函数
---------------------------------------------------------------------------------
function UIActivityDial:ctor()
	self._time_line = {}
	self._award = {}
	self._award_list = {}
    self._can_get = {}
    self._award_list = {}
    self._get_data = nil
    --开始数据
    self._is_sign = 0  
    self._continue_sign_day = 10
    self._month_day = 30
    self._continue_sign = {false ,false ,false, false}
    self._vip_sign = 0
    self._expired_day = ""
    self._vip_sign_gold = 0
    self._vip_type = 0
    -- self._is_running = false
    self._runner_result_str = ""
    self._runner_data = ""
    self._pro_visible = false

	self:init()
end

function UIActivityDial:init()
    self._bg_activity = control_tools.newImg({path = BPRESOURCE("res/mask.png"), size = cc.size(view_size.width, view_size.height + 10)})
    self:addChild(self._bg_activity)
    self._bg_activity:setPosition(cc.p(view_size.width/2,view_size.height/2 + 16))
	self._bg_activity:addTouchEventListener(function(param_sender, param_touchType) self:bgTouchEvent(param_sender, param_touchType) end)
	self._bg_activity:setTouchEnabled(true)

	self._bg_runner = control_tools.newImg({path = g_path .. "bg_runner.png"})
	self._bg_runner:setPosition(cc.p(view_size.width/2, view_size.height/2 - 15))
	self._bg_activity:addChild(self._bg_runner)
	self._bg_runner:addTouchEventListener(function(param_sender, param_touchType) self:layerTouchEvent(param_sender, param_touchType) end)
	self._bg_runner:setTouchEnabled(true)

	local mid_pos = cc.p(self._bg_runner:getContentSize().width/2, self._bg_runner:getContentSize().height/2)

	self._btn_close = control_tools.newBtn({small = true, normal = g_path .. "btn_close.png"})
	self._btn_close:addTouchEventListener(function(param_sender, param_touchType) self:btnTouchEvent(param_sender, param_touchType) end)
	self._btn_close:setPosition(cc.p(self._bg_runner:getContentSize().width - 12, self._bg_runner:getContentSize().height - 45))
	self._btn_close._index = BtnIndex.close
	self._bg_runner:addChild(self._btn_close)

	local img_title = control_tools.newImg({path = g_path.."img_title.png"})
	img_title:setPosition(cc.p(mid_pos.x + 175, mid_pos.y + 236))
	self._bg_runner:addChild(img_title)

	self._img_runner = control_tools.newImg({path = g_path.."img_runner1.png"})
	self._img_runner:setPosition(cc.p(mid_pos.x - 152, mid_pos.y + 2))
	self._bg_runner:addChild(self._img_runner)

	self._select_light = control_tools.newImg({path = g_path.."select_light.png"})
	self._select_light:setPosition(cc.p(mid_pos.x - 152, mid_pos.y + 125))
	self._select_light:setVisible(false)
	self._bg_runner:addChild(self._select_light)

	self._light_runner = control_tools.newImg({path = g_path.."light_runner.png"})
	self._light_runner:setPosition(cc.p(mid_pos.x - 152, mid_pos.y + 2))
	self._bg_runner:addChild(self._light_runner)

	--旋转动画
  	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "zhuanpan.ExportJson")
	self._ani_runner = CCArmature:create("zhuanpan")
	self._ani_runner:setPosition(cc.p(mid_pos.x - 152, mid_pos.y + 2))
	self._ani_runner:setVisible(false)
	self._bg_runner:addChild(self._ani_runner)

	self._pointer_runner = control_tools.newImg({path = g_path .. "pointer_runner.png"})
	self._pointer_runner:setPosition(cc.p(mid_pos.x - 152, mid_pos.y + 2))
	self._bg_runner:addChild(self._pointer_runner)

	self._btn_start = control_tools.newBtn({small = true, normal = g_path .. "btn_start_1.png", pressed = g_path .. "btn_start_2.png"})
	self._btn_start:setPosition(cc.p(mid_pos.x - 152, mid_pos.y + 2))
	self._btn_start._index = BtnIndex.start
	self._btn_start:addTouchEventListener(function (param_sender,param_touchType) self:btnTouchEvent(param_sender,param_touchType) end)
	self._btn_start:setBright(false)
	self._btn_start:setTouchEnabled(false)
	self._bg_runner:addChild(self._btn_start)

	for i=1, 3 do
		self._time_line[i] = control_tools.newImg({path = g_path .. "time_line_1.png"})
		self._time_line[i]._all = control_tools.newImg({path = g_path .. "time_line_2.png"})
		self._time_line[i]:addChild(self._time_line[i]._all)
		self._bg_runner:addChild(self._time_line[i])
		self._time_line[i]._all:setPosition(cc.p(self._time_line[i]:getContentSize().width/2, self._time_line[i]:getContentSize().height/2))
	end
	self._time_line[1]:setPosition(cc.p(mid_pos.x + 245, mid_pos.y + 159))
	self._time_line[2]:setRotation(90)
	self._time_line[2]:setPosition(cc.p(mid_pos.x + 342, mid_pos.y + 97))
	self._time_line[3]:setPosition(cc.p(mid_pos.x + 245, mid_pos.y + 38))

	local award_pos = {cc.p(mid_pos.x + 147, mid_pos.y + 156), cc.p(mid_pos.x + 342, mid_pos.y + 156), 
					cc.p(mid_pos.x + 342, mid_pos.y + 35), cc.p(mid_pos.x + 147, mid_pos.y + 35)}
	for i=1, 4 do
		self._award[i]=self:createBtnAward(i)
		self._award[i]:setPosition(award_pos[i])
		self._bg_runner:addChild(self._award[i])
		self._can_get[i]=false
	end

	self._img_sign_time = control_tools.newImg({path = g_path .. "img_sign_time.png"})
	self._img_sign_time:setPosition(cc.p(mid_pos.x + 242, mid_pos.y + 98))
	self._bg_runner:addChild(self._img_sign_time)

	self._label_sign_time = control_tools.newLabel({font = 20, color = cc.c3b(142, 90, 33)})
	self._label_sign_time:setPosition(cc.p(self._img_sign_time:getContentSize().width/2 + 41, self._img_sign_time:getContentSize().height/2))
	self._img_sign_time:addChild(self._label_sign_time)
	self._label_sign_time:setString(0)

	self._hint_word = control_tools.newImg({path = g_path .. "img_hint_word.png"})
	self._hint_word:setPosition(cc.p(mid_pos.x + 245, mid_pos.y - 30))
	self._bg_runner:addChild(self._hint_word)

	self._bg_signin = control_tools.newImg({path = g_path .. "bg_signin.png"})
	self._bg_signin:setPosition(cc.p(mid_pos.x + 240, mid_pos.y - 135))
	self._bg_runner:addChild(self._bg_signin)

	self._vip_logo = control_tools.newImg({path = g_path .. "vip_logo.png"})
	self._vip_logo:setPosition(cc.p(self._bg_signin:getContentSize().width/2, self._bg_signin:getContentSize().height/2 + 65))
	self._bg_signin:addChild(self._vip_logo)

	self._btn_signin = control_tools.newBtn({small = true, normal = g_path .. "btn_signin_1.png", pressed = g_path .. "btn_signin_2.png"})
	self._btn_signin._index = BtnIndex.signin
	self._btn_signin:addTouchEventListener(function(param_sender,param_touchType) self:btnTouchEvent(param_sender,param_touchType) end)
	self._btn_signin:setVisible(false)
	self._bg_signin:addChild(self._btn_signin)

	self._label_vip_time = control_tools.newLabel({font = 18, color = cc.c3b(254,233,200)})
	self._label_vip_time:setPosition(cc.p(self._bg_signin:getContentSize().width/2, self._bg_signin:getContentSize().height/2 - 52))
	self._bg_signin:addChild(self._label_vip_time)

	self._label_award_hint = control_tools.newLabel({font = 22,color = cc.c3b(154,94,36)})
	self._label_award_hint:setPosition(cc.p(self._bg_signin:getContentSize().width/2, self._bg_signin:getContentSize().height/2 + 30))
	self._bg_signin:addChild(self._label_award_hint)

	self._label_load_hint = control_tools.newLabel({font = 22, color = cc.c3b(154, 94, 36), str = "数据加载中, 请稍等..."})
	self._label_load_hint:setPosition(cc.p(self._bg_signin:getContentSize().width/2, self._bg_signin:getContentSize().height/2))
	self._bg_signin:addChild(self._label_load_hint)

	for i = 1, 4, 1 do
		self._award_list[i] = self:createAwardList(i)
		self._award_list[i]:setPosition(cc.p(mid_pos.x + 245, mid_pos.y + 97))
		self._award_list[i]:setVisible(false)
		self._bg_runner:addChild(self._award_list[i])
	end

	self._btn_probability = control_tools.newBtn({small = true, normal = g_path.."btn_probability.png"})
	self._btn_probability:addTouchEventListener(function(param_sender, param_touchType) self:btnEvent(param_sender, param_touchType) end)
	self._btn_probability:setPosition(cc.p(mid_pos.x + 340, mid_pos.y - 260))
	self._bg_runner:addChild(self._btn_probability)

	self._probability_table = control_tools.newImg({path = g_path.."probability_table1.png", anchor = cc.p(1, 0)})
	self._probability_table:setPosition(cc.p(mid_pos.x + 420, mid_pos.y - 240))
	self._probability_table:setVisible(false)
	self._bg_runner:addChild(self._probability_table)

	self:showLayer()
end
 
function UIActivityDial:btnEvent(param_sender,param_touchType)
	if param_touchType~=_G.TOUCH_EVENT_ENDED then
		return
	end
	-- playeffect(ClickMusic,false)
	self:showProbability(not self._pro_visible)
end

function UIActivityDial:layerTouchEvent(param_sender, param_touchType)
	if param_touchType~=_G.TOUCH_EVENT_ENDED then
		return
	end
	self:switchAwardList(0)
	self:showProbability(false)
end

function UIActivityDial:bgTouchEvent(param_sender, param_touchType)
	if param_touchType~=_G.TOUCH_EVENT_ENDED then
		return
	end
	self:showProbability(false)
end

function UIActivityDial:btnTouchEvent(param_sender,param_touchType)
	if param_touchType ~= _G.TOUCH_EVENT_ENDED then
		return
	end
	-- 点击音效（待添加）
	self:showProbability(false)
	if param_sender._index == BtnIndex.close then
		self:closeLayer()
	elseif param_sender._index == BtnIndex.start then
		self:setLayerTouch(false)
		self:switchAwardList(0)
		self:startRunner()
		self._select_light:setVisible(false)
		local rotate_action = action_tools.CCRotateTo(3, 360*4)
		local easein = cc.EaseIn:create(rotate_action, 2)
		local callback = action_tools.CCCallFunc(function() self:rotateRunner() end)
		self._img_runner:runAction(action_tools.CCSequence(easein, callback))
		-- playeffect("res#audio#runner1",true)
		param_sender:setTouchEnabled(false)
		self:showRunnerLight(0.1)
	elseif param_sender._index == BtnIndex.signin then
		self:switchAwardList(0)
		self:vipSign()
	elseif param_sender._index == BtnIndex.shop then 
	  	-- show_vip()
	elseif param_sender._index >= BtnIndex.award_1 and param_sender._index <= BtnIndex.award_4 then
		local btn_index = param_sender._index - 3
		if self._can_get[btn_index] == false then
			self:switchAwardList(btn_index)
		elseif self._can_get[btn_index] == true then
			self:getContinueAward(btn_index)
		end
	end
end

function UIActivityDial:createBtnAward(param_index)
	local btn_award = control_tools.newBtn({small = true, normal = g_path .. "btn_award_" .. param_index .. "_1" .. ".png"})

	btn_award._img_got = control_tools.newImg({path = g_path .. "img_got.png"})
	btn_award._img_got:setPosition(cc.p(btn_award:getContentSize().width/2, btn_award:getContentSize().height/2 + 2.5))
	btn_award:addChild(btn_award._img_got)
    btn_award._img_got:setVisible(false)

	local time_path = g_path .. "time_" .. param_index .. ".png"
	btn_award._time = control_tools.newImg({path = time_path})
	btn_award._time:setPosition(cc.p(btn_award:getContentSize().width/2, btn_award:getContentSize().height/2))
  	btn_award._time:setAnchorPoint(cc.p(0.5,-1.1))
	btn_award:addChild(btn_award._time)

	btn_award._index = BtnIndex["award_" .. param_index]
	btn_award:addTouchEventListener(function(param_sender,param_touchType) self:btnTouchEvent(param_sender,param_touchType) end)

	return btn_award
end

function UIActivityDial:showProbability(param_show)
	self._probability_table:setVisible(param_show)
	self._pro_visible = param_show
end

function UIActivityDial:createAwardList(param_index)
	local list_width = award_config[param_index].num*120
	local award_list = control_tools.newImg({path = g_path .. "bg_award.png", size = cc.size(list_width,120)})
	local mid_pos = cc.p(award_list:getContentSize().width/2, award_list:getContentSize().height/2)

	if award_config[param_index].num == 2 then
		local line = control_tools.newImg({path = g_path .. "line.png"})
		line:setPosition(mid_pos)
		award_list:addChild(line)
	elseif award_config[param_index].num == 3 then
		local line1 = control_tools.newImg({path = g_path .. "line.png"})
		line1:setPosition(cc.p(mid_pos.x - 60, mid_pos.y))
		award_list:addChild(line1)

		local line2 = control_tools.newImg({path = g_path .. "line.png"})
		line2:setPosition(cc.p(mid_pos.x + 60, mid_pos.y))
		award_list:addChild(line2)
	end

	local award_pos = {}
	if award_config[param_index].num == 1 then
		award_pos = {cc.p(mid_pos.x, mid_pos.y + 10)}
	elseif award_config[param_index].num == 2 then
		award_pos = {cc.p(mid_pos.x - 55, mid_pos.y + 10), cc.p(mid_pos.x + 55, mid_pos.y + 10)}
	elseif award_config[param_index].num == 3 then
		award_pos = {cc.p(mid_pos.x - 120, mid_pos.y + 10), cc.p(mid_pos.x, mid_pos.y + 10), cc.p(mid_pos.x + 120, mid_pos.y + 10)}
	end
	for i = 1,award_config[param_index].num,1 do
		local award = control_tools.newImg({path = g_path .. award_config[param_index]["award_" .. i].path, scale = 0.8})
		award:setPosition(award_pos[i]) 
		award_list:addChild(award)

		local award_name = award_config[param_index]["award_" .. i].name
		local label = control_tools.newLabel({font = 18, color = cc.c3b(252, 247, 163), str = award_name})
		label:setPosition(cc.p(award_pos[i].x, award_pos[i].y - 45))
		award_list:addChild(label)
	end

	return award_list
end

function UIActivityDial:switchAwardList(param_index)
	for i=1, 4 do
		if i == param_index then
			self._award_list[i]:setVisible(not self._award_list[i]:isVisible())
		else
			self._award_list[i]:setVisible(false)
		end
	end
end

function UIActivityDial:showLayer()
	print("--------------show")
	self:setVisible(true)
	-- if self._is_running==true then
	-- 	return 
	-- end
	if self._bg_runner==nil then
		return
	end

	local scale1 = action_tools.CCScaleTo(0.2,1.1)
	local scale2 = action_tools.CCScaleTo(0.1,0.9)
	local scale3 = action_tools.CCScaleTo(0.1,1)
	local callback = action_tools.CCCallFunc(function() 
		self._bg_runner:setTouchEnabled(true)
		-- self._is_running = false
		self:showRunnerLight(0.5)
		self:getSignData()
	end)

	self._bg_runner:setScale(0)
	self._bg_runner:stopAllActions()
	self._bg_runner:runAction(action_tools.CCSequence(scale1, scale2, scale3, callback))
end

function UIActivityDial:closeLayer()
	print("--------------close")
	if self._bg_runner == nil then
		return
	end
	-- if self._is_running == true then
	-- 	return 
	-- end

	self._bg_runner:setTouchEnabled(false)
	local scale1 = action_tools.CCScaleTo(0.1, 1.1)
	local scale2 = action_tools.CCScaleTo(0.2, 0)
	local callback = action_tools.CCCallFunc(function() 
		-- self._is_running = false
		self:destroy()
		self:setVisible(false)
	end)
	self._bg_runner:stopAllActions()
	self._bg_runner:runAction(action_tools.CCSequence(scale1, scale2, callback))
end

function UIActivityDial:showRunnerLight(time)
	local rotation = 0
	local delay = action_tools.CCDelayTime(time)
	local callback = action_tools.CCCallFunc(function() 
		rotation = 30 - rotation
		self._light_runner:setRotation(rotation)
		self._light_runner:setVisible(true)
	end)
	self._light_runner:stopAllActions()
	self._light_runner:runAction(action_tools.CCRepeatForever(action_tools.CCSequence(delay, callback)))
end

function UIActivityDial:getSignData()
	local send_url = bp_make_url(GetRunnerApi)
	local function call_func()
		self:updateSignData()
	end
	self:httpRequest(send_url, HttpIndex.GetSignData, call_func)    
end

function UIActivityDial:httpRequest(param_url, param_index, param_call_func)
 	local function on_http_request(param_identifier, param_success, param_code, param_header, context)
 		print(param_identifier, param_success, param_code, param_header, context)
	    bp_show_loading(0)
	    if param_success ~= true or param_code ~= 200 then 
	        print("DY Log >> 消息获取失败")
	        return 
	    end

	    local l_data = json.decode(context)
    	if not l_data then
    		return
    	end

	    if l_data.rescode ~= 1 then 
	        bp_show_hinting(l_data.resmsg)
	        return 
	    end

		local res_data = l_data.resdata
		self:analyData(param_index, res_data)
		if param_call_func then
			param_call_func()
		end
 	end
    bp_show_loading(1)
    bp_http_get(param_index, "", param_url, on_http_request, 1)
end 

function UIActivityDial:analyData(param_index, param_data)
	if param_index == HttpIndex.GetSignData then
		self._is_sign = param_data.issign
		self._continue_sign_day = param_data.continuesignday
		self._vip_type = param_data.fund_id
		self._vip_sign_gold = param_data.vipsigngold
		self._expired_day = param_data.expired_time
		self._month_day = param_data.monthday
		self._vip_sign = param_data.vipsign
		self._continue_sign[1] = param_data.continuesign1 == 1
		self._continue_sign[2] = param_data.continuesign2 == 1
		self._continue_sign[3] = param_data.continuesign3 == 1
		self._continue_sign[4] = param_data.continuesign4 == 1
	end
end

function UIActivityDial:updateSignData()
	self:setLayerTouch(true)
	self._label_load_hint:setVisible(false)

	local is_sign = self._is_sign == 0
	self._btn_start:setTouchEnabled(is_sign)
	self._btn_start:setBright(is_sign)

	local sign_time_table = {5, 10, 15, self._month_day}
	for i=1, 4 do
		self._can_get[i] = self._continue_sign_day >= sign_time_table[i]
		if i > 1 then
			self._time_line[i-1]._all:setVisible(self._can_get[i])
		end

		local btn_path = self._can_get[i] == false and g_path .. "btn_award_" .. i .."_1" or g_path .. "btn_award_" .. i
		self._award[i]:loadTextureNormal(btn_path..".png")
		self._award[i]._img_got:setVisible(self._continue_sign[i])

		self._can_get[i] = (self._can_get[i]) and (not self._continue_sign[i])
	end

	self._label_sign_time:setString(self._continue_sign_day)

	if self._vip_type == 0 then
		self._btn_signin:loadTextureNormal(g_path .. "btn_signin_3.png")
		self._btn_signin:setPosition(cc.p(self._bg_signin:getContentSize().width/2, self._bg_signin:getContentSize().height/2 - 24))
		self._label_award_hint:setString("会员每日可多领10,0000金币")
		self._label_vip_time:setString("")
		self._btn_signin._index = BtnIndex.shop
	else
		self._btn_signin:loadTextureNormal(g_path .. "btn_signin_1.png")
		self._btn_signin:setPosition(cc.p(self._bg_signin:getContentSize().width/2, self._bg_signin:getContentSize().height/2 - 16))
		self._label_vip_time:setString("会员到期" .. self._expired_day)
		self._btn_signin._index = BtnIndex.signin
		if self._vip_sign ~= 0 then
			self._label_award_hint:setString("今日签到领取" .. self._vip_sign .. "金币")
		else
			self._btn_signin:setTouchEnabled(false)
			self._btn_signin:setBright(false)
			self._label_award_hint:setString("今日签到已领取" .. self._vip_sign_gold .. "金币")
		end
	end
	self._btn_signin:setVisible(true)
	if self._runner_result_str ~= "" then
		bp_show_hinting(self._runner_result_str)
		self._runner_result_str = ""
	end

	bp_update_user_data(1)
end

function UIActivityDial:startRunner()
	local function on_http_request(param_identifier, param_success, param_code, param_header, context)
 		print(param_identifier, param_success, param_code, param_header, context)
	    if param_success ~= true or param_code ~= 200 then 
	        print("DY Log >> 消息获取失败")
	        return 
	    end

	    local l_data = json.decode(context)
    	if not l_data then
    		return
    	end

	    if l_data.rescode ~= 1 then 
	        self._runner_data = ""
            self._get_data = false
	        return 
	    end

		local res_data = l_data.resdata
		self._runner_data = res_data.config
        self._get_data = true
 	end
    local send_url = bp_make_url(StartRunnerApi)
    self._get_data = nil
    bp_http_get("start", "", send_url, on_http_request, 1)
end

function UIActivityDial:rotateRunner()
	local rotateto = action_tools.CCRotateTo(0.5, 360*2)
	local function call_func()
		if self._get_data ~= nil then
			self:dealRunnerData()
			local easeout = cc.EaseOut:create(action_tools.CCRotateTo(4.5, 360*4+self._runner_angle), 5)
			local callback1 = action_tools.CCCallFunc(function()
				local fadein = action_tools.CCFadeIn(0.2)
				local callback2 = action_tools.CCCallFunc(function()
					self._ani_runner:setVisible(true)
					-- SimpleAudioEngine:sharedEngine():stopAllEffects()
					-- playeffect("res#audio#runner2",false) 
					self:showRunnerLight(0.5)    
					self._ani_runner:getAnimation():play("Animation1", -1, -1)
				end)
				local delaytime = action_tools.CCDelayTime(1)
				local callback3 = action_tools.CCCallFunc(function() 
					self:updateSignData() 
				end)
				self._select_light:setOpacity(0)
				self._select_light:setVisible(true)
				self._select_light:runAction(action_tools.CCSequence(fadein, callback2, delaytime, callback3))
			end)

			self._img_runner:stopAllActions()
			self._img_runner:runAction(action_tools.CCSequence(easeout, callback1))
		end
	end
	local callback = action_tools.CCCallFunc(call_func)
	self._img_runner:stopAllActions()
	self._img_runner:runAction(action_tools.CCRepeatForever(action_tools.CCSequence(rotateto, callback)))
end

function UIActivityDial:dealRunnerData()
	self._result_id, self._runner_angle = 0, 0
	for i = 1,#runner_config,1 do
		if runner_config[i].award == self._runner_data then
			self._result_id = i
			break
		end
	end 
	if self._get_data == false then
		self._runner_result_str = "获取数据失败，请重新抽奖"
	elseif self._get_data == true and self._result_id > 0 then
		self._runner_result_str = "恭喜你获得" .. runner_config[self._result_id].name
		self._is_sign = 1
		self._runner_angle = self._result_id * 30
		self._continue_sign_day = self._continue_sign_day + 1
	end
end

function UIActivityDial:vipSign()
	local send_url = bp_make_url(VipSignApi)
	local function call_func()
		self._btn_signin:setTouchEnabled(false)
		self._btn_signin:setBright(false)
		self._label_award_hint:setString("今日签到已领取" .. self._vip_sign_gold .. "金币")
		-- show_gold_rain()
		bp_show_hinting("会员签到成功，获得"..self._vip_sign.."金币")
		self._vip_sign = 0
		bp_update_user_data(1)
	end
	self:httpRequest(send_url, HttpIndex.VipSign, call_func)
end

function UIActivityDial:getContinueAward(param_index)
	local new_str = GetContinueAward .. "\"award\":" .. param_index.."}}"
	local send_url = bp_make_url(new_str)
	local function call_func()
		local time_hint = {"5天","10天","15天","满月"}
		show_hinting("成功领取" .. time_hint[param_index]  .. "奖励")
		self._award[param_index]._img_got:setVisible(true)
		self._continue_sign[param_index] = true
		self._can_get[param_index] = false
		-- show_gold_rain()
		bp_update_user_data(1)
	end
	self:httpRequest(send_url, HttpIndex.ContinueAward, call_func)
end

function UIActivityDial:setLayerTouch(param_touch)
    self._btn_close:setTouchEnabled(param_touch)
    for i = 1, 4 do
        self._award[i]:setTouchEnabled(param_touch)
    end
    self._btn_signin:setTouchEnabled(param_touch)
end

function UIActivityDial:destroy()
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "zhuanpan.ExportJson")
	-- SimpleAudioEngine:sharedEngine():stopAllEffects()
end


function UIActivityDial.ShowActivityDial(param_show)
    if sptr_activity_dial==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_activity_dial=UIActivityDial:create();
        main_layout:addChild(sptr_activity_dial)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_activity_dial:showLayer();
    return sptr_activity_dial;
end

return UIActivityDial
