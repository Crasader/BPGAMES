local Layout_room=class("Layout_room",function() return ccui.Layout:create() end);
require "bptools/control_tools"
local UIHead=require("src/ui_head");
local RoomHall=require("src/RoomHall")
local g_path=BPRESOURCE("res/scene_room/")
local UILabelEx2=require("bptools/uilabelex2")
local UINotice=require("src/ui_notice")
local UITaskGuide=require("src/ui_taskguide")

--场景
local UIControl=require("src/ui_control")
local UIUserCenter=require("src/ui_usercenter")
local UITaskDay=require("src/ui_taskday")
local UIExchangeCenter=require("src/ui_exchangecenter")
local UIVipShop=require("src/ui_vipshop")
local UIShopCenter=require("src/ui_shopcenter")
local UIBank = require("src/ui_bank")
local UIBugle=require("src/ui_bugle")
local UIRule = require("src/ui_rule")


--游戏标识
local ROOM_MODE_NORMAL				=0			--普通场
local ROOM_MODE_MOBILE				=1			--移动场
local ROOM_MODE_FRIEND				=4			--好友场
local ROOM_MODE_REDPACKET			=8		--红包场

--local g_path=""
function Layout_room:ctor()
    print("hjjlog>>Layout_room")
    self.the_size=nil;
    self.ptr_layout_top=nil;
    self.ptr_layout_bottom=nil
    self.ptr_room_site=nil
    --各种layout
    self.ptr_layout_user_center=nil;

    self:init();
    --启动需要启动的东西。
    bp_application_run_fast(10002,"")
end

function Layout_room:destory()

end

function Layout_room:init()

    -- bp_set_common_value("test","2")
    -- bp_set_local_value("test_local","2")


    local  the_size=CCDirector:getInstance():getVisibleSize();
    self.the_size=the_size;
    local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA", function (eventCustom)
          self:on_update_user_data();
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    l_lister= cc.EventListenerCustom:create("MSG_DO_TASK", function (eventCustom)
        self:on_do_task(eventCustom);
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    -- local tt={}
    -- tt.command="frend:sendsms"
    -- self:on_do_task(tt)
    
    
    local l_bg=control_tools.newImg({path=g_path.."bg.png"})
    self:addChild(l_bg)
    l_bg:setPosition(cc.p(the_size.width/2,the_size.height/2))
    l_bg:setOpacity(100)
    
    --布局上方。
    self.ptr_layout_top=ccui.Layout:create()
    self:addChild(self.ptr_layout_top)
    self.ptr_layout_top:setContentSize(cc.p(self.the_size.width,80))
    self.ptr_layout_top:setPosition(cc.p(0,self.the_size.height-80));

    local l_btn_out=control_tools.newBtn({normal=g_path.."btn_return_1.png",small=true})
    l_btn_out:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_return(param_sender,param_touchType) end)
    self.ptr_layout_top:addChild(l_btn_out);
    l_btn_out:setPosition(cc.p(30,40))

    local l_layout_head=ccui.Layout:create();
    self.ptr_layout_top:addChild(l_layout_head);
    l_layout_head:setPosition(cc.p(100,0))

    local l_name_bg=control_tools.newImg({path=g_path.."img_name_bg.png"})
    l_layout_head:addChild(l_name_bg);
    l_name_bg:setPosition(110,40)
    l_name_bg:setTouchEnabled(true)
    l_name_bg:addTouchEventListener(function(param_sender,param_touchType) 
                    UIVipShop.ShowVipShop(true)
                end)

    local l_user_data=json.decode(bp_get_self_user_data());
    
    self.ptr_nickname=UILabelEx2:create();
    self.ptr_nickname:setAnchorPoint(cc.p(0,0.5));
    l_layout_head:addChild(self.ptr_nickname)
    self.ptr_nickname:setPosition(cc.p(40,40))
    self.ptr_nickname:setSystemFontSize(24)
    self.ptr_nickname:setTextEx(l_user_data.nickname,120)

    local l_head=UIHead:create();
    l_head:set_head(64,64)
    l_layout_head:addChild(l_head);
    l_head:setPosition(cc.p(0,40))

    local l_head_frame=control_tools.newBtn({normal=g_path.."head_frame.png",pressed=g_path.."head_frame.png"})
    l_layout_head:addChild(l_head_frame);
    l_head_frame:setPosition(cc.p(0,40));
    l_head_frame:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_head(param_sender,param_touchType) end);

    local l_vip=class_tools.get_vip();
    if l_vip==0 then 
        self.ptr_nickname:setTextColor(cc.c3b(240,232,165))
        self.ptr_img_vip=control_tools.newImg({path=g_path.."vip0.png"})
    else    
        self.ptr_nickname:setTextColor(cc.c3b(255,74,44))
        self.ptr_img_vip=control_tools.newImg({path=g_path.."vip"..(l_vip-1006)..".png"})
    end

    l_layout_head:addChild(self.ptr_img_vip);
    self.ptr_img_vip:setPosition(cc.p(190,40))

    --金币  
    local l_img_gold_bg=control_tools.newImg({path=g_path.."img_gold_bg.png"});
    self.ptr_layout_top:addChild(l_img_gold_bg)
    l_img_gold_bg:setPosition(cc.p(400,40))
    l_img_gold_bg:setTouchEnabled(true)
    l_img_gold_bg:addTouchEventListener(function(param_sender,param_touchType)  UIShopCenter.ShowShopCenter(true,0) end)

    local l_img_gold_icon=control_tools.newImg({path=g_path.."img_gold.png"})
    l_img_gold_bg:addChild(l_img_gold_icon)
    l_img_gold_icon:setPosition(cc.p(30,52/2-5))

    local l_btn_gold_add=control_tools.newBtn({normal=g_path.."btn_add.png",pressed=g_path.."btn_add.png"})
    l_img_gold_bg:addChild(l_btn_gold_add)
    l_btn_gold_add:setPosition(cc.p(150,52/2-3))
    l_btn_gold_add:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_add(param_sender,param_touchType)  end)
    if bp_have_mask_module(LC.MASK_MODULE_SHOP) ==0 then 
        l_btn_gold_add:setVisible(false)
    end

    self.ptr_label_gold=control_tools.newLabel({fnt=g_path.."num_dt_jbyb.fnt",anchor=cc.p(0,0.5)});
    l_img_gold_bg:addChild(self.ptr_label_gold)
    self.ptr_label_gold:setPosition(cc.p(55,52/2-6))
    if l_user_data.gold<1000000 then 
        self.ptr_label_gold:setString(l_user_data.gold)
    else 
        self.ptr_label_gold:setString(math.ceil( l_user_data.gold/10000 ))
    end

    --元宝
    local l_img_ingot_bg=control_tools.newImg({path=g_path.."img_gold_bg.png"});
    self.ptr_layout_top:addChild(l_img_ingot_bg)
    l_img_ingot_bg:setPosition(cc.p(570,40))
    l_img_ingot_bg:setTouchEnabled(true)
    l_img_ingot_bg:addTouchEventListener(function(param_sender,param_touchType)  UIShopCenter.ShowShopCenter(true,1) end)

    local l_img_ingot_icon=control_tools.newImg({path=g_path.."img_ingot.png"})
    l_img_ingot_bg:addChild(l_img_ingot_icon)
    l_img_ingot_icon:setPosition(cc.p(30,52/2-3))

    local l_btn_ingot_add=control_tools.newBtn({normal=g_path.."btn_add.png",pressed=g_path.."btn_add.png"})
    l_img_ingot_bg:addChild(l_btn_ingot_add)
    l_btn_ingot_add:setPosition(cc.p(150,52/2-2))
    l_btn_ingot_add:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_add(param_sender,param_touchType)  end)

    self.ptr_label_ingot=control_tools.newLabel({fnt=g_path.."num_dt_jbyb.fnt",anchor=cc.p(0,0.5)});
    l_img_ingot_bg:addChild(self.ptr_label_ingot)
    self.ptr_label_ingot:setPosition(cc.p(55,52/2-6))
    if l_user_data.ingot<1000000 then 
        self.ptr_label_ingot:setString(l_user_data.ingot)
    else
        self.ptr_label_ingot:setString(l_user_data.ingot)
    end

    --
    local l_btn_bank=control_tools.newBtn({normal=g_path.."btn_bank.png",small=true})
    self.ptr_layout_top:addChild(l_btn_bank)
    l_btn_bank:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_bank(param_sender,param_touchType) end )
    l_btn_bank:setPosition(cc.p(680,40))
    if bp_have_mask_module(LC.MASK_MODULE_BANK) ==0 then 
        l_btn_bank:setVisible(false)
    end
    if bp_have_mask_module(LC.MASK_MODULE_SHOP) ==0 then 
        l_img_ingot_bg:setVisible(false)
        l_btn_bank:setPosition(cc.p(510,40))
    end

    local l_btn_daily=control_tools.newBtn({normal=g_path.."btn_day_task.png",small=true})
    self.ptr_layout_top:addChild(l_btn_daily)
    l_btn_daily:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_daily(param_sender,param_touchType)  end)
    l_btn_daily:setPosition(cc.p(self.the_size.width-130,40))

    self.ptr_layout_taskguide=UITaskGuide:create();
    sptr_main_layout:addChild(self.ptr_layout_taskguide)

    local l_btn_notice=control_tools.newBtn({normal=g_path.."btn_message.png",small=true})
    self.ptr_layout_top:addChild(l_btn_notice)
    l_btn_notice:addTouchEventListener(function(param_sender,param_touchType)  self:on_btn_notice(param_sender,param_touchType)  end)
    l_btn_notice:setPosition(cc.p(self.the_size.width-45,40))

    local l_img_notice_point=control_tools.newImg({path=g_path.."img_point.png"})
    l_btn_notice:addChild(l_img_notice_point);
    l_img_notice_point:setPosition(cc.p(55,60))
    l_img_notice_point:setVisible(false);

    self.ptr_layout_notice=UINotice:create()
    sptr_main_layout:addChild(self.ptr_layout_notice);
    self.ptr_layout_notice:set_point(l_img_notice_point)
    

    --布局中间
    self.ptr_bugle=UIBugle:create();
    self:addChild(self.ptr_bugle)
    self.ptr_bugle:setPosition(cc.p(self.the_size.width/2-330,510))

    self.ptr_room_site=RoomHall:create();
    self:addChild(self.ptr_room_site)

    --布局下方。
    self.ptr_layout_bottom=ccui.Layout:create()
    self:addChild(self.ptr_layout_bottom)
    self.ptr_layout_bottom:setContentSize(cc.p(self.the_size.width,80))
    self.ptr_layout_bottom:setPosition(cc.p(0,0));

    local l_bottom_bg=control_tools.newImg({path=g_path.."bottom.png"})
    self.ptr_layout_bottom:addChild(l_bottom_bg);
    l_bottom_bg:setPosition(cc.p(self.the_size.width/2,25))
    
    local l_scale=self.the_size.width/960;
    if l_scale>0 then 
        l_bottom_bg:setScaleX(l_scale);
    end
    local l_list_bottom_btn={}

    local l_btn_shop=control_tools.newBtn({normal=g_path.."btn_setting.png",small=true})
    self.ptr_layout_bottom:addChild(l_btn_shop);
    l_btn_shop:addTouchEventListener(function(param_sender,param_touchType)  self:on_btn_shop(param_sender,param_touchType)  end)
    table.insert( l_list_bottom_btn, l_btn_shop );

    local l_btn_activity=control_tools.newBtn({normal=g_path.."btn_activity.png",small=true})
    self.ptr_layout_bottom:addChild(l_btn_activity)
    l_btn_activity:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_activity(param_sender,param_touchType) end)
    table.insert( l_list_bottom_btn,l_btn_activity )

    local l_btn_noble=control_tools.newBtn({normal=g_path.."noble.png",small=true})
    self.ptr_layout_bottom:addChild(l_btn_noble)
    l_btn_noble:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_noble(param_sender,param_touchType) end)
    table.insert(l_list_bottom_btn,l_btn_noble)


    local l_btn_exchange=control_tools.newBtn({normal=g_path.."exchange.png",small=true})
    self.ptr_layout_bottom:addChild(l_btn_exchange)
    l_btn_exchange:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_exchange(param_sender,param_touchType) end)
    table.insert( l_list_bottom_btn,l_btn_exchange )

    local l_btn_task=control_tools.newBtn({normal=g_path.."btn_task.png",small=true})
    self.ptr_layout_bottom:addChild(l_btn_task)
    l_btn_task:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_task(param_sender,param_touchType) end )
    table.insert( l_list_bottom_btn,l_btn_task )

    local l_btn_help=control_tools.newBtn({normal=g_path.."help.png",small=true})
    self.ptr_layout_bottom:addChild(l_btn_help)
    l_btn_help:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_help(param_sender,param_touchType) end )
    table.insert( l_list_bottom_btn,l_btn_help)

    local l_btn_customer=control_tools.newBtn({normal=g_path.."btn_customer.png",small=true})
    self.ptr_layout_bottom:addChild(l_btn_customer)
    l_btn_customer:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_customer(param_sender,param_touchType) end)
    table.insert(l_list_bottom_btn,l_btn_customer )

    local l_btn_setting=control_tools.newBtn({normal=g_path.."btn_setting.png",small=true})
    self.ptr_layout_bottom:addChild(l_btn_setting)
    l_btn_setting:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_set(param_sender,param_touchType) end)
    table.insert( l_list_bottom_btn,l_btn_setting )

    local l_btn_more=control_tools.newBtn({normal=g_path.."btn_more.png",small=true})
    self.ptr_layout_bottom:addChild(l_btn_more)
    l_btn_more:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_more(param_sender,param_touchType) end)
    table.insert( l_list_bottom_btn,l_btn_more)

    --
    local l_width=130;
    local l_interval_width=(self.the_size.width-130*2)/6
    for k,v in pairs(l_list_bottom_btn) do 
        v:setPosition(cc.p(l_width,40))
        l_width=l_width+l_interval_width;
    end
    

    local l_delay_time=cc.DelayTime:create(0.2)
    local l_ac_fun_1=cc.CallFunc:create(function() self:on_show_hint() end)
    self:runAction(cc.Sequence:create(l_delay_time,l_ac_fun_1))
end
--
function Layout_room:on_show_hint()
    local l_the_message={}
    l_the_message.id=0;
    l_the_message.message="抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。"
    --get_share_game_push():insert_message(l_the_message)
    bp_application_signal(10002,"INSERT_MESSAGE",json.encode(l_the_message))
    bp_application_signal(10002,"INSERT_MESSAGE",json.encode(l_the_message))

    self.ptr_bugle:play_bugle(l_the_message.message,10)
end

--展示
function Layout_room:show_game_room()
    

end
function Layout_room:on_update_user_data()
    local l_vip=class_tools.get_vip();
    if l_vip==0 then 
        self.ptr_nickname:setTextColor(cc.c3b(240,232,165))
        self.ptr_img_vip:loadTexture({path=g_path.."vip0.png"})
    else    
        self.ptr_nickname:setTextColor(cc.c3b(255,74,44))
        self.ptr_img_vip:loadTexture({path=g_path.."vip"..(l_vip-1006)..".png"})
    end

    local l_user_data=json.decode(bp_get_self_user_data());
    if l_user_data.gold<1000000 then 
        self.ptr_label_gold:setString(l_user_data.gold)
    else 
        self.ptr_label_gold:setString(math.ceil(l_user_data.gold/10000)) 
    end
    if l_user_data.ingot<1000000 then 
        self.ptr_label_ingot:setString(l_user_data.ingot)
    else 
        self.ptr_label_ingot:setString(math.ceil(l_user_data.ingot/10000))
    end
end

---按钮---
function Layout_room:on_btn_more(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end 
end
function Layout_room:on_btn_return(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("gamelog>>on_btn_return")
    self.ptr_room_site:back_to_hall()
end
--头像
function Layout_room:on_btn_head(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    UIUserCenter.ShowUserCenter(true)
end
function Layout_room:on_btn_add(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
end
--银行
function Layout_room:on_btn_bank(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if false then 
        print("hjjlog>>111");
        bp_application_run(218)
    end
    UIBank.ShowBank(true)
end
--日常
function Layout_room:on_btn_daily(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self.ptr_layout_taskguide:ShowGui(true)
end
--公告
function Layout_room:on_btn_notice(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self.ptr_layout_notice:ShowGui(true)
end
--商城
function Layout_room:on_btn_shop(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local UIShopCenter=require("src/ui_shopcenter")
    if self.ptr_layout_shopcenter==nil  then 
        self.ptr_layout_shopcenter=UIShopCenter:create();
        self:addChild(self.ptr_layout_shopcenter)
    end
    self.ptr_layout_shopcenter:ShowGui(true)

end
--活动
function Layout_room:on_btn_activity(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    bp_application_run(124)

end
--贵族
function Layout_room:on_btn_noble(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
end
--兑奖
function Layout_room:on_btn_exchange(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    UIExchangeCenter.ShowExchangeCenter(true,1)
end
--任务
function Layout_room:on_btn_task(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    UITaskDay.ShowTask(true)
end
--客服
function Layout_room:on_btn_customer(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
end
--玩法
function Layout_room:on_btn_help(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    UIRule.ShowRuleInfo()
end
--设置
function Layout_room:on_btn_set(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
end


function Layout_room:on_do_task(param_event)
    print("----------on_do_task-----------", param_event.command)
    local l_str_command=param_event.command
    local l_start,l_end=string.find( l_str_command,":" )
    local l_key=string.sub(l_str_command,1,l_start-1)
    local l_value=string.sub(l_str_command,l_end+1,string.len(l_str_command))
    print("hjjlog>>on_do_task:key:value:",l_key,l_value);

    if l_key=="enter" then 
        local l_int_value=tonumber(l_value)
        if l_int_value<1000 then 
            --快速进入游戏。
            self:quickly_enter_game(int_game_id)
        elseif l_int_value>10000 then 
            local int_game_id=math.floor( l_int_value/1000 )
            local int_site_id=math.floor( (l_int_value%1000)/100 )*100
            if int_site_id>499 then 
                return ;
            end
           self:quickly_enter_game(int_game_id,int_site_id)

        end
    elseif l_key=="enter_private_room" then 
        local l_start_1,l_end_1=string.find( l_value,"|" )
        local l_id=string.sub(l_value,1,l_start_1-1)
        local l_code=string.sub(l_value,l_end_1+1,string.len(l_value))

        local l_game_id=math.floor( l_id/1000 )
        local l_site_id=l_id%1000;
        print("hjjlog>>enter_private_room:",l_game_id,l_site_id,l_code);
        self:enter_private_room(l_game_id,l_site_id,l_code)
    elseif l_key == "open" then
        print("DY Log >> 显示商城 index = ", l_value)
        UIShopCenter.ShowShopCenter(true, l_value)
    end
end


function Layout_room:quickly_enter_game(param_game_id,param_site_id)
    param_game_id=param_game_id or 0
    param_site_id=param_site_id or 0 
    if bp_get_game_data(param_game_id)=="" then 
        bp_show_hinting("无法找到合适的游戏，请稍后再试")
        return ;
    end
    local int_enter_room_status=-1;--0成功。非零 0失败。
    local the_room_site=nil;
    if param_site_id==0 then 
        --最大房间。
        local vector_room_data=json.decode(bp_get_room_data_by_gameid(param_game_id))
        if #vector_room_data==0 then 
            bp_show_hinting("无法找到合适的房间，请稍后再试")
            return ;
        end
        local l_int_roomid=0;
        for k,v in pairs(vector_room_data) do
            local l_site_type=(v.roomid-v.roomid%100)/100
            if v.mode==ROOM_MODE_MOBILE then 
                int_enter_room_status=self:enter_site_test(v)
                if int_enter_room_status==0 then 
                    if v.roomid> l_int_roomid then 
                        l_int_roomid=l_int_roomid
                        the_room_site=v;
                    end
                end
            end
        end
    else
        --指定站点
        local vector_room_data=json.decode(bp_get_room_data_by_gameid(param_game_id))
        if #vector_room_data==0 then 
            bp_show_hinting("无法找到合适的房间，请稍后再试")
            return ;
        end
        for k,v in pairs(vector_room_data) do
            local l_site_type=(v.roomid-v.roomid%100)/100
            if l_site_type==(param_site_id-param_site_id%100)/100 then 
                the_room_site=v;
                int_enter_room_status=self:enter_site_test(v)
                break;
            end
        end
    end
    
    if the_room_site~=nil then 
        self:enter_site(param_game_id,the_room_site)
    else 
        if int_enter_room_status<0 then 
            --hjj_for_wait:simpleshop
        else
            bp_show_message_box("提示","您的金币已经超出本房间上限了，请将部分金币存入保险柜。",
            1,
            "确定","取消",
            function(param_1,param_2) UIBank.ShowBank(true)  end,
            function(param_1,param_2) end,0,"")
        end
    end
end
function Layout_room:enter_site_test(param_site_data)
    local l_user_data=json.decode(bp_get_self_user_data());
    if param_site_data.limit==nil then 
        return 0;
    end
    for k,v in pairs(param_site_data.limit) do 
        if v.id==4 then 
            if l_user_data.gold<v.value then
                return -1;
            end
        elseif v.id==8 then 
            if l_user_data.gold<v.value then
                return 1;
            end
        end
    end
    return 0;
end

function Layout_room:enter_site(parma_game_id,parma_site_data)
    local l_user_data=json.decode(bp_get_self_user_data());
    for k,v in pairs(parma_site_data.limit) do 
        if v.id==8 then 
            if l_user_data.gold>v.value then
                --最大金币。
                local vector_room_data=json.decode(bp_get_room_data_by_gameid(parma_game_id))
                if #vector_room_data==0 then 
                    bp_show_hinting("无法找到合适的房间，请稍后再试")
                    return ;
                end
                local l_bool_find=false;
                for k,v in pairs(vector_room_data) do
                    if v.mode==ROOM_MODE_MOBILE then 
                        int_enter_room_status=self:enter_site_test(v)
                        if int_enter_room_status==0 then 
                            l_bool_find=true;
                            return ;
                        end
                    end
                end
                if l_bool_find==true then
                    bp_show_message_box("提示","您的金币已经超出本房间上限了，快前往高分房间赢取更多金币吧！",
                    1,
                    "去高级场","稍后再说",
                    function(param_1,param_2) self:quickly_enter_game(parma_game_id)  end,
                    function(param_1,param_2) end,0,"")
                    return ;
                else
                    bp_show_message_box("提示","您的金币已经超出本房间上限了，请将部分金币存入保险柜。",
                    1,
                    "去高级场","稍后再说",
                    function(param_1,param_2) UIBank.ShowBank(true)  end,
                    function(param_1,param_2) end,0,"")
                    return ;
                end
            end
        end
    end
    --hjj_for_tip:有个/r 导致结构体错误
    local vector_room_data=json.decode(bp_get_room_data_by_gameid(parma_game_id))
    vector_room_data=json.decode(bp_string_replace_key(bp_get_room_data_by_gameid(parma_game_id),"\\r",""))
    local list_room_data={}
    for k,v in pairs(vector_room_data) do
        local l_type=(v.roomid-v.roomid%100)
        if math.floor(v.roomid/100)==math.floor(parma_site_data.roomid/100) then 
            table.insert( list_room_data,v )
        end
    end
    if #list_room_data==0 then 
        bp_show_hinting("没有找到对应的房间(1)")
    end
    math.newrandomseed();
    local l_index=math.random(1,#list_room_data)
    print("hjjlog>>bp_application_signal:",json.encode(list_room_data[l_index]));
    
    bp_application_run(list_room_data[l_index].gameid,"")
    bp_application_signal(list_room_data[l_index].gameid,"init_game_room",json.encode(list_room_data[l_index]))
   -- bp_application_run(list_room_data[l_index].gameid,json.encode(list_room_data[l_index]));
end

function Layout_room:enter_private_room(param_game_id,param_site_id,param_code)
    if bp_get_game_data(param_game_id)=="" then 
        bp_show_hinting("无法找到合适的游戏，请稍后再试")
        return ;
    end

    --指定站点
    local vector_room_data=json.decode(bp_get_room_data_by_gameid(param_game_id))
    print("hjjlog>>vector_room_data222:",bp_get_room_data_by_gameid(param_game_id));
    
    if #vector_room_data==0 then 
        bp_show_hinting("无法找到合适的房间，请稍后再试")
        return ;
    end
    local int_enter_room_status=0;
    local the_room_site=nil;
    for k,v in pairs(vector_room_data) do    
        if v.roomid==param_site_id then 
            the_room_site=v;
            --self:enter_site_test(v)
            break;
        end
    end
    if the_room_site==nil then 
        bp_show_hinting("无法找到合适的房间，请稍后再试")
    end
    the_room_site.code=param_code
    bp_application_run(param_game_id,"")
    bp_application_signal(param_game_id,"init_game_room_with_code",json.encode(the_room_site))

end




function Layout_room:on_btn_test_game(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("gamelog>>on_btn_test_game") 
    bp_application_run(107);
end

return Layout_room;