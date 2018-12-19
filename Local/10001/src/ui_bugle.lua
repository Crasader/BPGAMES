local UIBugle=class("UIBugle",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/scene_room/")
local UIRichText=require("bptools/ui_richtext")
function UIBugle:ctor()
    print("hjjlog>>UIBugle")
    self.m_list_message={}
    self.m_bool_running=false;
    self:init();
end
function UIBugle:destory()
end

function UIBugle:init()
    local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA", function (eventCustom)
          -- self:on_update_user_data(eventCustom);
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    
    self.the_size=cc.size(660,40);
    self:setContentSize(self.the_size)

    local l_bg_bugle=control_tools.newImg({path=g_path.."bugle_back.png"})
    self:addChild(l_bg_bugle)
    l_bg_bugle:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    l_bg_bugle:setTouchEnabled(true)
    l_bg_bugle:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_bugle_bg(param_sender,param_touchType) end)

    local l_img_bugle=control_tools.newImg({path=g_path.."img_bugle.png"})
    self:addChild(l_img_bugle)
    l_img_bugle:setPosition(cc.p(70,20))

    local l_img_edit=control_tools.newImg({path=g_path.."img_edit.png"})
    self:addChild(l_img_edit)
    l_img_edit:setPosition(cc.p(660-70,20))
    
    local l_layout_clipping=ccui.Layout:create();
    self:addChild(l_layout_clipping)
    l_layout_clipping:setContentSize(cc.size(510,40))
    l_layout_clipping:setPosition(cc.p(75,0));
    l_layout_clipping:setClippingEnabled(true)

    self.ptr_rich_text=UIRichText:create(24,cc.c3b(255, 250, 195),"Arial")
    l_layout_clipping:addChild(self.ptr_rich_text)
    self.ptr_rich_text:setAnchorPoint(cc.p(0,0.5))
    self.ptr_rich_text:setPosition(cc.p(660,20))

end
function UIBugle:on_play_bugle_frame(param_event)
    if bp_have_mask_module(LC.MASK_MODULE_SYSTEM_PUSH) ==false then 
        return ;
    end
    local l_str_text=param_event.str_message
    self: play_bugle(l_str_text,10);

end
function UIBugle:on_play_bugle_user(param_evnet)
    if bp_have_mask_module(LC.MASK_MODULE_PUSH) ==false then 
        return ;
    end
    local l_str_text=param_event.str_message
    self:play_bugle(l_str_text,10);
end

function UIBugle:play_bugle(param_text,parma_turn,param_time)
    parma_turn=parma_turn or 1;
    for i=1,parma_turn do
        local l_str=param_text; 
        table.insert( self.m_list_message, l_str )
    end
    print("hjjlog>>play_bugle:",#self.m_list_message,parma_turn);

    if self.m_bool_running==false then 
        self:on_start_bugle();
    end

end
function UIBugle:on_start_bugle()
    print("hjjlog>>on_start_bugle:",#self.m_list_message);
    self.m_bool_running = true;
    if #self.m_list_message==0 then 
        self.m_bool_running = false;
        return ;
    end
    self:setVisible(true)   
    local str_text=self.m_list_message[1]
    table.remove( self.m_list_message,1)
    print("hjjlog>>1111");
    
    self.ptr_rich_text:setTextEx(str_text)
    local the_rich_size=self.ptr_rich_text:getTextSize()
    local l_start_x=510+10
    local l_end_x=0-the_rich_size.width-30
    self.ptr_rich_text:setPosition(cc.p(l_start_x,20))
    local l_move_distance=l_start_x-l_end_x;
    print("hjjlog>>time:",the_rich_size.width,the_rich_size.height,l_move_distance,l_move_distance/150);
    
    local l_ac_move=cc.MoveTo:create(l_move_distance/150, cc.p(l_end_x, 20))
    local l_ac_fun_1=cc.CallFunc:create(function() self:on_start_bugle() end)

    self.ptr_rich_text:runAction(cc.Sequence:create(l_ac_move,l_ac_fun_1))
end

function UIBugle:on_btn_bugle_bg(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local l_table={}
    l_table.type=1
    bp_application_signal(10002,"SHOW_ROOM_BUGLE",json.encode(l_table))

end


return UIBugle