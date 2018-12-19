local UIControl=require("src/ui_control")
local UIVipShop=class("UIVipShop",UIControl)
local g_path=BPRESOURCE("res/vip/")
local UIMiniUserData=require("src/ui_miniuserdata")
local UIShopCenter=require("src/ui_shopcenter")
sptr_vip_shop=nil;
function UIVipShop:ctor(...)
    print("hjjlog>>UIVipShop")
    self.super:ctor(self)
    self.list_item_sleep={}
    self.list_item={}
    self:init();
end
function UIVipShop:destory()

end
function UIVipShop:init()
        local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA", function (eventCustom)
              self:on_update_user_data();
        end)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_vip.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();
    
    local l_img=control_tools.newImg({path=g_path.."img_back.png",size=cc.size(784,450)});
    l_bg:addChild(l_img)
    l_img:setPosition(cc.p(l_bg_size.width/2,l_bg_size.height/2+25))

    local l_bg_title=control_tools.newImg({path=g_path.."title.png"})
    l_bg:addChild(l_bg_title)
    l_bg_title:setPosition(cc.p(l_bg_size.width/2,500-10))

    local l_img_type=control_tools.newImg({path=g_path.."img_type.png"})
    l_bg:addChild(l_img_type)
    l_img_type:setPosition(cc.p(70,490))

    local l_x=210
    for i=1,4 do  
        local l_img_vip=control_tools.newImg({path=g_path.."vip_"..i..".png"})
        l_bg:addChild(l_img_vip)
        l_img_vip:setPosition(cc.p(l_x,490))
        l_x=l_x+165
    end

    -- local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=cc.size(760,330),anchor=cc.p(0,0)})
    -- l_bg:addChild(test_bg);
    -- test_bg:setPosition(cc.p(30,135))

    local l_drag_bg=control_tools.newImg({path=g_path.."drag_back.png",anchor=cc.p(0,0)})
    l_bg:addChild(l_drag_bg)
    l_drag_bg:setPosition(cc.p(27,128))

    self.ptr_scrollview=ccui.ScrollView:create();
    l_bg:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(cc.size(760,330))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)
    self.ptr_scrollview:setPosition(cc.p(30,135))

    local l_prop_count=0 
    for k,v in pairs(VIPDATA) do
        if #v.prop>l_prop_count then 
            l_prop_count=#v.prop;
        end
    end
    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,48*5 + 25 * l_prop_count+10)

    if the_scrollview_size.height< self.ptr_scrollview:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)


     
    local  t_float_height = the_scrollview_size.height-20;
    local  t_float_space_height = 48;
    for i=1,6 do
        local t_title=control_tools.newImg({path=g_path.."line_"..i..".png"})
        self.ptr_scrollview:addChild(t_title)
        t_title:setPosition(cc.p(48,t_float_height))
        local l_line=control_tools.newImg({path=g_path.."line.png"})
        self.ptr_scrollview:addChild(l_line)
        l_line:setPosition(cc.p(832/2,t_float_height+24))
        t_float_height=t_float_height-t_float_space_height;
    end


    local  t_float_weight = 185;
	local t_float_space_weight =168;
    for k,v in pairs(VIPDATA) do
        t_float_height = the_scrollview_size.height - 20;
        local l_label=control_tools.newLabel({font=20,color=cc.c3b(162, 105, 67)})
        self.ptr_scrollview:addChild(l_label)
        l_label:setString(v.gold)
        l_label:setPosition(cc.p(t_float_weight,t_float_height))
        t_float_height=t_float_height-t_float_space_height;

        l_label=control_tools.newLabel({font=20,color=cc.c3b(162, 105, 67)})
        self.ptr_scrollview:addChild(l_label)
        l_label:setString(v.award)
        l_label:setPosition(cc.p(t_float_weight,t_float_height))
        t_float_height=t_float_height-t_float_space_height;
        
        local l_img_check=control_tools.newImg({path=g_path.."img_sure.png"})
        self.ptr_scrollview:addChild(l_img_check)
        l_img_check:setPosition(cc.p(t_float_weight,t_float_height))
        t_float_height=t_float_height-t_float_space_height;

        l_img_check=control_tools.newImg({path=g_path.."img_sure.png"})
        self.ptr_scrollview:addChild(l_img_check)
        l_img_check:setPosition(cc.p(t_float_weight,t_float_height))
        t_float_height=t_float_height-t_float_space_height;

        l_label=control_tools.newLabel({font=20,color=cc.c3b(162, 105, 67)})
        self.ptr_scrollview:addChild(l_label)
        l_label:setString(v.day.."天")
        l_label:setPosition(cc.p(t_float_weight,t_float_height))
        t_float_height=t_float_height-t_float_space_height;

        for n,m in pairs(v.prop) do 
            if bp_get_prop_data(m.id)~="" then 
                local l_prop_data=json.decode(bp_get_prop_data(m.id))
                l_label=control_tools.newLabel({font=20,color=cc.c3b(162, 105, 67)})
                self.ptr_scrollview:addChild(l_label)
                l_label:setString(l_prop_data.name.."X"..m.count)
                l_label:setPosition(cc.p(t_float_weight,t_float_height))
                t_float_height=t_float_height-25;      
            end
        end
        t_float_weight = t_float_weight + t_float_space_weight;
    end 
    local l_img_price=control_tools.newImg({path=g_path.."img_price.png"})
    l_bg:addChild(l_img_price)
    l_img_price:setPosition(cc.p(68,100))

    local l_point_btn_x=213
    for k,v in pairs(VIPDATA) do
        local l_btn=control_tools.newBtn({normal=g_path.."price_back.png",small=true})
        l_btn:setPosition(cc.p(l_point_btn_x,100))
        l_btn:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_buy(param_sender,param_touchType) end)
        l_btn.id=v.id  
        l_btn.price=v.price
        l_btn.name=v.name
        l_bg:addChild(l_btn) 
        local l_label_price=control_tools.newLabel({fnt=g_path.."dj_btn.fnt"});
        l_btn:addChild(l_label_price)
        l_label_price:setString(v.price.."元宝")
        l_label_price:setPosition(cc.p(81,23))
        l_point_btn_x=l_point_btn_x+t_float_space_weight;
    end
    self.ptr_mini_user_data=UIMiniUserData:create()
    self:get_gui():addChild(self.ptr_mini_user_data);
    self.ptr_mini_user_data:setPosition(cc.p(10,8))
    self.ptr_mini_user_data:switch_type(14,"您还不是会员或者会员已过期，赶紧开通吧")
    self:on_update_user_data();

end
function UIVipShop:on_btn_buy(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return;
    end
    
    local l_user_data=json.decode(bp_get_self_user_data())
    if l_user_data.ingot<param_sender.price then 
        bp_show_message_box("提示","你没有足够的元宝开通此会员，请先充值元宝",1,"充值","取消",
                            function(param_1,param_2)  self:on_btn_get_ingot_ok(param_1,param_2)  end,
                            function(param_1,param_2) end,0,"")
    else
        bp_show_message_box("提示","你确定花费【"..param_sender.price.."】元宝开通【"..param_sender.name.."】？",1,
                            "立即开通","稍后再说",
                            function(param_1,param_2)  self:on_btn_get_vip_ok(param_1,param_2)  end,
                            function(param_1,param_2) end,param_sender.id,"")
    end
end
function UIVipShop:on_btn_get_vip_ok(param_1,param_2)
    print("hjjlog>>get_vip_ok:",param_1,param_2);
    bp_show_loading(1)
    local req = URL.HTTP_BUY_PROP
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{PROPID}",param_1);
    req=bp_string_replace_key(req,"{PROPCOUNT}",1);
    req=bp_string_replace_key(req,"{USETYPE}",1);
    print("hjjlog>>get_vip_ok",req);
    bp_http_get(""..param_1,"",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_buy_prop(param_identifier,param_success,param_code,param_header,context) end,1)
    
end
function UIVipShop:on_btn_get_ingot_ok(param_1,param_2)
    UIShopCenter.ShowShopCenter(true,1);
end

function UIVipShop:on_http_buy_prop(param_identifier,param_success,param_code,param_header,context)
    bp_show_loading(0)
    if param_success~=true or param_code~=200 then 
        bp_show_hinting("on_http_buy_prop")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    bp_update_user_data(1);
    bp_show_hinting(l_data.resmsg)
end
function UIVipShop:on_update_user_data()
    
    local l_user_data=json.decode(bp_get_self_user_data());

    local l_data=bp_get_self_prop_status(0)
    local user_prop_status=json.decode(l_data)

    local l_max_vip=0;
    local l_vip_time=0;
    for k,v in pairs(user_prop_status) do
        if v.time>os.time() then  
            if l_max_vip< v.id then 
                l_max_vip=v.id
                l_vip_time=v.time
            end
        end
    end
    --return l_max_vip
    if l_max_vip==0 then 
        self.ptr_mini_user_data:switch_type(14,"您还不是会员或者会员已过期，赶紧开通吧")
    else
        if bp_get_prop_status_data(l_max_vip)~="" then 
            local t_status_data=json.decode(bp_get_prop_status_data(l_max_vip))
            local l_str_time= os.date("%Y-%m-%d",l_vip_time)
            self.ptr_mini_user_data:switch_type(14,t_status_data.name.."<color value=0xfff8e967>"..l_str_time.."<color value=0xfff9f6de>过期")
        else
            self.ptr_mini_user_data:switch_type(14,"您还不是会员或者会员已过期，赶紧开通吧")
        end
    end

end




function UIVipShop.ShowVipShop(param_show)
    if sptr_vip_shop==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_vip_shop=UIVipShop:create();
        main_layout:addChild(sptr_vip_shop)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_vip_shop:ShowGui(param_show)
    return sptr_vip_shop;
end


return UIVipShop
