--------------------------------------------------------------------------------
-- 帮助界面
--------------------------------------------------------------------------------
local help_layer = class("help_layer", function() return ccui.Layout:create() end)

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function help_layer:ctor( visibleSize )
	self:setContentSize(visibleSize)
	self:init(visibleSize)
end
-- 初始化
function help_layer:init(visibleSize)
	-- 遮罩
	local back_ground = control_tools.newImg({path = "mask.png", ctype = 1, size = visibleSize, anchor = cc.p(0, 0)})
	self:addChild(back_ground)
	-- 背景
	local back = control_tools.newImg({path = g_path .. "help/bg_help.png"})
	self:addChild(back)
	back:setPosition(cc.p(visibleSize.width/2, visibleSize.height/2))
	-- 关闭按钮
    local btn_close = control_tools.newBtn({normal = "btn_close.png",ctype = 1})
    back:addChild(btn_close)
    btn_close:setPosition(cc.p(back:getContentSize().width - btn_close:getContentSize().width/3 , back:getContentSize().height - btn_close:getContentSize().height/3))
    btn_close:addTouchEventListener(function(sender, eventType) self:touch_event(sender, eventType) end)
    -- 拖动层
	self.drag_help = control_tools.newScrollView({size = cc.size(back:getContentSize().width+14, 410), csize = cc.size(back:getContentSize().width+14, 2606)})
	back:addChild(self.drag_help)
    self.drag_help:setScrollBarEnabled(false)
	self.drag_help:setPosition(cc.p(0, 20))	
	self.drag_help:setColor(cc.c3b(255,0,0))

	local height = 0
	for i=1, 2 do
		local help_img = control_tools.newImg({path = g_path .. "help/help" .. i ..".png"})
		self.drag_help:addChild(help_img)
		help_img:setScaleX(750/800)
		help_img:setPosition(cc.p(self.drag_help:getContentSize().width/2 - 6, 2606 - height - help_img:getContentSize().height/2 + 20))
		height = height + help_img:getContentSize().height
	end
	self.drag_help:jumpToTop()

	-- 界面空白处点击事件
	local function touchevent(sender, eventType)
		if eventType == _G.TOUCH_EVENT_ENDED then
			if self:touchTest(back, sender:getTouchEndPosition()) == false then 
				self:hide_help_layer()
			end
		end
	end
	self:addTouchEventListener(touchevent)

	self:hide_help_layer()
end
-- 点击区域
function help_layer:touchTest(sender, pos)
    local width = sender:getContentSize().width * sender:getScale()
    local height = sender:getContentSize().height * sender:getScale()

    local posx = sender:getPositionX()
    local posy = sender:getPositionY()
    
    local rect = cc.rect(posx - width/2, posy - height/2, width, height)
    
    return cc.rectContainsPoint(rect, pos)
end
-- 显示帮助界面
function help_layer:show_help_layer()
	self:setVisible(true)
	self:setTouchEnabled(true)
end
-- 隐藏帮助界面
function help_layer:hide_help_layer()
	self:setVisible(false)
	self:setTouchEnabled(false)
end
-- 点击事件
function help_layer:touch_event(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return
	end

	AudioEngine.playEffect(MUSIC_PATH.normal[0])
	self:hide_help_layer()
end

return help_layer