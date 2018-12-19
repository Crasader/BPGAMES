require "src/game_define"
require "src/game_logic"
local UIGrade = require("bpsrc/ui_grade")

--------------------------------------------------------------------------------
-- 单款主界面
--------------------------------------------------------------------------------
local game_layer = class("game_layer", function() return ccui.Layout:create() end)

--------------------------------------------------------------------------------
-- 常量
--------------------------------------------------------------------------------
local ZOrder = {back_ground = 1, logo = 2, card_layer = 3, hint_info = 4, mark_layer = 5, 
                trust_layer = 6, button = 7, clock = 8, task_layer = 9, top_bar = 10, 
                game_user = 11, chat_play = 12, menu = 13,finish_layer = 14, notice_info = 15, gift_play = 16, 
                help_layer = 17}

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
function game_layer:ctor(visibleSize)
    print("DY Log>>game_layer:ctor")
    self.m_game_main = nil
    AUTO_WIDTH = visibleSize.width / 960
    AUTO_HEIGHT = visibleSize.height / 640
    AUTO_SCALE = 1
    self.is_unkown_headimg = {}
    self:init(visibleSize)
end

function game_layer:init(visibleSize)
    print("DY Log>>game_layer:init", visibleSize.width, visibleSize.height)
    -- 初始化场景
    self:setContentSize(visibleSize)
    -- 初始化背景
    self:init_back_ground(visibleSize)
    -- 初始化任务界面
    self:init_task_layer(visibleSize)
    -- 初始化卡牌界面
    self:init_card_layer(visibleSize)
    -- 初始化提示信息
    self:init_hint_info(visibleSize)
    -- 初始化桌面按钮
    self:init_table_button(visibleSize)
    -- 初始化记牌器界面
    self:init_mark_layer(visibleSize)
    -- 初始化托管界面
    self:init_trust_layer(visibleSize)
    -- 初始化聊天和记牌器按钮
    self:init_chat_mark_button(visibleSize)
    -- 初始化计时器
    self:init_game_clock(visibleSize)
    -- 初始化玩家头像
    self:init_game_user_layer(visibleSize)
    -- 初始化顶部菜单
    self:init_top_bar(visibleSize)
    -- 初始化结束界面
    self:init_finish_layer(visibleSize)
    -- 初始化炸弹倍数
    self:init_bomb_times(visibleSize)
    -- 初始化礼物发送
    self:init_gift_play_layer(visibleSize)
    -- 初始化聊天界面
    self:init_chat_layer(visibleSize)
    -- 初始化帮助界面
    self:init_help_layer(visibleSize)
    -- 菜单
    self:init_menu_info(visibleSize)
    -- 初始化手机信息
    self:init_phone_info(visibleSize)
   
    self:on_start()

    -- self:load_config()

    --  DY  TEST
    self:DY_test()
end

function game_layer:set_game_main(game_main)
	self.m_game_main = game_main
end

function game_layer:DY_test()
	-- self.test_layer = require("bpsrc/ui_gameuserinfo").Instance()
	-- self:addChild(test_layer, 10000)
end

function game_layer:on_start()
    function call_back()
        -- 播放背景音乐
        AudioEngine.playMusic(MUSIC_PATH.normal[1], true)
        -- if show_friend_system then 
        --     show_friend_system()
        -- end
    end
    self:runAction(action_tools.CCSequence(action_tools.CCDelayTime(0.1), action_tools.CCCallFunc(call_back)))
end
-- 初始化背景
function game_layer:init_back_ground( visibleSize )
	print("-----------------------init_back_ground--------------------------")
	print("visibleSize = ", visibleSize.width, visibleSize.height, AUTO_WIDTH, AUTO_HEIGHT)
	-- 背景
    local back_ground = control_tools.newImg({path = g_path .. "game_back.jpg"})
    self:addChild(back_ground)
    back_ground:setPosition(cc.p(visibleSize.width/2, visibleSize.height/2))
    back_ground:setScaleX(visibleSize.width/back_ground:getContentSize().width)
    back_ground:setScaleY(visibleSize.height/back_ground:getContentSize().height)

    -- 桌子
    local back_table = control_tools.newImg({path = g_path .. "table.png"})
    self:addChild(back_table)
    back_table:setPosition(cc.p(visibleSize.width/2, 0))
    back_table:setAnchorPoint(cc.p(0.5, 0))
    back_table:setScaleX(visibleSize.width/back_table:getContentSize().width)
    
    -- logo
    local logo = control_tools.newImg({ctype = 1, path = "logo.png"})
    self:addChild(logo)
    logo:setPosition(cc.p(visibleSize.width/2, visibleSize.height/2 + 20))
	
	-- 房间号
    game_layer.label_table_code = control_tools.newLabel({fnt = g_path .. "text_font/number_doudizhu_fangfanghejushu.fnt"--[[, str = "房间号:510510"--]]})
    self:addChild(game_layer.label_table_code)
    game_layer.label_table_code:setAnchorPoint(cc.p(1,0.5))
    game_layer.label_table_code:setPosition(cc.p(visibleSize.width/2 + 5, visibleSize.height/2-40))
	
	-- 剩余局数
    game_layer.label_left_times = control_tools.newLabel({fnt = g_path .. "text_font/number_doudizhu_fangfanghejushu.fnt"--[[, str = "局数:1/5"--]]})
    self:addChild(game_layer.label_left_times)
    game_layer.label_left_times:setAnchorPoint(cc.p(0,0.5))
    game_layer.label_left_times:setPosition(cc.p(visibleSize.width/2 + 55, visibleSize.height/2 - 40))	
	
--[[	local delay = action_tools.CCDelayTime(0.1)
    local callfunc = action_tools.CCCallFunc(function()
		local tbl_json = bind_function.get_room_data()
		if tbl_json ~= nil then
        if bit_tools._and(tbl_json._int_room_mode, GF.ROOM_MODE_REDPACKET) ~= 0 then
            if set_game_redpacket_info then
                set_game_redpacket_info( 95, 300, 1000, 1)
            end
        end
    end
		
	end )
    local action = action_tools.CCRepeatForever(action_tools.CCSequence(delay, callfunc))
    self:runAction(action)--]]


    -- print("------------------富文本测试-----------start")
    -- local UIRichTextEx = require("src/g_tools/ui_richtext")
    -- local text_rich = UIRichTextEx:create(26, cc.c3b(0, 255, 0), "Arial", cc.size(760, 0), cc.p(0, 1))
    -- text_rich:setTextEx("恭喜玩家<color value=0xff1de800>test255")
    -- text_rich:setTextEx("<color value=0xfffe9f27>恭喜玩家<color value=0xff1de800>test255<color value=0xfffe9f27>在经典拼十游戏拿到<color value=0xffff0000>五小牛<color value=0xfffe9f27>牌型，获得<color value=0xffff0000>10000<color value=0xfffe9f27>奖池彩金！")
    -- text_rich:setTextEx("恭喜玩家test255在经典拼十游戏拿到五小牛牌型，获得10000奖池彩金！")
    -- text_rich:setTextEx("恭喜玩家test255")
    -- text_rich:setTextEx("<color value=0xfffe9f27>恭喜玩家<color value=0xff1de800>test255")
    -- text_rich:setTextEx2("恭喜玩家<color value=0xff1de800>test255<img=http://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png>")
    -- text_rich:setTextEx2("恭喜玩家<color value=0xff1de800>test255<img=" .. g_path .. "test_green.png>")
    -- text_rich:setTextEx2("<img=http://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png>")
    -- text_rich:setTextEx2("恭喜玩家test255<img=http://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png>")
    -- text_rich:setTextEx2("恭喜玩家test255<img=" .. g_path .. "test_green.png" .. ">")
    -- text_rich:setTextEx2("<color value=0xfffe9f27>恭喜玩家<color value=0xff1de800>test255<img=" .. g_path .. "test_green.png" .. "><color value=0xfffe9f27>在经典拼十游戏拿到<color value=0xffff0000>五小牛<color value=0xfffe9f27>牌型，获得<color value=0xffff0000>10000<color value=0xfffe9f27>奖池彩金！<img=http://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png>")
    -- text_rich:setHorizontalAlignment(1)
    -- text_rich:setPosition(cc.p(100, visibleSize.height/2+100))
    -- self:addChild(text_rich)
    -- print("------------------富文本测试-----------end")
end

function game_layer:init_task_layer( visibleSize )
    self.task_background = control_tools.newImg({ctype = 1, path = "bg_renwu.png"})
    self:addChild(self.task_background, ZOrder.task_layer)
    self.task_background:setPosition(cc.p(visibleSize.width/2, visibleSize.height - 95))

    self.task_layer = control_tools.newLabel({font = 26})
    self.task_background:addChild(self.task_layer)
    self.task_layer:setPosition(cc.p(self.task_background:getContentSize().width/2, self.task_background:getContentSize().height/2))

    self.task_layer.finish_logo = control_tools.newImg({ctype = 1, path = "finish_img.png"})
    self.task_layer:addChild(self.task_layer.finish_logo)
    self.task_layer.finish_logo:setPosition(-self.task_layer.finish_logo:getContentSize().width/2, 15)
    self.task_layer.finish_logo:setVisible(false)

    self.task_background:setVisible(false)
end

function game_layer:init_card_layer( visibleSize )
    self.card_layer = require("src/card_layer"):create(visibleSize)
    self:addChild(self.card_layer, ZOrder.card_layer)
	self.card_layer:set_game_layer(self)
end

function game_layer:init_trust_layer( visibleSize )
    self.trust_layer = require("src/trust_layer"):create(visibleSize)
    self:addChild(self.trust_layer, ZOrder.trust_layer)
    self.trust_layer:set_game_layer(self)
end

function game_layer:init_hint_info( visibleSize )
    self.hint_info = control_tools.newImg({ctype = 1, path = "hint_info.png"})
    self:addChild(self.hint_info, ZOrder.hint_info)
    self.hint_info:setPosition(cc.p(visibleSize.width/2, math.floor(visibleSize.height/6-13)))
    self.hint_info:setVisible(false)
end

function game_layer:init_table_button( visibleSize )
    -- 战绩
    self.btn_show_grade1 = self:create_btn({normal = "btn_show_grade_1.png", ctype = 1, tag = ButtonEventType.grade}) 
    self:addChild(self.btn_show_grade1, ZOrder.button)
    self.btn_show_grade1:setPosition(cc.p(self.btn_show_grade1:getContentSize().width/2,visibleSize.height*0.5-75))
    self.btn_show_grade1:setVisible(false)

    -- 邀请
    self.btn_invite = self:create_btn({normal = "btn_invite.png", ctype = 1, tag = ButtonEventType.invite})
    self:addChild(self.btn_invite, ZOrder.button)
    self.btn_invite:setPosition(cc.p(visibleSize.width/2 - 180, visibleSize.height*2/5 + self.btn_invite:getContentSize().height/2-92))

    -- 换桌按钮
    self.btn_change = self:create_btn({normal = "btn_changetable.png", pressed = "btn_changetable_1.png", ctype = 1, tag = ButtonEventType.change})
    self:addChild(self.btn_change, ZOrder.button)
    self.btn_change:setPosition(cc.p(visibleSize.width/2 - 180, visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-92))

    -- 换桌上的倒计时数字
    self.btn_change._num = control_tools.newLabel({fnt = g_path .. "/text_font/number_doudizhu_daojishi.fnt", str = "3"})
    self.btn_change:addChild(self.btn_change._num)
    self.btn_change._num:setPosition(cc.p(self.btn_change:getContentSize().width*5/6, self.btn_change:getContentSize().height*3/4))
    self.btn_change._num:setVisible(false)
    -- 准备
    self.btn_ready = self:create_btn({normal = "btn_ready.png", pressed = "btn_ready1.png", ctype = 1, tag = ButtonEventType.ready}) 
    self:addChild(self.btn_ready, ZOrder.button)
    self.btn_ready:setPosition(cc.p(visibleSize.width/2 + 180, visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-92))

    -- 战绩
    self.btn_show_grade2 = self:create_btn({normal = "btn_show_grade_2.png", ctype = 1, tag = ButtonEventType.grade})
    self:addChild(self.btn_show_grade2, ZOrder.button)
    self.btn_show_grade2:setPosition(cc.p(visibleSize.width*0.5,visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-92))
    self.btn_show_grade2:setVisible(false)

    -- 叫地主
    self.btn_landlord = self:create_btn({normal = "btn_landlord.png", ctype = 1, tag = ButtonEventType.landlord})
    self:addChild(self.btn_landlord, ZOrder.button)
    self.btn_landlord:setPosition(cc.p(visibleSize.width/2 + 145, visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-12))

    -- 不叫
    self.btn_no_landlord = self:create_btn({normal = "btn_no_landlord.png", ctype = 1, tag = ButtonEventType.no_landlord})
    self:addChild(self.btn_no_landlord, ZOrder.button)
    self.btn_no_landlord:setPosition(cc.p(visibleSize.width/2 - 145, visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-12))

    -- 抢地主
    self.btn_rob = self:create_btn({normal = "btn_rob.png", ctype = 1, tag = ButtonEventType.rob})
    self:addChild(self.btn_rob, ZOrder.button)
    self.btn_rob:setPosition(cc.p(visibleSize.width/2 + 145, visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-12))

    -- 不抢
    self.btn_no_rob = self:create_btn({normal = "btn_no_rob.png", ctype = 1, tag = ButtonEventType.no_rob})
    self:addChild(self.btn_no_rob, ZOrder.button)
    self.btn_no_rob:setPosition(cc.p(visibleSize.width/2 - 145, visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-12))

    -- 出牌
    self.btn_outcards = self:create_btn({normal = "btn_outcards.png",  pressed = "btn_outcards1.png", ctype = 1, tag = ButtonEventType.outcards})
    self:addChild(self.btn_outcards, ZOrder.button)
    self.btn_outcards:setPosition(cc.p(visibleSize.width*2/3+50, visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-12))

    -- 不出
    self.btn_pass = self:create_btn({normal = "btn_pass.png", ctype = 1, tag = ButtonEventType.pass})
    self:addChild(self.btn_pass, ZOrder.button)
    self.btn_pass:setPosition(cc.p(visibleSize.width/2, visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-12))

    -- 提示
    self.btn_hint = self:create_btn({normal = "btn_hint.png", ctype = 1, tag = ButtonEventType.hint})
    self:addChild(self.btn_hint, ZOrder.button)
    self.btn_hint:setPosition(cc.p(visibleSize.width/3-50, visibleSize.height*2/5 + self.btn_change:getContentSize().height/2-12))

    -- 显示结算界面
    self.btn_show_finish = self:create_btn({normal = "btn_show_grade.png", ctype = 1, tag = ButtonEventType.show_finish})
    self:addChild(self.btn_show_finish, ZOrder.button)
    self.btn_show_finish:setPosition(cc.p(visibleSize.width - self.btn_show_finish:getContentSize().width/2 - 10*AUTO_HEIGHT,  self.btn_show_finish:getContentSize().height/2 + 80))
    self.btn_show_finish:setVisible(false)

    self:on_event_button_power(0, 0)
end

function game_layer:init_game_clock( visibleSize )
    self.player_clock = require("src/ui_tools/ui_clock"):create({path = "clock_bg.png", ctype = 1, scale = AUTO_SCALE, fnt = g_path .. "text_font/number_doudizhu_chupaidaojishi.fnt"})
    self:addChild(self.player_clock, ZOrder.clock)
    self.player_clock:setPosition(cc.p(visibleSize.width/2, visibleSize.height/2))
    self.player_clock:hide()
end

function game_layer:init_menu_info( visibleSize )
    self.bg_menu = control_tools.newImg({path = g_path .. "menu/bg_menu.png", anchor = cc.p(1, 0.5)})
    self:addChild(self.bg_menu, ZOrder.chat_play)
    self.bg_menu:setPosition(cc.p(visibleSize.width, visibleSize.height/2))
    self.bg_menu:addTouchEventListener(function(sender, eventType)
        if eventType ~= _G.TOUCH_EVENT_ENDED then
            return 
        end
        if self.bg_menu and self.bg_menu:isVisible() then 
            self.game_menu:open_menu(false)         
        end
    end)
    self.bg_menu:setVisible(false)
	
	self.game_menu = require("src/game_menu"):create(visibleSize)
	self:addChild(self.game_menu, ZOrder.menu)
	self.game_menu:setPosition(cc.p(visibleSize.width - 55, visibleSize.height - 51.6*AUTO_WIDTH - 27.4))
	self.game_menu:set_game_layer(self)
end

function game_layer:init_mark_layer( visibleSize )
    local mark_back = control_tools.newLayout({clip = true, size = cc.size(visibleSize.width, 100)})
    self:addChild(mark_back, ZOrder.mark_layer)
    mark_back:setTouchEnabled(false)
    mark_back:setPosition(cc.p(0, 50))

    self.mark_layer = control_tools.newImg({path = "mark.png", anchor = cc.p(0.5, 0), ctype = 1})
    mark_back:addChild(self.mark_layer)
    self.mark_layer:setPosition(cc.p(visibleSize.width/2, -101))

    self.mark_word = {}
    for i=1, 15 do
        self.mark_word[18-i] = control_tools.newLabel({fnt = g_path .. "/text_font/number_doudizhu_jipaiqi.fnt", str = "0"})
        self.mark_layer:addChild(self.mark_word[18-i])
        if i < 3 then
            self.mark_word[18-i]:setPosition(cc.p((i-1)*65 + 146, 20))
        else
            self.mark_word[18-i]:setPosition(cc.p((i-1)*30.65 + 193.8, 20))
        end
    end
end

function game_layer:init_game_user_layer( visibleSize )
    self.game_user = require("src/game_user"):create(visibleSize)
    self.game_user:setPosition(cc.p(0, 0))
    self:addChild(self.game_user, ZOrder.game_user)
    self.game_user:set_game_layer(self)
end

function game_layer:init_top_bar( visibleSize )
    self.top_bar = require("src/top_bar"):create(visibleSize)
    self:addChild(self.top_bar)
    self.top_bar:set_game_layer(self)
end

function game_layer:init_bomb_times( visibleSize )
    self.times_img = control_tools.newLabel({fnt = g_path .. "text_font/number_ddz_qiangdizhubeishu.fnt", str = "x2"})
    self:addChild(self.times_img, ZOrder.chat_play)
    self.times_img:setPosition(cc.p(visibleSize.width/2, visibleSize.height*3/5))
    self.times_img:setVisible(false)
end

function game_layer:init_help_layer( visibleSize )
    self.help_layer = require("src/help_layer"):create(visibleSize)
    self:addChild(self.help_layer, ZOrder.help_layer)
end

function game_layer:init_chat_layer( visibleSize )
    local string_chat = {"快点吧，我等的花儿都谢了", 
                    "你的牌打得太好了！", 
                    "你好，很高兴认识你！", 
                    "你是MM，还是GG？", 
                    "再见了，下次再玩吧！", 
                    "怎么这么多炸弹，我都被炸晕了", 
                    "哎，一手的烂牌臭到底", 
                    "又断线了，网络怎么这么差呀！"}

    self.chat_layer = require("bpsrc/ui_chatsend").Instance()
    self.chat_layer:init_common_chat(string_chat)
end

function game_layer:init_finish_layer( visibleSize )
    self.finish_layer = require("src/finish_layer"):create(visibleSize)
    self:addChild(self.finish_layer, ZOrder.finish_layer)
    self.finish_layer:set_game_layer(self)
end

function game_layer:init_gift_play_layer( visibleSize )
    self.gift_play = require("bpsrc/ui_giftplay"):create(visibleSize)
    self:addChild(self.gift_play, ZOrder.gift_play)
end

function game_layer:init_chat_mark_button( visibleSize )
	local btn_chat = self:create_btn({normal = "btn_chat.png", ctype = 1, tag = ButtonEventType.chat})
    self:addChild(btn_chat, ZOrder.button)
    btn_chat:setPosition(cc.p(visibleSize.width - btn_chat:getContentSize().width/2 - 10*AUTO_HEIGHT, btn_chat:getContentSize().height/2 + 1))
        
    local btn_mark = self:create_btn({normal = "btn_mark.png", ctype = 1, tag = ButtonEventType.mark})
    self:addChild(btn_mark, ZOrder.button)
    btn_mark:setPosition(cc.p(btn_chat:getPositionX() - btn_chat:getContentSize().width - 10, btn_mark:getContentSize().height/2 + 1))
end

function game_layer:init_phone_info( visibleSize )
    self._phone_info=require("src/ui_tools/ui_phone_info"):create(visibleSize)
    self:addChild(self._phone_info)
    self._phone_info:setPosition(cc.p(100, visibleSize.height - 35))
    self._phone_info:setScale(AUTO_SCALE)
    self._phone_info:showPhoneInfo()
end

function game_layer:create_pipei_armature()
    if self.armature == nil then
        -- 匹配动画
        self.armature = ccs.Armature:create("ddz_pipei")
        self:addChild(self.armature)
        self.armature:setPosition(cc.p(self:getContentSize().width/2, self:getContentSize().height/3))
    end 
    self.armature:getAnimation():play("Animation1", -1, -1)
end

function game_layer:remove_popei_armature()
    if self.armature == nil then
        return 
    end
    self.armature:removeFromParent()
    self.armature = nil
end

function game_layer:fresh_revive_btn()
    if self._btn_active_find then
        self._btn_active_find:setVisible(false)
        self._btn_active_find_mid:setVisible(true)
        self._active_revive_btn:setVisible(false)
    end
    self.finish_layer:freshReviveBtn()
end

function game_layer:destory()
    print("DY Log>>game_layer:destory")
    AudioEngine.stopMusic()
    AudioEngine.stopAllEffects()
    self:clear_ui()
    self:clear_data()
end

--------------------------------------------------------------------------------
-- 点击事件
--------------------------------------------------------------------------------
-- 聊天
function game_layer:on_btn_chat()
    self.chat_layer.ShowChatCenter()
end
-- 不抢
function game_layer:on_btn_no_rob()
	if self.btn_no_rob:isVisible() == false then
		return 
	end
	self.btn_rob:setVisible(false)
	self.btn_rob:setTouchEnabled(false)
	self.btn_no_rob:setVisible(false)
	self.btn_no_rob:setTouchEnabled(false)

	local tbl = {}
	tbl.chair_id = bind_function.switch_to_chair_id(LocalSelfChairId)
	local str_data = json.encode(tbl)
	bind_function.send_data(ProtocolType.no_rob, str_data)

	self.game_user:set_status(LocalSelfChairId, UserStatus.no_rob)

    self.player_clock:hide()
end
-- 抢地主
function game_layer:on_btn_rob()
	if self.btn_rob:isVisible() == false then
		return 
	end
	self.btn_rob:setVisible(false)
	self.btn_rob:setTouchEnabled(false)
	self.btn_no_rob:setVisible(false)
	self.btn_no_rob:setTouchEnabled(false)

	local tbl = {}
	tbl.chair_id = bind_function.switch_to_chair_id(LocalSelfChairId)
	local str_data = json.encode(tbl)
	bind_function.send_data(ProtocolType.rob, str_data)

	self.game_user:set_status(LocalSelfChairId, UserStatus.rob)
	self.sound_tag = self.sound_tag + 1
    
    self.player_clock:hide()
end
-- 不叫
function game_layer:on_btn_no_landlord()
	if self.btn_no_landlord:isVisible() == false then
		return 
	end
	self.btn_landlord:setVisible(false)
	self.btn_landlord:setTouchEnabled(false)
	self.btn_no_landlord:setVisible(false)
	self.btn_no_landlord:setTouchEnabled(false)

	local tbl = {}
	tbl.chair_id = bind_function.switch_to_chair_id(LocalSelfChairId)
	local str_data = json.encode(tbl)
	bind_function.send_data(ProtocolType.no_landlord, str_data)

	self.game_user:set_status(LocalSelfChairId, UserStatus.no_landlord)
    self.player_clock:hide()
end
-- 叫地主
function game_layer:on_btn_landlord()
	if self.btn_landlord:isVisible() == false then
		return 
	end
	self.btn_landlord:setVisible(false)
	self.btn_landlord:setTouchEnabled(false)
	self.btn_no_landlord:setVisible(false)
	self.btn_no_landlord:setTouchEnabled(false)

	local tbl = {}
	tbl.chair_id = bind_function.switch_to_chair_id(LocalSelfChairId)
	local str_data = json.encode(tbl)
	bind_function.send_data(ProtocolType.landlord, str_data)

	self.game_user:set_status(LocalSelfChairId, UserStatus.landlord)

	self.player_clock:hide()
end

function game_layer:on_btn_user_revive_card()
	local tbl = {}
	tbl.chair_id = bind_function.switch_to_chair_id(LocalSelfChairId)
	local str_data = json.encode(tbl)
    bind_function.send_data(ProtocolType.revive, str_data)
end

function game_layer:on_btn_changetable()
    if bind_function.get_game_status() ~= GameStatus.free then
        return
    end

	self:clear_ui()
	self:clear_data()

	--好友场的再来一局
	if ROOM_MODE == GF.ROOM_MODE_FRIEND then
		self:on_btn_ready()
		return
	end

	-- 金币检查
    if self:check_gold() == false then return end

    -- 红包场金豆检查
    if self:check_bean() == false then return end

	if self:bool_lineup() then 
		self:create_pipei_armature()
		self:on_event_button_power(0, 0)
		for i=1, GAME_PLAYER do
			if i-1 ~= LocalSelfChairId then
				self.game_user:show_left_info(i-1, true)
			end
		end
        if self._btn_active_find then
            self._btn_active_find:setVisible(false)
        end
        if self._btn_active_find_mid then
            self._btn_active_find_mid:setVisible(false)
        end
        if self._active_revive_btn then
            self._active_revive_btn:setVisible(false)
        end
    end

	bind_function.re_sit_down()
end

function game_layer:on_btn_continue()
	-- 排队场 如果有人离开房间后点击准备 则进入匹配队列
	if self:bool_lineup() then
		local is_all = true
		for i=1, GAME_PLAYER do
			if self.game_user.player_background[i]:isVisible() == false then
				is_all = false
				break
			end
		end
		if not is_all then
			self:on_btn_changetable()
			return
		end
	end
	-- 金币检查
	self:check_gold()

    -- 红包场金豆检查
    self:check_bean()

	self:on_event_button_power(bit_tools._or(ButtonPower.changetable, ButtonPower.start), ButtonPower.changetable)

	self:clear_data()
	self:clear_ui()

    -- 播放音效
    AudioEngine.playEffect(MUSIC_PATH.normal[4])

    bind_function.send_ready_data()  
end

function game_layer:on_btn_ready() 
    print("=================== 游戏状态：", bind_function.get_game_status())
	if bind_function.get_game_status() ~= GameStatus.free then
		return
	end

	-- 排队场 如果有人离开房间后点击准备 则进入匹配队列
    if self:bool_lineup() then
		local is_all = true
		for i=1, GAME_PLAYER do
			if self.game_user.player_background[i]:isVisible() == false then
				is_all = false
				break
			end
		end
		if not is_all then
			self:on_btn_changetable()
			return
		end
	end
	if ROOM_MODE == GF.ROOM_MODE_FRIEND then
		self:on_event_button_power(bit_tools._or(ButtonPower.invite, ButtonPower.start), ButtonPower.invite)
	end

	-- 金币检查
    if self:check_gold() == false then return end

    -- 红包场金豆检查
    if self:check_bean() == false then return end

	self:clear_data()
	self:clear_ui()

	self.btn_ready:setBright(false)
	self.btn_ready:setTouchEnabled(false)

    -- 播放音效
    AudioEngine.playEffect(MUSIC_PATH.normal[4])

    bind_function.send_ready_data()  

	if self:bool_lineup() == true and TABLE_ID < 150 then
		local time = 10
	    local function update(dt)
	        time = time - dt
	        if time <= 0 then
	            self:unscheduleUpdate()
	            self:on_btn_changetable()
	        end
	    end
		self:scheduleUpdateWithPriorityLua(update, 0)
	end
end

function game_layer:on_btn_invite()
	-- if share_private_wechat then
	-- 	share_private_wechat("我在斗地主房间"..game_layer.table_code..",等你来战！", tostring(game_layer.table_code))
	-- end
end

function game_layer:on_btn_show_grade()
	if self.finish_layer:isVisible()==true then
        self:clear_data()
        self:clear_ui()
        if self.used_times < self.count_times then
        	self:on_event_button_power(bit_tools._or(ButtonPower.invite, ButtonPower.start), bit_tools._or(ButtonPower.invite, ButtonPower.start))
        else
        	self.btn_show_grade2:setVisible(true)
    		self.btn_show_grade2:setTouchEnabled(true)
        end
	end

	local friend_info = {}
	friend_info.room_code = self.table_code
	friend_info.grade_list = {}
	for i=1, self.data_count do
		local tbl = {}
        tbl.name = self.name_list[i]
        tbl.grade = self.grade_list[i]
        table.insert(friend_info.grade_list, tbl)
	end
	
    UIGrade.ShowGradeLayer(friend_info)
end

function game_layer:on_btn_config()
    -- 显示好友房战绩结算
    -- UIGrade.ShowGradeLayer({})
    -- 停止计时器 恢复计时器
    -- if true then
    --     self.touch_time = self.touch_time or 0
    --     if self.touch_time == 0 then
    --         self.player_clock:pauseTime()
    --         self.touch_time = 1
    --     else 
    --         self.player_clock:resumeTime()
    --         self.touch_time = 0
    --     end
    --     return 
    -- end

    -- 开启小游戏
    -- bind_function.send_open_mini_game(1)
    -- local UIGuess = require("bpsrc/ui_guess")
    -- UIGuess.ShowGuessLayer({
    --     userid=bind_function.get_self_user_data().dwUserID,
    --     int_tax=1000,
    --     int_count=5,
    --     int_time=20,
    --     long_gold=100000
    -- })
    -- self.sound_id = self.sound_id or 1
    -- print("==========sound id = ", self.sound_id)
    -- if not (self.sound_id == 3 or self.sound_id == 5 or (self.sound_id >= 9 and self.sound_id <= 12) ) then
    --     AudioEngine.playEffect(MUSIC_PATH.boy[self.sound_id])
    --     self.sound_id = self.sound_id + 1
    --     if self.sound_id > 18 then
    --         self.sound_id = 1
    --     end
    -- else
    --     self.sound_id_2 = self.sound_id_2 or 1
    --     print("==========sound id 2 = ", self.sound_id_2)
    --     AudioEngine.playEffect(MUSIC_PATH.boy[self.sound_id][self.sound_id_2])
    --     self.sound_id_2 = self.sound_id_2 + 1
    --     if self.sound_id_2 > #MUSIC_PATH.girl[self.sound_id] then
    --         self.sound_id_2 = 1
    --         self.sound_id = self.sound_id + 1
    --         if self.sound_id > 18 then
    --             self.sound_id = 1
    --         end
    --     end
    -- end
	-- show_setting(true)
end

function game_layer:on_btn_return_ok()
	bind_function.close_game()
end

function game_layer:on_btn_return()
    print("~~~~~~~~~~~~~~~~~~~~~~~~ ", bind_function.get_game_status())
	if bind_function.get_game_status() == GameStatus.free then
		self:on_btn_return_ok()
	else
		bp_show_message_box(
			"提示", 
            "当前正在游戏中，你确定要离开吗？", 
			MB.OKCANCEL, 
			"强行退出",
			"继续游戏",
			function () self:on_btn_return_ok() end,
			function () end,
			0,
            ""
			)
	end
end

function game_layer:on_btn_outcards()
	if not self.btn_outcards:isVisible() then
		return 
	end

	if self.card_layer.temp_outcards_count <= 0 then 
		return 
	end

	self.btn_outcards:setVisible(false)
	self.btn_outcards:setTouchEnabled(false)
	self.btn_pass:setVisible(false)
	self.btn_pass:setTouchEnabled(false)
	self.btn_hint:setVisible(false)
	self.btn_hint:setTouchEnabled(false)
    self.player_clock:hide()

	local tbl = {}
	tbl.chair_id = bind_function.switch_to_chair_id(LocalSelfChairId)
	tbl.outcards_count = self.card_layer.temp_outcards_count
	tbl.out_cards = {}
	for i,v in ipairs(self.card_layer.temp_out_cards) do
		table.insert(tbl.out_cards, v:get_card())
	end

	local str_data = json.encode(tbl)
	bind_function.send_data(ProtocolType.outcards, str_data)	

	-- 预显示
	self.game_user:set_status(LocalSelfChairId, UserStatus.outcards)
	local outcards_type = self.card_layer.temp_outcards_type

	self.card_layer:show_out_cards(self.card_layer.temp_out_cards, self.card_layer.temp_outcards_count)
	self.game_user:show_outcards_animation(outcards_type, LocalSelfChairId, self.card_layer.temp_outcards_count)
end

function game_layer:on_btn_pass()
	if not self.btn_pass:isVisible() then
		return 
	end

	self.btn_outcards:setVisible(false)
	self.btn_outcards:setTouchEnabled(false)
	self.btn_pass:setVisible(false)
	self.btn_pass:setTouchEnabled(false)
	self.btn_hint:setVisible(false)
	self.btn_hint:setTouchEnabled(false)
    self.random_time = 0

	local tbl = {}
	tbl.chair_id = bind_function.switch_to_chair_id(LocalSelfChairId)
	local str_data = json.encode(tbl)
	bind_function.send_data(ProtocolType.pass, str_data)

	if #self.card_layer.out_cards[LocalSelfChairId+1] == 0 then
		self.player_clock:hide()
		if self.hint_info:isVisible() then
			self.hint_info:stopAllActions()
			self.hint_info:setVisible(false)
		end
	end
	self.card_layer:choose_cards_move_down()
	self.card_layer:unscheduleUpdate()
end

function game_layer:on_btn_hint()
    if bind_function.switch_to_chair_id(LocalSelfChairId) == self.curr_outcards_chairid then
    	return 
    end

	self:get_hint_info()
end

function game_layer:on_btn_gift(gift_id, int_num)
    local table_json = bind_function.get_user_data_by_user_id(self.gift_show_user_id)
	if table_json == {} then return end 

    local self_json = bind_function.get_self_user_data()
    if self_json == {} then return end

    if table_json.dwUserID == self_json.dwUserID then
		bind_function.show_hinting(tostring("该表情只能对他人使用"))
		return 
	end

	local tbl = {}
	tbl.gift_id = gift_id
	tbl.from_chair_id = self_json.wChairID
	tbl.to_chair_id = table_json.wChairID
	tbl.from_user_id = self_json.dwUserID
	tbl.to_user_id = table_json.dwUserID
	tbl.int_num = int_num

	local str_data = json.encode(tbl)
	bind_function.send_data(ProtocolType.send_gift, str_data)
end

function game_layer:on_btn_buyReCard_ok()
	bind_function.show_shop(2)
end

function game_layer:on_btn_mark()
	if bind_function.get_self_prop_status(GF.ID_PROP_RECARD) == true then
		self.mark_layer:stopAllActions()
		if self.mark_layer:getPositionY() < 0 then
			self.mark_layer:setVisible(true)
			self.mark_layer:runAction(action_tools.CCMoveTo(0.2, self.mark_layer:getPositionX(), 0))
		else
			local move_to = action_tools.CCMoveTo(0.2, self.mark_layer:getPositionX(), -self.mark_layer:getContentSize().height)
            local hide = action_tools.CCHide()
			self.mark_layer:runAction(action_tools.CCSequence(move_to, hide))
		end	
	else
		if self:is_module_shop() == false then
			bind_function.show_hinting(tostring("您没有记牌器特权"))
			return
		end

		if bind_function.get_self_prop_count(GF.ID_PROP_RECARD_ONE) > 0 or bind_function.get_self_prop_count(GF.ID_PROP_RECARD) > 0 then
            local table_json = bind_function.get_user_data_by_chair_id(bind_function.switch_to_chair_id(LocalSelfChairId))
            if not (table_json == nil or table_json == {} or table_json == "") then
                UserInfo.ShowUserInfo(1, 
                    table_json,
                    function (index, num) self:on_btn_gift(index, num) end,
                    1)
                self.gift_show_user_id = table_json.user_id                
            end
            bind_function.show_hinting(tostring("记牌器特权已过期，请点击开通"))
		else
			bp_show_message_box(
                "提示", 
				"您还未开通记牌器特权或已过期，是否立即购买？", 
				MB.OKCANCEL, 
				"购买",
				"取消",
				function () self:on_btn_buyReCard_ok() end,
				function () end,
				0,
				""
				)
		end
	end
end

function game_layer:on_btn_no_trust()
    local tbl = {}
    tbl.chair_id = bind_function.switch_to_chair_id(LocalSelfChairId)

    local str_data = json.encode(tbl)
    bind_function.send_data(ProtocolType.no_trust, str_data)
end

function game_layer:on_btn_show_finish(bool_show)
    self.finish_layer:setFinishLayerVisible(bool_show)
end

function game_layer:touch_event(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end

    AudioEngine.playEffect(MUSIC_PATH.normal[0])
    if sender.tag == ButtonEventType.chat then
        self:on_btn_chat()
        
    elseif sender.tag == ButtonEventType.landlord then
        self:on_btn_landlord()

    elseif sender.tag == ButtonEventType.no_landlord then
        self:on_btn_no_landlord()

    elseif sender.tag == ButtonEventType.rob then
        self:on_btn_rob()

    elseif sender.tag == ButtonEventType.no_rob then
        self:on_btn_no_rob()

    elseif sender.tag == ButtonEventType.outcards then
        self:on_btn_outcards()

    elseif sender.tag == ButtonEventType.pass then
        self:on_btn_pass()

    elseif sender.tag == ButtonEventType.hint then
        self:on_btn_hint()

    elseif sender.tag == ButtonEventType.change then
        self:on_btn_changetable()

    elseif sender.tag == ButtonEventType.ready then
        self:on_btn_ready()

    elseif sender.tag == ButtonEventType.mark then
        self:on_btn_mark()
        
    elseif sender.tag == ButtonEventType.continue then
        self:on_btn_continue()
        
    elseif sender.tag == ButtonEventType.left then
        self:on_btn_show_finish(false)
    
    elseif sender.tag==ButtonEventType.invite then
        self:on_btn_invite()

    elseif sender.tag==ButtonEventType.grade then
        self:on_btn_show_grade()

    elseif sender.tag==ButtonEventType.show_finish then
        self:on_btn_show_finish(true)

    elseif sender.tag==ButtonEventType.revive then
        self:on_btn_user_revive_card()

    end    
end

--------------------------------------------------------------------------------
-- 自定义消息交互
--------------------------------------------------------------------------------
function game_layer:on_event_game_config(data)
    self.start_time = data.start_time
    self.auto_ready = data.auto_ready
    self.finish_time = data.finish_time
    self.change_tabel_time = data.change_table_time

    bind_function.set_game_status(GameStatus.free)
end

function game_layer:on_event_game_clock(data)
    local viewid = bind_function.switch_to_view_id(data.chair_id)
    local time_pos = {cc.p(self:getContentSize().width-230, 435), cc.p(self:getContentSize().width/2, 380), cc.p(230, 435)}
    if self.btn_ready:isVisible() then
        time_pos[2] = cc.p(self:getContentSize().width/2, self.btn_change:getPositionY())
    end
    self.player_clock:setPosition(time_pos[viewid+1])
    self.player_clock:setTime(data.time, true)
end

function game_layer:on_event_game_info(data)
    if data.base_gold == -1 then return end

    self.base_gold = data.base_gold
    self.top_bar:show_base_gold(data.base_gold)

    self.base_gold_times = 1
    self.top_bar:show_gold_times(1, 0)
end

function game_layer:on_event_room_info(data)
end

function game_layer:on_event_game_sound(data)
    -- if data.chair_id == -1 then
    --     return 
    -- end

    -- if data.chair_id == get_self_chair_id() then
    --     audio_engine.playEffect(data.kind_id, data.chair_id)
    -- end
end

function game_layer:on_event_chat(data)
    if data._int_type == ChatType.notice then
        bp_show_hinting(gbk_to_utf8(data._str_meassge))
    end
end

function game_layer:on_event_button_power(visible, enable)
    self.btn_change:setVisible(bit_tools._and(visible, ButtonPower.changetable) > 0)
    self.btn_change:setTouchEnabled(bit_tools._and(enable, ButtonPower.changetable) > 0)
    
    self.btn_ready:setVisible(bit_tools._and(visible, ButtonPower.start) > 0)
    self.btn_ready:setTouchEnabled(bit_tools._and(enable, ButtonPower.start) > 0)
    self.btn_ready:setBright(bit_tools._and(enable, ButtonPower.start) > 0)
    
    self.btn_invite:setVisible(bit_tools._and(visible,ButtonPower.invite)>0)
    self.btn_invite:setTouchEnabled(bit_tools._and(enable,ButtonPower.invite)>0)

    self.btn_landlord:setVisible(bit_tools._and(visible, ButtonPower.landlord) > 0)
    self.btn_landlord:setTouchEnabled(bit_tools._and(enable, ButtonPower.landlord) > 0)

    self.btn_no_landlord:setVisible(bit_tools._and(visible, ButtonPower.no_landlord) > 0)
    self.btn_no_landlord:setTouchEnabled(bit_tools._and(enable, ButtonPower.no_landlord) > 0)

    self.btn_rob:setVisible(bit_tools._and(visible, ButtonPower.rob) > 0)
    self.btn_rob:setTouchEnabled(bit_tools._and(enable, ButtonPower.rob) > 0)

    self.btn_no_rob:setVisible(bit_tools._and(visible, ButtonPower.no_rob) > 0)
    self.btn_no_rob:setTouchEnabled(bit_tools._and(enable, ButtonPower.no_rob) > 0)

    self.btn_outcards:setVisible(bit_tools._and(visible, ButtonPower.outcards) > 0)
    self.btn_outcards:setTouchEnabled(bit_tools._and(enable, ButtonPower.outcards) > 0)
    self.btn_outcards:setBright(bit_tools._and(enable, ButtonPower.outcards) > 0)

    self.btn_pass:setVisible(bit_tools._and(visible, ButtonPower.pass) > 0)
    self.btn_pass:setTouchEnabled(bit_tools._and(enable, ButtonPower.pass) > 0)
    self.btn_pass:setBright(bit_tools._and(enable, ButtonPower.pass) > 0)

    self.btn_hint:setVisible(bit_tools._and(visible, ButtonPower.hint) > 0)
    self.btn_hint:setTouchEnabled(bit_tools._and(enable, ButtonPower.hint) > 0)

    if self.btn_ready:isVisible() and self.btn_ready:isBright() then
        if ROOM_MODE ~= GF.ROOM_MODE_FRIEND then
            if self.change_tabel_time > 0 then
                self.btn_change._num:setString(self.change_tabel_time)
                self.btn_change:setBright(false)
                self.btn_change:setTouchEnabled(false)
                self.btn_change._num:setVisible(true)
                local function callfunc ()
                    self.change_tabel_time = self.change_tabel_time - 1
                    if self.change_tabel_time > 0 then
                        self.btn_change._num:setString(self.change_tabel_time)
                    else
                        self.btn_change._num:setVisible(false)
                        self.btn_change:setBright(true)
                        self.btn_change:setTouchEnabled(true)
                        self.btn_change._num:stopAllActions()
                    end
                end
                self.btn_change._num:runAction(action_tools.CCRepeatForever(action_tools.CCSequence(action_tools.CCDelayTime(1), action_tools.CCCallFunc(callfunc))))
            end
            self.player_clock:setTimeUpFunc(function () self:on_start_time_over() end)
            self.player_clock:setTime(self.start_time, true)
        end
    end

    if self.btn_ready:isVisible() and self.auto_ready == true then
        self:on_btn_ready()
        if self:bool_lineup() == true then
            self:on_event_button_power(0, 0)
            return
        end
    end
    
    if self.btn_outcards:isVisible() then
        self.is_reset_hint_data = true
        self.card_layer:check_temp_outcards()
        self.card_layer:whether_choose_outcards()
        if self.btn_hint:isVisible() == false then
            self.btn_outcards:setPositionX(self:getContentSize().width/2)
            self:search_hint_info(self.struct_hand_cards, #self.struct_hand_cards)
        else
            local time = 1
            local function update(dt)
                if time <= 0 then
                    self:on_btn_pass()
                end
                time = time - dt
            end

            self.btn_outcards:setPositionX(self:getContentSize().width*2/3+50)
            if (#self.struct_hand_cards <= 1 and self.max_outcards_count > 1) or
                (#self.struct_hand_cards < 4 and #self.struct_hand_cards >= 2 
                and self.is_pass == true) then
                self.card_layer:scheduleUpdateWithPriorityLua(update, 0)
            else
                if self.max_outcards_type ~= KindCards.cards_king then
                    self:search_hint_info(self.struct_hand_cards, #self.struct_hand_cards)
                else
                    self.hint_cards_data = {}
                    self:show_hint_info()
                    self.card_layer:scheduleUpdateWithPriorityLua(update, 0)
                end
            end
        end
    end
end

function game_layer:on_event_user_status(data)
    self.game_user:set_status(bind_function.switch_to_view_id(data.status_chair_id), data.user_status)
end

function game_layer:on_event_user_identify(data)
    self.user_identity = {}
    for k,v in pairs(data.identity) do    
        if v then
            local viewid = bind_function.switch_to_view_id(k-1)
            self.user_identity[viewid] = v
            self.game_user:set_identity(viewid, v)
        end
    end 
end

function game_layer:on_event_user_task(data)
    local string, value = nil, 0
    if game_logic.get_card_size(data.task_value) == 11 then
        value = "J"
    elseif game_logic.get_card_size(data.task_value) == 12 then
        value = "Q"
    elseif game_logic.get_card_size(data.task_value) == 13 then
        value = "K"
    elseif game_logic.get_card_size(data.task_value) == 14 then
        value = "A"
    elseif game_logic.get_card_size(data.task_value) == 15 then
        value = "2"
    elseif game_logic.get_card_size(data.task_value) == 16 then
        value = "小王"
    elseif game_logic.get_card_size(data.task_value) == 17 then
        value = "大王"
    else
        value = game_logic.get_card_size(data.task_value)
    end
    
    local task_text = self:bool_score() == true and "积分" or "金币"
    if data.task_id == TaskInfo.last_single then
        string = tostring("单张" .. value .. "赢取"..task_text.."x2")
    elseif data.task_id == TaskInfo.last_double then
        string = tostring("对子" .. value .. "赢取"..task_text.."x2")
    elseif data.task_id == TaskInfo.last_shunzi then
        string = tostring("顺子赢取"..task_text.."x3")
    elseif data.task_id == TaskInfo.last_three then
        string = tostring("三条(可带牌)赢取"..task_text.."x3")
    elseif data.task_id == TaskInfo.last_plane then
        string = tostring("飞机(可带牌)赢取"..task_text.."x3")
    elseif data.task_id == TaskInfo.last_bomb then
        string = tostring("炸弹(四带二不算炸弹)赢取"..task_text.."x4")
    elseif data.task_id == TaskInfo.last_doubleline then
        string = tostring("连对赢取"..task_text.."×3")
    end

    self.task_background:setVisible(true)
    self.task_layer:setString("最后手牌:" .. string)
end

function game_layer:on_event_start_landlord(data)
    -- 如果是防作弊场 更新玩家头像
    if self:bool_cheat() == true and bind_function.get_game_status() == GameStatus.free then
        for i=1, GAME_PLAYER do
            if i - 1 ~= LocalSelfChairId then
                local user_data = bind_function.get_user_data_by_chair_id(bind_function.switch_to_chair_id(i)) 
                if user_data ~= nil then
                    self.game_user:set_nickname(i-1, bp_gbk2utf(user_data.szName), user_data.cbMember)
                    self.game_user:set_sex(i-1, user_data)
                    self.game_user:set_gold(i-1, user_data.lGold)   
                end
            end
            self.is_unkown_headimg[i] = false
        end
    end

    bind_function.set_game_status(GameStatus.landlord)
    if ROOM_MODE == GF.ROOM_MODE_FRIEND then
        if self.used_times < self.count_times then
            self.label_left_times:setString("局数: "..tostring((self.used_times + 1) .. "/" .. self.count_times))
        else
            self.label_left_times:setString("局数: "..tostring((self.used_times) .. "/" .. self.count_times))
        end
    end

    self.btn_ready:setTouchEnabled(false)
    self.btn_ready:setVisible(false)
    self.btn_change:setTouchEnabled(false)
    self.btn_change:setVisible(false)
    self.btn_invite:setTouchEnabled(false)
    self.btn_invite:setVisible(false)

    for i=1, GAME_PLAYER do
        self.game_user:set_status(i-1, UserStatus.null)
    end
end

function game_layer:on_event_landlord(data)
    -- 播放音效
    if self:get_sex_by_chairid(data.chair_id) == PlayerSex.girl then
        AudioEngine.playEffect(MUSIC_PATH.girl[1])
    else
        AudioEngine.playEffect(MUSIC_PATH.boy[1])
    end
end

function game_layer:on_event_no_landlord(data)
    -- 播放音效
    if self:get_sex_by_chairid(data.chair_id) == PlayerSex.girl then
        AudioEngine.playEffect(MUSIC_PATH.girl[2])
    else
        AudioEngine.playEffect(MUSIC_PATH.boy[2])
    end
end

function game_layer:on_event_start_rob(data)
    bind_function.set_game_status(GameStatus.rob)
end

function game_layer:on_event_rob(data)
    self.sound_tag = data.rob_times

    -- 播放音效
    if self:get_sex_by_chairid(data.chair_id) == PlayerSex.girl then
        AudioEngine.playEffect(MUSIC_PATH.girl[3][self.sound_tag + 1])
    else
        AudioEngine.playEffect(MUSIC_PATH.boy[3][self.sound_tag + 1])
    end
end

function game_layer:on_event_no_rob(data)
    -- 播放音效
    if self:get_sex_by_chairid(data.chair_id) == PlayerSex.girl then
        AudioEngine.playEffect(MUSIC_PATH.girl[4])
    else
        AudioEngine.playEffect(MUSIC_PATH.boy[4])
    end
end

function game_layer:on_event_start_outcards(data)
    bind_function.set_game_status(GameStatus.outcards)
    self.card_layer:setTouchEnabled(true)
end

function game_layer:on_event_out_cards(data)
    self.player_clock:hide()
    self.is_pass = data.bool_pass

    self.card_layer:setTouchEnabled(true)
    if data.cards_count ~= 0 then
        -- 播放牌型音效
        self:play_sound(data.kind, data.chair_id, data.out_cards[1], data.is_follow)

        -- 更新记牌器
        self:update_mark_cards(data.out_cards, data.cards_count)

        local is_reset = false
        local client_count, client_outcards = self.card_layer:get_outcards_count(bind_function.switch_to_view_id(data.chair_id))
        if client_count ~= data.cards_count then
            self.card_layer.temp_outcards_count = data.cards_count
            is_reset = true
        else
            game_logic.sort_cards_by_size(client_outcards, client_count)
            game_logic.sort_cards_by_size(data.out_cards, data.cards_count)
            for i=1, client_count do
                if data.out_cards[i] ~= client_outcards[i] then
                    is_reset = true
                    break
                end
            end
        end
        if is_reset then
            self.card_layer:init_out_cards(bind_function.switch_to_view_id(data.chair_id), data.out_cards, data.cards_count)
            self.game_user:show_outcards_animation(data.kind, bind_function.switch_to_view_id(data.chair_id), data.cards_count)
        end
    else
        self.card_layer:clear_out_cards(bind_function.switch_to_view_id(data.chair_id))
    end
end

function game_layer:on_event_send_cards(data)
    if data.bool_ani == true then
        local value = bind_function.pause_message()
        -- 播放发牌音效
        self.send_cards_effectid = AudioEngine.playEffect(MUSIC_PATH.normal[5], true)
    end

    if data.cards_count == 0 then
        self.card_layer:clear_hand_cards()
    else
        local is_reset = false
        local client_count = self.card_layer:get_cards_count()

        if client_count ~= data.cards_count then
            is_reset = true
        else
            if self.struct_hand_cards == nil then
                is_reset = true 
            else
                for k,v in pairs(data.hand_cards) do  
                    if v and v ~= 0 and v ~= self.struct_hand_cards[k] then
                        is_reset = true
                        break
                    end
                end
            end
        end

        if is_reset then
            self.struct_hand_cards = {}
            for k,v in pairs(data.hand_cards) do  
                if v and v ~= 0 then
                    table.insert(self.struct_hand_cards, v)
                end
            end
            self.card_layer:show_hand_cards(data.bool_ani, data.cards_count, data.hand_cards)
        end
    end
end

function game_layer:on_event_game_finish(data)
    bind_function.set_game_status(GameStatus.free)
    self.card_layer:setTouchEnabled(false)

    -- 显示剩余手牌
    for i=1, GAME_PLAYER do
        local viewid = bind_function.switch_to_view_id(i-1)
        self.game_user:set_status(viewid, UserStatus.null)  
        self.game_user:set_cards_count(viewid, -1)
        self.card_layer:init_out_cards(viewid, nil, 0, false)
        if viewid ~= LocalSelfChairId then
            if data.hands_count[i] ~= 0 then
                self.card_layer:init_out_cards(viewid, data.hand_cards[i], data.hands_count[i], false)
            end
        end

        local user_data = bind_function.get_user_data_by_chair_id(data.chair_id[i])
        self.finish_layer:set_finish_data(user_data, data, i)
    end
    
    if data.int_kind_new[bind_function.switch_to_chair_id(LocalSelfChairId-1) + 1] == 4 then
        self.finish_layer:hide_finish_layer()
        -- if self.active_on_game then
        --     self.active_on_game:setGameZOrder(11)
        --     self.active_on_game:setReviveCountViewPos()
        --     self.active_on_game:setWinCountViewPos()
        -- end
        self.btn_show_grade2:setVisible(true)
        self.btn_show_grade2:setTouchEnabled(true)
    else
        if data.is_spring then
            self.game_user:showSpringAnimation()
        end
        self.finish_layer:set_times_data(data.rob_gold_times, data.is_spring, data.task_complete, data.bomb_gold_times)
        self.finish_layer:show_finish_layer(data)
    end
end

function game_layer:on_event_max_outcards(data)
    self.max_outcards_count = data.cards_count
    self.max_outcards_type = data.kind
    self.max_outcards_chairid = data.chair_id

    print("=========================================出牌最大牌型 >>>>>>>>>>>>>>>> ", self.max_outcards_type)
    self.struct_max_outcards = {}
    for k,v in pairs(data.out_cards) do
        table.insert(self.struct_max_outcards, v)
    end
end

function game_layer:on_event_base_cards(data)
    self.base_cards_times = data.times
    self.struct_base_cards = {}
    for k,v in pairs(data.base_cards) do  
        table.insert(self.struct_base_cards, v)
    end

    self.top_bar:show_base_cards(data.bool_ani, data.times)
end

function game_layer:on_event_gold_times(data)
    self.top_bar:show_gold_times(data.gold_times, data.times_status)
end

function game_layer:on_event_user_trust(data)
    local view_id = bind_function.switch_to_view_id(data.chair_id)
    if view_id == LocalSelfChairId then
        self.trust_layer:show_trust_layer(data.bool_trust)
    end
    self.game_user:set_trust(view_id, data.bool_trust)
end

function game_layer:on_event_mark_cards(data)
    if data.mark_cards == nil then
        return 
    end
    game_logic.sort_cards_by_size(data.mark_cards, #data.mark_cards)

    self.mark_cards_tbl = {}
    for i,v in ipairs(data.mark_cards) do
        local card = game_logic.get_card_size(v)
        self.mark_cards_tbl[card] = self.mark_cards_tbl[card] or 0
        self.mark_cards_tbl[card] = self.mark_cards_tbl[card]+1
    end

    for i=3, 17 do
        self.mark_cards_tbl[i] = self.mark_cards_tbl[i] or 0
        self.mark_word[i]:setString(self.mark_cards_tbl[i])
    end    
end

function game_layer:on_event_cards_count(data)
    self.game_user:set_cards_count(bind_function.switch_to_view_id(data.cards_id), data.cards_count)
end

function game_layer:on_event_send_gift(data)
    local player_pos = {[1] = cc.p(self:getContentSize().width-75, self:getContentSize().height -200*AUTO_HEIGHT), 
                        [2] = cc.p(75, 60), 
                        [3] = cc.p(75, self:getContentSize().height -200*AUTO_HEIGHT)}

    local from_pos = player_pos[bind_function.switch_to_view_id(data.from_chair_id)+1]
    local to_pos = player_pos[bind_function.switch_to_view_id(data.to_chair_id)+1]

    self.gift_play:play_gift_times(from_pos, to_pos, data.gift_id, data.int_num)
end

function game_layer:on_event_friend_info(data) 
    print("=================on_event_friend_info==================") 
    self.table_code = data.table_code
    self.used_times = data.used_times
    self.count_times = data.count_times
    self.data_count = data.data_count
    self.name_list, self.grade_list = {}, {}

    for i=1, data.data_count do
        table.insert(self.name_list, bp_gbk2utf(data.name_list[i]))
        table.insert(self.grade_list, data.grade_list[i])
    end

    self.label_table_code:setString("房间号: "..tostring(self.table_code))
    if bind_function.get_game_status() ~= GameStatus.free then
        if self.used_times < self.count_times then
            self.label_left_times:setString("局数: "..tostring((self.used_times + 1) .. "/" .. self.count_times))
        else
            self.label_left_times:setString("局数: "..tostring((self.used_times) .. "/" .. self.count_times))
        end
    else
        self.label_left_times:setString("局数: "..tostring(self.used_times .. "/" .. self.count_times))
    end

    if self.count_times - self.used_times <= 0 or self.used_times == 0 then
        self.btn_show_grade1:setVisible(false)
        self.btn_show_grade1:setTouchEnabled(false)
    else
        self.btn_show_grade1:setVisible(true)
        self.btn_show_grade1:setTouchEnabled(true)
    end
end

function game_layer:on_event_redpacket_info(data)
end

function game_layer:on_event_show_task_logo(data)
    self.task_layer.finish_logo:setScale(2)
    self.task_layer.finish_logo:setVisible(true)
    self.task_layer.finish_logo:runAction(action_tools.CCScaleTo(0.2, 1))
end

function game_layer:on_event_active_info(data)
end

function game_layer:on_event_fresh_revive_btn(data)
    self:fresh_revive_btn()
end

--------------------------------------------------------------------------------
-- 框架消息交互
--------------------------------------------------------------------------------
--[[ user_data
    {"szName":"最讨厌产品1号","dwMasterRight":1,"wChairID":0,"wNetDelay":0,"lLostCount":5,0
    "wFaceID":0,"lCharm":493,"lWinCount":7,"lFleeCount":0,"cbGender":1,"wTableID":0,"lPraise":2,
    "cbUserStatus":2,"lScore":30,"dwUserID":9058537,"lGold":110000,"cbMember":0,"lDrawCount":6,
    "lExperience":150,"dwGroupID":0,"dwUserRight":837156904}
--]]
--[[ room_info
    {"roomid": 101,
    "id": 12411,
    "chaircount": 3,
    "mode": 1,
    "address": "demo.bookse.cn",
    "limit": [{
        "id": 4,
        "value": 500
    }],
    "rule": "level=1;caption=\"初级场 500-2万\";caption_ex=\"新手入门场\";gift=\"1,2,5,1,2\";minitax=10;",
    "kind": 16,
    "gameid": 124,
    "tablecount": 50,
    "name": "初级场",
    "port": 12411}
--]]
function game_layer:on_game_user_enter(ptr_user_data)
    local viewid = bind_function.switch_to_view_id(ptr_user_data.wChairID)
    local room_json = bind_function.get_room_data()

    TABLE_ID = ptr_user_data.wTableID
    ROOM_KIND = room_json.kind
    ROOM_MODE = room_json.mode

    print("=============viewid = ", viewid, "TABLE_ID = ", TABLE_ID, self:bool_guess_game())
    -- 匹配场  （tableid >= 150 换桌进入匹配队列）
    if self:bool_lineup() == true then 
        if self.btn_change and self.btn_ready then 
            self.btn_change:loadTextureNormal("find_again.png", 1)
        end
        if TABLE_ID >= 150 then
            self:on_btn_changetable()
        end
    end

    if self:bool_score() == true then
        if viewid == LocalSelfChairId then
            self.game_user.gold_img[viewid+1]:loadTexture("img_score_da.png", 1)
        else
            self.game_user.gold_img[viewid+1]:loadTexture("img_score_xiao.png", 1)
        end
    end

    if self:bool_redpacket() then
        if viewid == LocalSelfChairId then
            self.game_user.gold_img[viewid+1]:loadTexture("img_bean_da.png", 1)
        else
            self.game_user.gold_img[viewid+1]:loadTexture("img_bean_xiao.png", 1)
        end
    end

    if self:bool_cheat() == true and ptr_user_data.cbUserStatus ~= GF.US_PLAY and viewid ~= LocalSelfChairId then 
        self.game_user:show_user(viewid, true, false, true)
        self.game_user:set_nickname(viewid, tostring("游戏玩家"), 0)
        self.game_user:set_sex(viewid, ptr_user_data, true)
        self.game_user:set_gold(viewid, -2)   
        self.is_unkown_headimg[viewid + 1] = true
    else
        self.game_user:show_user(viewid, true)
        self.game_user:set_nickname(viewid, bp_gbk2utf(ptr_user_data.szName), ptr_user_data.cbMember)
        self.game_user:set_sex(viewid, ptr_user_data)
        if self:bool_score() == true then
            self.game_user:set_score(viewid, ptr_user_data.lScore)
        else
            self.game_user:set_gold(viewid, ptr_user_data.lGold)
        end   
        self.is_unkown_headimg[viewid + 1] = false 
    end

    self.game_user:set_identity(viewid, UserIdentity.null)
    if ptr_user_data.cbUserStatus == GF.US_READY then -- 准备状态
    	self.game_user:set_status(viewid, UserStatus.ready)
    end
    if viewid == LocalSelfChairId then
        self.set_play_effect = false
        local function callback()
            self.set_play_effect = true
        end
        self:runAction(action_tools.CCSequence(action_tools.CCDelayTime(1), action_tools.CCCallFunc(callback)))
        AudioEngine.playEffect(MUSIC_PATH.normal[2])
    else
        self.set_play_effect = self.set_play_effect or false
        if self.set_play_effect == true then
            AudioEngine.playEffect(MUSIC_PATH.normal[2])
        end
    end
end

function game_layer:on_game_user_left(ptr_user_data)
    local viewid = bind_function.switch_to_view_id(ptr_user_data.wChairID)
    self.game_user:show_left_info(viewid, false)
    AudioEngine.playEffect(MUSIC_PATH.normal[3])

    -- 匹配场：一局结束后若三人都点了再来一局，则三人继续游戏。若有人离桌，则点击再来一局的人加入匹配队列
    if self:bool_lineup() and ptr_user_data.wChairID ~= bind_function.switch_to_chair_id(LocalSelfChairId) then 
    	local self_data = bind_function.get_self_user_data()
        if self_data.cbUserStatus == 0x03 then
	    	print("--------------------匹配场：一局结束后若三人都点了再来一局，则三人继续游戏。若有人离桌，则点击再来一局的人加入匹配队列----------------------------")
	        self:unscheduleUpdate()
            self:on_btn_changetable()
        end
    end
end

function game_layer:on_game_user_status(ptr_user_data)    
    if ptr_user_data.cbUserStatus == 0x03 then -- 准备状态
        self.game_user:set_status(bind_function.switch_to_view_id(ptr_user_data.wChairID), UserStatus.ready)
        if ptr_user_data.wChairID ~= bind_function.switch_to_chair_id(LocalSelfChairId) then
            self.set_play_effect = self.set_play_effect or false
            if self.set_play_effect == true then
                AudioEngine.playEffect(MUSIC_PATH.normal[4])
            end
        end
    end
end

function game_layer:on_game_user_data(ptr_user_data)
    if bind_function.switch_to_chair_id(LocalSelfChairId) == ptr_user_data.wChairID then
        --set_self_gold(table_json.gold)
        if self:bool_score() == true then
            self.game_user:set_score(LocalSelfChairId, ptr_user_data.lScore)
        else
            self.game_user:set_gold(LocalSelfChairId, ptr_user_data.lGold)
        end
    end
end

function game_layer:on_game_user_score(ptr_user_data)
    local viewid = bind_function.switch_to_view_id(ptr_user_data.wChairID)
    if bit._and(ROOM_KIND, GF.ROOM_KIND_SCORE) > 0 then
        self.game_user:set_score(viewid, ptr_user_data.lScore)
    else
        self.game_user:set_gold(viewid, ptr_user_data.lGold)
    end
end

function game_layer:on_game_message(id, data)
    local param_data = {}
    if data ~= "" then
        param_data = json.decode(data)
    end

    print("===================== on_game_message =====================id = ", id)
    if id == MessageType.config then
        self:on_event_game_config(param_data)   

    elseif id == MessageType.clock then
        self:on_event_game_clock(param_data)

    elseif id == MessageType.game_info then
        self:on_event_game_info(param_data) 

    elseif id == MessageType.room_info then
        self:on_event_room_info(param_data)

    -- elseif id == MessageType.sound then
    --     self:on_event_game_sound(param_data)

    elseif id == MessageType.chat then
        self:on_event_chat(param_data)  

    elseif id == MessageType.button_power then
        self:on_event_button_power(param_data.visible, param_data.enable)  

    elseif id == MessageType.status then
        self:on_event_user_status(param_data)   

    elseif id == MessageType.identify then
        self:on_event_user_identify(param_data)

    elseif id == MessageType.task then
        self:on_event_user_task(param_data) 

    elseif id == MessageType.start_landlord then
        self:on_event_start_landlord(param_data)

    elseif id == MessageType.landlord then
        self:on_event_landlord(param_data)

    elseif id == MessageType.no_landlord then
        self:on_event_no_landlord(param_data)

    elseif id == MessageType.start_rob then
        self:on_event_start_rob(param_data)

    elseif id == MessageType.rob then
        self:on_event_rob(param_data)

    elseif id == MessageType.no_rob then
        self:on_event_no_rob(param_data)

    elseif id == MessageType.start_outcards then
        self:on_event_start_outcards(param_data)
        
    elseif id == MessageType.outcards then
        self:on_event_out_cards(param_data) 

    elseif id == MessageType.send_cards then
        self:on_event_send_cards(param_data)

    elseif id == MessageType.finish then
        self:on_event_game_finish(param_data)   

    elseif id == MessageType.max_outcards then
        self:on_event_max_outcards(param_data)

    elseif id == MessageType.base_cards then
        self:on_event_base_cards(param_data)    

    elseif id == MessageType.gold_times then
        self:on_event_gold_times(param_data)    

    elseif id == MessageType.trust then
        self:on_event_user_trust(param_data)

    elseif id == MessageType.mark_cards then
        self:on_event_mark_cards(param_data)

    elseif id == MessageType.cards_count then
        self:on_event_cards_count(param_data)

    elseif id == MessageType.send_gift then
        self:on_event_send_gift(param_data)

    elseif id==MessageType.friend_info then
        self:on_event_friend_info(param_data)

    -- elseif id==MessageType.redpacket_info then
    --     self:on_event_redpacket_info(param_data)

    elseif id==MessageType.task_finish then
        self:on_event_show_task_logo(param_data)

    -- elseif id == MessageType.active_info then
    --     self:on_event_active_info(param_data)

    elseif id == MessageType.fresh_revive_btn then
        self:on_event_fresh_revive_btn(param_data)
        
    end 
end

function game_layer:on_game_user_chat(data, chat)
    local bool_chat = false
    local viewid = bind_function.switch_to_view_id(data.wChairID) + 1
    if self:bool_cheat() then
        if self.is_unkown_headimg[viewid] == false then
            bool_chat = true
        end
    else
        bool_chat = true
    end

    if bool_chat == true then
        local dir = ChatDirection.left_top
        if viewid < LocalSelfChairId + 1 then
            dir = ChatDirection.right_top
        end        
        self.game_user.player_heads[viewid]:play_chat_by_type(chat, dir)
    end
end

--------------------------------------------------------------------------------
-- 辅助函数
--------------------------------------------------------------------------------
-- 倒计时结束自动退出
function game_layer:on_start_time_over()
    print("---------------------倒计时结束自动退出")
    bind_function.close_game()
    bp_show_message_box(
        "提示",
        "长时间未开始，已自动离开房间",
        MB.OK,
        "确定",
        "",
        function(param_1,param_2)   end,
        function(param_1,param_2) end,
        0,
        ""
        )
end
-- 清除数据
function game_layer:clear_data()
	self.hint_cards_data = {}
    self.is_reset_hint_data = false
    self.max_outcards_count = 0
    self.max_outcards_type = 0
    self.struct_max_outcards = nil
    self.curr_outcards_chairid = -1
    self.user_identity = nil
    for i=1, 15 do
        self.mark_word[18-i]:setString("0")
    end
end
-- 清除ui
function game_layer:clear_ui()
	-- 计时器
    self.player_clock:hide()
    self.btn_change._num:setVisible(false)
	-- 得分按钮
	self.btn_show_finish:setVisible(false)
	self.btn_show_finish:setTouchEnabled(false)
	-- 任务
	self.task_layer.finish_logo:setVisible(false)
	self.task_background:setVisible(false)
	-- 底分倍数底牌
	self.top_bar:clear_ui()
	-- 卡牌
	self.card_layer:clear_ui()
	self.card_layer:unscheduleUpdate()
	-- 玩家
	self.game_user:clear_ui()
	-- 结算界面
	self.finish_layer:clear_ui()
end
-- 按钮辅助函数
function game_layer:create_btn(config_data)
    local btn = control_tools.newBtn({normal = config_data.normal, pressed = config_data.pressed, ctype = config_data.ctype})
    btn.tag = config_data.tag
    btn:addTouchEventListener(function(sender, eventType) self:touch_event(sender, eventType) end)
    return btn 
end
-- 金币不足提示
function game_layer:show_gold_tips(str)
    if self:is_module_shop() == true then
        bind_function.show_simple_shop()
    else
        bind_function.show_hinting(str)
    end
end
-- 金币检查
function game_layer:check_gold(bool_show)
    bool_show = bool_show or true
    if self:bool_score() == false then
        local user_data = bind_function.get_self_user_data()
        if user_data == nil then return false end 
        if user_data.lGold == 0 then
            if bool_show then
                self:show_gold_tips(tostring("金币不足，无法继续游戏"))
            end
            return false
        end

        -- 房间下限金币检查
        local tbl_json = bind_function.get_room_data()

        if tbl_json == nil then return false end

        if tbl_json.limit == nil then return --[[false--]]true end

        local tmp_limit = 0;
        for k,v in pairs(tbl_json.limit) do 
            if v.id == 4 then 
                tmp_limit = v.value 
                break
            end
        end

        if user_data.lGold < tmp_limit then 
            if bool_show then
                self:show_gold_tips(tostring("金币不足，无法继续游戏"))
            end
            return false
        end
    end

    return true
end
-- 金豆检查
function game_layer:check_bean()
    if ROOM_MODE == GF.ROOM_MODE_REDPACKET then
        local table_json = bind_function.get_self_user_data()
        if table_json == nil then return false end
        if table_json.lGold < self.redpacket_limit then 
            self:show_gold_tips(tostring("金豆不足，无法继续游戏"))
            return false
        end
    end
    return true
end
-- 提示信息
function game_layer:search_hint_info(cards, count)
    self:search_out_cards(cards, count)
    if self.hint_cards_data == nil or #self.hint_cards_data == 0 then
        self:show_hint_info()
    end
end
-- 寻找可出牌集
function game_layer:search_out_cards(cards, count)
    if self.is_reset_hint_data == true then
        self.is_reset_hint_data = false
        self.hint_index = 1
        self.hint_cards_data = {} 
        
        if self.max_outcards_type == KindCards.cards_error then
            game_logic.search_auto_outcards(cards, count, self.hint_cards_data)

        elseif self.max_outcards_type == KindCards.cards_1 or
            self.max_outcards_type == KindCards.cards_2 or
            self.max_outcards_type == KindCards.cards_3 or
            self.max_outcards_type == KindCards.cards_bomb then
            game_logic.search_kind_cards_1(cards, count, self.struct_max_outcards, self.max_outcards_count, self.max_outcards_type, self.hint_cards_data)

        elseif self.max_outcards_type == KindCards.cards_shunzi_1 then
            game_logic.search_kind_cards_2(cards, count, self.struct_max_outcards, self.max_outcards_count, self.max_outcards_type, self.hint_cards_data)

        elseif self.max_outcards_type == KindCards.cards_shunzi_2 then
            game_logic.search_kind_cards_3(cards, count, self.struct_max_outcards, self.max_outcards_count, self.max_outcards_type, self.hint_cards_data)

        elseif self.max_outcards_type == KindCards.cards_shunzi_3 or
            self.max_outcards_type == KindCards.cards_plane or
            self.max_outcards_type == KindCards.cards_3_1 or
            self.max_outcards_type == KindCards.cards_3_2 then
            game_logic.search_kind_cards_4(cards, count, self.struct_max_outcards, self.max_outcards_count, self.max_outcards_type, self.hint_cards_data)

        elseif self.max_outcards_type == KindCards.cards_4_2 or
            self.max_outcards_type == KindCards.cards_4_4 then
            game_logic.search_kind_cards_5(cards, count, self.struct_max_outcards, self.max_outcards_count, self.max_outcards_type, self.hint_cards_data)

        end

        game_logic.search_kind_cards_6(cards, count, self.max_outcards_type, self.hint_cards_data)
        game_logic.search_kind_cards_7(cards, count, self.hint_cards_data)
    end
end
-- 获取提示信息
function game_layer:get_hint_info()
    if self.hint_cards_data == nil or #self.hint_cards_data == 0 then
        self:on_btn_pass()
    else
        for i,v in ipairs(self.hint_cards_data) do
            if self.hint_index == i then
                local count = game_logic.get_outcards_count(v.hintcards_data)
                --self.card_layer.is_follow = true
                self.card_layer.temp_outcards_type = game_logic.get_outcards_type(v.hintcards_data, count)
                self.card_layer:show_choose_card(v.hintcards_data)
                self.hint_index = self.hint_index + 1
                if self.hint_index > #self.hint_cards_data then
                    self.hint_index = 1
                end
                break
            end
        end
    end
end
-- 显示提示信息
function game_layer:show_hint_info()
    if self.trust_layer:isVisible() == true then
        return 
    end

    self.hint_info:setOpacity(255)
    self.hint_info:setVisible(true) 
    self.hint_info:stopAllActions()
    self.hint_info:runAction(action_tools.CCSequence(action_tools.CCDelayTime(3), action_tools.CCFadeOut(1), action_tools.CCHide())) 
end
-- 是否是小游戏场
function game_layer:bool_guess_game()
    return bit_tools._and(ROOM_KIND, GF.ROOM_KIND_MINI_GAME) > 0 
end
-- 是否是防作弊场
function game_layer:bool_cheat()
    return bit_tools._and(ROOM_KIND, GF.ROOM_KIND_NOCHEAT) > 0 
end
-- 是否是积分场
function game_layer:bool_score()
    return bit_tools._and(ROOM_KIND, GF.ROOM_KIND_SCORE) > 0 
end
-- 是否是排队场
function game_layer:bool_lineup()
    return bit_tools._and(ROOM_KIND, GF.ROOM_KIND_LINEUP) > 0 
end
-- 是否是红包场
function game_layer:bool_redpacket()
    return bit_tools._and(ROOM_MODE, GF.ROOM_MODE_REDPACKET) > 0
end
-- 更新记牌器
function game_layer:update_mark_cards(cards, count)
    if count <= 0 then
        return 
    end
    if cards == nil then
        return 
    end
    if self.mark_cards_tbl == nil then
        return 
    end
    for i=1, count do
        local card = game_logic.get_card_size(cards[i])
        self.mark_cards_tbl[card] = self.mark_cards_tbl[card]-1
    end
    for i=3, 17 do
        self.mark_word[i]:setString(self.mark_cards_tbl[i])
    end
end
-- 玩家自己chair_id
function game_layer:get_self_chair_id()
    return bind_function.switch_to_chair_id(LocalSelfChairId)
end
-- 商城管控
function game_layer:is_module_shop()
    return bind_function.have_mask_module(GF.MASK_MODULE_SHOP)
end
-- 获取指定玩家性别
function game_layer:get_sex_by_chairid(chair_id)
    local table_json = bind_function.get_user_data_by_chair_id(chair_id)
    if table_json == nil or table_json == {} or table_json == "" then
        return -1
    end
    
    return table_json.cbGender
end
-- 根据牌型播放音效
function game_layer:play_sound(outcards_type, chairid, outcards_value, is_follow)
    outcards_type = outcards_type or self.max_outcards_type
    outcards_value = outcards_value or self.struct_max_outcards[1]

    local sex = self:get_sex_by_chairid(chairid)
    if outcards_type == KindCards.cards_plane or outcards_type == KindCards.cards_shunzi_3 then
        AudioEngine.playEffect(MUSIC_PATH.normal[11])
        AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[6] or MUSIC_PATH.boy[6])
    elseif outcards_type == KindCards.cards_king then
        AudioEngine.playEffect(MUSIC_PATH.normal[10])
        AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[7] or MUSIC_PATH.boy[7])
    elseif outcards_type == KindCards.cards_bomb then
        AudioEngine.playEffect(MUSIC_PATH.normal[9])
        AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[8] or MUSIC_PATH.boy[8])
    elseif outcards_type == KindCards.cards_1 then
        local value = game_logic.get_card_size(outcards_value)
        AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[9][value-2] or MUSIC_PATH.boy[9][value-2])
    elseif outcards_type == KindCards.cards_2 then
        local value = game_logic.get_card_size(outcards_value)
        AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[10][value-2] or MUSIC_PATH.boy[10][value-2])
    elseif outcards_type == KindCards.cards_3 then
        local value = game_logic.get_card_size(outcards_value)
        AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[11][value-2] or MUSIC_PATH.boy[11][value-2])
    else
        if is_follow == true then
            local num = math.random(1, 2)
            AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[12][num] or MUSIC_PATH.boy[12][num])
        else
            if outcards_type == KindCards.cards_3_1 then
                AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[13] or MUSIC_PATH.boy[13])
            elseif outcards_type == KindCards.cards_3_2 then
                AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[14] or MUSIC_PATH.boy[14])
            elseif outcards_type == KindCards.cards_4_2 then
                AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[15] or MUSIC_PATH.boy[15])
            elseif outcards_type == KindCards.cards_4_4 then
                AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[16] or MUSIC_PATH.boy[16])
            elseif outcards_type == KindCards.cards_shunzi_1 then
                AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[17] or MUSIC_PATH.boy[17])
            elseif outcards_type == KindCards.cards_shunzi_2 then
                AudioEngine.playEffect(sex == PlayerSex.girl and MUSIC_PATH.girl[18] or MUSIC_PATH.boy[18])
            end
        end
    end
end

return game_layer
