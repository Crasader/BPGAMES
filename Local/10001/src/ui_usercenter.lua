local UIControl=require("src/ui_control")
local UIUserCenter=class("UIUserCenter",UIControl)
local g_path=BPRESOURCE("res/usercenter/")
local UIUserInfo=require("src/ui_userinfo")
local UIUserRight=require("src/ui_userright")
local UIUserProp=require("src/ui_userprop")
sptr_user_center=nil;
function UIUserCenter:ctor(...)
    print("hjjlog>>UIUserCenter")
    self.super:ctor(self)
    self.ptr_layout_user_data=nil
    self.ptr_layout_self_right=nil
    self.ptr_layout_self_prop=nil
    self:init_center();
end
function UIUserCenter:destory()

end
function UIUserCenter:init_center()
    self:set_bg(g_path.."gui.png")

    self.ptr_layout_user_data=UIUserInfo:create();
    self:insert_item(0,BPRESOURCE("res/usercenter/btn_self_data_1.png"),BPRESOURCE("res/usercenter/btn_self_data_2.png"),self.ptr_layout_user_data)
    self.ptr_layout_user_data:setPosition(cc.p(23,30))

    self.ptr_layout_self_right=UIUserRight:create()
    self:insert_item(1,BPRESOURCE("res/usercenter/btn_self_right_1.png"),BPRESOURCE("res/usercenter/btn_self_right_2.png"),self.ptr_layout_self_right)

    self.ptr_layout_self_prop=UIUserProp:create();
    self:insert_item(2,BPRESOURCE("res/usercenter/btn_self_prop_1.png"),BPRESOURCE("res/usercenter/btn_self_prop_2.png"),self.ptr_layout_self_prop)

    self:update_layout();

    -- self.ptr_layout_self_prop=UIUserProp:create();
    -- self:set_item(BPRESOURCE("res/usercenter/111.png"),self.ptr_layout_self_prop)
end
function UIUserCenter.ShowUserCenter(param_show,param_id)
    if sptr_user_center==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_user_center=UIUserCenter:create();
        main_layout:addChild(sptr_user_center)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_user_center:ShowGui(param_show)
    if param_id~=nil then 
        sptr_user_center:switch_item(param_id)
    end
    return sptr_user_center;
end
return UIUserCenter