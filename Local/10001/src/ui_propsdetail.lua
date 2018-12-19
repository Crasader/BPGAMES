local UIControl=require("src/ui_control")
local UIPropsDetail=class("UIPropsDetail",UIControl)
local g_path=BPRESOURCE("res/props/")


local Type_Buy_Item = 1
local Type_Change_Item=2
local Type_Self_Item =3
local Type_Self_Power=4

sptr_props_detail=nil;
function UIPropsDetail:ctor(...)
    print("hjjlog>>UIPropsDetail")
    self.super:ctor(self)
    self.m_the_product_data=nil;
    self.m_curr_id=0;
    self.ptr_fun=nil;
    self.m_int_prop_id=0;
    self:init();
end
function UIPropsDetail:destory()

end
function UIPropsDetail:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_props_detail.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();

    local l_bg_props=control_tools.newImg({path=g_path.."bg_props.png"})
    l_bg:addChild(l_bg_props)
    l_bg_props:setPosition(cc.p(115,230))

    self.ptr_img_icon=control_tools.newImg({path=g_path.."kong.png"})
    l_bg_props:addChild(self.ptr_img_icon)
    self.ptr_img_icon:setPosition(cc.p(75,75))

    self.ptr_label_name=control_tools.newLabel({font=26,color=cc.c3b(163,105,67),anchor=cc.p(0,0.5)})
    l_bg:addChild(self.ptr_label_name)
    self.ptr_label_name:setPosition(cc.p(220,280))
    
    self.ptr_label_num=control_tools.newLabel({font=26,color=cc.c3b(163,105,67),anchor=cc.p(0,0.5)})
    l_bg:addChild(self.ptr_label_num)
    self.ptr_label_num:setPosition(cc.p(220,250))

    self.ptr_label_price=control_tools.newLabel({font=26,color=cc.c3b(163,105,67),anchor=cc.p(0,0.5)})
    l_bg:addChild(self.ptr_label_price)
    self.ptr_label_price:setPosition(cc.p(220,220))

    local l_bg_desc=control_tools.newImg({path=g_path.."bg_desc.png"})
    l_bg:addChild(l_bg_desc)
    l_bg_desc:setPosition(cc.p(566/2,120))

    self.ptr_label_desc=control_tools.newLabel({ex=true,font=24,color=cc.c3b(255,252,242),anchor=cc.p(0,0.5)})
    l_bg_desc:addChild(self.ptr_label_desc)
    self.ptr_label_desc:setPosition(cc.p(15,40))

    self.ptr_btn_use=control_tools.newBtn({normal=g_path.."btn_use.png",small=true})
    l_bg:addChild(self.ptr_btn_use)
    self.ptr_btn_use:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_use(param_sender,param_touchType) end)
    self.ptr_btn_use:setPosition(cc.p(566/2,45))
    self.ptr_btn_use:setVisible(false)

    self.ptr_btn_buy=control_tools.newBtn({normal=g_path.."btn_buy.png",small=true})
    l_bg:addChild(self.ptr_btn_buy)
    self.ptr_btn_buy:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_pay(param_sender,param_touchType) end)
    self.ptr_btn_buy:setPosition(cc.p(566/2,45))


    self.ptr_btn_true=control_tools.newBtn({normal=g_path.."btn_true.png",small=true})
    l_bg:addChild(self.ptr_btn_true)
    self.ptr_btn_true:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_true(param_sender,param_touchType) end)
    self.ptr_btn_true:setPosition(cc.p(566/2,45))

    self.ptr_btn_exchange=control_tools.newBtn({normal=g_path.."btn_exchange.png",small=true})
    l_bg:addChild(self.ptr_btn_exchange)
    self.ptr_btn_exchange:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_exchange(param_sender,param_touchType) end)
    self.ptr_btn_exchange:setPosition(cc.p(566/2,45))
    
    

end

function UIPropsDetail:set_product_data(param_id,param_count,parma_value,param_type,param_fun)
    local the_prop_data=nil 
    if  bp_get_prop_data(param_id)~="" then 
        the_prop_data=json.decode(bp_get_prop_data(param_id))
    end
    if the_prop_data==nil then 
        return ;
    end
    self.ptr_fun=param_fun;
    self.m_int_prop_id=parma_value.id;

    self.ptr_img_icon:loadTexture(g_path.."prop_"..the_prop_data.id..".png")
    self.ptr_label_name:setString(the_prop_data.name)
    self.ptr_label_desc:setTextEx(the_prop_data.caption,485,3)

    self.ptr_label_price:setVisible(false);
    self.ptr_btn_buy:setVisible(false)
    self.ptr_btn_true:setVisible(false)
    self.ptr_btn_use:setVisible(false)
    self.ptr_btn_exchange:setVisible(false)
    if  param_type== Type_Buy_Item then 
        self.ptr_label_num:setString("数量："..param_count)
        self.ptr_label_price:setString("价格："..parma_value)
        self.ptr_label_price:setVisible(true)
        self.ptr_btn_buy:setVisible(true)
    elseif param_type==Type_Change_Item then 
        self.ptr_label_num:setString("库存："..param_count)
        self.ptr_label_price:setString("价格："..parma_value.price)
        self.ptr_label_price:setVisible(true)
        self.ptr_btn_exchange:setVisible(true)
    elseif param_type==Type_Self_Item then 
        self.ptr_label_num:setString("数量："..param_count)
        if the_prop_data.mask==1 then 
            self.ptr_btn_use:setVisible(true)
        else
            self.ptr_btn_true:setVisible(true)
        end
    elseif param_type==Type_Self_Power then 
        if param_count>0 then 
            self.ptr_label_num:setString("剩"..param_count.."天")
        else
            self.ptr_label_num:setString("已过期")
        end
        self.ptr_btn_true:setVisible(true)
    end
end
function UIPropsDetail:on_btn_pay(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self:ShowGui(false)
    if self.ptr_fun==nil then 
        return ;
    end
    self.ptr_fun(self.m_int_prop_id,"")
end
function UIPropsDetail:on_btn_use(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self:ShowGui(false)
    if self.ptr_fun==nil then 
        return ;
    end
    self.ptr_fun(self.m_int_prop_id,"")
    
end
function UIPropsDetail:on_btn_true(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self:ShowGui(false)
    if self.ptr_fun==nil then 
        return ;
    end
    self.ptr_fun(self.m_int_prop_id,"")
end
function UIPropsDetail:on_btn_exchange(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self:ShowGui(false)
    if self.ptr_fun==nil then 
        return ;
    end
    self.ptr_fun(self.m_int_prop_id,"")
end

function UIPropsDetail.ShowPropsDetail(param_id,param_count,parma_value,param_type,param_fun)
    if sptr_props_detail==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_props_detail=UIPropsDetail:create();
        main_layout:addChild(sptr_props_detail)
        print("hjjlog>>UIPropsDetail is nil",sptr_props_detail);
    else
        print("hjjlog>>UIPropsDetail is not nil",sptr_props_detail);
    end
    sptr_props_detail:ShowGui(param_show)
    sptr_props_detail:set_product_data(param_id,param_count,parma_value,param_type,param_fun);
    return sptr_props_detail;
end


return UIPropsDetail