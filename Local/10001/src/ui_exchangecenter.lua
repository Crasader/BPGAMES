local UIControl=require("src/ui_control")
local UIExchangeCenter=class("UIExchangeCenter",UIControl)
local g_path=BPRESOURCE("res/exchange/")

local UIExchangeRedpack=require("src/ui_exchangeredpack")
local UIExchangeRecord=require("src/ui_exchangerecord")
local UIExchangeProps=require("src/ui_exchangeprops")
local UIMiniUserData=require("src/ui_miniuserdata")


sptr_exchange_center=nil;
function UIExchangeCenter:ctor(...)
    print("hjjlog>>UIExchangeCenter")
    self.super:ctor(self)
    self.ptr_layout_exchange_props=nil
    self.ptr_layout_exchange_record=nil
    self.ptr_layout_exchange_redpack=nil
    self.ptr_layout_shop_prop=nil

    self:init_center();
end
function UIExchangeCenter:destory()

end
function UIExchangeCenter:init_center()
    self:set_bg(g_path.."gui.png")
    

    if bp_have_mask_module(LC.MASK_MODULE_REDPACKET) ==false or true then 
        self.ptr_layout_exchange_redpack=UIExchangeRedpack:create()
        self:insert_item(0,BPRESOURCE("res/exchange/title_record_1.png"),BPRESOURCE("res/exchange/title_record_2.png"),self.ptr_layout_exchange_redpack,0,50)
    end



    self.ptr_layout_exchange_props=UIExchangeProps:create()
    self:insert_item(1,BPRESOURCE("res/exchange/title_props_1.png"),BPRESOURCE("res/exchange/title_props_2.png"),self.ptr_layout_exchange_props,0,50)


    self.ptr_layout_exchange_record=UIExchangeRecord:create()
    self:insert_item(2,BPRESOURCE("res/exchange/title_record_1.png"),BPRESOURCE("res/exchange/title_record_2.png"),self.ptr_layout_exchange_record,0,50)

    self.ptr_mini_user_data=UIMiniUserData:create()
    self:get_gui():addChild(self.ptr_mini_user_data);
    self.ptr_mini_user_data:setPosition(cc.p(10,8))
    self.ptr_mini_user_data:switch_type(20,"奖品兑换与苹果公司无关")
    self:update_layout();
end
function UIExchangeCenter:on_back_switch_item(parma_id)
    self.ptr_mini_user_data:switch_type(20+parma_id)
end
function UIExchangeCenter.ShowExchangeCenter(param_show,param_id)
    if sptr_exchange_center==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_exchange_center=UIExchangeCenter:create();
        main_layout:addChild(sptr_exchange_center)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_exchange_center:ShowGui(param_show)
    if param_id~=nil then 
        sptr_exchange_center:switch_item(param_id)
    end
    return sptr_exchange_center;
end


return UIExchangeCenter