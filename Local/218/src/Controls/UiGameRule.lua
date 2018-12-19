local UiGameRule=class("UiGameRule",function() return control_tools.newImg({}) end);
local the_path = BPRESOURCE("res/help_layer/")
function UiGameRule:ctor()
    self:init()
end

function UiGameRule:init()
    self:loadTexture(the_path.."G_Layer_black.png")
    self:setScale9Enabled(true)
	self:setSize(view_size)

    self._bg_form=control_tools.newImg({path=the_path.."G_Help_bg.png"})
    self._bg_form:setPosition(cc.p(view_size.width/2,view_size.height/2))
    self._bg_form:setAnchorPoint(cc.p(1, 0.5))
    self:addChild(self._bg_form)

    self._bg_form_2=control_tools.newImg({path=the_path.."G_Help_bg.png"})
    self._bg_form_2:setPosition(cc.p(self._bg_form:getContentSize().width,self._bg_form:getContentSize().height/2))
    self._bg_form_2:setAnchorPoint(cc.p(1, 0.5))
    self._bg_form_2:setScaleX(-1)
    self._bg_form:addChild(self._bg_form_2)

    self._img_hint=control_tools.newImg({path=the_path.."g_help_logo.png"})
    self._img_hint:setPosition(cc.p(self._bg_form:getContentSize().width,self._bg_form:getContentSize().height/2+245))
    self._bg_form:addChild(self._img_hint)

    self._scroll_view=control_tools.newScroll({size=cc.size(730,420),direction=_G.SCROLLVIEW_DIR_VERTICAL})
    self._scroll_view:setPosition(cc.p(self._bg_form:getContentSize().width-365,self._bg_form:getContentSize().height/2-220))
    self._scroll_view:setScrollBarEnabled(false)
    self._bg_form:addChild(self._scroll_view)
    local rule_cnt,height=4,0
    for i=rule_cnt,1, -1 do
        local rule_img=control_tools.newImg({path=the_path.."G_Help_rule_"..i..".png",anchor=cc.p(0.5,0)})
        rule_img:setPosition(cc.p(365,height))
        height=height+rule_img:getContentSize().height
        self._scroll_view:addChild(rule_img)
    end
    self._scroll_view:setInnerContainerSize(cc.size(720,height))

     self._btn_close=control_tools.newBtn({small=true,normal=the_path.."G_Help_btn_close.png"})
    self._btn_close:setPosition(cc.p(self._bg_form:getContentSize().width+362,self._bg_form:getContentSize().height/2+170))
    self._btn_close:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_close(param_sender,param_touchType) end)
    self._bg_form:addChild(self._btn_close)
end

function UiGameRule:on_btn_close(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return
    end
    --audio_engine.playButtonEffect()
    self:hideForm()
end

function UiGameRule:layerEvent(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return
    end
end

function UiGameRule:showForm()
    self._bg_form:setScale(0)
    self:setVisible(true)
    self:setTouchEnabled(true)
    self._runing=true

    local act1 = action_tools.CCScaleTo(0.1,1)
    local act2 = action_tools.CCCallFunc(function()
        self._runing=false
    end)

--    local array=CCArray:create()
--    --array:addObject(CCScaleTo:create(0.1,1.1))
--    --array:addObject(CCScaleTo:create(0.05,0.9))
--    array:addObject(CCScaleTo:create(0.1,1))
--    array:addObject(CCCallFunc:create(function()
--        self._runing=false
--    end))
    local action=action_tools.CCSequence(act1, act2)
    self._bg_form:stopAllActions()
    self._bg_form:runAction(action)

end

function UiGameRule:hideForm()
    self._runing=true
    local act1 = action_tools.CCScaleTo(0.1,0)
    local act2 = action_tools.CCCallFunc(function()
        self:setTouchEnabled(false)
        self:setVisible(false)
        self._runing=false
    end)
--    local array=CCArray:create()
--    --array:addObject(CCScaleTo:create(0.05,1.1))
--    array:addObject(CCScaleTo:create(0.1,0))
--    array:addObject(CCCallFunc:create(function()
--         self:setTouchEnabled(false)
--         self:setVisible(false)
--         self._runing=false
--    end))
    local action=action_tools.CCSequence(act1, act2)
    self._bg_form:stopAllActions()
    self._bg_form:runAction(action)
end


return UiGameRule