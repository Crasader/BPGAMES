local UIControl=require("src/ui_control")
local UIPrivateDetail=class("UIPrivateDetail",UIControl)
local g_path=BPRESOURCE("res/privateroom/")
sptr_private_detail=nil;
function UIPrivateDetail:ctor(...)
    print("hjjlog>>UIPrivateDetail")
    self.super:ctor(self)
    self.list_item_sleep={}
    self.list_item={}
    self:init();
end
function UIPrivateDetail:destory()

end
function UIPrivateDetail:init()
    self:set_bg(g_path.."gui_detail.png")
    self:set_title(g_path.."title_enter_room.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();

    local l_img_nickname=control_tools.newImg({path=g_path.."img_owner.png"})
    l_bg:addChild(l_img_nickname)
    l_img_nickname:setPosition(cc.p(130,280))

    self.ptr_label_nickname=control_tools.newLabel({font=26,color=cc.c3b(170,91,59),anchor=cc.p(0,0.5)})
    l_bg:addChild(self.ptr_label_nickname)
    self.ptr_label_nickname:setPosition(cc.p(190,280))

    local l_img_game=control_tools.newImg({path=g_path.."img_game.png"})
    l_bg:addChild(l_img_game)
    l_img_game:setPosition(cc.p(130,220))

    self.ptr_label_game=control_tools.newLabel({font=26,color=cc.c3b(170,91,59),anchor=cc.p(0,0.5)})
    l_bg:addChild(self.ptr_label_game)
    self.ptr_label_game:setPosition(cc.p(190,220))

    local l_img_type=control_tools.newImg({path=g_path.."img_owner.png"})
    l_bg:addChild(l_img_type)
    l_img_type:setPosition(cc.p(130,160))

    self.ptr_label_type=control_tools.newLabel({font=26,color=cc.c3b(170,91,59),anchor=cc.p(0,0.5)})
    l_bg:addChild(self.ptr_label_type)
    self.ptr_label_type:setPosition(cc.p(190,160))

    local l_btn_enter=control_tools.newBtn({normal=g_path.."btn_join.png",small=true})
    l_bg:addChild(l_btn_enter)
    l_btn_enter:setPosition(cc.p(564/2,55))
    l_btn_enter:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_enter(param_sender,param_touchType) end)


end
function UIPrivateDetail:set_private_data(param_private_data)
    self.m_private_data=param_private_data;
    self.ptr_label_nickname:setString(param_private_data.nickname)
    if bp_get_game_data(param_private_data.gameid)~="" then
        local l_game_data=json.decode(bp_get_game_data(param_private_data.gameid))
        self.ptr_label_game:setString(l_game_data.name)
    end
    self.ptr_label_type:setString(param_private_data.tallyname)
end

function UIPrivateDetail:on_btn_enter(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end

    local event = cc.EventCustom:new("MSG_DO_TASK");
    event.command = "enter_private_room:"..self.m_private_data.gameid*1000+self.m_private_data.roomid.."|"..self.m_private_data.code
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event) 
    self:ShowGui(false)
end

function UIPrivateDetail.ShowPrivateDetail(param_show,param_private_data)
    if sptr_private_detail==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_private_detail=UIPrivateDetail:create();
        main_layout:addChild(sptr_private_detail)
    end
    if param_show==nil then 
        param_show=true;
    end
    if param_show==true then 
        sptr_private_detail:set_private_data(param_private_data)
        sptr_private_detail:ShowGui(param_show)
    end
    return sptr_private_detail;
end


return UIPrivateDetail