-- require "src/button_event"
--------------------------------------------------------------------------------
-- 菜单界面
--------------------------------------------------------------------------------
local game_menu = class("game_menu", function() return ccui.Layout:create() end)
local BtnIndex={Open=1, Close=2, Setting=3, Back=4, Rule = 5}

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
function game_menu:ctor(visibleSize)
	self.game_layer = nil
	self._size = cc.size(80*visibleSize.width / 960, 80*visibleSize.width / 960)
	self:setContentSize(self._size)
	self:init(visibleSize)
end

function game_menu:init(visibleSize)
	self._btn_menu = control_tools.newBtn({normal = "btn_menu.png", ctype = 1})
	self._btn_menu:setPosition(cc.p(-5*visibleSize.height / 640,self._size.height*0.5 - 5*visibleSize.height / 640))
	self._btn_menu._index = BtnIndex.Open
	self._btn_menu:addTouchEventListener(function(param_sender,param_touchType) self:btnTouchEvent(param_sender,param_touchType) end)
	self:addChild(self._btn_menu)

	self._btn_setting = control_tools.newBtn({normal = "btn_setting.png", ctype = 1})
    self._btn_setting:setPosition(cc.p(-15*visibleSize.height / 640,self._size.height*0.5-100*visibleSize.height / 640))
	self._btn_setting._index = BtnIndex.Setting
	self._btn_setting:addTouchEventListener(function(param_sender,param_touchType) self:btnTouchEvent(param_sender,param_touchType) end)
    self._btn_setting:setVisible(false)
	self:addChild(self._btn_setting)

	self._btn_back = control_tools.newBtn({normal = "btn_back.png", ctype = 1})
	self._btn_back:setPosition(cc.p(-15*visibleSize.height / 640,self._size.height*0.5-298*visibleSize.height / 640))
	self._btn_back._index = BtnIndex.Back
	self._btn_back:addTouchEventListener(function(param_sender,param_touchType) self:btnTouchEvent(param_sender,param_touchType) end)
    self._btn_back:setVisible(false)
	self:addChild(self._btn_back)

	self._btn_rule  =  control_tools.newBtn({normal = "btn_rule.png", ctype = 1})
    self._btn_rule:setPosition(cc.p(-15*visibleSize.height / 640,self._size.height*0.5-199*visibleSize.height / 640))
    self._btn_rule._index = BtnIndex.Rule
    self._btn_rule:addTouchEventListener(function(param_sender,param_touchType) self:btnTouchEvent(param_sender,param_touchType) end)
    self._btn_rule:setVisible(false)
    self:addChild(self._btn_rule)
end

function game_menu:set_game_layer( game_layer )
	self.game_layer = game_layer
end

function game_menu:btnTouchEvent(param_sender,param_touchType)
	if param_touchType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end
    
    AudioEngine.playEffect(MUSIC_PATH.normal[0])
    if param_sender._index == BtnIndex.Open then
    	self:open_menu(true)
	elseif param_sender._index == BtnIndex.Close then
    	self:open_menu(false)
	elseif param_sender._index == BtnIndex.Setting then
        self:open_menu(false)
        self.game_layer:on_btn_config()
	elseif param_sender._index == BtnIndex.Back then
        self:open_menu(false)
		self.game_layer:on_btn_return()
    elseif param_sender._index == BtnIndex.Rule then
        self:open_menu(false)
        self.game_layer.help_layer:show_help_layer()
    end
end

function game_menu:open_menu(bool_open)
    if self._btn_back:isVisible() == bool_open then
    	return 
    end
    self._btn_menu._index = bool_open == true and BtnIndex.Close or BtnIndex.Open
    self._btn_menu:loadTextures(bool_open == true and "img_close.png" or "btn_menu.png", "", "", 1)

	self.game_layer.bg_menu:setVisible(bool_open)
	self.game_layer.bg_menu:setTouchEnabled(bool_open)
    
    self._btn_rule:setVisible(bool_open)
	self._btn_setting:setVisible(bool_open)
	self._btn_back:setVisible(bool_open)
end

function game_menu:show_layer(bool_show)
	self:setVisible(bool_show)
end

return game_menu