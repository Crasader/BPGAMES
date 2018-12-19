--------------------------------------------------------------------------------
-- 结算界面
--------------------------------------------------------------------------------
local finish_layer = class("finish_layer", function () return ccui.Layout:create() end )
local UIGuess = require("bpsrc/ui_guess")

--------------------------------------------------------------------------------
-- 常量
--------------------------------------------------------------------------------
local MsgIndex = {name = 1, base_glod = 2, multible = 3, result = 4}
local MutipleIndex = {call = 1, boom = 2, spring = 3, base = 4, task = 5}


--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function finish_layer:ctor(visibleSize)
    self:setContentSize(visibleSize)
    self:init(visibleSize)
end
-- 初始化
function finish_layer:init(visibleSize)
    -- 事件监听
    local l_lister= cc.EventListenerCustom:create("NOTICE_MINIGUESS", function (eventCustom)
        print("====================================小游戏事件响应", eventCustom)
        if eventCustom == nil then return end

        self:on_open_mini_guess(eventCustom.value)
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)
    -- 半透明背景
    self.result_back = control_tools.newImg({path = g_path .. "result/finish.png", anchor = cc.p(0, 0)})
    self:addChild(self.result_back)
    self.result_back:setScaleX(AUTO_WIDTH)
    self.result_back:setScaleY(AUTO_HEIGHT)

    -- 倒计时
    self.player_clock = require("src/ui_tools/ui_clock"):create({path = "clock_bg.png", ctype = 1, scale = AUTO_SCALE, fnt = g_path .. "text_font/number_doudizhu_chupaidaojishi.fnt"})
    self:addChild(self.player_clock)
    self.player_clock:setPosition(cc.p(visibleSize.width/2, 100))

    -- 初始化结果form
    self:init_result_form(visibleSize)

    -- 离开
    self.btn_left = control_tools.newBtn({normal = "btn_left.png", ctype = 1})
    self:addChild(self.btn_left)
    self.btn_left:setPosition(cc.p(45, visibleSize.height - 45))
    self.btn_left:addTouchEventListener(function(sender, eventType) self:on_btn_left(sender, eventType) end)
    self.btn_left:setVisible(false)

    -- 小游戏按钮
    self.btn_guess = control_tools.newImg({size = cc.size(100, 100)})
    self:addChild(self.btn_guess)
    self.btn_guess:setPosition(cc.p(70, 130))
    self.btn_guess:setVisible(false)
    self.btn_guess:setTouchEnabled(true)
    self.btn_guess:addTouchEventListener(function(sender, eventType) self:on_btn_guess(sender, eventType) end)

    -- 台费
    self.label_tax_fee = control_tools.newLabel({font = "24", color = cc.c3b(250, 250, 250), anchor = cc.p(1, 0)})
    self:addChild(self.label_tax_fee)
    self.label_tax_fee:setPosition(cc.p(visibleSize.width - 10, 70))

    self:setVisible(false)
    self:setTouchEnabled(false)
end
-- 设置父层级
function finish_layer:set_game_layer( game_layer )
    self.game_layer = game_layer
    self:create_about_btn()
end
-- 初始化结算表格
function finish_layer:init_result_form(visibleSize)
    -- 表格背景
    self.finish_info_form = control_tools.newImg({path = g_path .. "result/form.png"})
    self.finish_info_form:setPosition(cc.p(visibleSize.width/2, visibleSize.height/2 -20))
    self:addChild(self.finish_info_form)
    
    -- 倍数详情
    self.l_btn_detail = control_tools.newBtn({normal = "detail_btn.png", ctype = 1})
    self.finish_info_form:addChild(self.l_btn_detail)
    self.l_btn_detail:addTouchEventListener(function(param_sender,param_touchType) self:showResultDetail(param_sender,param_touchType) end)
    self.l_btn_detail:setPosition(cc.p(self.finish_info_form:getContentSize().width*5/8, self.finish_info_form:getContentSize().height*3/4 + 8))
    self.l_btn_detail:setLocalZOrder(2)

    self.detail = {}
    self.detail.bg = control_tools.newImg({path = "detail_img.png", ctype = 1})
    self.detail.bg:setPosition(cc.p(0, self.detail.bg:getContentSize().height/3*2+10))
    self.detail.bg:setVisible(false)
    for i = 1, 5 do
        local h, v = math.floor(i/4), (i-1)%3
        self.detail[i] = control_tools.newLabel({fnt = g_path .. "text_font/number_doudizhu_beishutishi.fnt"})
        self.detail[i]:setPosition(cc.p(self.detail.bg:getContentSize().width/2 + 130*v - 80, self.detail.bg:getContentSize().height/2 - 40*h + 20))
        self.detail.bg:addChild(self.detail[i])
    end    
    self.l_btn_detail:addChild(self.detail.bg)

    -- 用户信息
    self.all_user_info = {}
    self.banker_logo = {}
    for i = 1, GAME_PLAYER do
        self.all_user_info[i] = {}
        for j = 1, 4 do
            self.all_user_info[i][j] = control_tools.newLabel({font = 32, ex = true})
            self.finish_info_form:addChild(self.all_user_info[i][j])
            self.all_user_info[i][j]:setPosition(cc.p(25 + (self.finish_info_form:getContentSize().width - 50)/8*(j*2-1), self.finish_info_form:getContentSize().height -(self.finish_info_form:getContentSize().height - 120)/8*(i*2+1) - 55))
            if j == 1 then
                self.banker_logo[i] = control_tools.newImg({path = "banker_logo.png", ctype = 1})
                self.all_user_info[i][j]:addChild(self.banker_logo[i])
                self.banker_logo[i]:setPosition(cc.p(155, 12))
                self.banker_logo[i]:setVisible(false)
            end
        end
    end
end
-- 返回点击事件
function finish_layer:on_btn_left(sender, eventType)
    print("--------------eventType = ", eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end

    AudioEngine.playEffect(MUSIC_PATH.normal[0])

    self:setFinishLayerVisible(false)
end
-- 翻翻乐小游戏点击事件
function finish_layer:on_btn_guess(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end
    
    print("=============翻翻乐小游戏点击事件===============")
    AudioEngine.playEffect(MUSIC_PATH.normal[0])
    -- 暂停计时器
    self.player_clock:pauseTime()

    -- 开启小游戏
    bind_function.send_open_mini_game()
end
-- 翻翻乐小游戏响应
function finish_layer:on_open_mini_guess(value)
    local function callback()
        -- 恢复计时器
        self.player_clock:resumeTime()
    end

    UIGuess.ShowGuessLayer(json.decode(value), callback)
end
-- 创建相关按钮
function finish_layer:create_about_btn()
    -- 准备按钮
    self.btn_continue = self.game_layer:create_btn({normal = "btn_ready.png", ctype = 1, tag = ButtonEventType.continue})
    self.btn_continue:setPosition(cc.p(self:getContentSize().width/2+180, 100))
    self:addChild(self.btn_continue)
    -- 换桌按钮
    self.btn_change = self.game_layer:create_btn({normal = "btn_changetable.png", pressed = "btn_changetable_1.png", ctype = 1, tag = ButtonEventType.change})
    self.btn_change:setPosition(cc.p(self:getContentSize().width/2-180, 100))
    self:addChild(self.btn_change)
    -- 重新匹配按钮
    self.btn_leave = self.game_layer:create_btn({normal = "find_again.png", ctype = 1, tag = ButtonEventType.change}) 
    self.btn_leave:setPosition(cc.p(self:getContentSize().width/2-180, 100))
    self:addChild(self.btn_leave)
    -- 再来一局按钮
    self.btn_again = self.game_layer:create_btn({normal = "btn_continue.png", ctype = 1, tag = ButtonEventType.continue}) 
    self.btn_again:setPosition(cc.p(self:getContentSize().width/2+180, 100))
    self:addChild(self.btn_again)
    -- 再来一局中间按钮
    self.btn_again_mid = self.game_layer:create_btn({normal = "btn_continue.png", ctype = 1, tag = ButtonEventType.change}) 
    self.btn_again_mid:setPosition(cc.p(self:getContentSize().width/2, 100))
    self:addChild(self.btn_again_mid)
    -- 查看战绩按钮
    self.btn_show_grade = self.game_layer:create_btn({normal = "btn_show_grade_2.png", ctype = 1, tag = ButtonEventType.grade})
    self.btn_show_grade:setPosition(cc.p(self:getContentSize().width/2,100))
    self:addChild(self.btn_show_grade)

    self:hide_all_btn()
end
-- 隐藏全部按钮
function finish_layer:hide_all_btn()
    self.btn_continue:setTouchEnabled(false)
    self.btn_continue:setVisible(false)
    self.btn_change:setTouchEnabled(false)
    self.btn_change:setVisible(false)
    self.btn_leave:setTouchEnabled(false)
    self.btn_leave:setVisible(false)
    self.btn_again:setTouchEnabled(false)
    self.btn_again:setVisible(false)
    self.btn_again_mid:setTouchEnabled(false)
    self.btn_again_mid:setVisible(false)
    self.btn_show_grade:setTouchEnabled(false)
    self.btn_show_grade:setVisible(false)
end
-- 关闭结算界面
function finish_layer:hide_finish_layer()
    self:hide_all_btn()
    self.player_clock:hide()
    if self.armature then
        self.armature:removeFromParent()
        self.armature = nil
    end
    if self.guess_armature then
        self.guess_armature:removeFromParent()
        self.guess_armature = nil
        self.btn_guess:setTouchEnabled(false)
        self.btn_guess:setVisible(false)
    end
    self:setVisible(false)
    self:setTouchEnabled(false)
end
-- 显示结算界面倒计时
function finish_layer:show_wait_time()
    local time = self.game_layer.finish_time or 20
    print("-----------------time = ", time)
    if time > 1 then
        self.game_layer.player_clock:setPosition(cc.p(self.game_layer:getContentSize().width/2, self.game_layer.btn_change:getPositionY()))
        self.game_layer.player_clock:setVisible(false)

        self.player_clock:setTime(time, true)

        local pay_sign = self.game_layer:check_gold(false) == true and 0 or 1
        if pay_sign ~= 1 then
            self.player_clock:setTimeUpFunc(function () self.game_layer:on_start_time_over() end)
        end
    end
end

function finish_layer:setFinishLayerVisible(bool_visible)
    self:setVisible(bool_visible)
    self:setTouchEnabled(bool_visible)

    -- 桌面按钮显示
    if self.btn_leave:isVisible() then
        self.game_layer.btn_change:loadTextures("find_again.png", "", "",1)
        self.game_layer.btn_ready:loadTextures("btn_continue.png", "", "",1)
    end

    if self.game_layer.active_on_game then
        if bool_visible == false then
            self.game_layer.active_on_game:setGameZOrder(11)
            self.game_layer.active_on_game:setReviveCountViewPos()
            self.game_layer.active_on_game:setWinCountViewPos()
        else
            self.game_layer.active_on_game:setGameZOrder(self:getZOrder() + 1)
            self.game_layer.active_on_game:setReviveCountViewPos(cc.p(self.game_layer.active_on_game:getReviveCountViewPos().x + 50, self.game_layer.active_on_game:getReviveCountViewPos().y + 35))
            self.game_layer.active_on_game:setWinCountViewPos(cc.p(self.game_layer.active_on_game:getWinCountViewPos().x + 30, self.game_layer.active_on_game:getWinCountViewPos().y - 5))
        end
    end

    if self.game_layer.active_on_game and self.game_layer.active_on_game._active_begin_game_status == 0 then
        if not self.game_layer._btn_active_find then   
            self.game_layer._btn_active_find = self.game_layer:create_btn({normal = "find_again_2.png", ctype = 1, tag  = ButtonEventType.change})
            self.game_layer._btn_active_find:setPosition(cc.p(self:getContentSize().width/2 + 180, self:getContentSize().height*2/5 + self.game_layer.btn_change:getContentSize().height/2-92))
            self.game_layer.layer:addChild(self.game_layer._btn_active_find, 6)
            self.game_layer._btn_active_find:setTouchEnabled(true)

            self.game_layer._btn_active_find_mid = self.game_layer:create_btn({normal = "find_again_2.png", ctype = 1, tag  = ButtonEventType.change})
            self.game_layer._btn_active_find_mid:setPosition(cc.p(self:getContentSize().width/2, self:getContentSize().height*2/5 + self.game_layer.btn_change:getContentSize().height/2-200))
            self.game_layer.layer:addChild(self.game_layer._btn_active_find_mid, 6)
            self.game_layer._btn_active_find_mid:setTouchEnabled(true)

            self.game_layer._active_revive_btn = self.game_layer:create_btn({normal = "btn_revive.png", ctype = 1, tag  = ButtonEventType.revive}) 
            self.game_layer._active_revive_btn:setPosition(cc.p(self:getContentSize().width/2 - 180, self:getContentSize().height*2/5 + self.game_layer.btn_change:getContentSize().height/2-92))
            self.game_layer._active_revive_btn:setVisible(false)
            self.game_layer.layer:addChild(self.game_layer._active_revive_btn, 6)
            self.game_layer._active_revive_btn:setTouchEnabled(true)

            self.game_layer._active_revive_btn._count_lable = control_tools.newLabel({fnt = "doudizhu/text_font/number_doudizhutiaozhansai_fuhuokashuliang_anniu.fnt"})
            self.game_layer._active_revive_btn:addChild(self.game_layer._active_revive_btn._count_lable)
            self.game_layer._active_revive_btn._count_lable:setPosition(cc.p(60, 8))
        end
        if self.game_layer.active_on_game._active_status == ActiveStatus.LoseWithOutProperty and self.game_layer.active_on_game:getWinCount() > 0 then
            self.game_layer._btn_active_find_mid:setVisible(false)
            self.game_layer._btn_active_find:setVisible(not bool_visible)
            self.game_layer._active_revive_btn:setVisible(not bool_visible)
            self.game_layer._active_revive_btn._count_lable:setString(self.game_layer.active_on_game:getReviveCount())
        else
            self.game_layer._btn_active_find_mid:setVisible(not bool_visible)
            self.game_layer._btn_active_find:setVisible(false)
            self.game_layer._active_revive_btn:setVisible(false)
        end
        self.game_layer.btn_ready:setVisible(false)
        self.game_layer.btn_change:setVisible(false)
    else
        if self.game_layer._btn_active_find then
            self.game_layer._btn_active_find:setVisible(false)
            self.game_layer._btn_active_find_mid:setVisible(false)
            self.game_layer._active_revive_btn:setVisible(false)
        end
        self.game_layer.btn_ready:setVisible(not bool_visible)
        self.game_layer.btn_ready:setBright(true)
        self.game_layer.btn_ready:setTouchEnabled(not bool_visible)
        self.game_layer.btn_change:setVisible(not bool_visible)
        self.game_layer.btn_change:setTouchEnabled(not bool_visible)
        self.game_layer.btn_change._num:setVisible(false)
        self.game_layer.btn_change:setBright(true)
    end

    self.game_layer.btn_show_finish:setVisible(not bool_visible)
    self.game_layer.btn_show_finish:setTouchEnabled(not bool_visible)
    
    -- 倒计时显示切换
    self.game_layer.player_clock:setVisible(not bool_visible)
    if bool_visible == false then
        self.game_layer.player_clock:setTime(self.player_clock:getTime(), true)
    else
        self.game_layer.player_clock:hide()
    end
end
-- 玩家详情
function finish_layer:set_finish_data(user_data, data, index)
    local chun_tian = data.is_spring == true and 3 or 1
    local tast_times = data.task_complete == true and data.task_gold_times or 1
    local times = self.game_layer.base_cards_times > 1 and self.game_layer.base_cards_times or 1

    -- 玩家名字
    if user_data and user_data ~= "" then
        local name_str = bp_gbk2utf(user_data.szName)
        self.all_user_info[data.chair_id[index] + 1][MsgIndex.name]:setTextEx(name_str, 160, 2)
    else
        self.all_user_info[data.chair_id[index] + 1][MsgIndex.name]:setTextEx("玩家"..index, 160, 2)
    end
    -- 底分
    self.all_user_info[data.chair_id[index] + 1][MsgIndex.base_glod]:setString(data.base_gold)
    -- 倍数
    local mutible = times * data.bomb_gold_times * tast_times * data.rob_gold_times * chun_tian
    if self.game_layer.user_identity and self.game_layer.user_identity[bind_function.switch_to_view_id(data.chair_id[index])] == UserIdentity.landlord then
        self.banker_logo[data.chair_id[index]+1]:setVisible(true)
        mutible = mutible * 2
    else
        self.banker_logo[data.chair_id[index]+1]:setVisible(false)
    end
    self.all_user_info[data.chair_id[index] + 1][MsgIndex.multible]:setString("x"..mutible)
    -- 得分
    local res = data.int_gold_new[data.chair_id[index] + 1] > 0 and "+" .. data.int_gold_new[data.chair_id[index] + 1] or data.int_gold_new[data.chair_id[index] + 1]
    self.all_user_info[data.chair_id[index] + 1][MsgIndex.result]:setString(res)
    -- 地主与农民详情颜色
    for j = 1, 4 do
        if data.chair_id[index] == self.game_layer:get_self_chair_id() then
            self.all_user_info[data.chair_id[index] + 1][j]:setColor(cc.c3b(255,255,151))
        else
            self.all_user_info[data.chair_id[index] + 1][j]:setColor(cc.c3b(255,255,255))
        end
    end
end
-- 倍数详情
function finish_layer:set_times_data(rob_gold_times, is_spring, task_complete, bomb_gold_times)
    local chun_tian = is_spring == true and 3 or 1
    local tast_times = task_complete == true and task_gold_times or 1
    local times = self.game_layer.base_cards_times > 1 and self.game_layer.base_cards_times or 1

    self.detail[MutipleIndex.base]:setString("x"..times)
    self.detail[MutipleIndex.call]:setString("x".. rob_gold_times)
    self.detail[MutipleIndex.spring]:setString("x"..chun_tian)
    self.detail[MutipleIndex.task]:setString("x"..tast_times)
    self.detail[MutipleIndex.boom]:setString("x"..bomb_gold_times)
end
-- 显示结算界面
function finish_layer:show_finish_layer(result)
    self.detail.bg:setVisible(false)
    
    -- 台费
    self:show_tax_fee(result.tax_fee)

    -- 翻翻乐小游戏
    self:show_guess_armature(result.int_kind_new[self.game_layer:get_self_chair_id() + 1])

    local action = action_tools.CCSequence(action_tools.CCDelayTime(1.5), action_tools.CCCallFunc(function ()
    	if result.is_spring and result.int_kind_new[self.game_layer:get_self_chair_id()+1] == GameResult.win then
            self.armature = ccs.Armature:create("ddz_shengli_chuntian")
            self.armature:getAnimation():play("Animation1", -1, 0)
		    AudioEngine.playEffect(MUSIC_PATH.normal[6])   
	    else
		    if result.int_kind_new[self.game_layer:get_self_chair_id()+1] == GameResult.win then
                self.armature = ccs.Armature:create("ddz_shengli")
                self.armature:getAnimation():play("shengli", -1, 0)
			    AudioEngine.playEffect(MUSIC_PATH.normal[7])   
		    else
                self.armature = ccs.Armature:create("ddz_shibai")
                self.armature:getAnimation():play("Animation1", -1, 0)
			    AudioEngine.playEffect(MUSIC_PATH.normal[8])
		    end
	    end

        self.armature:setPosition(cc.p(self.finish_info_form:getContentSize().width/2, self.finish_info_form:getContentSize().height + 25))
        self.finish_info_form:addChild(self.armature)

        self:setVisible(true)
        self:setTouchEnabled(true)
        if self.game_layer.active_on_game then
            self.game_layer.active_on_game:setGameZOrder(self:getZOrder() + 1)
            self.game_layer.active_on_game:setReviveCountViewPos(cc.p(self.game_layer.active_on_game:getReviveCountViewPos().x + 50, self.game_layer.active_on_game:getReviveCountViewPos().y + 35))
            self.game_layer.active_on_game:setWinCountViewPos(cc.p(self.game_layer.active_on_game:getWinCountViewPos().x + 30, self.game_layer.active_on_game:getWinCountViewPos().y - 5))
        end
    end))

    if ROOM_MODE == GF.ROOM_MODE_FRIEND then
        local is_show = self.game_layer.count_times - self.game_layer.used_times <= 1 and true or false

        self.btn_show_grade:setVisible(is_show)
        self.btn_show_grade:setTouchEnabled(is_show)
        self.btn_again_mid:setTouchEnabled(not is_show)
        self.btn_again_mid:setVisible(not is_show)

        self.player_clock:hide()
    else
        if self.game_layer.active_on_game and self.game_layer.active_on_game._active_begin_game_status == 0 then
            if not self._active_revive_btn then
                self._active_revive_btn = self.game_layer:create_btn({normal = "btn_revive.png", ctype = 1, tag  = ButtonEventType.revive}) 
                self._active_revive_btn:setPosition(cc.p(self:getContentSize().width/2-180, 100))
                self._active_revive_btn:setVisible(false)
                self:addChild(self._active_revive_btn)
                self._active_revive_btn:setTouchEnabled(true)

                self._active_revive_btn:setPressedActionEnabled(false)
                self._active_revive_btn._count_lable = control_tools.newLabel({fnt = "doudizhu/text_font/number_doudizhutiaozhansai_fuhuokashuliang_anniu.fnt"})
                self._active_revive_btn:addChild(self._active_revive_btn._count_lable)
                self._active_revive_btn._count_lable:setPosition(cc.p(60, 8))

                self._active_revive_btn._hint = control_tools.newImg({path = "btn_tips_task_1.png", ctype = 1})
                self._active_revive_btn:addChild(self._active_revive_btn._hint)
                self._active_revive_btn._hint:setAnchorPoint(cc.p(1, 0))
                self._active_revive_btn._hint:setPositionY(self._active_revive_btn._hint:getContentSize().height/3)

                self._active_find_btn = self.game_layer:create_btn({normal = "find_again_2.png", ctype = 1, tag  = ButtonEventType.change})
                self._active_find_btn:setPosition(cc.p(self:getContentSize().width/2+180, 100))
                self._active_find_btn:setVisible(false)
                self._active_find_btn:setTouchEnabled(true)
                self:addChild(self._active_find_btn)

                
                self._active_find_btn_mid = self.game_layer:create_btn({normal = "find_again_2.png", ctype = 1, tag  = ButtonEventType.change}) 
                self._active_find_btn_mid:setPosition(cc.p(self:getContentSize().width/2, 100))
                self._active_find_btn_mid:setVisible(false)
                self._active_find_btn_mid:setTouchEnabled(true)
                self:addChild(self._active_find_btn_mid)
            end
            self.btn_leave:setTouchEnabled(false)
            self.btn_leave:setVisible(false)
            self.btn_again:setTouchEnabled(false)
            self.btn_again:setVisible(false)
            self.btn_continue:setTouchEnabled(false)
            self.btn_continue:setVisible(false)
            self.btn_change:setTouchEnabled(false)
            self.btn_change:setVisible(false)
            if result.int_kind_new[self.game_layer:get_self_chair_id() + 1] == GameResult.lose and self.game_layer.active_on_game._active_status == ActiveStatus.LoseWithOutProperty and self.game_layer.active_on_game:getWinCount() > 0 then
                self._active_revive_btn:setVisible(true)
                local l_revive_count = 2
                if get_prop_count_by_id(ID_PROP_REVIVE_CARD) > 0 then
                    l_revive_count = 1
                end
                self._active_revive_btn._count_lable:setString(get_prop_count_by_id(ID_PROP_REVIVE_CARD))
                self._active_revive_btn._hint:loadTexture("btn_tips_task_"..l_revive_count..".png", 1)
                self._active_revive_btn:setTouchEnabled(true)
                self._active_find_btn:setTouchEnabled(true)
                self._active_find_btn:setVisible(true)
                self.player_clock:setPositionX(self:getContentSize().width/2)
            else
                self._active_find_btn_mid:setVisible(true)
                self._active_find_btn_mid:setTouchEnabled(true)
                self._active_find_btn:setVisible(false)
                self._active_revive_btn:setVisible(false)
                self.player_clock:setPositionX(self:getContentSize().width/2 - self.player_clock:getContentSize().width - self._active_find_btn_mid:getContentSize().width/2 + 10)
            end
            self.btn_left:setTouchEnabled(true)
            self.btn_left:setVisible(true)

        else
            local show_rlt = self.game_layer:bool_lineup()
            if self._active_revive_btn then   
                self._active_find_btn_mid:setVisible(false)
                self._active_revive_btn:setVisible(false)
                self._active_find_btn:setVisible(false)
            end
            self.btn_leave:setTouchEnabled(show_rlt)
            self.btn_leave:setVisible(show_rlt)
            self.btn_again:setTouchEnabled(show_rlt)
            self.btn_again:setVisible(show_rlt)
            self.btn_left:setTouchEnabled(true)
            self.btn_left:setVisible(true)
            self.btn_continue:setTouchEnabled(not show_rlt)
            self.btn_continue:setVisible(not show_rlt)
            self.btn_change:setTouchEnabled(not show_rlt)
            self.btn_change:setVisible(not show_rlt)
        end
        self:show_wait_time()
    end

    self:stopAllActions()
    self:runAction(action)
end
-- 翻翻乐小游戏
function finish_layer:show_guess_armature(result)
    if self.game_layer:bool_guess_game() == true then
        if self.guess_armature == nil then             
            self.guess_armature = ccs.Armature:create("dh_fanfanle")
            self.btn_guess:addChild(self.guess_armature)
            self.guess_armature:setPosition(cc.p(self.btn_guess:getContentSize().width/2, self.btn_guess:getContentSize().height/2))
        end

        if result == GameResult.win then
            self.guess_armature:getAnimation():playWithIndex(0)
        elseif result == GameResult.lose then
            self.guess_armature:getAnimation():playWithIndex(1)
        end
        self.btn_guess:setVisible(true)
        self.btn_guess:setTouchEnabled(true)
    end
end
-- 显示台费
function finish_layer:show_tax_fee(result)
    if result > 0 then
        local l_tax_fee = result >= 10000 and result/10000 .. "万" or result
        self.label_tax_fee:setString("服务费:"..l_tax_fee)
    else
        self.label_tax_fee:setString("")
    end
end

function finish_layer:freshReviveBtn()
    if self._active_revive_btn and self._active_revive_btn:isVisible() == true then
        self._active_revive_btn:setVisible(false)
    end
    if self._active_find_btn and self._active_find_btn:isVisible() == true then
        self._active_find_btn:setVisible(false)
    end
    if self._active_find_btn_mid then
        self._active_find_btn_mid:setVisible(true)
    end
    self.player_clock:setPositionX(self:getContentSize().width/2 - self.player_clock:getContentSize().width - self._active_find_btn_mid:getContentSize().width/2 + 10)
end

function finish_layer:showResultDetail(param_sender,param_touchType)
    if param_touchType ~= nil and param_touchType ~= _G.TOUCH_EVENT_ENDED then
        return
    end
    if self.detail.bg:isVisible() then
        self.detail.bg:setVisible(false)
    else
        self.detail.bg:setVisible(true)
    end
end

function finish_layer:clear_ui()
    self:hide_all_btn()
    self.player_clock:hide()
    if self.armature then
        self.armature:removeFromParent()
        self.armature = nil
    end
    if self.guess_armature then
        self.guess_armature:removeFromParent()
        self.guess_armature = nil
        self.btn_guess:setTouchEnabled(false)
        self.btn_guess:setVisible(false)
    end
    self:setVisible(false)
    self:setTouchEnabled(false)
end

function finish_layer:DY_test(visibleSize)
   --  -- 测试
   -- local result = {}
   -- result.int_kind_new = {GameResult.lose, GameResult.lose, GameResult.lose}
   -- result.is_spring = true
   -- result.int_gold_new = {1111, 2222, 3333, 4444}
   -- result.bomb_gold_times = 1024
   -- result.rob_gold_times = 16
   -- result.bomb_times = 4
   -- result.rob_times = 10
   -- result.task_gold_times = 2
   -- result.hands_count = 0
   -- result.task_complete = true
   -- result.struct_hand_cards = {}
   -- result.chair_id = {1, 2, 0, 3}
   -- result.tax_fee = 0
   -- for i=1, 3 do  
   --     table.insert(result.struct_hand_cards, i)
   -- end
   -- self.game_layer.struct_base_cards = {1, 2, 3}
   -- self.game_layer.base_gold = 2000
   -- self.game_layer.struct_game_config = {}
   -- self.game_layer.struct_game_config.finish_time = 20
   -- for i=1, GAME_PLAYER do
   --     self:set_finish_data()
   -- end
   -- self:show_finish_layer(result)
end

function finish_layer:destory()
    self.player_clock:hide()
end

return finish_layer
