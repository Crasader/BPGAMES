local UIControl=require("src/ui_control")
local UIChatCenter=class("UIChatCenter",UIControl)
local g_path=BPRESOURCE("res/bugle/")

local UIBugleSend=require("src/ui_buglesend")
local UIChatSend=require("src/ui_chatsend")
sptr_chat_center=nil
function UIChatCenter:ctor(...)
    print("hjjlog>>UIChatCenter")
    self.super:ctor(self)
    self.ptr_layout_bugle_send=nil
    self.ptr_layout_chat_send=nil
    self:init();
end
function UIChatCenter:destory()

end
function UIChatCenter:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_chat1.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();
    
    self.ptr_layout_bugle_send=UIBugleSend:create();
    self:insert_item(0,BPRESOURCE("res/bugle/btn_bugle_send_1.png"),BPRESOURCE("res/bugle/btn_bugle_send_2.png"),self.ptr_layout_bugle_send)
    self.ptr_layout_bugle_send:setPosition(cc.p(23,20))

    self.ptr_layout_chat_send=UIChatSend:create();
    self:insert_item(1,BPRESOURCE("res/bugle/btn_chat_send_1.png"),BPRESOURCE("res/bugle/btn_chat_send_2.png"),self.ptr_layout_chat_send)
    self.ptr_layout_chat_send:setPosition(cc.p(23,20))
    
    self:update_layout();
end

function UIChatCenter:show_center(param_table)
    -- param_table={}
    -- param_table.type=1;
    if param_table.type==0 then 
        self:switch_item(1)
        self.ptr_layout_bugle_send:set_game_data(0,param_table.game_id,param_table.room_id)
        self:set_title(g_path.."title_chat1.png")
    else
        if bp_have_mask_module(LC.MASK_MODULE_PUSH) and false then 
            self:switch_item(1)
            self.ptr_layout_bugle_send:set_game_data(1)
            self:update_layout();
        else 
            self:switch_item(1)
            self:set_title(g_path.."title_chat1.png")
        end
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