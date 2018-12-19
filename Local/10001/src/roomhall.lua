local RoomHall=class("RoomHall",function() return ccui.Layout:create() end);
require "bptools/control_tools"
local RoomSite=require("src/roomsite")
local g_path=BPRESOURCE("res/notice_panel/")
function RoomHall:ctor()
    print("hjjlog>>RoomHall")
    self.the_size=nil;
    self.ptr_page_notice=nil;
    self.ptr_page_site=nil;
    self.ptr_room_site=nil;
    self:init();
end
function RoomHall:destory()
end

function RoomHall:init()
    local  the_size=CCDirector:getInstance():getVisibleSize();
    self.the_size=the_size;
    self:setContentSize(the_size);

    local l_float=(the_size.width-254-260*2)/4

    self.ptr_page_notice=ccui.PageView:create();
    self.ptr_page_notice:setContentSize(cc.size(254,386))
    self:addChild(self.ptr_page_notice)
    self.ptr_page_notice:setVisible(true)
    self.ptr_page_notice:setPosition(cc.p(l_float,110))

    local l_str=cc.FileUtils:getInstance():getStringFromFile(BPRESOURCE("res/notice_panel/4000.json"));
    local l_config_notice=json.decode(l_str)
    for k,v in pairs(l_config_notice.message) do 
        local l_btn=control_tools.newBtn({normal=BPRESOURCE("res/notice_panel/notice.png"),pressed=BPRESOURCE("res/notice_panel/notice.png"),size=cc.size(254,386)})
        self.ptr_page_notice:addPage(l_btn)
        l_btn.notice_data=v;
        l_btn:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_notice(param_sender,param_touchType) end)

        local l_img=control_tools.newImg({path=BPRESOURCE("res/notice_panel/")..v.name})
        l_btn:addChild(l_img)
        l_img:setPosition(cc.p(254/2,386/2))
    end
    
    self.ptr_page_site=ccui.PageView:create();
    self.ptr_page_site:setContentSize(cc.size(l_float+260*2,400))
    self:addChild(self.ptr_page_site)
    self.ptr_page_site:setVisible(true)
    self.ptr_page_site:setPosition(cc.p(l_float+254+l_float,110));
    
    local l_config_game=json.decode(bp_get_game_list())
    local l_count=6
    local l_site_begin_width=130;
    local l_site_begin_height=334;
    local l_float_space_x=l_float+260
    local l_float_space_y=138;
    local l_float_x=l_site_begin_width
    local l_float_y=l_site_begin_height

    local l_layout_page=nil;
    for k,v in pairs(l_config_game) do 
        if l_count==6 then 
            l_layout_page=ccui.Layout:create();
            l_layout_page:setContentSize(cc.size(l_float+260*2,400))
            self.ptr_page_site:addPage(l_layout_page)
            l_float_x=l_site_begin_width
            l_float_y=l_site_begin_height
            l_count=0
        end
        local l_btn=control_tools.newBtn({normal=BPRESOURCE("res/game_logo/logo.png"),pressed=BPRESOURCE("res/game_logo/logo.png"),size=cc.size(260,136)})
        l_layout_page:addChild(l_btn)
        l_btn.list_data=v;
        l_btn:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_game_site(param_sender,param_touchType) end)
    
        local l_img=control_tools.newImg({path=BPRESOURCE("res/game_logo/logo_")..v.id..".png"})
        l_btn:addChild(l_img)   
        l_img:setPosition(cc.p(260/2,136/2))
        l_btn:setPosition(cc.p(l_float_x,l_float_y))

        if l_count%2==0 then 
            l_float_x=l_float_x+l_float_space_x
        else
            l_float_x=l_site_begin_width
            l_float_y=l_float_y-l_float_space_y;
        end
        l_count=l_count+1;
    end

    if #l_config_game >6 then
        local l_btn_next=control_tools.newBtn({normal=BPRESOURCE("res/scene_room/btn_next.png"),pressed=BPRESOURCE("res/scene_room/btn_next.png")}) 
        self:addChild(l_btn_next)
        l_btn_next:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_next(param_sender,param_touchType) end)
        if l_float<40 then
            l_btn_next:setPosition(cc.p(self.the_size.width-20,self.the_size.height/2))
        else 
            l_btn_next:setPosition(cc.p(self.the_size.width-l_float/2,self.the_size.height/2));
        end

    end 
    self.ptr_page_site:scrollToPage(0)


    --游戏站点
    self.ptr_room_site=RoomSite:create();
    self:addChild(self.ptr_room_site);
    self.ptr_room_site:setVisible(false)

end

function RoomHall:on_btn_next(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
   
    local l_curr_page_index=self.ptr_page_site:getCurrentPageIndex();
    print("hjjlog>>on_btn_next",l_curr_page_index,#self.ptr_page_site:getItems())
    if l_curr_page_index==#self.ptr_page_site:getItems()-1 then 
        self.ptr_page_site:scrollToPage(0)
    else 
        self.ptr_page_site:scrollToPage(l_curr_page_index + 1)
    end
end
function RoomHall:on_btn_notice(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("hjjlog>>on_btn_notice")
end
function RoomHall:back_to_hall(param_bool_action)
 
    self:hide_game_site(param_bool_action)
    self:show_game_hall(param_bool_action)
end
function RoomHall:back_to_site(param_game_id,param_site_id,param_bool_action)
    self:hide_game_hall(param_bool_action);
    self:show_game_site(param_game_id,param_site_id,param_bool_action)
end


function RoomHall:on_btn_game_site(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local l_site=param_sender.list_data;
    local event = cc.EventCustom:new("BTN_GAME");
    event.value = l_site.id
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)

end
function RoomHall:show_game_site(param_game_id,param_site_id,param_bool_action)

    self.ptr_room_site:show_game_site(param_game_id,param_site_id);
    if param_bool_action then 
        self.ptr_room_site:setVisible(true)
        self.ptr_room_site:setOpacity(0)
        local l_ac_delay_1=cc.DelayTime:create(0.2)
        local l_ac_fadein_1=cc.FadeIn:create(0.2)
        self.ptr_room_site:runAction(cc.Sequence:create(l_ac_delay_1,l_ac_fadein_1))
    else
        self.ptr_room_site:setOpacity(255)
        self.ptr_room_site:setVisible(true)

    end
end
function RoomHall:hide_game_site(param_bool_action)
    if param_bool_action==true then 
        local l_ac_fade_out=cc.FadeOut:create(0.2)
        local l_ac_fun=cc.CallFunc:create(function(param_sender) self.ptr_room_site:setVisible(false) end )
        self.ptr_room_site:runAction(cc.Sequence:create(l_ac_fade_out,l_ac_fun));
    else 
        self.ptr_room_site:setVisible(false)
    end
end

function RoomHall:show_game_hall(param_bool_action)
    if  param_bool_action==true  then 
        self.ptr_page_notice:setVisible(true)
        self.ptr_page_site:setVisible(true)
        self.ptr_page_notice:setOpacity(0)
        self.ptr_page_site:setOpacity(0)
        local l_ac_delay_1=cc.DelayTime:create(0.2)
        local l_ac_fade_in_1=cc.FadeIn:create(0.2)
        self.ptr_page_notice:runAction(cc.Sequence:create(l_ac_delay_1,l_ac_fade_in_1))

        local l_ac_delay_2=cc.DelayTime:create(0.2)
        local l_ac_fade_in_2=cc.FadeIn:create(0.2)
        self.ptr_page_site:runAction(cc.Sequence:create(l_ac_delay_2,l_ac_fade_in_2))
    else
        self.ptr_page_notice:setVisible(true)
        self.ptr_page_site:setVisible(true)
        self.ptr_page_notice:setOpacity(255)
        self.ptr_page_site:setOpacity(255)
    end
end
function RoomHall:hide_game_hall(param_bool_action)
    if param_bool_action==true then 
        local l_ac_fade_out=cc.FadeOut:create(0.2)
        local l_ac_fun=cc.CallFunc:create(function(param_sender) self.ptr_page_notice:setVisible(false) end )
        self.ptr_page_notice:runAction(cc.Sequence:create(l_ac_fade_out,l_ac_fun));

        local l_ac_fade_out_2=cc.FadeOut:create(0.2)
        local l_ac_fun_2=cc.CallFunc:create(function(param_sender) self.ptr_page_site:setVisible(false) end )
        self.ptr_page_site:runAction(cc.Sequence:create(l_ac_fade_out_2,l_ac_fun_2));
    else
        self.ptr_page_notice:setVisible(false)
        self.ptr_page_site:setVisible(false)
    end
end




return RoomHall