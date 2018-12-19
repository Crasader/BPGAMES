local UIControl=require("src/ui_control")
local UISimpleShop=class("UISimpleShop",UIControl)
local g_path=BPRESOURCE("res/simpleshop/")
sptr_simple_shop=nil
function UISimpleShop:ctor(...)
    print("hjjlog>>UISimpleShop")
    self.super:ctor(self)
    self.list_item_sleep={}
    self.list_item={}
    self:init();
end
function UISimpleShop:destory()

end
function UISimpleShop:init()
    self:set_bg(g_path.."bg_gold_gift.png")
    self:update_layout();
    self:set_touch_bg(true)
    local the_bg=self:get_gui();

    self.ptr_btn_shop=control_tools.newBtn({normal=g_path.."btn_shop.png",small=true})
    the_bg:addChild(self.ptr_btn_shop)
    self.ptr_btn_shop:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_shop(param_sender,param_touchType) end)


    self.ptr_btn_share=control_tools.newBtn({normal=g_path.."btn_share.png",small=true})
    the_bg:addChild(self.ptr_btn_share)
    self.ptr_btn_share:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_share(param_sender,param_touchType) end)

    self.ptr_btn_buy=control_tools.newBtn({normal=g_path.."btn_buy.png",small=true})
    the_bg:addChild(self.ptr_btn_buy)
    self.ptr_btn_buy:setPosition(cc.p(550/2,70));
    self.ptr_btn_buy:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_buy(param_sender,param_touchType) end)

    self.ptr_label_gold=control_tools.newLabel({fnt=g_path.."num_jinqian.fnt"});
    the_bg:addChild(self.ptr_label_gold)
    self.ptr_label_gold:setPosition(cc.p(100,340))
    self.ptr_label_gold:setRotation(-10)


    self.ptr_label_prop_name=control_tools.newLabel({fnt=g_path.."num_dt_lbd.fnt",anchor=cc.p(0,0.5)});
    the_bg:addChild(self.ptr_label_prop_name)
    self.ptr_label_prop_name:setPosition(cc.p(550/2,160))

    self.ptr_label_prop_name_append=control_tools.newLabel({fnt=g_path.."num_dt_lbx.fnt",anchor=cc.p(0,0.5)});
    the_bg:addChild(self.ptr_label_prop_name_append)
    

    self.ptr_label_hint=control_tools.newLabel({font=26,color=cc.c3b(158,101,64)})
    the_bg:addChild(self.ptr_label_hint)
    self.ptr_label_hint:setPosition(cc.p(550/2,144))
end



function UISimpleShop:switch_visiable_type(param_type)
    self.ptr_label_gold:setVisible(false)
    self.ptr_label_gold:setVisible(false)
    self.ptr_label_prop_name:setVisible(false)
    self.ptr_label_prop_name_append:setVisible(false)
    self.ptr_btn_share:setVisible(false)
    self.ptr_btn_shop:setVisible(false)
    self.ptr_btn_buy:setVisible(false)

    --金币and救济金
    print("hjjlog>>simpshop:4444444444",param_type);
    self.m_pay_type=param_type
    if param_type== 1 then 
        local l_user_data=json.decode(bp_get_self_user_data());
        self:set_bg(g_path.."bg_gold_share.png")
        self:update_layout();
        local l_str=bp_get_common_text(16)        
        l_str=bp_string_replace_key(l_str,"{COUNT}",l_user_data.relief_count_gold)
        self.ptr_label_hint:setVisible(true)
        self.ptr_label_hint:setString(l_str)
        self.ptr_btn_share:setVisible(true)
        self.ptr_btn_shop:setVisible(true)
        self.ptr_btn_shop:setPosition(cc.p(550/2-100,70))
        self.ptr_btn_share:setPosition(cc.p(550/2+100,70))
    elseif param_type==2 then 
        local l_user_data=json.decode(bp_get_self_user_data());
        self:set_bg(g_path.."bg_gold_share.png")
        self:update_layout();
        local l_str=bp_get_common_text(16)
        l_str=bp_string_replace_key(l_str,"{COUNT}",l_user_data.relief_count_gold)
        self.ptr_label_hint:setVisible(true)
        self.ptr_label_hint:setString(l_str)
        self.ptr_btn_share:setVisible(true)
        self.ptr_btn_share:setPosition(cc.p(550/2,70))
    elseif param_type==3 then 
        local l_user_data=json.decode(bp_get_self_user_data());
        self:set_bg(g_path.."bg_gold_buy.png")
        self:update_layout();
        self.ptr_label_prop_name:setVisible(true)
        self.ptr_label_gold:setVisible(true)
        self.ptr_label_gold:setString(self.m_the_product_data.price.."元")
        self.ptr_label_prop_name:setString(self.m_the_product_data.name)
        local l_size_name=self.ptr_label_prop_name:getContentSize();
        if self.m_the_product_data.caption~="" then 
            self.ptr_label_prop_name_append:setVisible(true)
            self.ptr_label_prop_name_append:setString(self.m_the_product_data.caption)
            local l_size_append=self.ptr_label_prop_name_append:getContentSize()
            local l_width=l_size_name.width+l_size_append.width
            self.ptr_label_prop_name:setPosition(cc.p(550/2-l_width/2,160))
            self.ptr_label_prop_name_append:setPosition(cc.p(550/2-l_width/2+l_size_name.width,140))
        else
            self.ptr_label_prop_name:setPosition(cc.p(550/2,l_size_name.width,160))
            
        end
        self.ptr_btn_buy:setVisible(true)
    elseif param_type==4 then 
        self:switch_visiable_type(3);
        self:set_bg(g_path.."bg_gold_gift.png")
        self:update_layout();
        self.m_pay_type=param_type
    elseif param_type==5 then 
        local l_user_data=json.decode(bp_get_self_user_data());
        self:set_bg(g_path.."bg_bean_share.png")
        self:update_layout();
        local l_str=bp_get_common_text(15)        
        l_str=bp_string_replace_key(l_str,"{COUNT}",l_user_data.relief_count_gold)
        self.ptr_label_hint:setVisible(true)
        self.ptr_label_hint:setString(l_str)
        self.ptr_btn_share:setVisible(true)
        self.ptr_btn_shop:setVisible(true)
        self.ptr_btn_shop:setPosition(cc.p(550/2-100,70))
        self.ptr_btn_share:setPosition(cc.p(550/2+100,70))
        self.m_pay_type=param_type
    elseif param_type==6 then
        local l_user_data=json.decode(bp_get_self_user_data());
        self:set_bg(g_path.."bg_bean_share.png")
        self:update_layout();
        local l_str=bp_get_common_text(15)
        l_str=bp_string_replace_key(l_str,"{COUNT}",l_user_data.relief_count_gold)
        self.ptr_label_hint:setVisible(true)
        self.ptr_label_hint:setString(l_str)
        self.ptr_btn_share:setVisible(true)
        self.ptr_btn_share:setPosition(cc.p(550/2,70))
        self.m_pay_type=param_type
    elseif param_type==7 then 
        self:switch_visiable_type(3);
        self:set_bg(g_path.."bg_bean_buy.png")
        self:update_layout();
        self.m_pay_type=param_type
    elseif param_type==8 then 
        self:switch_visiable_type(3);
        self:set_bg(g_path.."bg_bean_gift.png")
        self:update_layout();
        self.m_pay_type=param_type
    end
end
function UISimpleShop:on_btn_shop(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if self.m_pay_type>4 then 
        local event = cc.EventCustom:new("MSG_DO_TASK");
        event.command ="open:12"
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
    else
        local event = cc.EventCustom:new("MSG_DO_TASK");
        event.command = "open:1"
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
    end

end
function UISimpleShop:on_btn_share(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local l_share_data=bp_get_local_text(1);
    l_share_data=bp_url_decode(l_share_data)
    l_share_data=json.decode(l_share_data)
    local share_data={}
    for k,v in pairs(l_share_data) do 
        if v.id==1 then 
            share_data=v;
            break;
        end
    end
    self:share_wechat(share_data,1)

end
function UISimpleShop:on_btn_buy(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local UIPay=require("src/ui_pay")
    UIPay.ShowPay(self.m_the_product_data,true)
end
function UISimpleShop:share_wechat(param_share_data,param_type)
    local share_data=param_share_data
    local l_share_text={}
    if share_data.mode==0 then 
        l_share_text.title=share_data.title
        local l_message_count=#share_data.message;
        math.randomseed(os.time())
        l_share_text.message=share_data.message[math.random(1,#share_data.message)]
        local l_str_icon=share_data.icon
        l_str_icon=bp_string_replace_key(l_str_icon,"{ICON}",BPRESOURCE("res/icon/"..bp_get_keyword()..".png"))
        l_share_text.icon=l_str_icon
        l_share_text.url=bp_make_url(share_data.url)
        l_share_text.type=param_type
        --print("hjjlog>>share_text:",json.encode(l_share_text))
        bp_wechat_share_text(json.encode(l_share_text),function(param_code)  self:on_share_callback_gold(param_code) end)
    else
        --图片
        l_share_text.type=param_type
        l_share_text.image=bp_make_url(share_data.image)
        local l_url=bp_make_url(share_data.url)
        l_url=bp_url_encode(l_url)
        l_share_text.image=bp_string_replace_key(l_share_text.image,"{GAMEID}",self.m_int_game_id)
        bp_wechat_share_image(json.encode(l_share_text),function(param_code)  self:on_share_callback_gold(param_code)  end)
    end
end
function UISimpleShop:on_share_callback_gold(param_code)
    -- if param_code==0 then 
    --     if self.m_the_product_data.type==1 then 
    --         self:request_wechat_award(316)
    --     else
    --         self:request_wechat_award(317)
    --     end
    -- else
    --     bp_show_hinting("分享未成功（:"..param_code.."）") 
    -- end
    self:request_wechat_award(316)
end
function UISimpleShop:request_wechat_award(param_type)
    bp_show_loading(1)
    local req = URL.HTTP_GET_RELIEF
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{TYPEID}",param_type);
    local post=req.."8062e5d0872bc6f6"
    post=bp_md5(post)
    
    bp_http_post(""..param_type,"",req,post,function(param_identifier,param_success,param_code,param_header,context) self:on_http_wechat_award(param_identifier,param_success,param_code,param_header,context) end,1)

end
function UISimpleShop:on_http_wechat_award(param_identifier,param_success,param_code,param_header,context)
    print("hjjlog>>on_http_wechat_award:",context);
    
     bp_show_loading(0)
     if param_success~=true or param_code~=200 then 
         bp_show_hinting("领取救济金失败")
         return  ;
     end
 
     local l_data=json.decode(context);
     if l_data.Result_code~=1 then 
         bp_show_hinting(l_data.Result_msg)
         return ;
     end
     local int_count=l_data.Result_data;
     local l_int_type=316
     if l_data.Result_type~=nil then 
        l_int_type=l_user_data.Result_type;
     end

     if  l_int_type==316 then 
        local l_data={}
        l_data.relief_count_gold=int_count
        bp_set_self_user_data(json.encode(l_data))
    else
        local l_data={}
        l_data.relief_count_bean=int_count
        bp_set_self_user_data(json.encode(l_data))
    end
    bp_show_hinting(l_data.Result_msg)
    bp_update_user_data(0)
end 
function UISimpleShop:show_giftshop(param_product_data,param_game_id)
    
    self.m_the_product_data=param_product_data;
    self.m_int_game_id=param_game_id
    local l_bool_power_shop=bp_have_mask_module(LC.MASK_MODULE_SHOP) 
    local l_bool_power_wechat=bp_have_mask_module(LC.MASK_MODULE_SHARE_WECHAT) 
    if l_bool_power_shop==false and l_bool_power_wechat== false then 
        --hjj_for_wait
        bp_show_hinting("金币不足，无法后续操作");
        return;
    end
    local l_user_data=json.decode(bp_get_self_user_data());
    if param_product_data.type==1 then 
        l_bool_power_shop=bp_have_mask_module(LC.MASK_MODULE_SHOP) ;
    elseif param_product_data.type==5 then 
        l_bool_power_shop=bp_have_mask_module(LC.MASK_MODULE_BEANS) ;
    end
    if  l_bool_power_shop==false then 
        return ;
    end
    if param_product_data.type==1 then 
        self:switch_visiable_type(4)
    else 
        self:switch_visiable_type(4)
    end

end

function UISimpleShop:show_simpleshop(param_product_data,param_game_id)
    print("hjjlog>>simpshop:111111111111111111");
    
    self.m_the_product_data=param_product_data;
    self.m_int_game_id=param_game_id
    local l_bool_power_shop=bp_have_mask_module(LC.MASK_MODULE_SHOP) 
    local l_bool_power_wechat=bp_have_mask_module(LC.MASK_MODULE_SHARE_WECHAT) 
    if l_bool_power_shop==false and l_bool_power_wechat== false then 
        --hjj_for_wait
        bp_show_hinting("金币不足，无法后续操作");
        return;
    end
    local l_bool_find=false;
    for k,v in pairs(RELIEF_GAME) do
        if v==param_game_id then 
            l_bool_find=true 
            break;
        end
    end
    if l_bool_find==false then 
        l_bool_power_wechat=false;
    end

    if param_product_data.type==1 then 
        l_bool_power_shop=bp_have_mask_module(LC.MASK_MODULE_SHOP) ;
    elseif param_product_data.type==6 then 
        l_bool_power_shop=bp_have_mask_module(LC.MASK_MODULE_BEANS) ;
    end
    
    local l_user_data=json.decode(bp_get_self_user_data());
    --金币充值
    if param_product_data.type==1 then 
        if l_user_data.gold+l_user_data.bank>RELIEF_GOLD then 
            l_bool_power_wechat=false;
        end
        if l_user_data.relief_count_gold<=0 then 
            l_bool_power_wechat=false;
        end
        if l_bool_power_shop==false and l_bool_power_wechat==false then 
            self:setVisible(false)
            bp_show_hinting("金币不足")
            return ;
        end
        self:setVisible(true);
        if l_bool_power_shop==true and l_bool_power_wechat==true then 
            self:switch_visiable_type(1)            
        elseif l_bool_power_shop==true then 
            self:switch_visiable_type(3)
        else
            self:switch_visiable_type(2)
        end
    else
        if l_user_data.bean>RELIEF_BEANS then  
            l_bool_power_wechat=false;
        end
        if l_user_data.relief_count_bean<=0 then 
            l_bool_power_wechat=false;
        end
        if l_bool_power_shop==false and l_bool_power_wechat then 
            self:setVisible(false)
            bp_show_hinting("金豆不足")
        end
        self:setVisible(true)
        if l_bool_power_shop==true and l_bool_power_wechat==true then 
            self:switch_visiable_type(5)            
        elseif l_bool_power_shop==true then 
            self:switch_visiable_type(7)
        else
            self:switch_visiable_type(6)
        end
    end
end


function UISimpleShop.ShowSimpleShop(param_show,param_product_data,param_game_id)
    if sptr_simple_shop==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_simple_shop=UISimpleShop:create();
        main_layout:addChild(sptr_simple_shop)
    end
    if param_show==nil then 
        param_show=true;
    end
    if bp_have_mask_module(LC.MASK_MODULE_SHOP) ==false then 
        return sptr_simple_shop;
    end
    sptr_simple_shop:ShowGui(param_show)
    param_game_id=param_game_id or 0;
    if param_product_data~=nil then 
        sptr_simple_shop:show_simpleshop(param_product_data,param_game_id);
    end
    return sptr_simple_shop;
end
function UISimpleShop.ShowGiftShop(param_show,param_product_data,param_game_id)
    if sptr_simple_shop==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_simple_shop=UISimpleShop:create();
        main_layout:addChild(sptr_simple_shop)
    end
    if param_show==nil then 
        param_show=true;
    end
    if bp_have_mask_module(LC.MASK_MODULE_SHOP) ==false then 
        return sptr_simple_shop;
    end
    sptr_simple_shop:ShowGui(param_show)
    param_game_id=param_game_id or 0;
    if param_product_data~=nil then 
        sptr_simple_shop:show_giftshop(param_product_data,param_game_id);
    end
    return sptr_simple_shop;
end




return UISimpleShop