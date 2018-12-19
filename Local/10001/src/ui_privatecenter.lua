local UIControl=require("src/ui_control")

local UIPrivateCenter=class("UIPrivateCenter",UIControl)
local g_path=BPRESOURCE("res/privateroom/")

local UIPriteCreate=require("src/ui_privatecreate")
local UIPriteEnter=require("src/ui_privateenter")
local UIPriteRoom=require("src/ui_privateroom")
sptr_private_center=nil;

function UIPrivateCenter:ctor(...)
    print("hjjlog>>UIPrivateCenter")
    self.super:ctor(self)
    self.m_int_game_id=0;
    self.ptr_layout_create_room=nil
    self.ptr_layout_enter_room=nil
    self.ptr_layout_show_room=nil
    self:init_center();
end
function UIPrivateCenter:destory()

end
function UIPrivateCenter:init_center()
    
    self:set_bg(g_path.."gui.png")

    self.ptr_layout_create_room=UIPriteCreate:create();
    self:insert_item(0,BPRESOURCE("res/privateroom/btn_create_room_1.png"),BPRESOURCE("res/privateroom/btn_create_room_2.png"),self.ptr_layout_create_room)

    self.ptr_layout_enter_room=UIPriteEnter:create();
    self:insert_item(1,BPRESOURCE("res/privateroom/btn_enter_room_1.png"),BPRESOURCE("res/privateroom/btn_enter_room_2.png"),self.ptr_layout_enter_room)

    self.ptr_layout_show_room=UIPriteRoom:create();
    self:insert_item(2,BPRESOURCE("res/privateroom/btn_show_room_1.png"),BPRESOURCE("res/privateroom/btn_show_room_2.png"),self.ptr_layout_show_room)

    self:update_layout();
end

function UIPrivateCenter:on_back_switch_item(param_id)
    print("hjjlog>>on_back_switch_item",param_id);
    if param_id==2 then 
        self.ptr_layout_show_room:request_private_room();
    end
end
function UIPrivateCenter:set_game_id(param_id)
    self.m_int_game_id=param_id
    self.ptr_layout_create_room:set_friendsite_data(param_id)
    self.ptr_layout_show_room:set_game_id(param_id)
end


function UIPrivateCenter.ShowPrivateCenter(param_show,param_id)
    if sptr_private_center==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_private_center=UIPrivateCenter:create();
        main_layout:addChild(sptr_private_center)
    end
    if param_show==nil then 
        param_show=true;
    end
    if param_id~=0 then 
        sptr_private_center:set_game_id(param_id)
    end
    sptr_private_center:ShowGui(param_show)
    sptr_private_center:switch_item(0)
    return sptr_private_center;
end
function UIPrivateCenter.GetPrivateCenter()
    if sptr_private_center==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_private_center=UIPrivateCenter:create();
        main_layout:addChild(sptr_private_center)
    end
    return sptr_private_center;
end
return UIPrivateCenter