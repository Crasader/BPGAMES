local UIBugleSend=class("UIBugleSend",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/bugle/")
local UIRichText=require("bptools/ui_richtext")
function UIBugleSend:ctor()
    print("hjjlog>>UIBugleSend")
    self.list_chat_item_sleep={}
    self.list_chat_item={}
    self.m_int_type=1;
    self.m_int_mode=1;
    self.m_int_game_id=0;
    self.m_int_room_id=0;
    self:init();
end

function UIBugleSend:destory()
    
end


function UIBugleSend:init()
    local   l_lister= cc.EventListenerCustom:create(PUSH_NOTIE_MESSAGE, function (eventCustom)
          self:on_notice_message(eventCustom);
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA", function (eventCustom)
          self:on_update_user_data(eventCustom);
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    self.the_size=cc.size(780,480);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);
    
    local l_bg=control_tools.newImg({path=g_path.."bugle_bg.png"})
    self:addChild(l_bg)
    l_bg:setPosition(cc.p(780/2,480/2+30))


    test_bg=control_tools.newImg({path=TESTCOLOR.r,size=cc.size(760,385),anchor=cc.p(0,0)})
    self:addChild(test_bg);
    test_bg:setPosition(cc.p(10,80))

    self.ptr_scrollview=ccui.ScrollView:create();
    self:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(cc.size(760,385))
    self.ptr_scrollview:setPosition(cc.p(10,80))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)

    self.ptr_btn_choose_bugle=control_tools.newBtn({normal=g_path.."btn_bugle.png",small=true})
    self:addChild(self.ptr_btn_choose_bugle)
    self.ptr_btn_choose_bugle:setPosition(cc.p(70,35))
    self.ptr_btn_choose_bugle:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_bugle(param_sender,param_touchType) end)

    self.ptr_label_bugle=control_tools.newLabel({font=24,color=cc.c3b(250,255,223)})
    self.ptr_btn_choose_bugle:addChild(self.ptr_label_bugle)
    self.ptr_label_bugle:setPosition(cc.p(75,35))

    self.ptr_bg_bugle=control_tools.newImg({path=g_path.."bg_bugle.png"})
    self:addChild(self.ptr_bg_bugle)
    self.ptr_bg_bugle:setPosition(cc.p(70,125))
    self.ptr_bg_bugle:setVisible(false)

    self.ptr_btn_small_bugle=control_tools.newBtn({normal=g_path.."test_green.png",pressed=g_path.."test_green.png",size=cc.size(115,40)})
    self.ptr_bg_bugle:addChild(self.ptr_btn_small_bugle)
    self.ptr_btn_small_bugle:setPosition(cc.p(65,80))
    self.ptr_btn_small_bugle.id=0;
    self.ptr_btn_small_bugle:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_choose_bugle(param_sender,param_touchType) end)

    self.ptr_label_small_bugle=control_tools.newLabel({font=24,color=cc.c3b(254,243,184)})
    self.ptr_bg_bugle:addChild(self.ptr_label_small_bugle)
    self.ptr_label_small_bugle:setPosition(cc.p(65,85))
    self.ptr_label_small_bugle:setString("小喇叭(9)")

    self.ptr_btn_big_bugle=control_tools.newBtn({normal=g_path.."test_green.png",pressed=g_path.."test_green.png",size=cc.size(115,40)})
    self.ptr_bg_bugle:addChild(self.ptr_btn_big_bugle)
    self.ptr_btn_big_bugle:setPosition(cc.p(65,30))
    self.ptr_btn_big_bugle.id=1;
    self.ptr_btn_big_bugle:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_choose_bugle(param_sender,param_touchType) end)


    self.ptr_label_big_bugle=control_tools.newLabel({font=24,color=cc.c3b(254,243,184)})
    self.ptr_bg_bugle:addChild(self.ptr_label_big_bugle)
    self.ptr_label_big_bugle:setPosition(cc.p(65,25))
    self.ptr_label_big_bugle:setString("大喇叭(9)")

    local l_edit=control_tools.newImg({path=g_path.."bg_edit.png"})
    self:addChild(l_edit);
    l_edit:setPosition(cc.p(370,35))


    self.ptr_edit_chat = ccui.EditBox:create(cc.size(440,50),g_path.."kong.png")
    self.ptr_edit_chat:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
    self:addChild(self.ptr_edit_chat)
    self.ptr_edit_chat:setPosition( cc.p(370,35) )
    self.ptr_edit_chat:setPlaceHolder("请输入需要发送的内容")
    self.ptr_edit_chat:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.ptr_edit_chat:setPlaceholderFontSize(28)
    self.ptr_edit_chat:setPlaceholderFontColor(cc.c3b(225,196,164))
    self.ptr_edit_chat:setFontSize(28)
    self.ptr_edit_chat:setFontColor(cc.c3b(185,143,89))
    self.ptr_edit_chat:setMaxLength(25)


    self.ptr_btn_send=control_tools.newBtn({normal=g_path.."btn_send.png",small=true})
    self:addChild(self.ptr_btn_send)
    self.ptr_btn_send:setPosition(cc.p(690,30))
    self.ptr_btn_send:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_send(param_sender,param_touchType) end)

    self:clear_item()
    for k,v in pairs(get_share_game_push().m_list_messages) do 
        print("hjjlog>>push_message:",v.id,v.message);
        self:get_a_item(v)
    end
    self:update_layout()
    self:on_update_user_data()

end

function UIBugleSend:clear_item()
    for k,v in pairs(self.list_chat_item) do
        v.bg:setVisible(false)
        table.insert( self.list_chat_item_sleep, v )
    end
    self.list_chat_item={}
 end

 function UIBugleSend:get_a_item(param_table)
    local l_item={}
    if #self.list_chat_item_sleep >0 then 
        l_item=self.list_chat_item_sleep[#self.list_chat_item_sleep]
        table.remove( self.list_chat_item_sleep,#self.list_chat_item_sleep )
        table.insert( self.list_chat_item,l_item)
    else 
        l_item={}
        local l_item_bg= ccui.Layout:create()
        l_item.bg=l_item_bg;
        self.ptr_scrollview:addChild(l_item_bg)
        
        local l_img_flag=control_tools.newImg({path=g_path.."flag_system.png"})
        l_item_bg:addChild(l_img_flag)
        l_img_flag:setPosition(cc.p(35,-15))
        l_item.flag=l_img_flag;

        local l_rich_message=UIRichText:create(24,cc.c3b(156, 60, 60),"Arial",cc.size(680,60))
        l_item_bg:addChild(l_rich_message)
        l_rich_message:setAnchorPoint(cc.p(0,1))
        l_rich_message:setPosition(cc.p(70,-3))
        l_item.ptr_rich=l_rich_message;
        table.insert(self.list_chat_item,l_item)
    end
    self:update_item_data(l_item,param_table)
    return l_item;
 end
 function UIBugleSend:update_item_data(param_item,param_table)
    if param_table.id==0 then 
        param_item.flag:loadTexture(g_path.."flag_system.png")
        param_item.ptr_rich:setNormalColor(cc.c3b(156, 60, 60))
    elseif param_table.id==1 then 
        param_item.flag:loadTexture(g_path.."flag_user.png")
        param_item.ptr_rich:setNormalColor(cc.c3b(174,119,86))
    end
    if param_table.message~=nil then 
        param_item.ptr_rich:setTextEx(param_table.message)
    end
 end

 function UIBugleSend:update_layout()
    local l_height=0;
    for k,v in pairs(self.list_chat_item) do
        local l_size=v.ptr_rich:getTextSize();
        l_height=l_height+l_size.height+4;
    end

    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,l_height)

    if the_scrollview_size.height< self.ptr_scrollview:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)

    local float_pos_y = the_scrollview_size.height 
    print("hjjlog>>update_layout:",float_pos_y);


    local int_index=0;
    for k,v in pairs(self.list_chat_item) do 
        v.bg:setVisible(true);
        v.bg:setPosition(0,float_pos_y)
        float_pos_y =float_pos_y- v.ptr_rich:getTextSize().height-4;
    end
 end
 function UIBugleSend:set_game_data(param_mode,param_game_id,param_room_id)
    self.m_int_mode=param_mode;
    self.ptr_btn_choose_bugle:setTouchEnabled(true)
    if self.m_int_mode==0 then 
        self.ptr_btn_choose_bugle:setTouchEnabled(false)
        self.ptr_bg_bugle:setVisible(false)
        self.m_int_type=1;
        self:on_update_user_data();
    end
    self.m_int_game_id=param_game_id;
    self.m_int_room_id=param_room_id;
 end


 function UIBugleSend:on_update_user_data()
    local l_small_count=bp_get_self_prop_count(PROP.ID_PROP_SMALL_BUGLE)
    local l_big_count=bp_get_self_prop_count(PROP.ID_PROP_BIG_BUGLE)
    self.ptr_label_small_bugle:setString("小喇叭("..l_small_count..")")
    self.ptr_label_big_bugle:setString("大喇叭("..l_big_count..")")
    if self.m_int_type==0 then 
        self.ptr_label_bugle:setString("小喇叭("..l_small_count..")")
    else
        self.ptr_label_bugle:setString("大喇叭("..l_big_count..")")
    end

 end

 function UIBugleSend:on_notice_message(param_event)
    local l_message=param_event.message;
    local l_data={}
    l_data.id=0
    l_data.message=l_message
    self:get_a_item(l_data)
    self:update_layout()
 end

 function UIBugleSend:on_notice_bugle(param_event)

    local l_message=param_event.message;
    local l_data={}
    l_data.id=1
    l_data.message=l_message
    self:get_a_item(l_data)
    self:update_layout()
 end

 function UIBugleSend:on_btn_send(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end

    local l_edit_message=self.ptr_edit_account:getText();
    if l_edit_message=="" then 
        bp_show_hinting("请输入发送的信息")
        return ;
    end

    local l_small_count=bp_get_self_prop_count(PROP.ID_PROP_SMALL_BUGLE)
    local l_big_count=bp_get_self_prop_count(PROP.ID_PROP_BIG_BUGLE)
    local l_prop_id=0;
    local l_prop_name=""
    local l_prop_count=0;
    if self.m_int_type== 0 then 
        l_prop_id=PROP.ID_PROP_SMALL_BUGLE
        l_prop_name="小喇叭"
        l_prop_count=l_small_count;
    else
        l_prop_id=PROP.ID_PROP_BIG_BUGLE
        l_prop_name="大喇叭"
        l_prop_count=l_big_count;
    end

    if l_prop_count<0 then 
        if bp_have_mask_module(LC.MASK_MODULE_SHOP) then 

            bp_show_message_box("提示","你没有【"..l_prop_name.."】，无法发送信息",1,
            "立即购买","稍后再说",
            function(param_1,param_2)  self:on_btn_change_ok(param_1,param_2)  end,
            function(param_1,param_2) end,self.m_int_sex,"") 
        else 
            bp_show_hinting("你没有【"..l_prop_name.."】，无法发送信息")
        end
    end
    local l_user_data=json.decode(bp_get_self_user_data());
    local l_message="";
    if l_prop_id==PROP.ID_PROP_SMALL_BUGLE then    
        l_message="["..l_user_data.nickname.."]说："..l_edit_message
        l_message=bp_base64_encode(l_message)
    else 


    end
    local the_value={}
    the_value.userid=l_user_data.userid
    the_value.sex=l_user_data.sex
    the_value.faceid=l_user_data.faceid
    the_value.vipid=l_user_data.vipid
    the_value.msg=l_message
    local l_str=json.encode(the_value)

    if #l_str>800 then 
        bp_show_hinting("你发送的消息过长")
        return ;
    end
    local l_location_id=self.m_int_game_id*1000+self.m_int_room_id;

    if l_prop_id==PROP.ID_PROP_SMALL_BUGLE then 
        local l_str_param={}
        l_str_param.msg=l_str
        l_str_param.locationid=l_location_id
        request_use_prop(l_prop_id,json.encode(l_str_param))
    else
        local l_str_param={}
        l_str_param.msg=l_str
        request_use_prop(l_prop_id,json.encode(l_str_param))
    end
end

function UIBugleSend:request_use_prop(param_prop_id,param_str)
    bp_show_loading(1)
    local req = URL.HTTP_USE_PROP
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{PROPID}",param_prop_id);
    req=bp_string_replace_key(req,"{PARAM}",param_str);
    bp_http_get("HTTP_CHANGE_ACCOUNT","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_use_prop(param_identifier,param_success,param_code,param_header,context) end,1)

end
function UIBugleSend:on_http_use_prop(param_identifier,param_success,param_code,param_header,context)

    bp_show_loading(0)
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>on_http_change_realname   fail");
        bp_show_hinting("发送消息失败...")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end

    local l_resdata=l_data.resdata.msg
    bp_update_user_data(1)
    get_share_game_push():insert_bugle_message(bp_base64_decode(l_resdata))

end

function UIBugleSend:on_btn_buy_ok(param_1,param_2)

    local event = cc.EventCustom:new("MSG_DO_TASK");
    event.command = ""
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

function UIBugleSend:on_btn_choose_bugle(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self.m_int_type=param_sender.id;
    self:on_update_user_data();
    self.ptr_bg_bugle:setVisible(false)
end

function UIBugleSend:on_btn_bugle(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if self.m_int_mode==0 then 
        return ;
    end

    if self.ptr_bg_bugle:isVisible()==true then 
        self.ptr_bg_bugle:setVisible(false)
    else
        self.ptr_bg_bugle:setVisible(true)
    end

end


return UIBugleSend

