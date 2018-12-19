local UIControl=require("src/ui_control")
local UIChatCenter=class("UIChatCenter",UIControl)
local g_path=BPRESOURCE("res/bugle/")

local UIBugleSend=require("src/ui_buglesend")
sptr_chat_center=nil
function UIChatCenter:ctor(...)
    print("hjjlog>>UIChatCenter")
    self.super:ctor(self)
    self.ptr_layout_bugle_send=nil
    self:init();
end
function UIChatCenter:destory()

end
function UIChatCenter:init()
    self:set_bg(g_path.."gui.png")
    self.ptr_layout_bugle_send=UIBugleSend:create();
    self:set_item(g_path.."title_chat1.png",self.ptr_layout_bugle_send)
end

function UIChatCenter:show_center(param_table)
    param_table.game_id =param_table.game_id or 0
    param_table.room_id =param_table.room_id or 0
    if param_table.game_id==0 then 
        self.ptr_layout_bugle_send:set_game_data(0,param_table.game_id,param_table.room_id)
    else
        self.ptr_layout_bugle_send:set_game_data(1,param_table.game_id,param_table.room_id)
    end
end

function UIChatCenter.ShowChatCenter(param_show,param_table)
    if sptr_chat_center==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_chat_center=UIChatCenter:create();
        main_layout:addChild(sptr_chat_center)
    end
    if param_show==nil then 
        param_show=true;
    end
    if param_show==true then 
        sptr_chat_center:show_center(param_table);
    end
    sptr_chat_center:ShowGui(param_show)
    return sptr_chat_center;
end


return UIChatCenter