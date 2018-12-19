local UIControl=require("src/ui_control")
local UINotice=class("UINotice",UIControl)
local g_path=BPRESOURCE("res/notice/")
function UINotice:ctor(...)
    print("hjjlog>>UINotice")
    self.super:ctor(self)
    self.list_item_sleep={}
    self.list_item={}
    self.ptr_img_point=nil;
    self:init();
end
function UINotice:destory()

end
function UINotice:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_notice.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();

    self.ptr_label_title=control_tools.newLabel({font=26,color=cc.c3b(158,101,64)})
    l_bg:addChild(self.ptr_label_title)
    self.ptr_label_title:setPosition(cc.p(500,417))

    local l_img_bg_time=control_tools.newImg({path=g_path.."img_time.png"})
    l_bg:addChild(l_img_bg_time)
    l_img_bg_time:setPosition(cc.p(500,365))

    self.ptr_label_time=control_tools.newLabel({font=24,color=cc.c3b(255,248,237)})
    l_img_bg_time:addChild(self.ptr_label_time)
    self.ptr_label_time:setPosition(cc.p(150,20))

    self.ptr_label_text=control_tools.newLabel({ex=true,font=26,color=cc.c3b(158,101,65),anchor=cc.p(0,1)})
    l_bg:addChild(self.ptr_label_text)
    self.ptr_label_text:setPosition(cc.p(270,340))

    self.ptr_btn_true=control_tools.newBtn({normal=g_path.."btn_bg.png",small=true})
    l_bg:addChild(self.ptr_btn_true)
    self.ptr_btn_true:setPosition(cc.p(500,55)) 
    self.ptr_btn_true:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_true(param_sender,param_touchType) end)


    self.ptr_label_btn_name_shadow=control_tools.newLabel({font=28,color=cc.c3b(74,81,39)}) 
    self.ptr_btn_true:addChild(self.ptr_label_btn_name_shadow)
    self.ptr_label_btn_name_shadow:setPosition(cc.p(190/2,45-1))

    self.ptr_label_btn_name=control_tools.newLabel({font=28,color=cc.c3b(255,252,239)}) 
    self.ptr_btn_true:addChild(self.ptr_label_btn_name)
    self.ptr_label_btn_name:setPosition(cc.p(190/2,45))

    self.ptr_scrollview=ccui.ScrollView:create();
    l_bg:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(cc.size(240,425))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)
    self.ptr_scrollview:setPosition(cc.p(20,20))

    self:request_notice();
end
function UINotice:set_point(param_object)
    self.ptr_img_point=param_object;
end

function UINotice:clear_item()
    for k,v in pairs(self.list_item) do
        v.bg:setVisible(false)
        table.insert( self.list_item_sleep,v ) 
    end
    self.list_item={};
end

function UINotice:get_a_item()
    if #self.list_item_sleep >0 then 
        local l_item=self.list_item_sleep[#self.list_item_sleep]
        table.remove( self.list_item_sleep,#self.list_item_sleep )
        table.insert( self.list_item,l_item )
        return l_item;
    else 
        local l_item={}
        local l_item_bg=control_tools.newBtn({normal=g_path.."btn_notice_1.png",pressed=g_path.."btn_notice_2.png"})
        self.ptr_scrollview:addChild(l_item_bg)
        l_item_bg:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_item(param_sender,param_touchType) end)
        l_item.bg=l_item_bg;

        local l_item_name=control_tools.newLabel({font=26,color=cc.c3b(162,86,69)})
        l_item_bg:addChild(l_item_name)
        l_item_name:setPosition(cc.p(110,40))
        l_item.name=l_item_name
        l_item.bg.ptr_name=l_item_name

        local l_img_status=control_tools.newImg({path=g_path.."img_status_1.png"})
        l_item_bg:addChild(l_img_status)
        l_img_status:setPosition(cc.p(29,54))
        l_item.status=l_img_status;
        l_item.bg.ptr_status=l_img_status

        table.insert(self.list_item,l_item)
        return l_item;
    end
end 
function UINotice:request_notice()
    bp_show_loading(1)
    local req = URL.HTTP_GET_NOTICE
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    bp_http_get("hjj_task_data","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_notice(param_identifier,param_success,param_code,param_header,context) end,1)
end
function UINotice:on_http_notice(param_identifier,param_success,param_code,param_header,context)
   -- print("hjjlog>>on_http_notice",context);
    bp_show_loading(0)
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>on_http_notice   fail");
        bp_show_hinting("通知数据请求失败")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    self:clear_item();
    local the_value=l_data.resdata
    self:clear_item();
    self.m_int_status=0;
    for k,v in pairs(the_value) do
        local l_item_btn=self:get_a_item()
        l_item_btn.bg.id=v.id;
        l_item_btn.bg.title=v.title;
        l_item_btn.bg.time=v.create_time;
        l_item_btn.bg.content=v.content
        l_item_btn.bg.btn_name=v.btn_name
        l_item_btn.bg.btn_action=v.btn_action
        l_item_btn.name:setString(v.title)
        if bp_get_local_value("notice_"..v.id,"0")=="0" then 
            l_item_btn.status:loadTexture(g_path.."img_status_0.png");
            l_item_btn.bg.type=0;
            self.m_int_status=self.m_int_status+1;
        else
            l_item_btn.status:loadTexture(g_path.."img_status_1.png");
            l_item_btn.bg.type=1;
        end
    end
    self:update_layout()
    if #self.list_item then 
        self:switch_btn_item(self.list_item[1].bg)
    end
end
function UINotice:switch_btn_item(param_sender)
    for k,v in pairs(self.list_item) do 
        v.bg:setBright(true)
        v.name:setTextColor(cc.c3b(162,86,69))
    end
    param_sender:setBright(false)
    param_sender.ptr_name:setTextColor(cc.c3b(255,248,237))
    if param_sender.type==0 then 
        bp_set_local_value("notice_"..param_sender.id,"1")
        param_sender.ptr_status:loadTexture(g_path.."img_status_1.png");
        param_sender.type=1;
        self.m_int_status=self.m_int_status-1;
    end
    if self.ptr_img_point~=nil then 
        if self.m_int_status>0 then 
            self.ptr_img_point:setVisible(true)
        else
            self.ptr_img_point:setVisible(false)
        end
    end

    self.ptr_label_title:setString(param_sender.title)
    self.ptr_label_time:setString(param_sender.time)
    self.ptr_label_text:setTextEx(param_sender.content,470,3)
    self.ptr_label_btn_name:setString(param_sender.btn_name)
    self.ptr_label_btn_name_shadow:setString(param_sender.btn_name)
    self.ptr_btn_true.btn_action=param_sender.btn_action;
end

function UINotice:on_btn_item(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
  self:switch_btn_item(param_sender);
end

function UINotice:on_btn_true(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if param_sender.btn_action==nil or param_sender.btn_action=="" then 
        return ;
    end

    local event = cc.EventCustom:new("MSG_DO_TASK");
    event.command = param_sender.btn_action
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end
function UINotice:update_layout()
    local int_line_count=#self.list_item
    local the_item_size=cc.size(240,80)
    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,the_item_size.height*int_line_count)

    if the_scrollview_size.height< self.ptr_scrollview:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)
    local float_space_y = the_item_size.height;
	local float_pos_x = the_item_size.width/2
    local float_pos_y = the_scrollview_size.height - the_item_size.height/2 ;
    for k,v in pairs(self.list_item) do 
        v.bg:setVisible(true);
        v.bg:setPosition(float_pos_x,float_pos_y)
        float_pos_y =float_pos_y- float_space_y;
    end
end


return UINotice