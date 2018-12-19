print("=====UIGuess=====")

sptr_guesss_layer=nil
---------------------------------------------------------------------------------
-- 翻翻乐小游戏界面
---------------------------------------------------------------------------------
local UIControl = require("bpsrc/ui_control")
local UIGuess = class("UIGuess", UIControl)

local g_path = BPRESOURCE("bpres/ui_guess/")

---------------------------------------------------------------------------------
-- 常量
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- 函数
---------------------------------------------------------------------------------
function UIGuess:ctor()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "dh_kaishi.ExportJson")

    self.super:ctor(self)
	self:init()
end

function UIGuess:init()
    -- 事件监听
    local l_lister= cc.EventListenerCustom:create("NOTICE_MINIGUESS_RESULT", function (eventCustom)
        print("====================================小游戏事件响应", eventCustom)
        if eventCustom == nil then return end

        self:on_miniguess_result(json.decode(eventCustom.value))
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

	-- 背景框
    self:set_bg(g_path .. "gui.png")
    self:update_layout()

    self.info_bg = self:get_gui()
    self.view_size = self.info_bg:getContentSize()

    self.light_img = control_tools.newImg({path = g_path .. "light_0.png"})
    self.info_bg:addChild(self.light_img)
    self.light_img:setPosition(cc.p(self.view_size.width/2, self.view_size.height/2))

    local title_img = control_tools.newImg({path = g_path .. "gui_2.png"})
    self.info_bg:addChild(title_img)
    title_img:setPosition(cc.p(self.view_size.width/2, self.view_size.height/2))

    self.game_tips = control_tools.newLabel({str = "参加小游戏需要一次性支付100金币，最多能参与5轮", font = 18})
    self.info_bg:addChild(self.game_tips)
    self.game_tips:setPosition(cc.p(self.view_size.width/2, self.view_size.height/2 - 60))

    self.result_tips = control_tools.newImg({path = g_path .. "img_hint_win.png"})
    self.info_bg:addChild(self.result_tips)
    self.result_tips:setPosition(cc.p(self.view_size.width/2, self.view_size.height/2 - 100))

    self.btn_start = control_tools.newBtn({normal = g_path .. "btn_start_1.png", pressed = g_path .. "btn_start_2.png"})
    self.info_bg:addChild(self.btn_start)
    self.btn_start:setPosition(cc.p(self.view_size.width/2, self.view_size.height/2 - 160))
    self.btn_start:addTouchEventListener( function (sender, eventType) self:on_btn_start(sender, eventType) end )

    self.guide_armature = ccs.Armature:create("dh_kaishi")
    self.info_bg:addChild(self.guide_armature)  
    self.guide_armature:setPosition(cc.p(self.view_size.width/2, self.view_size.height/2 - 160))

    self.tips_info = control_tools.newLabel({str = "提示：关闭可获得当前奖励，点击翻牌赢奖励翻倍", font = 20, color = cc.c3b(205, 104, 57)})
    self.info_bg:addChild(self.tips_info)
    self.tips_info:setPosition(cc.p(self.view_size.width/2, 80))

    self.result_gold = control_tools.newLabel({str = "本局输赢：+10000", fnt = g_path .. "num_shuying1.fnt"})
    self.info_bg:addChild(self.result_gold)
    self.result_gold:setPosition(cc.p(self.view_size.width/2, 35))

    self.btn_close = control_tools.newBtn({normal = g_path .. "btn_close_2.png", pressed = g_path .. "btn_close.png"})
    self.info_bg:addChild(self.btn_close)
    self.btn_close:setPosition(cc.p(self.view_size.width, 40))
    self.btn_close:addTouchEventListener( function (sender, eventType) self:on_btn_close(sender, eventType) end )

    self.card_tbl = {}
    for i=0, 5 do
    	local card_img = control_tools.newImg({path = g_path .. i .. ".png"})
	    self.info_bg:addChild(card_img)
	    card_img:setPosition(cc.p(self.view_size.width/2 + (i%3 - 1)*120, self.view_size.height/2 + 135 - math.floor(i/3) * 125))
	    card_img:addTouchEventListener(function (sender, eventType) self:on_btn_card(sender, eventType) end)
	    table.insert(self.card_tbl, card_img)

	    card_img.light_img = control_tools.newImg({path = g_path .. "img_check.png"})
	    card_img:addChild(card_img.light_img)
	    card_img.light_img:setPosition(cc.p(card_img:getContentSize().width/2, card_img:getContentSize().height/2))
	    card_img.light_img:setVisible(false)
    end

    self.turn_label = control_tools.newLabel({str = "第一轮", font = 20})
    self.info_bg:addChild(self.turn_label)
    self.turn_label:setPosition(cc.p(self.view_size.width/2 + 230, self.view_size.height/2 + 175))

    self.close_time = control_tools.newLabel({str = "（10s）", font = 26, color = cc.c3b(255, 236, 139)})
    self.btn_close:addChild(self.close_time)
    self.close_time:setPosition(cc.p(self.btn_close:getContentSize().width*2/3 + 15, self.btn_close:getContentSize().height/2 + 4))
    self.close_time:setVisible(false)

    self.result_img = control_tools.newImg({path = g_path .. "win.png"})
    self.info_bg:addChild(self.result_img)
    self.result_img:setPosition(cc.p(self.info_bg:getContentSize().width/2, self.info_bg:getContentSize().height/2 - 100))
    self.result_img:setVisible(false)

    self.change_gold = control_tools.newLabel({str = "+10000", fnt = g_path .. "num_shuying1.fnt"})
    self.info_bg:addChild(self.change_gold)
    self.change_gold:setPosition(cc.p(self.view_size.width/2, 35))
    self.change_gold:setVisible(false)
end
-- 开始点击事件
function UIGuess:on_btn_start(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return
	end
	sender:setTouchEnabled(false)
	sender:setBright(false)
	-- 点击音效
	AudioEngine.playEffect(BPRESOURCE("bpres/sound/click.mp3"))
	-- 指引动画隐藏
	self.guide_armature:getAnimation():gotoAndPause(0)
	self.guide_armature:setVisible(false)
	-- 洗牌动画
	self:show_shuffle_cards()
	-- test
	-- self:rand_cards(0, 6)
end
-- 关闭点击事件
function UIGuess:on_btn_close(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return
	end
	-- 点击音效
	AudioEngine.playEffect(BPRESOURCE("bpres/sound/click.mp3"))

	self:hide_guess_layer()
end
-- 卡牌点击事件
function UIGuess:on_btn_card(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return
	end
	-- 点击音效
	AudioEngine.playEffect(BPRESOURCE("bpres/sound/click.mp3"))
	-- 停止倒计时
	self.close_time:stopAllActions()

	self.check_id = sender.tag
    -- 发送卡牌消息
    bind_function.send_mini_guess_checkid(sender.tag)
end
-- 随机手牌 
function UIGuess:rand_cards(bool_success, check_id)
	-- 随机手牌
	local rand_index = bool_success == 1 and math.random(1, 3) or math.random(4, 6)

	local target_tbl, index_tbl = ui_tools.randArrary({1, 2, 3, 4, 5, 6})
	for i,v in ipairs(index_tbl) do
		if v == rand_index then
			target_tbl[check_id], target_tbl[i] = v, target_tbl[check_id]
			break
		end
	end
	print("---------------------target_tbl", json.encode(target_tbl), "rand_index = ", rand_index)
	return target_tbl, rand_index
end
-- 猜牌结果反馈
function UIGuess:on_miniguess_result(eventValue)
	-- 随机手牌
	local target_tbl, rand_index = self:rand_cards(eventValue.bool_success, self.check_id)

	-- 点击牌翻牌结束
	local function completeCard()
        self.card_tbl[self.check_id].light_img:setVisible(true)

        self:on_miniguess_result_next(eventValue, target_tbl)
    end

    local callfunc1 = action_tools.CCCallFunc(completeCard)
	self.card_tbl[self.check_id]:runAction(action_tools.CCSequence(self:draw_card(self.card_tbl[self.check_id], rand_index-1), callfunc1))
end
-- 猜牌结果后续动作
function UIGuess:on_miniguess_result_next(eventValue, target_tbl)
	-- 结果提示
    self.result_img:setOpacity(0)
	self.result_img:setVisible(true)
    self.result_img:loadTexture(eventValue.bool_success ~= 0 and g_path .. "win.png" or g_path .. "lose.png")
    AudioEngine.playEffect(eventValue.bool_success ~= 0 and g_path .. "music_win.mp3" or g_path .. "music_loss.mp3") 

    local function callback()
    	self:show_close_time()
    end
	self.result_img:runAction(action_tools.CCSequence(action_tools.CCFadeIn(0.2), action_tools.CCDelayTime(2), action_tools.CCFadeOut(0.2), action_tools.CCCallFunc(callback)))

	-- 显示全部手牌
    for i,v in ipairs(self.card_tbl) do
    	v.tag = target_tbl[i]
    	if i ~= self.check_id then
		    v:stopAllActions()
    		v:runAction(action_tools.CCSequence(action_tools.CCDelayTime(0.2), self:draw_card(v, v.tag-1)))
    	end
    end

	-- 金币动画
	self:move_gold_action(eventValue.long_gold, eventValue.bool_success)
	-- 根据金币提示不同信息
    if eventValue.long_gold > 0 then
	    if eventValue.int_turn > eventValue.int_total_turn then
	    	self.tips_info:setString("提示：游戏结束，关闭可获得当前奖金！")
	    else
	    	self.tips_info:setString("提示：关闭可获得当前奖金，继续翻牌进入下一轮")
	    	-- 重新翻牌
	    	self:runAction(action_tools.CCSequence(action_tools.CCDelayTime(2), action_tools.CCCallFunc(function () self:show_shuffle_cards() end )))
	    end 
    else
    	if eventValue.long_gold == 0 then
    		if eventValue.bool_success ~= 0 then
    			self.tips_info:setString("提示：恭喜免单成功，欢迎下次参与")
    		else
    			self.tips_info:setString("提示：很遗憾，您输掉了本局赢得的金币")
    		end
    	else
    		self.tips_info:setString("提示：免单失败，本局输赢将双倍结算")
    	end
    end
end
-- 金币提示动画
function UIGuess:move_gold_action(int_gold, bool_sucess)
	self.change_gold:setString((int_gold > 0 or bool_sucess ~= 0) and "+" .. tostring(math.abs(self.long_gold)) or "-" .. tostring(math.abs(self.long_gold)))
	self.change_gold:setBMFontFilePath((int_gold > 0 or bool_sucess ~= 0) and g_path .. "num_shuying1.fnt" or g_path .. "num_shuying2.fnt")

	self.change_gold:setVisible(true)
	self.change_gold:setScale(0)
	self.change_gold:setPositionY(70)
	self.change_gold:setOpacity(255)

	local scale_to = action_tools.CCScaleTo(0.3, 1)
	local delay = action_tools.CCDelayTime(0.5)
	local move_to = action_tools.CCMoveTo(0.8, cc.p(self.change_gold:getPositionX(), 110))
	local fade_out = action_tools.CCFadeOut(0.8)
	local hide = action_tools.CCHide()
	local callfunc = action_tools.CCCallFunc(function () self:update_result(int_gold) end)
	local spawn = action_tools.CCSpawn(move_to, fade_out)
	self.change_gold:runAction(action_tools.CCSequence(scale_to, delay, spawn, hide, callfunc))
end
-- 更新结果
function UIGuess:update_result(int_gold)
	self.result_gold:setBMFontFilePath(self.long_gold > 0 and g_path .. "num_shuying1.fnt" or g_path .. "num_shuying2.fnt")
	self.result_gold:setString(self.long_gold > 0 and "本局输赢：+" .. tostring(int_gold) or "本局输赢：" .. tostring(int_gold))
end
-- 翻牌动画
function UIGuess:draw_card(sender, card_value)
	card_value = card_value or "card_back"
    -- 翻牌到一半时
    local function changeCard()
        sender:loadTexture(g_path .. card_value .. ".png", 0)
    end

    local scaleto1 = action_tools.CCScaleToXY(0.2, 0, 1)
    local callfunc1 = action_tools.CCCallFunc(changeCard)
    local scaleto2 = action_tools.CCScaleToXY(0.2, 1, 1)
    local delay1 = action_tools.CCDelayTime(0.2)

    return action_tools.CCSequence(scaleto1, callfunc1, scaleto2, delay1)
end
-- 显示洗牌动画
function UIGuess:show_shuffle_cards()
	local target_posX, target_posY = self.view_size.width/2, self.view_size.height/2 + 125/2

    for i, v in ipairs(self.card_tbl) do
        local posX, posY = v:getPositionX(), v:getPositionY()
    	v.light_img:setVisible(false)

        -- 恢复位置后
        local function completeCard()
            v:setTouchEnabled(true)

            -- 关闭按钮
            self.btn_close:loadTextureNormal(g_path .. "btn_close.png")

            if i == 6 then
            	self:show_close_time()
            end
        end

        local callfunc1 = self:draw_card(v)
        local moveto1 = action_tools.CCMoveTo(0.2, target_posX, target_posY)
        local delay = action_tools.CCDelayTime(0.2)
        local moveto2 = action_tools.CCMoveTo(0.2, posX, posY)
        local callfunc2 = action_tools.CCCallFunc(completeCard)

        v:runAction(action_tools.CCSequence(callfunc1, moveto1, delay, moveto2, callfunc2))
	end
end
-- 开始倒计时
function UIGuess:show_close_time()
	local time = self.int_time 
	-- 倒计时开始
	local function callback()
		time = time - 1
		self.close_time:setString(string.format("(%ds)", time))

		if time <= 0 then
			self:hide_guess_layer()
		end
	end

    self.close_time:setVisible(true)
    self.close_time:setString(string.format("(%ds)", time))
    self.close_time:stopAllActions()
	self.close_time:runAction(action_tools.CCRepeatForever(action_tools.CCSequence(action_tools.CCDelayTime(1), action_tools.CCCallFunc(callback))))
end
-- 关闭详情界面
function UIGuess:hide_guess_layer()
	self.close_time:setVisible(false)
	self.close_time:stopAllActions()
	
	self.light_img:stopAllActions()
	
	self:stopAllActions()

	if self._extura_function then
		self._extura_function()
	end

	self:ShowGui(false)
end
-- 设置外部函数
function UIGuess:setExtraFunc(cb_function)
    if cb_function and type(cb_function) == "function" then
        self._extura_function = cb_function
    end
end
-- 显示界面详情
function UIGuess:show_guess_layer(eventValue, callfunc)
	self:setExtraFunc(callfunc)
	print("------------eventValue = ", eventValue , "time = ", eventValue.int_time)
	self.int_time = eventValue.int_time
	self.long_gold = eventValue.long_gold
	-- 播放音效
	AudioEngine.playEffect(g_path .. "music_open.mp3")

	-- 显示指引动画
	self.guide_armature:setVisible(true)
    self.guide_armature:getAnimation():playWithIndex(0)    

    -- 光点动画
    local num = 0
    local delay = action_tools.CCDelayTime(0.4)
    local function callback ()
    	num = num == 0 and 1 or 0
    	self.light_img:loadTexture(g_path .. "light_" .. num .. ".png", 0)
    end
    local callfunc = action_tools.CCCallFunc(callback)
    self.light_img:runAction(action_tools.CCRepeatForever(action_tools.CCSequence(delay, callfunc)))

    -- 显示初始牌值
    for i, v in ipairs(self.card_tbl) do
    	v:loadTexture(g_path .. i-1 .. ".png", 0)
    	v.light_img:setVisible(false)
    	v:setTouchEnabled(false)
    	v.tag = i
    end

    -- 根据输赢显示 相关不同
    if eventValue.long_gold > 0 then
    	self.turn_label:setVisible(true)
    	self.turn_label:setString("第1轮")
    	self.result_tips:loadTexture(g_path .. "img_hint_win.png")
    	self.game_tips:setString(string.format("参加小游戏需要一次性支付%d金币，最多能参与%d轮", eventValue.int_tax, eventValue.int_count))
    	self.result_gold:setBMFontFilePath(g_path .. "num_shuying1.fnt")
    	self.result_gold:setString("本局输赢：+" .. tostring(eventValue.long_gold))
    	self.tips_info:setString("提示：关闭可获得当前奖金，点击翻牌赢奖金翻倍")
    else
    	self.turn_label:setVisible(false)
    	self.result_tips:loadTexture(g_path .. "img_hint_lose.png")
    	self.game_tips:setString(string.format("参加小游戏需要一次性支付%d金币", eventValue.int_tax))
    	self.result_gold:setString("本局输赢：" .. tostring(eventValue.long_gold))
    	self.result_gold:setBMFontFilePath(g_path .. "num_shuying2.fnt")
    	self.tips_info:setString("提示：关闭照常结算金币，点击翻牌赢免单")
    end

    -- 显示关闭按钮初始图片
    self.btn_close:loadTextureNormal(g_path .. "btn_close_2.png")
    self.close_time:setVisible(false)

    -- 显示开始按钮初始图片
    self.btn_start:setTouchEnabled(true)
    self.btn_start:setBright(true)

    -- 结果提示图片隐藏
    self.result_img:setVisible(false)

	self:ShowGui(true)
end
-- 显示翻翻乐小游戏界面
function UIGuess.ShowGuessLayer(eventValue, callfunc)
    if sptr_guesss_layer == nil then 
        local main_layout = bp_get_main_layout()
        sptr_guesss_layer = UIGuess:create()
        main_layout:addChild(sptr_guesss_layer)
    end
  
    sptr_guesss_layer:show_guess_layer(eventValue, callfunc)
    return sptr_guesss_layer
end

function UIGuess:destroy()
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "dh_kaishi.ExportJson")
end

return UIGuess
