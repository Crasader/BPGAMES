local gameMain=class("gameMain");
local UIGameHead = require "src/Controls/UIGameHead"
local UIHelper = require "src/UIHelper"
local UiPhoneInfo = require "src/Controls/UiPhoneInfo"
local UiTimeClock = require "src/Controls/UiTimeClock"
local ARCardLayer = require "src/ARCardLayer"
local UiGameEnd = require "src/Controls/UiGameEnd"
local UiReCard = require "src/Controls/UiReCard"
local UiMutilInfo = require "src/Controls/UiMutilInfo"
local UiGameRule = require "src/Controls/UiGameRule"
require "src/g_tools/control_tools"
require "src/g_tools/action_tools"
require "src/g_tools/bit_tools"
require "src/game_data"
require "src/game_config"
require "src/game_logic"

local CardsSortIndex = {
    size    = 0,
    count   = 1,
}
local TipsIndex={
    no_bigger_card  = 1,
    opposite_card   = 2,
    trust           = 3,
}

function gameMain:ctor()
    self._extra_func={}           --外部函数
    
    self.ptr_game_frame=nil
    self.ptr_layout=nil
    self.ptr_card_layer=nil
    self.ptr_menu_layer=nil
    self.ptr_time_clock=nil
    self.ptr_phone_info=nil
    self.ptr_game_end=nil
    self.ptr_recard = nil
    self.ptr_mutil_info = nil
    self.ptr_rule_layer = nil

    self._map_head={}
    self._map_outing_cards={}
    self._map_ready={}
    self._map_pass={}
    self._map_left_cards_count={}
    self._map_seat={}
    self._map_card_type_ani_1 = {}
    self._map_card_type_ani_2 = {}
    self._map_fact_view_id = {}

    self._img_tips = {}
    self._last_outing_cards_value={}
    self._last_outing_id = -1
    self._cur_out_card_id = -1
    self._sort_index = CardsSortIndex.size
    self._hint_ret = {}
    self._hint_order = 0
    
    self.the_size=nil
    self._time_schedule = nil
    
    self:init();
end

function gameMain:set_game_frame(param_game_frame)
    self.ptr_game_frame=param_game_frame;
end

function gameMain:destory()
    print("gamelog>>gameMain:destory")

    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(BPRESOURCE("res/animation/shuangkou_donghua_baozha.ExportJson"))
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(BPRESOURCE("res/animation/shuangkou_donghua_jiesuan.ExportJson"))
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(BPRESOURCE("res/image/animation/srd_ppdh.ExportJson"))

    if self._time_schedule then
        CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
        self._time_schedule=nil
    end

    if self.ptr_time_clock then
        self.ptr_time_clock:destroy()
    end

    if self.ptr_phone_info then
        self.ptr_phone_info:destroy()
    end

    if self.ptr_game_end then
        self.ptr_game_end:destroy()
    end

    self.ptr_layout:stopAllActions()
    self.ptr_layout:removeFromParent();
    
end

function gameMain:init()
    -- 初始化场景
    local main_layout=bp_get_main_layout();
    --
    print("hjjlog>>gameMain-----------------------",main_layout)
    self.ptr_layout=ccui.Layout:create()
    main_layout:addChild(self.ptr_layout)

    local  the_size=CCDirector:getInstance():getVisibleSize();
    self.the_size=the_size;
    self.ptr_layout:setContentSize(the_size);
    
    --加载动画资源

    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(BPRESOURCE("res/animation/shuangkou_donghua_baozha.ExportJson"))
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(BPRESOURCE("res/animation/shuangkou_donghua_baozha.ExportJson"))
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(BPRESOURCE("res/animation/shuangkou_donghua_jiesuan.ExportJson"))
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(BPRESOURCE("res/animation/shuangkou_donghua_jiesuan.ExportJson"))
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(BPRESOURCE("res/animation/srd_ppdh.ExportJson"))
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(BPRESOURCE("res/animation/srd_ppdh.ExportJson"))

    UIHelper.set_game_main(self)
    self:initBackGround()
    self:initPos()
    self:initBtn()
    self:initMenu()
    self:initTimeClock()
    self:initUserHeads()
    --self:initCardLayer()
    --self:initOutingCards()
    self:initReady()
    self:initPassInfo()
    self:initLeftCardsCount()
    self:initGameEnd()
    self:initTips()
    self:initReCard()
    self:initUiMitilInfo()
    self:initCardTypeAni()
end
-------------------初始化信息---------------------
--一些位置的初始化
function gameMain:initPos()
    --头像位置
    self.head_pos = {}
    self.head_pos[UserIndex.left] = cc.p(55 , 100*AUTO_HEIGHT+self.the_size.height/2)
    self.head_pos[UserIndex.down] = cc.p(52, 52)
    self.head_pos[UserIndex.right] = cc.p(self.the_size.width-55, 100*AUTO_HEIGHT+self.the_size.height/2)
    self.head_pos[UserIndex.up] = cc.p(self.the_size.width/2, self.the_size.height - 55*AUTO_HEIGHT)

    --出牌位置
    self.outing_cards_pos = {}
    self.outing_cards_pos[UserIndex.left] = cc.p(self.head_pos[UserIndex.left].x+110, self.head_pos[UserIndex.left].y-5)
    self.outing_cards_pos[UserIndex.down] = cc.p(self.the_size.width/2,  self.the_size.height/2-40)
    self.outing_cards_pos[UserIndex.right] = cc.p(self.head_pos[UserIndex.right].x-110, self.head_pos[UserIndex.right].y-5)
    self.outing_cards_pos[UserIndex.up] = cc.p(self.head_pos[UserIndex.up].x+110, self.head_pos[UserIndex.up].y-10)

    --时钟位置
    self.time_clock_pos={}
    self.time_clock_pos[0] = cc.p(self.the_size.width/2,-70*AUTO_HEIGHT+self.the_size.height/2)
    self.time_clock_pos[UserIndex.left] = cc.p(self.head_pos[UserIndex.left].x + 110, self.head_pos[UserIndex.left].y - 20)
    self.time_clock_pos[UserIndex.down] = cc.p(-140*AUTO_WIDTH+self.the_size.width/2,-70*AUTO_HEIGHT+self.the_size.height/2)
    self.time_clock_pos[UserIndex.right] = cc.p(self.head_pos[UserIndex.right].x - 110, self.head_pos[UserIndex.right].y - 20)
    self.time_clock_pos[UserIndex.up] = cc.p(self.head_pos[UserIndex.up].x + 110, self.head_pos[UserIndex.up].y - 20)

    --准备、不出位置
    self.ready_pos={}
    self.ready_pos[UserIndex.left] = cc.p(self.head_pos[UserIndex.left].x + 110, self.head_pos[UserIndex.left].y - 20)
    self.ready_pos[UserIndex.down] = cc.p(self.the_size.width/2,-70*AUTO_HEIGHT+self.the_size.height/2)
    self.ready_pos[UserIndex.right] = cc.p(self.head_pos[UserIndex.right].x - 110, self.head_pos[UserIndex.right].y - 20)
    self.ready_pos[UserIndex.up] = cc.p(self.head_pos[UserIndex.up].x + 110, self.head_pos[UserIndex.up].y - 20)

    --玩家剩余牌数位置
    self.left_cards_count_pos={}
    self.left_cards_count_pos[UserIndex.left] = cc.p(self.head_pos[UserIndex.left].x, self.head_pos[UserIndex.left].y+77)
    self.left_cards_count_pos[UserIndex.down] = cc.p(0,0)   --无用
    self.left_cards_count_pos[UserIndex.right] = cc.p(self.head_pos[UserIndex.right].x, self.head_pos[UserIndex.right].y+77)
    self.left_cards_count_pos[UserIndex.up] = cc.p(self.head_pos[UserIndex.up].x-85, self.head_pos[UserIndex.up].y)
end

--初始化场景信息
function gameMain:initBackGround()
    local l_bg=control_tools.newImg({path=BPRESOURCE("res/bg.jpg"),size = cc.size(self.the_size.width+20, self.the_size.height+20)})
    self.ptr_layout:addChild(l_bg)
    l_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    l_bg:setOpacity(255)

    local img_logo=control_tools.newImg({path=BPRESOURCE("res/logo.png")})
    l_bg:addChild(img_logo)
    img_logo:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2+100*AUTO_HEIGHT))

    local img_bg_bottom=control_tools.newImg({path=BPRESOURCE("res/bg_bottom.png"),size=cc.size(self.the_size.width,46), anchor=cc.p(0.5,0)})
    l_bg:addChild(img_bg_bottom)
    img_bg_bottom:setPosition(cc.p(self.the_size.width/2+10, 10))

    local img_bg_gold = control_tools.newImg({path=BPRESOURCE("res/bg_gold.png")})
    l_bg:addChild(img_bg_gold)
    img_bg_gold:setPosition(cc.p(310, 32))

    self.img_gold = control_tools.newImg({path=BPRESOURCE("res/head/gold.png")})
    l_bg:addChild(self.img_gold)
    self.img_gold:setPosition(cc.p(245, 32))

    local btn_recharge = control_tools.newBtn({small=true, normal=BPRESOURCE("res/recharge.png")})

    l_bg:addChild(btn_recharge)
    btn_recharge:setPosition(cc.p(380, 32))
    btn_recharge:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_recharge(param_sender,param_touchType) end)

    self.ptr_phone_info=UiPhoneInfo:create()
    self.ptr_phone_info:setPosition(cc.p(self.the_size.width-120,21))
    self.ptr_layout:addChild(self.ptr_phone_info)
    self.ptr_phone_info:showPhoneInfo()
end
--初始化按钮
function gameMain:initBtn()
    --固定显示按钮
    local btn_open_menu=control_tools.newBtn({normal=BPRESOURCE("res/menu/img_menu_open.png")})
    self.ptr_layout:addChild(btn_open_menu)
    btn_open_menu:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_open_menu(param_sender,param_touchType) end)
    btn_open_menu:setPosition(cc.p(self.the_size.width-40,self.the_size.height-40))
    btn_open_menu:setLocalZOrder(LZOrder.user_head)

    local btn_chat=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/btn_chat.png")})
    self.ptr_layout:addChild(btn_chat)
    btn_chat:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_open_menu(param_sender,param_touchType) end)
    btn_chat:setPosition(cc.p(self.the_size.width-40,self.the_size.height/2-70*AUTO_HEIGHT))
    btn_chat:setLocalZOrder(LZOrder.user_head)

    --非固定显示按钮
    self.btn_changetable=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/change_table.png")})
    self.ptr_layout:addChild(self.btn_changetable)
    self.btn_changetable:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_changetable(param_sender,param_touchType) end)
    self.btn_changetable:setPosition(cc.p(self.the_size.width/2-140,self.the_size.height/2-70*AUTO_HEIGHT))
    self.btn_changetable:setVisible(false)
    self.btn_changetable:setLocalZOrder(LZOrder.user_head)

    self.btn_ready=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/ready.png")})
    self.btn_ready:loadTextureDisabled(BPRESOURCE("res/table_btn/already.png"))
    self.ptr_layout:addChild(self.btn_ready)
    self.btn_ready:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_ready(param_sender,param_touchType) end)
    self.btn_ready:setPosition(cc.p(self.the_size.width/2+140,self.the_size.height/2-70*AUTO_HEIGHT))
    self.btn_ready:setVisible(false)
    self.btn_ready:setLocalZOrder(LZOrder.user_head)

    self.btn_sort_by_size=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/btn_sort_by_size.png")})
    self.ptr_layout:addChild(self.btn_sort_by_size)
    self.btn_sort_by_size:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_sort_by_size(param_sender,param_touchType) end)
    self.btn_sort_by_size:setPosition(cc.p(self.the_size.width - 75, 80))
    self.btn_sort_by_size:setVisible(false)
    self.btn_sort_by_size:setLocalZOrder(LZOrder.user_head)

    self.btn_sort_by_count=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/btn_sort_by_count.png")})
    self.ptr_layout:addChild(self.btn_sort_by_count)
    self.btn_sort_by_count:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_sort_by_count(param_sender,param_touchType) end)
    self.btn_sort_by_count:setPosition(cc.p(self.the_size.width - 75, 80))
    self.btn_sort_by_count:setVisible(false)
    self.btn_sort_by_count:setLocalZOrder(LZOrder.user_head)

    self.btn_out_card=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/btn_out_card.png")})
    self.btn_out_card:loadTextureDisabled(BPRESOURCE("res/table_btn/btn_out_card_dark.png"))
    self.ptr_layout:addChild(self.btn_out_card)
    self.btn_out_card:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_out_card(param_sender,param_touchType) end)
    self.btn_out_card:setPosition(cc.p(self.the_size.width/2+215*AUTO_WIDTH, self.the_size.height/2-70*AUTO_HEIGHT))
    self.btn_out_card:setVisible(false)
    self.btn_out_card:setLocalZOrder(LZOrder.user_head)

    self.btn_pass=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/btn_pass.png")})
    self.ptr_layout:addChild(self.btn_pass)
    self.btn_pass:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_pass(param_sender,param_touchType) end)
    self.btn_pass:setPosition(cc.p(self.the_size.width/2+5*AUTO_WIDTH, self.the_size.height/2-70*AUTO_HEIGHT))
    self.btn_pass:setVisible(false)
    self.btn_pass:setLocalZOrder(LZOrder.user_head)

    self.btn_hint=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/btn_tips.png")})
    self.ptr_layout:addChild(self.btn_hint)
    self.btn_hint:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_hint(param_sender,param_touchType) end)
    self.btn_hint:setPosition(cc.p(self.the_size.width/2-285*AUTO_WIDTH, self.the_size.height/2-70*AUTO_HEIGHT))
    self.btn_hint:setVisible(false)
    self.btn_hint:setLocalZOrder(LZOrder.user_head)

    self.btn_no_trust=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/btn_no_trust.png")})
    self.btn_no_trust:setPosition(cc.p(self.the_size.width/2,110))
    self.btn_no_trust:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_no_trust(param_sender,param_touchType) end)
    self.ptr_layout:addChild(self.btn_no_trust)
    self.btn_no_trust:setLocalZOrder(LZOrder.phone_info+1)--放在记牌器上面
    self.btn_no_trust:setVisible(false)

    self.btn_details=control_tools.newBtn({normal=BPRESOURCE("res/table_btn/btn_details.png")})
    self.ptr_layout:addChild(self.btn_details)
    self.btn_details:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_details(param_sender,param_touchType) end)
    self.btn_details:setPosition(cc.p(self.the_size.width - 75, 80))
    self.btn_details:setLocalZOrder(LZOrder.user_head)
    self.btn_details:setVisible(false)
end
--初始化菜单
function gameMain:initMenu()
    local bg_width = 300
    self.ptr_menu_layer = control_tools.newImg({path=BPRESOURCE("res/menu/bg_menu.png"), size=cc.size(bg_width, self.the_size.height), anchor=cc.p(1,0.5)})
    self.ptr_layout:addChild(self.ptr_menu_layer)
    self.ptr_menu_layer:setTouchEnabled(true)
    self.ptr_menu_layer:setPosition(cc.p(self.the_size.width, self.the_size.height/2))
    self.ptr_menu_layer:setVisible(false)
    self.ptr_menu_layer:setLocalZOrder(LZOrder.menu)


    local btn_close_menu = control_tools.newBtn({normal=BPRESOURCE("res/menu/img_menu_close.png")})
    self.ptr_menu_layer:addChild(btn_close_menu)
    btn_close_menu:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_close_menu(param_sender,param_touchType) end)
    btn_close_menu:setPosition(cc.p(bg_width-40, self.the_size.height-40))

    local btn_setting=control_tools.newBtn({normal=BPRESOURCE("res/menu/btn_setting.png")})
    self.ptr_menu_layer:addChild(btn_setting)
    btn_setting:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_open_setting(param_sender,param_touchType) end)
    btn_setting:setPosition(cc.p(bg_width-10, self.the_size.height-130))
    btn_setting:setAnchorPoint(1,0.5)

    local btn_rule=control_tools.newBtn({normal=BPRESOURCE("res/menu/btn_rule.png")})
    self.ptr_menu_layer:addChild(btn_rule)
    btn_rule:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_rule(param_sender,param_touchType) end)
    btn_rule:setPosition(cc.p(bg_width-10, self.the_size.height-210))
    btn_rule:setAnchorPoint(1,0.5)

    local btn_back=control_tools.newBtn({normal=BPRESOURCE("res/menu/btn_back.png")})
    self.ptr_menu_layer:addChild(btn_back)
    btn_back:addTouchEventListener(function(param_sender,param_touchType) UIHelper.on_btn_leave(param_sender,param_touchType) end)
    btn_back:setPosition(cc.p(bg_width-10, self.the_size.height-290))
    btn_back:setAnchorPoint(1,0.5)

    self.ptr_rule_layer= UiGameRule:create()
    self.ptr_layout:addChild(self.ptr_rule_layer)
    self.ptr_rule_layer:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self.ptr_rule_layer:setVisible(false)
    self.ptr_rule_layer:setLocalZOrder(LZOrder.menu)
end
--初始化时钟
function gameMain:initTimeClock()
    self.ptr_time_clock = UiTimeClock:create()
    self.ptr_time_clock:setPosition(self.time_clock_pos[0])
    self.ptr_layout:addChild(self.ptr_time_clock)
    self.ptr_time_clock:setLocalZOrder(LZOrder.table_timer)
    self.ptr_time_clock:setVisible(false)
end
--初始化头像
function gameMain:initUserHeads()
    for i=1,GamePlayer do
        self._map_head[i] = UIGameHead:create()
        self._map_head[i]:setPosition(self.head_pos[i])
        self.ptr_layout:addChild(self._map_head[i])
        self._map_head[i]:setLocalZOrder(LZOrder.user_head)
    end
end

--初始化自己手牌
function gameMain:initCardLayer()
    self.ptr_card_layer = ARCardLayer:create(self.the_size)
    self.ptr_card_layer:setPosition(cc.p(self.the_size.width/2, self.the_size.height/2))
    self.ptr_layout:addChild(self.ptr_card_layer)
    self.ptr_card_layer:setLocalZOrder(LZOrder.hand_card)

    self.ptr_card_layer:setGameMain(self)
end
--初始化出的牌
function gameMain:initOutingCards()
    for i=1, GamePlayer do
        self._map_outing_cards[i] = ARCardLayer:create()
        self.ptr_layout:addChild(self._map_outing_cards[i])
        self._map_outing_cards[i]:setCardsUserIndex(i)
        self._map_outing_cards[i]:setPosition(self.outing_cards_pos[i])
        self._map_outing_cards[i]:setLocalZOrder(LZOrder.hand_card)

        self._map_outing_cards[i]:setCardMaxSpeace(20)
        if i == UserIndex.down then
            self._map_outing_cards[i]:setCardScale(0.42)
        else
             self._map_outing_cards[i]:setCardScale(0.4)
        end
    end
end
--初始化"准备"字样
function gameMain:initReady()
    for i=1,GamePlayer do
        self._map_ready[i]=control_tools.newImg({path=BPRESOURCE("res/ready.png")})
        self.ptr_layout:addChild(self._map_ready[i])
        self._map_ready[i]:setPosition(self.ready_pos[i])
        self._map_ready[i]:setLocalZOrder(LZOrder.user_head)
        self._map_ready[i]:setVisible(false)
    end
end
--初始化"不出"字样
function gameMain:initPassInfo()
    for i=1, GamePlayer do
        self._map_pass[i]=control_tools.newImg({path=BPRESOURCE("res/no_card.png")})
        self.ptr_layout:addChild(self._map_pass[i])
        self._map_pass[i]:setPosition(self.ready_pos[i])
        self._map_pass[i]:setLocalZOrder(LZOrder.user_head)
        self._map_pass[i]:setVisible(false)
    end
end
--初始化其他玩家剩余手牌数量
function gameMain:initLeftCardsCount()
    for i=1,GamePlayer do
        self._map_left_cards_count[i] = control_tools.newImg({path=BPRESOURCE("res/head/bg_left_cards.png")})
        self._map_left_cards_count[i]:setPosition(self.left_cards_count_pos[i])
        self.ptr_layout:addChild(self._map_left_cards_count[i])
        self._map_left_cards_count[i]:setVisible(false)
        self._map_left_cards_count[i]:setLocalZOrder(LZOrder.user_head)

        self._map_left_cards_count[i].counts_label = control_tools.newLabel({fnt=BPRESOURCE("res/text_font/number_shuangkou_ypsl.fnt")})
        self._map_left_cards_count[i].counts_label:setPosition(cc.p(19.5,21.5))
        self._map_left_cards_count[i]:addChild(self._map_left_cards_count[i].counts_label)
    end
end

function gameMain:initGameEnd()
    self.ptr_game_end = UiGameEnd:create()
    self.ptr_layout:addChild(self.ptr_game_end)
    self.ptr_game_end:setPosition(cc.p(self.the_size.width/2, self.the_size.height/2))
    self.ptr_game_end:setLocalZOrder(LZOrder.game_end)
    self.ptr_game_end:setVisible(false)
    self.ptr_game_end:setGameMain(self)
end

function gameMain:initTips()
    --遮罩
    self._img_tip_mask = control_tools.newImg({path=BPRESOURCE("res/tip_mask.png"),size = cc.size(self.the_size.width,249)})
    self.ptr_layout:addChild(self._img_tip_mask)
    self._img_tip_mask:setAnchorPoint(cc.p(0.5, 0))
    self._img_tip_mask:setPosition(cc.p(self.the_size.width/2, 0))
    self._img_tip_mask:setLocalZOrder(LZOrder.user_head+1)
    self._img_tip_mask:setVisible(false)
    self._img_tip_mask:setTouchEnabled(true)

    --提示
    self._img_tips[TipsIndex.no_bigger_card] = control_tools.newImg({path=BPRESOURCE("res/img_no_bigger_cards.png")})
    self.ptr_layout:addChild(self._img_tips[TipsIndex.no_bigger_card])
    self._img_tips[TipsIndex.no_bigger_card]:setPosition(cc.p(self.the_size.width/2,100))
    self._img_tips[TipsIndex.no_bigger_card]:setLocalZOrder(LZOrder.user_head+1)
    self._img_tips[TipsIndex.no_bigger_card]:setVisible(false)

    self._img_tips[TipsIndex.opposite_card] = control_tools.newImg({path=BPRESOURCE("res/img_opposite_cards.png")})
    self.ptr_layout:addChild(self._img_tips[TipsIndex.opposite_card])
    self._img_tips[TipsIndex.opposite_card]:setPosition(cc.p(self.the_size.width/2,100))
    self._img_tips[TipsIndex.opposite_card]:setLocalZOrder(LZOrder.user_head+1)
    self._img_tips[TipsIndex.opposite_card]:setVisible(false)


    self._img_tips[TipsIndex.trust] = control_tools.newLabel({font = 22, color = cc.c3b(255,255,255)})
    self._img_tips[TipsIndex.trust]:setString("托管超限，您将被扣除额外金币作为惩罚")
    self.ptr_layout:addChild(self._img_tips[TipsIndex.trust])
    self._img_tips[TipsIndex.trust]:setPosition(cc.p(self.the_size.width/2,60))
    self._img_tips[TipsIndex.trust]:setLocalZOrder(LZOrder.user_head+1)
    self._img_tips[TipsIndex.trust]:setVisible(false)
end

function gameMain:initReCard()
    self.ptr_recard = UiReCard:create()
    self.ptr_layout:addChild(self.ptr_recard)
    self.ptr_recard:setPosition(self.the_size.width/2, 95)
    self.ptr_recard:setLocalZOrder(LZOrder.assist)
    self.ptr_recard:setVisible(false)

    self.ptr_recard:setData({8,8,8,8,8,8,8,8,8,8,8,8,8,2,2})
end

function gameMain:initUiMitilInfo()
    self.ptr_mutil_info = UiMutilInfo:create()
    self.ptr_layout:addChild(self.ptr_mutil_info)
    self.ptr_mutil_info:setLocalZOrder(LZOrder.assist)
    self.ptr_mutil_info:setPosition(self.the_size.width/2, self.the_size.height/2)
    self.ptr_mutil_info:setGameMain(self)
end

--初始化牌型动画
function gameMain:initCardTypeAni()
    for i=1,GamePlayer do
        self._map_card_type_ani_2[i] = ccs.Armature:create("shuangkou_donghua_baozha")
        self._map_card_type_ani_2[i]:setVisible(false)
        self._map_card_type_ani_2[i]:setPosition(self.outing_cards_pos[i])
        self.ptr_layout:addChild(self._map_card_type_ani_2[i])
        self._map_card_type_ani_2[i]:setLocalZOrder(LZOrder.user_head)

        self._map_card_type_ani_1[i] = ccs.Armature:create("shuangkou_donghua_baozha")
        self._map_card_type_ani_1[i]:setVisible(false)
        self._map_card_type_ani_1[i]:setPosition(self.outing_cards_pos[i]) 
        self.ptr_layout:addChild(self._map_card_type_ani_1[i])
        self._map_card_type_ani_1[i]:setLocalZOrder(LZOrder.user_head)
        self._map_card_type_ani_1[i]:getAnimation():setMovementEventCallFunc(function (armatureBack, movementType, movementID)
            if movementType ~= 0 then
                self._map_card_type_ani_1[i]:setVisible(false)
                self._map_card_type_ani_1[i]:setPosition(cc.p(self._map_outing_cards[i]:getPositionX(), self._map_outing_cards[i]:getPositionY()))
                self._map_card_type_ani_2[i]:setPosition(cc.p(self._map_outing_cards[i]:getPositionX(), self._map_outing_cards[i]:getPositionY()))
            end
        end)
    end
end

-----------------其他函数---------------
--播放离开房间动画
function gameMain:playerLeftAni(Pos)
    if not self.handle_sprite then
        self.handle_sprite=cc.Sprite:create()
        self.ptr_layout:addChild(self.handle_sprite)
    end
    self.handle_sprite:setPosition(Pos)
    self.handle_sprite:setVisible(true)
    local animation = cc.Animation:create()
    for i=1, 7 do
        local sprit_frame = cc.SpriteFrame:create((BPRESOURCE("res/head/") .. i .. ".png"),
                                            cc.rect(0, 0, 64, 84))
        animation:addSpriteFrame(sprit_frame)
    end
    animation:setDelayPerUnit(0.7 / 7)
    animation:setRestoreOriginalFrame(true)
    local act1 = cc.Animate:create(animation)
    local act2 = action_tools.CCCallFunc(function() self.handle_sprite:setVisible(false) end)
    local seq=action_tools.CCSequence(act1, act2)
    self.handle_sprite:stopAllActions()
    self.handle_sprite:runAction(seq)
end


-- 准备倒计时
function  gameMain:setOverReadyTime(timer_len, show_table_time)
    self._all_time = 0
    if show_table_time then
        self.ptr_time_clock:setTime(timer_len, true)
    end
    if self._time_schedule then
        CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
        self._time_schedule=nil
    end
    self._time_schedule=CCDirector:getInstance():getScheduler():scheduleScriptFunc(function(dt) self:scheduleTimer(dt) end , 0.1,false)
end

-- 倒计时事件
function gameMain:scheduleTimer(dt)
    self._time_num = self._time_num - dt
    self._all_time = self._all_time + dt
    if RoomMode ~= GameRoomMode.ROOM_MODE_FRIEND and isPlayedGame and IsLockRoom then
--     bit_tools._and(RoomType, GameRoomType.ROOM_KIND_LINEUP) <= 0 and 
--     bit_tools._and(RoomType, GameRoomType.NOCHEAT) <= 0 and 
        if self._all_time > LockRoomAutoOutTime then
            if self._time_schedule then
                CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
                self._time_schedule=nil
            end
            if IsAutoOut then
                self.ptr_game_frame:close_game();
                --("长时间未开始，已自动离开房间", "提示", 0)
            end
        end
    else
        if self._time_num < 0 then
            if self._time_schedule then
                CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
                self._time_schedule=nil
            end
            if IsAutoOut or not isPlayedGame then
                self.ptr_game_frame:close_game()
                --show_sysmessage_box("长时间未开始，已自动离开房间", "提示", 0)
            end
        end
    end

    
    if self._time_num > 0 then
        self.ptr_game_end:setLeftTime(math.modf(self._time_num))
    end
end

--更新准备状态
function gameMain:updateReadyStatus()
    if m_game_status == GameStatus.free then
        for i=1,GamePlayer do
            if self._map_head[i] and self._map_head[i]._img_head and self._map_head[i]:isVisible() then
                local user_data = self.ptr_game_frame:get_user_data_by_user_id(UserData[i].id)
                if user_data.cbUserStatus == UserStatus.us_ready then
                    self:showReady(i)
                end
            end
        end
    end
end

function gameMain:showReady(param_viewid)
    if param_viewid ~= UserIndex.down then
        self._map_ready[param_viewid]:setVisible(true)
        --audio_engine.game_effect("user_ready")
    end

end

--显示与隐藏"不出"字样
function gameMain:refreshPassInfo(bool_show, chairid)
    if chairid then
        local view_id = self:switch_to_view_id(chairid)
        self._map_pass[view_id]:setVisible(bool_show)
    else
        for i=1,GamePlayer do
            self._map_pass[i]:setVisible(bool_show or false)
        end
    end
end

--刷新提示信息
function gameMain:refreshTipsInfo(tips_id, bool_show_mask)
    self._img_tip_mask:setVisible(bool_show_mask or false)
    for i=1,3 do
        self._img_tips[i]:setVisible(false)
        if tips_id and tips_id == i then
            self._img_tips[i]:stopAllActions()
            self._img_tips[i]:setOpacity(255)
            if (OpenTrustPunish and tips_id == 3) or tips_id ~= 3 then
                self._img_tips[i]:setVisible(true)
            end
        end
    end

    if tips_id and tips_id == TipsIndex.trust then
        self.btn_no_trust:setVisible(true)
    elseif tips_id and tips_id == TipsIndex.no_bigger_card then
        local act1 = action_tools.CCDelayTime(1)
        local act2 = action_tools.CCFadeOut(2)
        local seq = action_tools.CCSequence(act1, act2)
        self._img_tips[tips_id]:runAction(seq)
    elseif tips_id and tips_id == TipsIndex.opposite_card then
        self.btn_no_trust:setVisible(false)
    end
end

function gameMain:clear_game_info(view_id)
    if view_id then
        if self._map_outing_cards[view_id] then
            self._map_outing_cards[view_id]:clearHandCards()
        end
        self._map_left_cards_count[view_id]:setVisible(false)
        self._map_pass[view_id]:setVisible(false)
        self._map_head[view_id]:showRank(false)
    else
        for i=1,GamePlayer do
            if self._map_outing_cards[i] then
                self._map_outing_cards[i]:clearHandCards()
            end
            self._map_left_cards_count[i]:setVisible(false)
            self._map_pass[i]:setVisible(false)
            self._map_head[i]:showRank(false)
        end
    end
end

function gameMain:shakeAct()
    local delaytime = action_tools.CCDelayTime(0.5)
    local jumpTo = action_tools.CCJumpTo(0.1, 5, 5, -10, 1)
    local jumpTo2 = action_tools.CCJumpTo(0.1,5, -5, -10, 1)
    local jumpTo3 = action_tools.CCJumpTo(0.1,-5, 5, -10, 1)
    local jumpTo4 = action_tools.CCJumpTo(0.1,-5, -5, -10, 1)
    local jumpTo4 = action_tools.CCJumpTo(0.1, 0, 0, -10, 1)
    self.ptr_layout:stopAllActions()
    self.ptr_layout:runAction(action_tools.CCSequence(delaytime, jumpTo, jumpTo2, jumpTo3, jumpTo4, jumpTo5));
end

function gameMain:showCardTypeAni(view_id, card_type, cards_count)
    self.shiftY = 0
    self.shiftX = 0
        if card_type == CardsType.stright_s then
        self.shiftY = 20
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_shunzi",-1,-1)
    elseif card_type == CardsType.stright_d then
        self.shiftY = 20
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_liandui",-1,-1)
    elseif card_type == CardsType.stright_t then
        self.shiftY = 20
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_liansanzhang",-1,-1)
    elseif card_type == CardsType.bomb_4 then
        self.shiftY = 20
        --audio_engine.game_effect("G_4")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_2[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_4xianzhadan",-1,0)
        self._map_card_type_ani_2[view_id]:getAnimation():play("shuangkou_4xianzhadan_Copy1",-1,0)
    elseif card_type == CardsType.bomb_5 then
        self.shiftY = 20
        --audio_engine.out_card_effect(UserData[view_id].sex,"5")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_2[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_5xianzhadan",-1,0)
        self._map_card_type_ani_2[view_id]:getAnimation():play("shuangkou_4xianzhadan_Copy1",-1,0)
    elseif card_type == CardsType.bomb_6 then
        self.shiftY = 20
        --audio_engine.out_card_effect(UserData[view_id].sex,"6")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_2[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_6xianzhadan",-1,0)
        self._map_card_type_ani_2[view_id]:getAnimation():play("shuangkou_4xianzhadan_Copy1",-1,0)
    elseif card_type == CardsType.bomb_7 then
        self.shiftY = 20
        --audio_engine.out_card_effect(UserData[view_id].sex,"7")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_2[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_7xianzhadan",-1,0)
        self._map_card_type_ani_2[view_id]:getAnimation():play("shuangkou_4xianzhadan_Copy1",-1,0)
    elseif card_type == CardsType.bomb_8 then
        self.shiftY = 20
        --audio_engine.out_card_effect(UserData[view_id].sex,"8")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_2[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_8xianzhadan",-1,0)
        self._map_card_type_ani_2[view_id]:getAnimation():play("shuangkou_4xianzhadan_Copy1",-1,0)
    elseif card_type == CardsType.bomb_9 then
        self.shiftY = 20
        --audio_engine.out_card_effect(UserData[view_id].sex,"9_10")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_2[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_9xianzhadan",-1,0)
        self._map_card_type_ani_2[view_id]:getAnimation():play("shuangkou_4xianzhadan_Copy1",-1,0)
    elseif card_type == CardsType.bomb_10 then
        self.shiftY = 20
        --audio_engine.out_card_effect(UserData[view_id].sex,"9_10")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_2[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_10xianzhadan",-1,0)
        self._map_card_type_ani_2[view_id]:getAnimation():play("shuangkou_4xianzhadan_Copy1",-1,0)
    elseif card_type == CardsType.bomb_11 then
        self.shiftY = 20
        --audio_engine.out_card_effect(UserData[view_id].sex,"9_10")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self._map_card_type_ani_2[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_11xianzhadan",-1,0)
        self._map_card_type_ani_2[view_id]:getAnimation():play("shuangkou_4xianzhadan_Copy1",-1,0)
    elseif card_type == CardsType.bomb_joker_3 then
        --audio_engine.out_card_effect(UserData[view_id].sex,"6")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_bz1",-1,0)
    elseif card_type == CardsType.bomb_joker_4 then
        --audio_engine.out_card_effect(UserData[view_id].sex,"7")
        self._map_card_type_ani_1[view_id]:setVisible(true)
        self:shakeAct()
        self._map_card_type_ani_1[view_id]:getAnimation():play("shuangkou_bz2")
    end

    
    if cards_count >10 then
        cards_count = 10
    end

    if self._map_fact_view_id[view_id] == UserIndex.left or self._map_fact_view_id[view_id] == UserIndex.up then
        self.shiftX = math.floor(cards_count/2) * 25 -20
    elseif self._map_fact_view_id[view_id] == UserIndex.right then
        self.shiftX = -1 * math.floor(cards_count/2) * 25 +20
    end
    local tmp_pos = cc.p(self._map_outing_cards[view_id]:getPositionX()+self.shiftX ,self._map_outing_cards[view_id]:getPositionY() - self.shiftY)
    self._map_card_type_ani_1[view_id]:setPosition(tmp_pos)
    self._map_card_type_ani_2[view_id]:setPosition(tmp_pos)
end

-----------服务器消息处理事件-----------
function gameMain:on_event_game_config(param_data)
    m_game_status = param_data.game_status
    ChangeTableTime = param_data.wait_change_table_time
    StartTime = param_data.start_time
    EndTime = param_data.end_time
    OutCardTime = param_data.out_card_time
    IsAutoReady = param_data.is_auto_ready
    OpenTrustPunish = (param_data.open_trust_punish == 1)
    ConsumeGold= param_data.consume_gold
    IsLockRoom=param_data.is_lock_room
    IsAutoOut=param_data.is_auto_out
    LockRoomAutoOutTime=param_data.lock_room_auto_out_time

    --好友房信息
    if param_data.room_code and param_data.curr_count and  param_data.total_count then
        FriendData.code = param_data.room_code
        FriendData.currcount = param_data.curr_count
        FriendData.totalcount = param_data.total_count
        self:refreshRoomInfo(RoomInfoIndex.room_id, param_data.room_code, (param_data.curr_count).."/"..param_data.total_count)
        if FriendData.currcount >= 1 then
            self._btn_record:setVisible(true)
        end
    end

    if m_game_status == GameStatus.free then
        --倒计时
        if RoomMode == GameRoomMode.ROOM_MODE_FRIEND or bit_tools._and(RoomType, GameRoomType.ROOM_KIND_LINEUP) > 0 then
        else
            self:setOverReadyTime(StartTime, true)
            self._time_num = StartTime
        end
        --self:showReadyMsg(true)
        if IsAutoReady == 1 then
            if self._time_schedule then
                CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
                self._time_schedule=nil
            end
        end
    else
        --防作弊场
        if bit_tools._and(RoomType, GameRoomType.NOCHEAT) > 0 then
            for i=1,GamePlayer do
                if i ~= UserIndex.down then
                    local chairid = game_tools.switch_to_chair_id(i)
                    local user_data=game_tools.decode(get_user_data(chairid))
                    self._map_head[i]:setUserData(user_data.user_id,user_data, i)
                end
            end
        end
        --self:initChatMessageAlter(self.chat_pos, self.emoji_pos, self._direction)

        --积分场
        if bit_tools._and(RoomType, GameRoomType.SCORE) > 0 then
            self:refreshRoomInfo(RoomInfoIndex.room_id, FriendData.code, (FriendData.currcount+1).."/"..FriendData.totalcount)
        end
        if self._time_schedule then
            CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
            self._time_schedule=nil
        end
    end
    --显示底分
    if param_data.base_gold then
        local gold = game_logic.getGoldText(param_data.base_gold)
        if RoomMode ~= GameRoomMode.ROOM_MODE_FRIEND then
            --self:refreshRoomInfo(RoomInfoIndex.base_gold, gold)
        else
            --self:refreshRoomInfo(RoomInfoIndex.base_gold, gold, (FriendData.currcount+1).."/"..FriendData.totalcount)
        end
    end

    self:updateReadyStatus()
end

function gameMain:on_event_button_power(param_data)
    UIHelper.on_button_power(param_data.visible_power, param_data.enable_power)

end

function gameMain:on_event_time_data(param_data)
    if param_data.show_id == -1 then
        if bit_tools._and(RoomType, GameRoomType.ROOM_KIND_LINEUP) > 0 then
            self.ptr_time_clock:setPosition(self.time_clock_pos[UserIndex.down])
        else
            self.ptr_time_clock:setPosition(self.time_clock_pos[0])
        end
    else
        local self_chair_id=self:switch_to_chair_id(UserIndex.down)
        local self_seat_id=self._map_seat[self_chair_id+1]
        local show_seat_id = self._map_seat[param_data.show_id+1]
        if(show_seat_id - self_seat_id + 4)%4 == 1 then
            self.ptr_time_clock:setPosition(self.time_clock_pos[UserIndex.right])
        elseif(show_seat_id - self_seat_id + 4)%4 == 2 then
            self.ptr_time_clock:setPosition(self.time_clock_pos[UserIndex.up])
        elseif(show_seat_id - self_seat_id + 4)%4 == 3 then
            self.ptr_time_clock:setPosition(self.time_clock_pos[UserIndex.left])
        elseif(show_seat_id - self_seat_id + 4)%4 == 0 then
            self.ptr_time_clock:setPosition(self.time_clock_pos[UserIndex.down])
        end
        --清除 即将出牌人 之前的出牌、不出信息
        local view_act_id = self:switch_to_view_id(param_data.show_id)
        if view_act_id == UserIndex.down then
            self.ptr_card_layer:clearOutCards()
        end
        self._map_outing_cards[view_act_id]:clearHandCards()
        --清除不出
        self:refreshPassInfo(false,param_data.show_id)
    end

    self.ptr_time_clock:setTime(param_data.timer_len, true)
    self.ptr_time_clock:setVisible(true)
end

function gameMain:on_event_game_start(param_data)
    if self._time_schedule then
        CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
        self._time_schedule=nil
    end
    isPlayedGame = true
    if not self.ptr_card_layer then
        self:initCardLayer()
        self:initOutingCards()
    end
    for i=1,GamePlayer do
        if self._map_ready[i] then
            self._map_ready[i]:setVisible(false)
        end
    end
    self._last_outing_cards_value={}
    self.btn_sort_by_size:setVisible(true)
    
    --防作弊场 暂缓
end

function gameMain:on_event_hand_cards(param_data)
    if not self.ptr_card_layer then
        self:initCardLayer()
        self:initOutingCards()
    end

    if not param_data.bool_ani then
        if self._sort_index == CardsSortIndex.size then
            self.ptr_card_layer:setSortFunc(game_logic.sort_cards_by_size)
        elseif self._sort_index == CardsSortIndex.count then
            self.ptr_card_layer:setSortFunc(game_logic.sort_cards_by_count)
        end
    end
    self.ptr_card_layer:setHandCardsByValue(param_data.hand_cards, #param_data.hand_cards, param_data.bool_ani)
end

function gameMain:on_event_show_hand_card_count(param_data)
    local view_id = self:switch_to_view_id(param_data.show_id)
    if view_id ~= UserIndex.down then  
        self._map_left_cards_count[view_id]:setVisible(true)
        self._map_left_cards_count[view_id].counts_label:setString(param_data.hand_cards_count)

        if param_data.hand_cards_count == 0 then
            self._map_left_cards_count[view_id]:setVisible(false)
        --到5张牌或以下的提示音 暂缓

        end
    end
end

function gameMain:on_event_light_card(param_data)
    local cards = {}
    if param_data.light_card_chair == param_data.opposite_light_card_chair then
        table.insert(cards, param_data.light_card)
        table.insert(cards, param_data.light_card)
        local view_id = self:switch_to_view_id(param_data.light_card_chair)
        local act1 = action_tools.CCDelayTime(1)
        local act2 = action_tools.CCCallFunc(function()
            self._map_outing_cards[view_id]:setHandCardsByValue(cards, #cards, true)  
        end)
        local act3 = action_tools.CCDelayTime(3)
        local act4 = action_tools.CCCallFunc(function()
            for i=1,GamePlayer do
                self._map_outing_cards[i]:clearHandCards()
            end
        end)
        local seq = action_tools.CCSequence(act1, act2, act3, act4)
        self.ptr_layout:runAction(seq)
    else
        table.insert(cards, param_data.light_card)
        local view_light_id = self:switch_to_view_id(param_data.light_card_chair)
        local view_opposite_id = self:switch_to_view_id(param_data.opposite_light_card_chair)
        local act1 = action_tools.CCDelayTime(1)
        local act2 = action_tools.CCCallFunc(function()
            self._map_outing_cards[view_light_id]:setHandCardsByValue(cards, #cards, true)  
        end)
        local act3 = action_tools.CCDelayTime(1)
        local act4 = action_tools.CCCallFunc(function()
            self._map_outing_cards[view_opposite_id]:setHandCardsByValue(cards, #cards, true)  
        end)
        local act5 = action_tools.CCDelayTime(2)
        local act6 = action_tools.CCCallFunc(function()
            for i=1,GamePlayer do
                self._map_outing_cards[i]:clearHandCards()
            end
        end)
        local seq = action_tools.CCSequence(act1, act2, act3, act4, act5, act6)
        self.ptr_layout:runAction(seq)
    end
end

function gameMain:on_event_change_seat(param_data)
    local self_chair_id = self:switch_to_chair_id(UserIndex.down)
    local self_seat_id = param_data.seat[self_chair_id + 1]

    if not self.ptr_card_layer then
        self:initCardLayer()
        self:initOutingCards()
    end
    for i=1,GamePlayer do
        self._map_seat[i] = param_data.seat[i]
        local chair_id = self:switch_to_chair_id(i)
        local seat_id = param_data.seat[chair_id+1]
        if (seat_id-self_seat_id+4)%4 == 1 then
            self._map_fact_view_id[i] = UserIndex.right
        elseif (seat_id - self_seat_id + 4)%4 == 2 then
            self._map_fact_view_id[i] = UserIndex.up
        elseif (seat_id - self_seat_id + 4)%4 == 3 then
            self._map_fact_view_id[i] = UserIndex.left
        elseif (seat_id - self_seat_id + 4)%4 == 0 then
            self._map_fact_view_id[i] = UserIndex.down
        end
        self._map_head[i]:setPosition(self.head_pos[self._map_fact_view_id[i]])
        self._map_head[i]:refreshRankPos( self._map_fact_view_id[i])
        self._map_outing_cards[i]:setPosition(self.outing_cards_pos[self._map_fact_view_id[i]])
        self._map_outing_cards[i]:setCardsUserIndex(self._map_fact_view_id[i])
        self._map_ready[i]:setPosition(self.ready_pos[self._map_fact_view_id[i]])
        self._map_pass[i]:setPosition(self.ready_pos[self._map_fact_view_id[i]])
        self._map_left_cards_count[i]:setPosition(self.left_cards_count_pos[self._map_fact_view_id[i]])
    end
end

function gameMain:on_event_out_card(param_data)
    isPlayedGame = true
    self._cur_out_card_id = param_data.act_id
    self._last_outing_id = param_data.show_id
    self.ptr_time_clock:setVisible(false)
    local view_id = self:switch_to_view_id(param_data.show_id)
    local view_act_id = self:switch_to_view_id(param_data.act_id)
    self._last_outing_cards_value = {}

    if view_id == UserIndex.down then
        if param_data.user_status == 1 then
            isTrust = true
        elseif param_data.user_status == 0 then
            isTrust = false
        end

        UIHelper.on_button_power(0,0)
    end

    

    for i=1,param_data.cards_count do
        table.insert(self._last_outing_cards_value, param_data.cards_value[i])
    end
    if param_data.cards_type >= CardsType.stright_s then
        self:showCardTypeAni(view_id, param_data.cards_type, param_data.cards_count)
    else
        self._map_card_type_ani_1[view_id]:setVisible(false)
        self._map_card_type_ani_2[view_id]:setVisible(false)
    end


    if view_id == UserIndex.down and isTrust then
        self.ptr_card_layer:setHandCardSelect(self._last_outing_cards_value, false)
        self.ptr_card_layer:doOutCards()
    end

    --牌型动画 暂缓

    if view_id ~= UserIndex.down then
        local cards = game_logic.sort_outing_cards(param_data.cards_value, param_data.cards_count)
        self._map_outing_cards[view_id]:setHandCardsByValue(cards, #cards, true)
    end

end

function gameMain:on_event_pass(param_data)
     self._cur_out_card_id = param_data.act_id
     local view_id = self:switch_to_view_id(param_data.show_id)
     local view_act_id = self:switch_to_view_id(param_data.act_id)

     self:refreshPassInfo(true, param_data.show_id)
     --若是新的一圈，则清除所有的出牌与不出
     if param_data.bool_new_cicle or self._cur_out_card_id == self._last_outing_id then
        IsPause = true
        self.ptr_game_frame:pause_message()
        local act1 = action_tools.CCDelayTime(0.5)
        local act2 = action_tools.CCCallFunc(function()
            self._last_outing_cards_value = {}
            self:refreshPassInfo(false)
            for i=1,GamePlayer do
                self._map_outing_cards[i]:clearHandCards()
            end
            self.ptr_card_layer:clearOutCards()

            self.ptr_game_frame:restore_message()
            IsPause = false
        end)
        local seq = action_tools.CCSequence(act1, act2)
        self.ptr_layout:runAction(seq)
     end
     self.ptr_time_clock:setVisible(false)
     UIHelper.on_button_power(0,0)
end

function gameMain:on_event_finish_info(param_data)
    m_game_status = param_data.game_status
    for i=1,GamePlayer do
        local chair_id = self:switch_to_chair_id(i)
        if param_data.rank[chair_id+1] == 0 then
            self._map_head[i]:showRank(param_data.rank[chair_id+1])
        end
    end
    self._sort_index = CardsSortIndex.size
    self.ptr_card_layer:setSortFunc(game_logic.sort_cards_by_size)
    UIHelper.on_button_power(0,0)
    self.btn_sort_by_size:setVisible(false)
    self.btn_sort_by_count:setVisible(false)
    self.ptr_time_clock:setVisible(false)

    self.ptr_game_end:setUserData(param_data)

    local act1 = action_tools.CCDelayTime(3)
    local act2 = action_tools.CCCallFunc(function()
        self.ptr_game_end:setVisible(true)
        self.ptr_game_end:setLeftTime(EndTime)
        self._time_num = EndTime
        self:setOverReadyTime(self._time_num)
        --好友房按钮显示 暂缓
    end)
    local seq = action_tools.CCSequence(act1, act2)
    self.ptr_game_end:runAction(seq)
    self._cur_out_card_id = -1
end

function gameMain:on_event_show_opposite_hand_cards(param_data)
    if not self.ptr_card_layer then
        self:initCardLayer()
        self:initOutingCards()
    end
    self._sort_index = CardsSortIndex.size
    self.ptr_card_layer:setHandCardsByValue(param_data.hand_cards, #param_data.hand_cards, false)
    self.ptr_card_layer:setSortFunc(game_logic.sort_cards_by_size)
    self.btn_sort_by_size:setVisible(false)
    self.btn_sort_by_count:setVisible(false)
    if isTrust then
        self:refreshTipsInfo()
        self.btn_no_trust:setVisible(false)
    end
    self:refreshTipsInfo(TipsIndex.opposite_card, true)
end

function gameMain:on_event_trust(param_data)
    local view_id = self:switch_to_view_id(param_data.show_id)
    if param_data.trust == 1 then --托管
        if view_id == UserIndex.down then
            self:refreshTipsInfo(TipsIndex.trust, true)
            isTrust = true
            if self.ptr_card_layer then
                self.ptr_card_layer:clearSelectStatus()
            end
        end
        self._map_head[view_id]:showRobot()
    else--不托管
        if view_id == UserIndex.down then
            self:refreshTipsInfo()
            self.btn_no_trust:setVisible(false)
            isTrust = false
        end
        self._map_head[view_id]:hideRobot()
    end
end

function gameMain:on_event_rest_hand_cards(param_data)
    local self_chair_id = self:switch_to_chair_id(UserIndex.down)
    if #param_data.rest_hand_cards[self_chair_id+1] <= 0 then
        self.ptr_card_layer:clearHandCards()
    end
    self:refreshPassInfo(false)

    local act1 = action_tools.CCDelayTime(1)
    local act2 = action_tools.CCCallFunc(function()
        for i = 1,GamePlayer do
            self._map_outing_cards[i]:clearHandCards()
        end
        self.ptr_card_layer:clearHandCards()
        self.ptr_card_layer:clearOutCards()
        self:refreshTipsInfo()
        for i = 1, GamePlayer do
            local view_id = self:switch_to_view_id(i-1)
            local hand_cards = param_data.rest_hand_cards[i]
            if #hand_cards > 0 then
                hand_cards = game_logic.sort_cards_by_size(hand_cards, #hand_cards)
                self._map_outing_cards[view_id]:setHandCardsByValue(hand_cards, #hand_cards, true)
            end
        end
    end)
    local seq = action_tools.CCSequence(act1, act2)
    self.ptr_layout:runAction(seq)
end

function gameMain:on_event_rest_cards_count(param_data)
    self.ptr_recard:setData(param_data.cards_count)
end

function gameMain:on_event_outing_cards(param_data)
    self._last_outing_id = param_data.last_out_cards_id
    self._cur_out_card_id = param_data.cur_out_cards_id
    self._last_outing_cards_value={}
    for i=1,GamePlayer do
        local chair_id = self:switch_to_chair_id(i)
        local outed_cards = {}
        for k,v in pairs(param_data.outed_cards[chair_id+1]) do
            table.insert(outed_cards, v)
            if self._last_outing_id == chair_id then
                table.insert(self._last_outing_cards_value, v)
            end
        end
        if chair_id ~= self._cur_out_card_id then
            self._map_outing_cards[i]:setHandCardsByValue(outed_cards, #outed_cards, true)
            if param_data.pass_info[chair_id+1] then
                self:refreshPassInfo(true, chair_id)
            end
        end
    end
end

function gameMain:on_event_mutil_change(param_data)
    if param_data.chair_id == -1 then
        self.ptr_mutil_info:setData(param_data, true)
    else
        self.ptr_mutil_info:setData(param_data)
    end
end

function gameMain:on_event_rank_info(param_data)
    local view_id = self:switch_to_view_id(param_data.show_id)
    if param_data.rank then
        self._map_head[view_id]:showRank(param_data.rank)
    end
end

---------------游戏通知----------------
function gameMain:on_game_message(int_main_id,data)
    print("gamelog>>on_game_message",int_main_id,data)
    local param_data = {}
    if data ~= nil and data ~= "" then
        param_data = json.decode(data or "")
    end
     
    if int_main_id ==S2CP.game_config then
        self:on_event_game_config(param_data)
    elseif int_main_id == S2CP.button_power then
        self:on_event_button_power(param_data)
    elseif int_main_id == S2CP.time_data then
        self:on_event_time_data(param_data)
    elseif int_main_id == S2CP.game_start then
        self:on_event_game_start(param_data)
    elseif int_main_id == S2CP.hand_cards then
        self:on_event_hand_cards(param_data)
    elseif int_main_id == S2CP.hand_card_count then
        self:on_event_show_hand_card_count(param_data)
    elseif int_main_id == S2CP.light_card then
        self:on_event_light_card(param_data)
    elseif int_main_id == S2CP.user_seat then
        self:on_event_change_seat(param_data)
    elseif int_main_id == S2CP.out_card then
        self:on_event_out_card(param_data)
    elseif int_main_id == S2CP.pass then
        self:on_event_pass(param_data)
    elseif int_main_id == S2CP.finish_info then
        self:on_event_finish_info(param_data)
    elseif int_main_id == S2CP.opposite_hand_cards then
        self:on_event_show_opposite_hand_cards(param_data)
    elseif int_main_id == S2CP.trust then
        self:on_event_trust(param_data)
    elseif int_main_id == S2CP.rest_hand_cards then
        self:on_event_rest_hand_cards(param_data)
    elseif int_main_id == S2CP.rest_cards_count then
        self:on_event_rest_cards_count(param_data)
    elseif int_main_id == S2CP.outing_card then
        self:on_event_outing_cards(param_data)
    elseif int_main_id == S2CP.mutil_change then
        self:on_event_mutil_change(param_data)
    elseif int_main_id == S2CP.rank_info then
        self:on_event_rank_info(param_data)
    end

end

function gameMain:on_game_user_left(ptr_user_data,bool_look)
    print("gamelog>>on_game_user_left",json.encode(ptr_user_data))
    --[[

    ]]--

    local l_view_id=self:switch_to_view_id(ptr_user_data.wChairID)
   
    if self._map_head[l_view_id] then 
        self._map_head[l_view_id]:setVisible(false)
        self._map_pass[l_view_id]:setVisible(false)
        self:playerLeftAni(cc.p(self._map_head[l_view_id]:getPositionX(), self._map_head[l_view_id]:getPositionY()))
    end
    self:clear_game_info(l_view_id)

--    if self._map_outing_cards[l_view_id] then
--        self._map_outing_cards[l_view_id]:clearHandCards()
--    end
--    self._map_left_cards_count[l_view_id]:setVisible(false)
end

--用户状态改变
function gameMain:on_game_user_status(ptr_user_data,bool_look)
    print("gamelog>>on_game_user_status",json.encode(ptr_user_data))
    local view_id = self:switch_to_view_id(ptr_user_data.wChairID)
    if ptr_user_data.cbUserStatus == UserStatus.us_ready then
        if view_id == UserIndex.down then
            self.ptr_time_clock:hide()
            if self._time_schedule then
                CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
                self._time_schedule=nil
            end
            self.btn_ready:setBright(false)
        else
            self:showReady(view_id)
            self:clear_game_info(view_id)
        end

    end
    if ptr_user_data.cbUserStatus == UserStatus.us_offline then
        self._map_head[view_id]:showRobot()
        if m_game_status == GameStatus.free then
            self:playerLeftAni(cc.p(self._map_head[view_id]:getPositionX(), self._map_head[view_id]:getPositionY()))
            self._map_pass[view_id]:setVisible(false)
            self:clear_game_info(view_id)
        end
    else
        self._map_head[view_id]:hideRobot()
    end

end 

function gameMain:on_game_user_enter(ptr_user_data,bool_look)
    print("gamelog>>on_game_user_enter",json.encode(ptr_user_data))
    --[[{"szName":"最讨厌产品1号","dwMasterRight":1,"wChairID":0,"wNetDelay":0,"lLostCount":5,0
    "wFaceID":0,"lCharm":493,"lWinCount":7,"lFleeCount":0,"cbGender":1,"wTableID":0,"lPraise":2,
    "cbUserStatus":2,"lScore":30,"dwUserID":9058537,"lGold":110000,"cbMember":0,"lDrawCount":6,
    "lExperience":150,"dwGroupID":0,"dwUserRight":837156904}]]--

    --hjj_for_game
    local l_view_id=self:switch_to_view_id(ptr_user_data.wChairID)

    UserData[l_view_id].nickname=ptr_user_data.szName
    UserData[l_view_id].id=ptr_user_data.dwUserID
    UserData[l_view_id].sex=ptr_user_data.cbGender

    print("gamelog>>enter_viewid:",l_view_id)
    if self._map_head[l_view_id]._img_head==nil  then
        self._map_head[l_view_id]:set_head(ptr_user_data, l_view_id);
    else 
        self._map_head[l_view_id]:update_head(ptr_user_data)
    end

    self._map_head[l_view_id]:setVisible(true)
    if l_view_id and l_view_id >0 and l_view_id <=4 then
        self._map_head[l_view_id]:setPosition(self.head_pos[l_view_id])
    end

end

function gameMain:on_game_user_data(ptr_user_data,bool_look)
    print("gamelog>>on_game_user_data",json.encode(ptr_user_data))
end
function gameMain:on_game_user_score(ptr_user_data,boo_look)
    print("gamelog>>on_game_user_score",json.encode(ptr_user_data))
end
function gameMain:on_game_user_chat(ptr_user_data,string_chat)
    print("gamelog>>on_game_user_chat",json.encode(ptr_user_data))
end


--tools
function gameMain:switch_to_view_id(param_chair_id)
    local view_id=self.ptr_game_frame:switch_to_view_id(param_chair_id)
    if view_id == 0 then
        view_id = 4
    end
    return view_id
end

function gameMain:switch_to_chair_id(param_view_id)
    if param_view_id == 4 then
        param_view_id = 0
    end
    local chair_id=self.ptr_game_frame:switch_to_chair_id(param_view_id)
    return chair_id
end

--设置外部函数
function gameMain:setExtraFunc(param_key,param_func)
    self._extra_func[param_key]=param_func
end



return gameMain