--------------------------------------------------------------------------------
-- 顶部工具条
--------------------------------------------------------------------------------
local top_bar = class("top_bar", function() return ccui.Layout:create() end)
local card_sprite = require("src/card_sprite")

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
function top_bar:ctor( visibleSize )
    self.end_pos = cc.p(visibleSize.width/2, visibleSize.height-40)
    self:init(visibleSize)
end

function top_bar:init(visibleSize)
    self.top_bar2 = control_tools.newImg({path = "top_bar2.png", ctype = 1})
    self:addChild(self.top_bar2)
    self.top_bar2:setPosition(self.end_pos)

    self.base_gold = control_tools.newLabel({fnt = g_path .. "text_font/number_doudizhu_difenbeishu.fnt", str = tostring("—")}) --CCLabelBMFont:create("", "doudizhu/text_font/number_doudizhu_difenbeishu.fnt")
    self.top_bar2:addChild(self.base_gold)
    self.base_gold:setPosition(cc.p(52, self.top_bar2:getContentSize().height/4))

    self.gold_times = control_tools.newLabel({fnt = g_path .. "text_font/number_doudizhu_difenbeishu.fnt", str = tostring("—")})
    self.top_bar2:addChild(self.gold_times)
    self.gold_times:setPosition(cc.p(self.top_bar2:getContentSize().width - 52, self.top_bar2:getContentSize().height/4))

    -- 底牌区
    self.base_cards = {}
    self.scale = 0.265*AUTO_HEIGHT
    if AUTO_HEIGHT then
        self.scale = self.scale * AUTO_HEIGHT
    end
    for i=1, 3 do
        local card = card_sprite:create(cc.p(self.top_bar2:getContentSize().width/2 + (i - 2)*50, self.top_bar2:getContentSize().height/2 + 5), self.scale)
        self.top_bar2:addChild(card)
        table.insert(self.base_cards, card)
    end

    self.base_times_img = control_tools.newImg({path = "2bei.png", ctype = 1})
    self.top_bar2:addChild(self.base_times_img)
    self.base_times_img:setPosition(cc.p(self.top_bar2:getContentSize().width/2 + self.base_times_img:getContentSize().width/2 + 55, self.top_bar2:getContentSize().height/2 - 5))
    self.base_times_img:setVisible(false)
end
-- 设置父层级
function top_bar:set_game_layer(game_layer)
    self.game_layer = game_layer
end
-- 显示底牌
function top_bar:show_base_cards(isAni, times)
	if isAni == false then
        for i,v in ipairs(self.base_cards) do
	        if v then
	            v:load_cards_png(self.game_layer.struct_base_cards[i])
	        end
	    end
        if times > 1 then
            self.base_times_img:loadTexture(times .. "bei.png", 1)
            self.base_times_img:setVisible(true)
        end

        return
    end
    for i,v in ipairs(self.base_cards) do
        -- 翻牌到一半时
        local function changeCard(sender)
            v:load_cards_png(self.game_layer.struct_base_cards[i])
        end

        -- 翻牌结束
        local function completeCard(sender)
            if times > 1 then
                self.base_times_img:loadTexture(times .. "bei.png", 1)
                self.base_times_img:setVisible(true)
            end
        end

        local scaleto1 = action_tools.CCScaleToXY(0.5, 0, self.scale)
        local callfunc1 = action_tools.CCCallFunc(changeCard)
        local scaleto2 = action_tools.CCScaleToXY(0.5, self.scale, self.scale)
        local callfunc2 = action_tools.CCCallFunc(completeCard)
        v:runAction(action_tools.CCSequence(scaleto1, callfunc1, scaleto2, callfunc2))
    end
end
-- 显示底分
function top_bar:show_base_gold(base_gold)
    if base_gold == -1 then
        self.base_gold:setString(tostring("—"))
        return 
    end

    if base_gold < 100000 then
        self.base_gold:setString(tostring(base_gold))
    else
        self.base_gold:setString(string.format("%d万", base_gold/10000))
    end
end
-- 显示倍数
function top_bar:show_gold_times(gold_times, times_status)
    if gold_times == -1 then
        self.gold_times:setString("—")
        return
    end

    if gold_times >= 1 then
        if times_status == 0 then
            self.gold_times:setString(tostring(gold_times))
        elseif times_status == 2 then
            self:gold_times_action(gold_times)
            if bind_function.get_game_status() ~= GameStatus.outcards then
                local visibleSize = cc.Director:getInstance():getWinSize()
                local times_label = control_tools.newLabel({fnt = g_path .. "text_font/number_ddz_qiangdizhubeishu.fnt"})
                times_label:setString("x" .. gold_times)
                times_label:setAnchorPoint(cc.p(0.5, 1))
                times_label:setPosition(cc.p(visibleSize.width/2-50, visibleSize.height-245))
                self.game_layer:addChild(times_label, 11)
                local function callback()
                    times_label:removeFromParent()
                end
                local ease_out = action_tools.CCEaseElasticOut(action_tools.CCMoveTo(0.5, cc.p(visibleSize.width/2, times_label:getPositionY())))
                local delay = action_tools.CCDelayTime(0.05)
                local callfunc = action_tools.CCCallFunc(callback)
                times_label:runAction(action_tools.CCSequence(ease_out, delay, callfunc))
           end
        end
    end
end
-- 倍数变化action
function top_bar:gold_times_action(gold_times)
    self.gold_times:setString(tostring(gold_times))
    local action1 = action_tools.CCScaleTo(0.25, 1.2)
    local action2 = action_tools.CCScaleTo(0.25, 1)
    self.gold_times:runAction(action_tools.CCSequence(action1, action2))
end

function top_bar:clear_ui()
    self:show_base_gold(-1)
    self:show_gold_times(-1)
    self.base_times_img:setVisible(false)
    for i,v in ipairs(self.base_cards) do
        if v then
            v:load_cards_png(0)
        end
    end
end 

return top_bar