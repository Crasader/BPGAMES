local UIControl=require("src/ui_control")
local UIShopCenter=class("UIShopCenter",UIControl)
local g_path=BPRESOURCE("res/shop/")
local UIShopGold=require("src/ui_shopgold")
local UIShopBeans=require("src/ui_shopbeans")
local UIShopIngot=require("src/ui_shopingot")
local UIShopProp=require("src/ui_shopprop")
local UIMiniUserData=require("src/ui_miniuserdata")
sptr_shop_center=nil
function UIShopCenter:ctor(...)
    print("hjjlog>>UIShopCenter")
    self.super:ctor(self)
    self.ptr_layout_shop_gold=nil
    self.ptr_layout_shop_beans=nil
    self.ptr_layout_shop_ingot=nil
    self.ptr_layout_shop_prop=nil

    self:init_center();
end
function UIShopCenter:destory()

end
function UIShopCenter:init_center()
    self:set_bg(g_path.."gui.png")

    self.ptr_layout_shop_gold=UIShopGold:create()
    self:insert_item(0,BPRESOURCE("res/shop/title_gold_1.png"),BPRESOURCE("res/shop/title_gold_2.png"),self.ptr_layout_shop_gold,0,50)


    self.ptr_layout_shop_ingot=UIShopIngot:create()
    self:insert_item(1,BPRESOURCE("res/shop/title_ingot_1.png"),BPRESOURCE("res/shop/title_ingot_2.png"),self.ptr_layout_shop_ingot,0,50)


    self.ptr_layout_shop_beans=UIShopBeans:create()
    self:insert_item(2,BPRESOURCE("res/shop/title_beans_1.png"),BPRESOURCE("res/shop/title_beans_2.png"),self.ptr_layout_shop_beans,0,50)

    self.ptr_layout_shop_prop=UIShopProp:create()
    self:insert_item(3,BPRESOURCE("res/shop/title_prop_1.png"),BPRESOURCE("res/shop/title_prop_2.png"),self.ptr_layout_shop_prop,0,50)

    self.ptr_mini_user_data=UIMiniUserData:create()
    self:get_gui():addChild(self.ptr_mini_user_data);
    self.ptr_mini_user_data:switch_type(1);
    self.ptr_mini_user_data:setPosition(cc.p(10,8))
    self.ptr_mini_user_data:switch_type(10)

    self:update_layout();
end
function UIShopCenter:on_back_switch_item(parma_id)

    self.ptr_mini_user_data:switch_type(10+parma_id)
end

function UIShopCenter.ShowShopCenter(param_show,param_id)
    if sptr_shop_center==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_shop_center=UIShopCenter:create();
        main_layout:addChild(sptr_shop_center)
    end
    if param_show==nil then 
        param_show=true;
    end
    if bp_have_mask_module(LC.MASK_MODULE_SHOP) ==false then 
        return sptr_shop_center;
    end

    sptr_shop_center:ShowGui(param_show)
    if param_id~=nil then 
        sptr_shop_center:switch_item(param_id)
    end
    return sptr_shop_center;
end


return UIShopCenter