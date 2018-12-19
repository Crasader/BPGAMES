local UIControl=require("src/ui_control")
local UIPay=class("UIPay",UIControl)
local g_path=BPRESOURCE("res/pay/")

--支付标记位
local MASK_PAY_ALIPAY			= 0x00000002        -- 支付宝支付
local MASK_PAY_MANUALPAY		= 0x00000008        -- 人工充值
local MASK_PAY_WEIXINPAY		= 0x00000200        -- 微信支付
--local MASK_PAY_HEEPAY			= 0x00008000        -- 汇付宝支付
local MASK_PAY_CHANNELPAY		= 0x10000000        -- 渠道支付
sptr_pay=nil;
function UIPay:ctor(...)
    print("hjjlog>>UIPay")
    self.super:ctor(self)
    self.m_the_product_data=nil;
    self.m_curr_id=0;
    self:init();
end
function UIPay:destory()

end
function UIPay:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_pay.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();

    self.ptr_label_title=control_tools.newLabel({font=26,color=cc.c3b(152,98,63),anchor=cc.p(0,0.5)})
    l_bg:addChild(self.ptr_label_title)
    self.ptr_label_title:setPosition(cc.p(40,305))

    self.ptr_label_price=control_tools.newLabel({font=26,color=cc.c3b(152,98,63),anchor=cc.p(0,0.5)})
    l_bg:addChild(self.ptr_label_price)
    self.ptr_label_price:setPosition(cc.p(375,305))

    self.array_weixin={}
    local l_item_bg=control_tools.newBtn({normal=g_path.."img_pay_normal.png",pressed=g_path.."img_pay_normal.png"})
    l_bg:addChild(l_item_bg)
    l_item_bg:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_pay_type(param_sender,param_touchType) end)
    l_item_bg.id=12;
    self.array_weixin.btn=l_item_bg

    local l_item_icon=control_tools.newImg({path=g_path.."btn_weixin.png"})
    l_item_bg:addChild(l_item_icon)
    l_item_icon:setPosition(cc.p(80,90)) 
    self.array_weixin.icon=l_item_icon

    local l_item_name=control_tools.newLabel({font=24,color=cc.c3b(152,98,63)})
    l_item_bg:addChild(l_item_name)
    l_item_name:setPosition(cc.p(80,30))
    l_item_name:setString("微信支付")
    self.array_weixin.name=l_item_name

    local l_item_select=control_tools.newImg({path=g_path.."img_pay_select.png"})
    l_item_bg:addChild(l_item_select)
    l_item_select:setPosition(cc.p(80,80))
    l_item_select:setVisible(false)
    self.array_weixin.select=l_item_select
    --alipay
    self.array_alipay={}
    l_item_bg=control_tools.newBtn({normal=g_path.."img_pay_normal.png",pressed=g_path.."img_pay_normal.png"})
    l_bg:addChild(l_item_bg)
    l_item_bg.id=11;
    l_item_bg:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_pay_type(param_sender,param_touchType) end)
    self.array_alipay.btn=l_item_bg

    l_item_icon=control_tools.newImg({path=g_path.."btn_ali.png"})
    l_item_bg:addChild(l_item_icon)
    l_item_icon:setPosition(cc.p(80,90)) 
    self.array_alipay.icon=l_item_icon

    l_item_name=control_tools.newLabel({font=24,color=cc.c3b(152,98,63)})
    l_item_bg:addChild(l_item_name)
    l_item_name:setPosition(cc.p(80,30))
    l_item_name:setString("支付宝支付")
    self.array_alipay.name=l_item_name
    
    l_item_select=control_tools.newImg({path=g_path.."img_pay_select.png"})
    l_item_bg:addChild(l_item_select)
    l_item_select:setPosition(cc.p(80,80))
    l_item_select:setVisible(false)
    self.array_alipay.select=l_item_select
    
    --渠道
    self.array_channel={}
    l_item_bg=control_tools.newBtn({normal=g_path.."img_pay_normal.png",pressed=g_path.."img_pay_normal.png"})
    l_bg:addChild(l_item_bg)
    l_item_bg:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_pay_type(param_sender,param_touchType) end)
    l_item_bg.id=13;
    self.array_channel.btn=l_item_bg

    l_item_icon=control_tools.newImg({path=g_path.."btn_apple.png"})
    l_item_bg:addChild(l_item_icon)
    l_item_icon:setPosition(cc.p(80,90)) 
    self.array_channel.icon=l_item_icon

    l_item_name=control_tools.newLabel({font=24,color=cc.c3b(152,98,63)})
    l_item_bg:addChild(l_item_name)
    l_item_name:setPosition(cc.p(80,30))
    l_item_name:setString("渠道支付")

    self.array_channel.name=l_item_name
    l_item_select=control_tools.newImg({path=g_path.."img_pay_select.png"})
    l_item_bg:addChild(l_item_select)
    l_item_select:setPosition(cc.p(80,80))
    l_item_select:setVisible(false)
    self.array_channel.select=l_item_select

    --确认支付
    self.ptr_btn_true=control_tools.newBtn({normal=g_path.."btn_true.png",small=true})
    l_bg:addChild(self.ptr_btn_true)
    self.ptr_btn_true:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_true(param_sender,param_touchType) end)
    self.ptr_btn_true:setPosition(cc.p(566/2,60))


end

function UIPay:set_product_data(param_product_data)
    self.m_the_product_data=param_product_data;
    print("hjjlog>>sef_product_data",json.encode(param_product_data));
    self.ptr_label_title:setString("购买:"..param_product_data.describe)
    self.ptr_label_price:setString("价格:"..param_product_data.price)
    local m_vector_btn={}

    self.array_weixin.btn:setVisible(false)
    self.array_alipay.btn:setVisible(false)
    self.array_channel.btn:setVisible(false)

    
    if bit._and(param_product_data.option,MASK_PAY_ALIPAY)>0 then 
        self.array_alipay.btn:setVisible(true)
        table.insert( m_vector_btn,self.array_alipay)
    end
    if bit._and(param_product_data.option,MASK_PAY_WEIXINPAY)>0 then 
        self.array_weixin.btn:setVisible(false)
        table.insert( m_vector_btn, self.array_weixin )
    end
    if bit._and(param_product_data.option,MASK_PAY_CHANNELPAY)>0 then 
        table.insert( m_vector_btn, self.array_channel )
        if bp_get_areaid()==2 then 
            self.array_channel.icon:loadTexture(g_path.."btn_ali.png")
            self.array_channel.name:setString("苹果支付")
        end
    end

    local l_x=123
    local l_x_space=160
    if #m_vector_btn ==3 then 
        l_x_space=165
        l_x=566/2-l_x_space
    elseif #m_vector_btn==2 then 
        l_x_space=250
        l_x=566/2-l_x_space/2
    elseif #m_vector_btn==1 then 
        l_x_space=0
        l_x=566/2
    end
    for k,v in pairs(m_vector_btn) do 
        v.btn:setPosition(cc.p(l_x,180))
        l_x=l_x+l_x_space;
    end
    if self.m_curr_id==0 then 
        if #m_vector_btn~=0 then 
            m_vector_btn[1].select:setVisible(true)
            self.m_curr_id=m_vector_btn[1].btn.id
        end
    end

end
function UIPay:on_btn_pay_type(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("hjjlog>>ttttttttttttt");
    
    self.m_curr_id=param_sender.id
    if param_sender.id==12 then 
        self.array_weixin.select:setVisible(true)
        self.array_alipay.select:setVisible(false)
        self.array_channel.select:setVisible(false)
    elseif param_sender.id==11 then 
        self.array_weixin.select:setVisible(false)
        self.array_alipay.select:setVisible(true)
        self.array_channel.select:setVisible(false)
    elseif param_sender.id==13 then 
        self.array_weixin.select:setVisible(false)
        self.array_alipay.select:setVisible(false)
        self.array_channel.select:setVisible(true)
    end
end
function UIPay:on_btn_true(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    bp_payment_proudct(self.m_the_product_data.id,self.m_curr_id)
end

function UIPay:on_callback_pay(param_id,param_code)
    if param_code~=0 then 
        bp_show_hinting("购买失败")
        return;
    end
    bp_update_user_data(1);
    self:ShowGui(false)
end

function UIPay.ShowPay(param_product_data,param_show)
    if sptr_pay==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_pay=UIPay:create();
        main_layout:addChild(sptr_pay)
        print("hjjlog>>ShowPay is nil",sptr_pay);
    else
        print("hjjlog>>ShowPay is not nil",sptr_pay);
    end
    if param_show==true then 
        sptr_pay:ShowGui(param_show)
        sptr_pay:set_product_data(param_product_data);
    else
        sptr_pay:ShowGui(param_show)
    end
    return sptr_pay;
end


return UIPay