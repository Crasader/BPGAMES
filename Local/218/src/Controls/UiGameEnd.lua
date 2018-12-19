local UiGameEnd=class("UIGameEnd",function() return ccui.Layout:create() end);

local UiTimeClock = require "src/Controls/UiTimeClock"
local UIHelper = require "src/UIHelper"
local m_game_main = nil
function UiGameEnd:ctor()
    self._map_user_head = {}
    self._game_grade_table = nil    --好友房分数记录
    self._left_time = nil
    self.ptr_time_clock = nil
    self:init()
end

function UiGameEnd:setGameMain(gameMain)
    m_game_main = gameMain;
end

function UiGameEnd:init()
    self:initBackGround()
    self:initTimeClock()
    self:initButton()
    self:initUserInfo()
end

function UiGameEnd:initBackGround(is_win)
    local end_type = "win"
    if not is_win then
        end_type = "lose"
    end

    --背景黑底
    self._bg_img = control_tools.newImg({path=BPRESOURCE("res/game_end/bg_black.png"), size = view_size})
    self:addChild(self._bg_img)
    self._bg_img:setTouchEnabled(true)

    --胜利光效
    self._img_guang_xiao = control_tools.newImg({path=BPRESOURCE("res/game_end/guangxiao.png")})
    self:addChild(self._img_guang_xiao)
    self._img_guang_xiao:setPosition(cc.p(0,view_size.height*0.5 - 140*AUTO_HEIGHT))
    self._img_guang_xiao:setVisible(false)
    self._img_guang_xiao:setScale(0.9)

     --底框
    self._bg_form = control_tools.newImg({path=BPRESOURCE("res/game_end/")..end_type.."_bg.png"})
    self:addChild(self._bg_form)

    --信息
    self._img_mutil = control_tools.newImg({path=BPRESOURCE("res/game_end/")..end_type.."_bomb.png"})
    self._img_mutil:setPosition(cc.p(-240,-100))
    self:addChild(self._img_mutil)
    self._mutil_label = control_tools.newLabel({fnt=BPRESOURCE("res/text_font/number_shuangkou_jssz_")..end_type..".fnt"})
    self._mutil_label:setPosition(cc.p(90,10))
    self._img_mutil:addChild(self._mutil_label)

    self._img_gx = control_tools.newImg({path=BPRESOURCE("res/game_end/")..end_type.."_img_gx.png"})
    self._img_gx:setPosition(cc.p(-240,-140))
    self:addChild(self._img_gx)
    self._gx_label = control_tools.newLabel({fnt=BPRESOURCE("res/text_font/number_shuangkou_jssz_")..end_type..".fnt"})
    self._gx_label:setPosition(cc.p(90,10))
    self._img_gx:addChild(self._gx_label)

    self._line = control_tools.newImg({path=BPRESOURCE("res/game_end/")..end_type.."_line.png"})
    self._line:setPosition(cc.p(170,10))
    self:addChild(self._line)

    self._self_guangxiao = control_tools.newImg({path=BPRESOURCE("res/game_end/")..end_type.."_bg_head.png"})
    self._self_guangxiao:setPosition(cc.p(-150,50))
    self:addChild(self._self_guangxiao)

    --结算界面标题动画
    self._end_ani_1 = ccs.Armature:create("shuangkou_donghua_jiesuan")
    self._end_ani_1:setPosition(cc.p(0,view_size.height*0.5 - 160*AUTO_HEIGHT))
    self._end_ani_1:setVisible(false)
    self:addChild(self._end_ani_1)
    self._end_ani_1:setLocalZOrder(11)
    self._end_ani_2 = ccs.Armature:create("shuangkou_donghua_jiesuan")
    self._end_ani_2:setPosition(cc.p(0,view_size.height*0.5 - 160*AUTO_HEIGHT))
    self._end_ani_2:setVisible(false)
    self:addChild(self._end_ani_2)
    self._end_ani_1:setLocalZOrder(12)

    --结束类型动画
    self._end_type_ani = ccs.Armature:create("shuangkou_donghua_jiesuan")
    self._end_type_ani:setPosition(cc.p(-100,-120))
    self:addChild(self._end_type_ani)
    self._end_type_ani:setVisible(false)

    --单扣平扣
    self._img_end_type = control_tools.newImg({path=BPRESOURCE("res/game_end/")..end_type.."_pk.png"})
    self._img_end_type:setPosition(cc.p(-100,-120))
    self:addChild(self._img_end_type)
    self._img_end_type:setVisible(false)

    self._lable_over_trust_70_percent = control_tools.newLabel({color=cc.c3b(255,255,255)})
    self._lable_over_trust_70_percent:setPosition(ccp(0,-view_size.height/2))
    self._lable_over_trust_70_percent:setAnchorPoint(cc.p(0.5,0))
    self:addChild(self._lable_over_trust_70_percent)
    self._lable_over_trust_70_percent:setSystemFontSize(22)
    self._lable_over_trust_70_percent:setString("联盟托管时间超限，其扣除的惩罚金币由您获得。")
    self._lable_over_trust_70_percent:setVisible(false)

end

--初始化倒计时
function UiGameEnd:initTimeClock()
    self.ptr_time_clock = UiTimeClock:create()
    self.ptr_time_clock:setPosition(cc.p(0,-view_size.height/2+110*AUTO_HEIGHT))
    self:addChild(self.ptr_time_clock)

--    local room_data=game_tools.decode(get_room_data())
--    if bit_tools._and(room_data.room_kind, GameRoomType.ROOM_KIND_LINEUP) > 0 then
--        self.ptr_time_clock:setPositionX(-170*AUTO_WIDTH)
--    else
--        self.ptr_time_clock:setPositionX(0)
--    end
end

--初始化按钮
function UiGameEnd:initButton()
    self._btn_ready = control_tools.newBtn({normal = BPRESOURCE("res/table_btn/ready.png")})
    self._btn_ready:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_ready(param_sender,param_touchType) end)
    self._btn_ready:setPosition(cc.p(170*AUTO_WIDTH,-view_size.height/2+110*AUTO_HEIGHT))
    self:addChild(self._btn_ready)

    self._btn_change = control_tools.newBtn({normal = BPRESOURCE("res/table_btn/change_table.png")})
    self._btn_change:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_changetable(param_sender,param_touchType) end)
    self._btn_change:setPosition(cc.p(-170*AUTO_WIDTH,-view_size.height/2+110*AUTO_HEIGHT))
    self:addChild(self._btn_change)

    self._btn_back = control_tools.newBtn({normal = BPRESOURCE("res/game_end/btn_back.png")})
    self._btn_back:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_end_back(param_sender,param_touchType) end)
    self._btn_back:setPosition(cc.p(view_size.width/2-40, view_size.height/2-40))
    self:addChild(self._btn_back)
end

--初始化头像
function UiGameEnd:initUserInfo(is_win)
    local end_type = "win"
    if not is_win then
        end_type = "lose"
    end
    local head_pos = {
        cc.p(60,-40),    --对手玩家1
        cc.p(-150,50),   --自己
        cc.p(60,-110),   --对手玩家2
        cc.p(60,60)      --对家
    }
    for i=1,GamePlayer do
        self._map_user_head[i] = control_tools.newImg({})
        self._map_user_head[i]:setPosition(head_pos[i])
        self:addChild(self._map_user_head[i])

        --头像
        self._map_user_head[i]._head_img=control_tools.newImg({path=BPRESOURCE("gameres/head_id_1.png")})
        self._map_user_head[i]:addChild(self._map_user_head[i]._head_img)

        --头像框
        self._map_user_head[i]._border = control_tools.newImg({path=BPRESOURCE("res/head/border.png")})
        self._map_user_head[i]:addChild(self._map_user_head[i]._border)

        --上限、破产图标
        self._map_user_head[i]._sign = control_tools.newImg({path=BPRESOURCE("res/game_end/img_limit.png")})
        self._map_user_head[i]._sign:setPosition(cc.p(180,-10))
        self._map_user_head[i]._sign._index = i
        self._map_user_head[i]._sign:addTouchEventListener(function(param_sender,param_touchType) self:imgTouchEvent(param_sender,param_touchType) end)
        self._map_user_head[i]._sign:setTouchEnabled(true)
        self._map_user_head[i]:addChild(self._map_user_head[i]._sign)

        --提示框
        self._map_user_head[i]._bg_tip = control_tools.newImg({path=BPRESOURCE("res/game_end/bg_tip_right.png")})
        self._map_user_head[i]._bg_tip:setPosition(head_pos[i])
        self:addChild(self._map_user_head[i]._bg_tip)
        self._map_user_head[i]._bg_tip:setVisible(false)
        self._map_user_head[i]._bg_tip:setLocalZOrder(100)
        --提示内容
        self._map_user_head[i]._img_tip = control_tools.newImg({path=BPRESOURCE("res/game_end/tip2.png")})
        self._map_user_head[i]._img_tip:setPosition(cc.p(153,33))
        self._map_user_head[i]._bg_tip:addChild(self._map_user_head[i]._img_tip)

        self._map_user_head[i]._name_label = control_tools.newLabel({font=24})
        self._map_user_head[i]._name_label:setPosition(cc.p(45, 10))
        self._map_user_head[i]:addChild(self._map_user_head[i]._name_label)
        self._map_user_head[i]._name_label:setLocalZOrder(2)
        self._map_user_head[i]._name_label:setAnchorPoint(cc.p(0,0.5))
        self._map_user_head[i]._name_label:setString("这是一个名字")

        self._map_user_head[i]._img_gold = control_tools.newImg({path=BPRESOURCE("res/head/gold.png")})
        self._map_user_head[i]._img_gold:setPosition(cc.p(55, -20))
        self._map_user_head[i]._img_gold:setScale(0.6)
        self._map_user_head[i]:addChild(self._map_user_head[i]._img_gold)
        self._map_user_head[i]._img_gold:setLocalZOrder(2)

        self._map_user_head[i]._gold_label = control_tools.newLabel({font=24, color=cc.c3b(255,252,166)})
        self._map_user_head[i]._gold_label:setPosition(cc.p(70, -20))
        self._map_user_head[i]:addChild(self._map_user_head[i]._gold_label)
        self._map_user_head[i]._gold_label:setLocalZOrder(2)
        self._map_user_head[i]._gold_label:setAnchorPoint(cc.p(0,0.5))
        self._map_user_head[i]._gold_label:setString("99.99万")

        if i == UserIndex.down then
            --self._map_user_head[i]:loadTexture(BPRESOURCE("res/game_end/")..end_type.."_bg_head.png")
            self._map_user_head[i]._sign:setPosition(cc.p(80,20))
            self._map_user_head[i]._bg_tip:loadTexture(BPRESOURCE("res/game_end/bg_tip_left.png"))
            self._map_user_head[i]._bg_tip:setPosition(cc.p(head_pos[i].x+260,head_pos[i].y+20))

            self._map_user_head[i]._bg_name = control_tools.newImg({path=BPRESOURCE("res/game_end/")..end_type.."_bg_gold.png"})
            self._map_user_head[i]._bg_name:setPosition(cc.p(0, -75))
            self._map_user_head[i]:addChild(self._map_user_head[i]._bg_name)
            self._map_user_head[i]._bg_name:setLocalZOrder(1)

            self._map_user_head[i]._bg_gold = control_tools.newImg({path=BPRESOURCE("res/game_end/")..end_type.."_bg_gold.png"})
            self._map_user_head[i]._bg_gold:setPosition(cc.p(0, -110))
            self._map_user_head[i]:addChild(self._map_user_head[i]._bg_gold)
            self._map_user_head[i]._bg_gold:setLocalZOrder(1)

            self._map_user_head[i]._name_label:setPosition(cc.p(0, -75))
            self._map_user_head[i]._name_label:setAnchorPoint(cc.p(0.5,0.5))
            self._map_user_head[i]._img_gold:setPosition(cc.p(-45, -110))
            self._map_user_head[i]._gold_label:setPosition(cc.p(-20, -110))
        else
            
        end
    end
end

function UiGameEnd:setUserData(param_data)
    local is_win = false
    local end_type = 0 
    local self_chair_id = m_game_main:switch_to_chair_id(UserIndex.down)
    local self_seat_id = param_data.user_seat[self_chair_id+1]
    local is_self_trust_70_percent = false
    local is_opposite_trust_70_percent = false


    --todo cyn  玩家头像图片显示
    for i=1,GamePlayer do
        local chair_id = m_game_main:switch_to_chair_id(i)
        local seat_id = param_data.user_seat[chair_id+1]
        local user_data = m_game_main.ptr_game_frame:get_user_data_by_chair_id(chair_id)
        --local user_data=json.decode(m_game_main.ptr_game_frame:get_user_data_by_chair_id(chair_id))
        local view_id = -1
        if (self_seat_id - seat_id + 4)%4 == 0 then
            view_id = UserIndex.down
            --self._map_user_head[i]:set_head(user_data, view_id)
            end_type = end_type + param_data.rank[chair_id+1]
            is_self_trust_70_percent = param_data.trust_70percent[chair_id+1]
        elseif (self_seat_id - seat_id + 4)%4 == 1 then
            view_id = UserIndex.right
            --self._map_user_head[i]:set_head(user_data, view_id)
        elseif (self_seat_id - seat_id + 4)%4 == 2 then
            view_id = UserIndex.up
            --self._map_user_head[i]:set_head(user_data, view_id)
            end_type = end_type + param_data.rank[chair_id+1]
            is_opposite_trust_70_percent = param_data.trust_70percent[chair_id+1]
        elseif (self_seat_id - seat_id + 4)%4 == 3 then
            view_id = UserIndex.left
            --self._map_user_head[i]:set_head(user_data, view_id)
        end
        self._map_user_head[view_id]._name_label:setString(user_data.szName)
        --金币输赢
        local gold = param_data.gold[chair_id+1]
        local gold_text = gold
        local sign = "+"
        if gold < 0 then
            gold_text = -1 * gold
            sign = "-"
            self._map_user_head[view_id]._gold_label:setColor(cc.c3b(255,255,255))
        end
        gold_text = game_logic.getGoldText(gold_text)
        self._map_user_head[view_id]._gold_label:setString(sign..gold_text)
        --金币上限
        local is_show_sign = false
        if param_data.limit_info[chair_id+1] then
            is_show_sign = true
            self._map_user_head[view_id]._sign:loadTexture(BPRESOURCE("res/game_end/").."img_limit.png")
            self._map_user_head[view_id]._sign:setTouchEnabled(true)

            if view_id == UserIndex.down then
                self._map_user_head[view_id]._bg_tip:setVisible(true)
                local act1 = action_tools.CCDelayTime(3)
                local act2 = action_tools.CCCallFunc(function()
                    self._map_user_head[view_id]._bg_tip:setVisible(false)
                end)
                local seq = action_tools.CCSequence(act1, act2)
                self._map_user_head[view_id]:runAction(seq)
            end
        end
        --破产
        if param_data.bankruptcy_info[chair_id+1] then
            is_show_sign = true
            self._map_user_head[view_id]._sign:loadTexture(BPRESOURCE("res/game_end/").."img_bankruptcy.png")
            self._map_user_head[view_id]._sign:setTouchEnabled(false)
        end
        --积分场不显示图标 暂缓


        self._map_user_head[view_id]._sign:setVisible(is_show_sign)
    end
    if param_data.gold[self_chair_id+1] > 0 then
        is_win = true
    end

    if param_data.contribution[self_chair_id+1] >= 0 then
        self._gx_label:setString("+"..param_data.contribution[self_chair_id+1])
    else
        self._gx_label:setString(param_data.contribution[self_chair_id+1])
    end
    self._mutil_label:setString("x"..param_data.mutil)

    self:refreshEndType(end_type)
    --输赢界面显示不同
    self:refreshResources(is_win)

    --托管超限提示
    if not is_self_trust_70_percent and is_opposite_trust_70_percent then
        local punish_gold = game_logic.getGoldText(param_data.trust_punish_gold[self_chair_id+1])  
        self._lable_over_trust_70_percent:setString("联盟托管超限，其扣除的"..punish_gold.."惩罚金币由您获得")
        self._lable_over_trust_70_percent:setVisible(true)
    elseif is_self_trust_70_percent and not is_opposite_trust_70_percent then
        local punish_gold = game_logic.getGoldText(param_data.trust_punish_gold[self_chair_id+1])  
        if punish_gold < 0 then
            punish_gold = -1* punish_gold
        end
        self._lable_over_trust_70_percent:setString("托管超限，额外扣除"..punish_gold.."惩罚金币")
        self._lable_over_trust_70_percent:setVisible(true)
    else
        self._lable_over_trust_70_percent:setVisible(false)
    end
    --好友房记录 暂缓
end

function UiGameEnd:refreshResources(is_win)
    local end_type = "win"
    if not is_win then
        end_type = "lose"
        self._end_ani_1:getAnimation():play("shuangkou_shibai_1",-1,0)
        self._end_ani_1:setPosition(cc.p(0,view_size.height*0.5 - 190*AUTO_HEIGHT))
        self._end_ani_1:setVisible(true)
        self._end_ani_2:getAnimation():play("shuangkou_shibai_2",-1,0)
        self._end_ani_2:setPosition(cc.p(20,view_size.height*0.5 - 210*AUTO_HEIGHT))
        self._end_ani_2:setVisible(true)
        self._img_guang_xiao:setVisible(false)
    else
        self._end_ani_1:getAnimation():play("shuangkou_shengli_1",-1,0)
        self._end_ani_1:setPosition(ccp(0,view_size.height*0.5 - 180*AUTO_HEIGHT))
        self._end_ani_1:setVisible(true)
        self._end_ani_2:getAnimation():play("shuangkou_shengli_2",-1,-1)
        self._end_ani_2:setPosition(ccp(0,view_size.height*0.5 - 190*AUTO_HEIGHT))
        self._end_ani_2:setVisible(true)
        self._img_guang_xiao:setVisible(true)
        self._img_guang_xiao:runAction(action_tools.CCRepeatForever(action_tools.CCRotateBy(5, 360)))
    end
    --audio_engine.game_effect(end_type)
    self._bg_form:loadTexture(BPRESOURCE("res/game_end/")..end_type.."_bg.png")
    self._img_mutil:loadTexture(BPRESOURCE("res/game_end/")..end_type.."_bomb.png")
    self._img_gx :loadTexture(BPRESOURCE("res/game_end/")..end_type.."_img_gx.png")
    self._line:loadTexture(BPRESOURCE("res/game_end/")..end_type.."_line.png")
    self._self_guangxiao:loadTexture(BPRESOURCE("res/game_end/")..end_type.."_bg_head.png") 
    self._map_user_head[UserIndex.down]._bg_name:loadTexture(BPRESOURCE("res/game_end/")..end_type.."_bg_gold.png")
    self._map_user_head[UserIndex.down]._bg_gold:loadTexture(BPRESOURCE("res/game_end/")..end_type.."_bg_gold.png")

end

function UiGameEnd:refreshEndType(end_type)
    if end_type == 3 then
        self._end_type_ani:getAnimation():play("shuangkou_sk_1",-1,0)
        self._end_type_ani:setVisible(true)
        self._img_end_type:setVisible(false)
    elseif end_type == 0 then
        self._end_type_ani:getAnimation():play("shuangkou_sk_2",-1,0)
        self._end_type_ani:setVisible(true)
        self._img_end_type:setVisible(false)
    elseif end_type == 4 then
        self._img_end_type:loadTexture(BPRESOURCE("res/game_end/").."win_dk.png")
        self._img_end_type:setVisible(true)
        self._end_type_ani:setVisible(false)
    elseif end_type == 2 then
        self._img_end_type:loadTexture(BPRESOURCE("res/game_end/").."lose_dk.png")
        self._img_end_type:setVisible(true)
        self._end_type_ani:setVisible(false)
    elseif end_type == 1 then
        self._img_end_type:loadTexture(BPRESOURCE("res/game_end/").."win_pk.png")
        self._img_end_type:setVisible(true)
        self._end_type_ani:setVisible(false)
    elseif end_type == 5 then
        self._img_end_type:loadTexture(BPRESOURCE("res/game_end/").."lose_pk.png")
        self._img_end_type:setVisible(true)
        self._end_type_ani:setVisible(false)
    end
end

function UiGameEnd:setLeftTime(text)
    self._left_time = text
    self.ptr_time_clock:setTime(text, true)
end

function UiGameEnd:destroy()
    self.ptr_time_clock:destroy()
    if m_game_main._time_schedule then
        CCDirector:getInstance():getScheduler():unscheduleScriptEntry(m_game_main._time_schedule)
        m_game_main._time_schedule = nil
    end
end

return UiGameEnd