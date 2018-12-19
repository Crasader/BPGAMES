--------------------------------------------------------------------------------
-- 托管界面
--------------------------------------------------------------------------------
local trust_layer = class("trust_layer", function() return ccui.Layout:create() end)

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function trust_layer:ctor(visibleSize)
    self:setContentSize(visibleSize)
    self:init(visibleSize)
    self:setVisible(false)
    self:setTouchEnabled(false)
end
-- 初始化
function trust_layer:init(visibleSize)
    local back_ground = control_tools.newImg({path = "trust_mask_1.png", ctype = 1, anchor = cc.p(0, 0)})
    self:addChild(back_ground)
    back_ground:setScaleX((visibleSize.width+10)/back_ground:getContentSize().width)
    back_ground:setPosition(cc.p(-5, math.floor(visibleSize.height/16) + 10))

    local btn_no_trust = control_tools.newBtn({normal = "btn_no_trust.png", ctype = 1})
    self:addChild(btn_no_trust)
    btn_no_trust:setPosition(cc.p(visibleSize.width/2, back_ground:getContentSize().height/2+btn_no_trust:getContentSize().height/2-5))
    btn_no_trust:addTouchEventListener(function(sender, eventType) self:on_btn_no_trust(sender, eventType)end)
end
-- 设置父层级
function trust_layer:set_game_layer(game_layer)
    self.game_layer = game_layer
end
-- 取消托管点击事件
function trust_layer:on_btn_no_trust(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end
    -- 点击音效
    self.game_layer:on_btn_no_trust()
end
-- 托管事件响应
function trust_layer:show_trust_layer(trust_status)
    if trust_status == nil then
        return 
    end
    self:setVisible(trust_status)
    self:setTouchEnabled(trust_status)
end

return trust_layer
