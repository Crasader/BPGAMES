local UIControl=require("src/ui_control")
local UIBank=class("UIBank",UIControl)
local g_path=BPRESOURCE("res/bank/")
sptr_bank=nil;
function UIBank:ctor(...)
    print("hjjlog>>UIBank")
    self.super:ctor(self)
    self.m_cash_original = 0
    self.m_deposit_original = 0
    self.m_cash = 0
    self.m_deposit = 0
    self.m_total_gold = 0
    self.m_unit_gold = 10000
    self:init();
end
function UIBank:destory()

end
function UIBank:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_bank.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getSize();

    --滑动条
    local l_slider_bg=control_tools.newImg({path=g_path.."slider_bar.png"})
    l_bg:addChild(l_slider_bg)
    l_slider_bg:setScale9Enabled(true)
    l_slider_bg:setCapInsets(cc.rect(50, 40, 180, 1))
    l_slider_bg:setContentSize(450,80)
    l_slider_bg:setPosition(cc.p(l_bg_size.width/2,l_bg_size.height/2+65))

    self.slider_bank=ccui.Slider:create()
    l_bg:addChild(self.slider_bank)
    self.slider_bank:setScale9Enabled(true)
    self.slider_bank:loadProgressBarTexture(g_path.."slider_progress_bar.png", 0)
    self.slider_bank:loadSlidBallTextureNormal(g_path.."slider_ball.png", 0)
    self.slider_bank:loadSlidBallTexturePressed(g_path.."slider_ball.png", 0)
    self.slider_bank:setCapInsets(cc.rect(16,21,32,0))
    self.slider_bank:setContentSize(390,42)
    self.slider_bank:setPosition(cc.p(l_bg_size.width/2,l_bg_size.height/2+66))
    self.slider_bank:addEventListener(function(ref,eventType) self:on_slider_move(ref,eventType)  end)


    --按钮
    local l_reset_btn=control_tools.newBtn({small=true, normal=g_path.."btn_reset.png"})
    l_bg:addChild(l_reset_btn)
    l_reset_btn:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_reset(param_sender,param_touchType) end)
    l_reset_btn:setPosition(cc.p(l_bg_size.width/2,l_bg_size.height/2-55))

    local l_quick_draw_btn=control_tools.newBtn({small=true, normal=g_path.."btn_quick_draw.png"})
    l_bg:addChild(l_quick_draw_btn)
    l_quick_draw_btn:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_quick_draw(param_sender,param_touchType) end)
    l_quick_draw_btn:setPosition(cc.p(130,l_bg_size.height/2-55))
    
    self.btn_add=control_tools.newBtn({small=true, normal=g_path.."btn_add.png"})
    l_bg:addChild(self.btn_add)
    self.btn_add:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_add(param_sender,param_touchType) end)
    self.btn_add:setPosition(cc.p(l_bg_size.width - 90,l_bg_size.height/2+66))

    self.btn_subtract=control_tools.newBtn({small=true, normal=g_path.."btn_subtract.png"})
    l_bg:addChild(self.btn_subtract)
    self.btn_subtract:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_subtract(param_sender,param_touchType) end)
    self.btn_subtract:setPosition(cc.p(90,l_bg_size.height/2+66))

    self.ptr_bg_quick_draw = control_tools.newImg({path=g_path.."bg_quick_draw.png"})
    l_bg:addChild(self.ptr_bg_quick_draw)
    self.ptr_bg_quick_draw:setPosition(cc.p(l_bg_size.width/2,l_bg_size.height/2+40))
    self.ptr_bg_quick_draw:setVisible(false)
    self.ptr_bg_quick_draw:setTouchEnabled(true)

    self.btn_draw_100k = control_tools.newBtn({small=true, normal=g_path.."100k.png"})
    self.btn_draw_100k:loadTextureDisabled(g_path.."100k_dark.png",0)
    self.btn_draw_100k:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_quick_draw_100k(param_sender,param_touchType) end)
    self.ptr_bg_quick_draw:addChild(self.btn_draw_100k)
    self.btn_draw_100k:setPosition(cc.p(100,90))
    self.btn_draw_100k:setBright(false)

    self.btn_draw_1m = control_tools.newBtn({small=true, normal=g_path.."1m.png"})
    self.btn_draw_1m:loadTextureDisabled(g_path.."1m_dark.png",0)
    self.btn_draw_1m:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_quick_draw_1m(param_sender,param_touchType) end)
    self.ptr_bg_quick_draw:addChild(self.btn_draw_1m)
    self.btn_draw_1m:setPosition(cc.p(300,90))
    self.btn_draw_1m:setBright(false)

    self.btn_draw_10m = control_tools.newBtn({small=true, normal=g_path.."10m.png"})
    self.btn_draw_10m:loadTextureDisabled(g_path.."10m_dark.png",0)
    self.btn_draw_10m:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_quick_draw_10m(param_sender,param_touchType) end)
    self.ptr_bg_quick_draw:addChild(self.btn_draw_10m)
    self.btn_draw_10m:setPosition(cc.p(500,90))
    self.btn_draw_10m:setBright(false)

    self.btn_deposit=control_tools.newBtn({small=true, normal=g_path.."btn_deposit.png"})
    l_bg:addChild(self.btn_deposit)
    self.btn_deposit:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_deposit(param_sender,param_touchType) end)
    self.btn_deposit:setPosition(cc.p(l_bg_size.width - 130,l_bg_size.height/2-55))
    self.btn_deposit:setVisible(false)

    self.btn_draw=control_tools.newBtn({small=true, normal=g_path.."btn_draw.png"})
    l_bg:addChild(self.btn_draw)
    self.btn_draw:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_draw(param_sender,param_touchType) end)
    self.btn_draw:setPosition(cc.p(l_bg_size.width - 130,l_bg_size.height/2-55))
    self.btn_draw:setVisible(false)

    self.btn_close=control_tools.newBtn({small=true, normal=g_path.."btn_close.png"})
    l_bg:addChild(self.btn_close)
    self.btn_close:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_close(param_sender,param_touchType) end)
    self.btn_close:setPosition(cc.p(l_bg_size.width - 130,l_bg_size.height/2-55))

    local label_cash_text = control_tools.newImg({path=g_path.."cash.png"})
    l_bg:addChild(label_cash_text)
    label_cash_text:setPosition(cc.p(100,l_bg_size.height-62))

    --现金金额
    self.label_cash = control_tools.newLabel({fnt=g_path.."fnt/num_dt_bxx.fnt"})
    l_bg:addChild(self.label_cash)
    self.label_cash:setPosition(cc.p(150,l_bg_size.height-63))
    self.label_cash:setAnchorPoint(cc.p(0,0.5))
    self.label_cash:setString("正在查询...")
    
    local label_deposit_text = control_tools.newImg({path=g_path.."deposit.png"})
    l_bg:addChild(label_deposit_text)
    label_deposit_text:setPosition(cc.p(l_bg_size.width/2+60,l_bg_size.height-62))

    --存款金额
    self.label_deposit = control_tools.newLabel({fnt=g_path.."fnt/num_dt_bxx.fnt"})
    l_bg:addChild(self.label_deposit)
    self.label_deposit:setPosition(cc.p(l_bg_size.width/2+110,l_bg_size.height-63))
    self.label_deposit:setAnchorPoint(cc.p(0,0.5))
    self.label_deposit:setString("正在查询...")

    --提示信息
    local label_tip1 = control_tools.newLabel({color=cc.c3b(149,83,40), font = 26})
    l_bg:addChild(label_tip1)
    label_tip1:setAnchorPoint(cc.p(0,0.5))
    label_tip1:setPosition(cc.p(50,85))
    label_tip1:setString("1.左滑动为取出, 右滑动为存入")

    local label_tip2 = control_tools.newLabel({color=cc.c3b(149,83,40), font = 26})
    l_bg:addChild(label_tip2)
    label_tip2:setAnchorPoint(cc.p(0,0.5))
    label_tip2:setPosition(cc.p(50,50))
    label_tip2:setString("2.通过 “+” . “-” 可以"..self.m_unit_gold .." 为单位进行调节")
end


function UIBank:on_btn_quick_draw(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self.ptr_bg_quick_draw:setVisible(not self.ptr_bg_quick_draw:isVisible())

    self:refreshQuickDrawBtn()
    
end

function UIBank:on_btn_quick_draw_100k(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if self.m_deposit >= 100000 then
        self.m_cash = self.m_cash+100000
        self.m_deposit = self.m_deposit - 100000

        self:refreshButton()
        self:refreshGold()
        self:refreshQuickDrawBtn()
    end
end

function UIBank:on_btn_quick_draw_1m(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if self.m_deposit >= 1000000 then
        self.m_cash = self.m_cash+1000000
        self.m_deposit = self.m_deposit - 1000000

        self:refreshButton()
        self:refreshGold()
        self:refreshQuickDrawBtn()
    end
end

function UIBank:on_btn_quick_draw_10m(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if self.m_deposit >= 10000000 then
        self.m_cash = self.m_cash+10000000
        self.m_deposit = self.m_deposit - 10000000

        self:refreshButton()
        self:refreshGold()
        self:refreshQuickDrawBtn()
    end
end

function UIBank:on_btn_reset(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self.m_cash = self.m_cash_original
    self.m_deposit = self.m_deposit_original
    self:refreshGold()
    self:refreshQuickDrawBtn()
    self.btn_close:setVisible(true)
    self.btn_deposit:setVisible(false)
    self.btn_draw:setVisible(false)
end

function UIBank:on_btn_add(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if self.m_cash > self.m_unit_gold then
        self.m_cash = (math.floor(self.m_cash/self.m_unit_gold)-1)*self.m_unit_gold
        self.m_deposit = self.m_total_gold - self.m_cash
    else
        self.m_cash = 0
        self.m_deposit = self.m_total_gold
    end
    self:refreshButton()
    self:refreshGold()
end

function UIBank:on_btn_subtract(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    
    local added_gold = (math.floor(self.m_cash/self.m_unit_gold)+1)*self.m_unit_gold
    if added_gold < self.m_total_gold then
        self.m_cash = added_gold
        self.m_deposit = self.m_total_gold - self.m_cash
    else
        self.m_cash = self.m_total_gold
        self.m_deposit = 0
    end
    self:refreshButton()
    self:refreshGold()
end

function UIBank:on_btn_draw(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local draw_gold = self.m_cash - self.m_cash_original
    if draw_gold > 0 then
        self:request_access_gold(draw_gold,1)
    end
end

function UIBank:on_btn_deposit(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local deposit_gold = self.m_cash_original - self.m_cash
    if deposit_gold > 0 then
        self:request_access_gold(deposit_gold,0)
    end
end

function UIBank:on_slider_move(ref,eventType)
    if eventType ~= 0 then
        return 
    end
    
    if self.m_total_gold == 0 then
        return
    end
    
    self.m_deposit = math.floor(self.m_total_gold * ref:getPercent()/100)
    self.m_cash = self.m_total_gold - self.m_deposit

    self:refreshButton()
    self:refreshGold()
end


--修改金币。
function UIBank:request_access_gold(param_gold,param_type)
    local req = URL.HTTP_ACCESS_GOLD
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{OPGOLD}",param_gold);
    req=bp_string_replace_key(req,"{OPTYPE}",param_type);

    bp_http_get("cyn_access_gold","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_access_gold(param_identifier,param_success,param_code,param_header,context) end,1)
end
--处理 数据。。
function UIBank:on_http_access_gold(param_identifier,param_success,param_code,param_header,context)
    print("cynlog>>222222222222222222",context)
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>request_task_data   fail");
        bp_show_hinting("存取金币失败")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode ~= 1 then 
        bp_show_hinting(l_data.resmsg)
        return
    else
        bp_show_hinting(l_data.resmsg)
    end

    self.m_cash_original = self.m_cash
    self.m_deposit_original = self.m_deposit

    self:refreshGold()
    self:refreshButton()
    bp_update_user_data(1)
end

--查询金币
function UIBank:request_query_gold()
    local req = URL.HTTP_QUERY_GOLD
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{RANKTYPE}",4);
    bp_http_get("cyn_query_gold","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_query_gold(param_identifier,param_success,param_code,param_header,context) end,1)
    
end

function UIBank:on_http_query_gold(param_identifier,param_success,param_code,param_header,context)
   self:clearLayout()
    if param_success~=true or param_code~=200 then 
        bp_show_hinting("查询金币失败")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end

    self.m_cash_original = l_data.resdata.bodygold
    self.m_deposit_original = l_data.resdata.gold
    self.m_cash = self.m_cash_original
    self.m_deposit = self.m_deposit_original
    self.m_total_gold = self.m_cash + self.m_deposit
    self:refreshGold()
end

function UIBank:refreshButton()
    if self.m_cash < self.m_cash_original then
        self.btn_close:setVisible(false)
        self.btn_deposit:setVisible(true)
        self.btn_draw:setVisible(false)
    elseif self.m_cash > self.m_cash_original then
        self.btn_close:setVisible(false)
        self.btn_deposit:setVisible(false)
        self.btn_draw:setVisible(true)
    else
        self.btn_close:setVisible(true)
        self.btn_deposit:setVisible(false)
        self.btn_draw:setVisible(false)
    end
end

function UIBank:refreshGold()
    self.label_cash:setString(self.m_cash)
    self.label_deposit:setString(self.m_deposit)
    self.slider_bank:setPercent(100-math.floor(100*self.m_cash/self.m_total_gold))
end

function UIBank:refreshQuickDrawBtn()
    self.btn_draw_100k:setBright(self.m_deposit >= 100000)
    self.btn_draw_1m:setBright(self.m_deposit >= 1000000)
    self.btn_draw_10m:setBright(self.m_deposit >= 10000000)
end

function UIBank:clearLayout()
    self.ptr_bg_quick_draw:setVisible(false)
end

function UIBank.ShowBank(param_show)
    if sptr_bank==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_bank=UIBank:create();
        main_layout:addChild(sptr_bank)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_bank:ShowGui(param_show)
    if param_show then 
        sptr_bank:request_query_gold()
    end
    return sptr_pay;
end

return UIBank