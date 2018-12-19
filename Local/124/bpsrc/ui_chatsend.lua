local UIControl=require("bpsrc/ui_control")
local UIChatSend=class("UIChatSend",UIControl)
local g_path=BPRESOURCE("bpres/bugle/")
local HTTP_PUT_USER_RESOURCES="http://bookse.oss-cn-hangzhou.aliyuncs.com";

sptr_chat_send=nil
function UIChatSend:ctor(...)
    print("hjjlog>>UIChatSend")
    self.super:ctor(self)
    self.list_common={}
    self.list_common_sleep={}
    self.list_record={}
    self.list_record_sleep={}
    self._schedule=nil
    self.m_int_time=0;
    self:init();
end
function UIChatSend:destory()

end
function UIChatSend:init()
    self.sharedScheduler = CCDirector:getInstance():getScheduler()
    
    local   l_lister= cc.EventListenerCustom:create("NOTICE_USER_CHAT", function (eventCustom)
        self:on_event_user_chat(eventCustom);
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)


    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_chat1.png")
    local l_bg=self:get_gui();
    self.the_size=l_bg:getContentSize();

    local l_bg_emoji=control_tools.newImg({path=g_path.."bg_emoji.png"})
    l_bg:addChild(l_bg_emoji)
    l_bg_emoji:setPosition(cc.p(250,275))

    local l_img_title=control_tools.newImg({path=g_path.."btn_title_1.png"})
    l_bg_emoji:addChild(l_img_title)
    l_img_title:setPosition(cc.p(75,395))

    local l_label_emoji=control_tools.newLabel({font=24,color=cc.c3b(132,70,20)})
    l_img_title:addChild(l_label_emoji)
    l_label_emoji:setPosition(cc.p(154/2,60/2))
    l_label_emoji:setString("常用表情")


    self.ptr_scrollview_emoji=ccui.ScrollView:create();
    l_bg_emoji:addChild(self.ptr_scrollview_emoji);
    self.ptr_scrollview_emoji:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview_emoji:setContentSize(cc.size(430,350))
    self.ptr_scrollview_emoji:setPosition(cc.p(6,10))
    self.ptr_scrollview_emoji:setScrollBarAutoHideEnabled(false)


    local int_line_count=math.ceil(26/4)
    local the_scrollview_size=cc.size(self.ptr_scrollview_emoji:getContentSize().width,90*int_line_count)

    if the_scrollview_size.height< self.ptr_scrollview_emoji:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview_emoji:getContentSize().height
    end
    self.ptr_scrollview_emoji:setInnerContainerSize(the_scrollview_size)

    local l_interval_x=(430-80*4)/4+80
    local l_x=l_interval_x/2;
    local l_y=the_scrollview_size.height-45;
    for i=0,26 do
        local l_btn_emoji=control_tools.newBtn({normal=g_path.."emoji/emoji_"..i..".png",pressed=g_path.."emoji/emoji_"..i..".png"})
        l_btn_emoji:setScale(0.4);
        self.ptr_scrollview_emoji:addChild(l_btn_emoji)
        l_btn_emoji:setPosition(cc.p(l_x,l_y))
        l_btn_emoji.id=i;        
        l_btn_emoji:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_emoji(param_sender,param_touchType)  end)
        l_x=l_x+l_interval_x;
        if (i+1)%4==0 then 
            l_x=l_interval_x/2;
            l_y=l_y-90;
            local l_line=control_tools.newImg({path=g_path.."img_line.png"})
            self.ptr_scrollview_emoji:addChild(l_line)
            l_line:setPosition(cc.p(200,l_y+45))
        end
    end

    local l_bg_chat=control_tools.newImg({path=g_path.."bg_common.png"})
    l_bg:addChild(l_bg_chat)
    l_bg_chat:setPosition(cc.p(630,275))

    self.ptr_btn_title_common=control_tools.newBtn({normal=g_path.."btn_title_1.png",pressed=g_path.."btn_title_1.png"})
    self.ptr_btn_title_common:loadTextures(g_path.."btn_title_1.png",g_path.."btn_title_1.png",g_path.."btn_title_2.png")
    l_bg_chat:addChild(self.ptr_btn_title_common)
    self.ptr_btn_title_common:setPosition(cc.p(75,395))
    self.ptr_btn_title_common.id=0
    self.ptr_btn_title_common:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_choose_view(param_sender,param_touchType) end)

    local l_label_common=control_tools.newLabel({font=24,color=cc.c3b(132,70,20)})
    self.ptr_btn_title_common:addChild(l_label_common)
    l_label_common:setPosition(cc.p(154/2,60/2))
    l_label_common:setString("常用语")

    
    self.ptr_btn_title_record=control_tools.newBtn({normal=g_path.."btn_title_1.png",pressed=g_path.."btn_title_1.png"})
    self.ptr_btn_title_record:loadTextures(g_path.."btn_title_1.png",g_path.."btn_title_1.png",g_path.."btn_title_2.png")
    l_bg_chat:addChild(self.ptr_btn_title_record)
    self.ptr_btn_title_record:setPosition(cc.p(235,395))
    self.ptr_btn_title_record.id=1
    self.ptr_btn_title_record:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_choose_view(param_sender,param_touchType) end)

    local l_label_common=control_tools.newLabel({font=24,color=cc.c3b(132,70,20)})
    self.ptr_btn_title_record:addChild(l_label_common)
    l_label_common:setPosition(cc.p(154/2,60/2))
    l_label_common:setString("聊天记录")


    self.ptr_scrollview_chat=ccui.ScrollView:create();
    l_bg_chat:addChild(self.ptr_scrollview_chat);
    self.ptr_scrollview_chat:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview_chat:setContentSize(cc.size(320,350))
    self.ptr_scrollview_chat:setPosition(cc.p(7,10))
    self.ptr_scrollview_chat:setScrollBarAutoHideEnabled(false)
    self.ptr_scrollview_chat:setVisible(true)

    self.ptr_scrollview_record=ccui.ScrollView:create();
    l_bg_chat:addChild(self.ptr_scrollview_record);
    self.ptr_scrollview_record:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview_record:setContentSize(cc.size(320,350))
    self.ptr_scrollview_record:setPosition(cc.p(7,10))
    self.ptr_scrollview_record:setScrollBarAutoHideEnabled(false)
    self.ptr_scrollview_record:setVisible(false)
    


    self.ptr_btn_voice=control_tools.newBtn({normal=g_path.."btn_voice.png",small=true})
    l_bg:addChild(self.ptr_btn_voice)
    self.ptr_btn_voice:setPosition(cc.p(75,50))
    self.ptr_btn_voice:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_voice(param_sender,param_touchType) end)


    local l_edit=control_tools.newImg({path=g_path.."bg_edit.png"})
    l_bg:addChild(l_edit);
    l_edit:setPosition(cc.p(370,50))


    self.ptr_edit_chat = ccui.EditBox:create(cc.size(440,50),g_path.."kong.png")
    self.ptr_edit_chat:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
    l_bg:addChild(self.ptr_edit_chat)
    self.ptr_edit_chat:setPosition( cc.p(370,50) )
    self.ptr_edit_chat:setPlaceHolder("请输入需要发送的内容")
    self.ptr_edit_chat:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.ptr_edit_chat:setPlaceholderFontSize(28)
    self.ptr_edit_chat:setPlaceholderFontColor(cc.c3b(225,196,164))
    self.ptr_edit_chat:setFontSize(28)
    self.ptr_edit_chat:setFontColor(cc.c3b(185,143,89))
    self.ptr_edit_chat:setMaxLength(25)


    self.ptr_btn_send=control_tools.newBtn({normal=g_path.."btn_send.png",small=true})
    l_bg:addChild(self.ptr_btn_send)
    self.ptr_btn_send:setPosition(cc.p(705,50))
    self.ptr_btn_send:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_send(param_sender,param_touchType) end)

    self.ptr_btn_title_record:setBright(false)
    self.ptr_scrollview_chat:setVisible(true)
    self.ptr_scrollview_record:setVisible(false)

    self.ptr_img_voice=control_tools.newImg({path=g_path.."bg_voice.png"})
    l_bg:addChild(self.ptr_img_voice)
    self.ptr_img_voice:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self.ptr_img_voice:setVisible(false)

    self.ptr_label_voice=control_tools.newLabel({font=26,color=cc.c3b(158,101,64)})
    self.ptr_img_voice:addChild(self.ptr_label_voice)
    self.ptr_label_voice:setPosition(cc.p(90,35))

    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path.."dh_dt_ltbq/dh_dt_ltbq.ExportJson")
    -- --ccs.Armature:create("shuangkou_donghua_baozha")
    -- local armature = ccs.Armature:create("dh_dt_ltbq")
    -- armature:setPosition(0, 0)                    -- 设置位置
    -- l_bg_emoji:addChild(armature)                      -- 把动画对象加载到场景内
    -- armature:getAnimation():play("dh_dt_ltbq1",-1,1)            -- 设置动画对象执行的动画名称
    -- armature:setScale(0.5)

    -- local l_test_table={}
    -- table.insert( l_test_table,"快点吧，我等的花儿都谢了" )
    -- table.insert( l_test_table,"你的牌打得太好了！" )
    -- table.insert( l_test_table,"你好，很高心认识你！" )
    -- table.insert( l_test_table,"怎么这么多炸弹，我都被炸晕了。" )
    -- table.insert( l_test_table,"你的牌打得太好了11111" )
    -- table.insert( l_test_table,"222222222222" )
    -- table.insert( l_test_table,"3333333333333" )
    -- table.insert( l_test_table,"你的牌打得太好了4444444" )
    -- table.insert( l_test_table,"你的牌打得太好了4444444" )
    -- table.insert( l_test_table,"你的牌打得太好了4444444" )
    -- table.insert( l_test_table,"你的牌打得太好了4444444" )
    -- table.insert( l_test_table,"你的牌打得太好了4444444" )
    -- table.insert( l_test_table,"你的牌打得太好了4444444" )
    -- self:init_common_chat(l_test_table)   
end

function UIChatSend:clear_common_label()
    for k,v in pairs(self.list_common) do
        -- v.bg:setVisible(false)
        table.insert( self.list_common_sleep, v )
    end
    self.list_common={}
 end

 function UIChatSend:get_a_common_label(param_string)
    local l_item={}
    if #self.list_common_sleep >0 then 
        l_item=self.list_common_sleep[#self.list_common_sleep]
        table.remove( self.list_common_sleep,#self.list_common_sleep )
        table.insert( self.list_common,l_item )
    else 
        
        local l_label_message=control_tools.newLabel({ex=true,font=24,color=cc.c3b(132,70,20),anchor=cc.p(0,1)})
        self.ptr_scrollview_chat:addChild(l_label_message);
        l_item.ptr_label=l_label_message;

        local l_btn_label=control_tools.newBtn({normal=g_path.."test_green.png",pressed=g_path.."test_green.png",anchor=cc.p(0,0)})
        l_label_message:addChild(l_btn_label)
        l_item.ptr_btn=l_btn_label
        l_btn_label:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_common(param_sender,param_touchType) end)

        local l_img_line=control_tools.newImg({path=g_path.."img_line.png"})
        l_label_message:addChild(l_img_line)
        l_item.ptr_line=l_img_line;
        table.insert( self.list_common, l_item )
    end
    if param_string~=nil then 

        l_item.ptr_label:setTextEx(param_string,320,3)
        local l_label_size=l_item.ptr_label:getContentSize()
        l_item.ptr_btn:setScale9Enabled(true)
		l_item.ptr_btn:setContentSize(cc.size(320,l_label_size.height))
        l_item.ptr_btn.text=param_string;
    end

    return l_item;
 end

 function UIChatSend:clear_record_label()
    for k,v in pairs(self.list_record) do
        v.bg:setVisible(false)
        table.insert( self.list_record_sleep, v )
    end
    self.list_record={}
 end

 function UIChatSend:get_a_record_label()
    local l_item={}
    if #self.list_record_sleep >0 then 
        local l_item=self.list_record_sleep[#self.list_record_sleep]
        table.remove( self.list_record_sleep,#self.list_record_sleep )
        table.insert( self.list_record,l_item )
        l_item.ptr_emoji:setVisible(false)
        l_item.ptr_speak:setVisible(false)
        return l_item;
    else 
        local l_label_message=control_tools.newLabel({ex=true,font=24,color=cc.c3b(132,70,20),anchor=cc.p(0,1)})
        self.ptr_scrollview_record:addChild(l_label_message);
        l_item.ptr_label=l_label_message;

        local l_img_emoji=control_tools.newImg({path=g_path.."kong.png"})
        l_img_emoji:setScale(0.2)
        l_label_message:addChild(l_img_emoji)
        l_item.ptr_emoji=l_img_emoji
        l_img_emoji:setVisible(false)

        local l_btn_speak=control_tools.newBtn({normal=g_path.."btn_speak_common.png",pressed=g_path.."btn_speak_common.png"})
        l_label_message:addChild(l_btn_speak)
        l_item.ptr_speak=l_btn_speak;
        l_btn_speak:setVisible(false)
        l_btn_speak:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_voice(param_sender,param_touchType) end)

        local l_label_voice=control_tools.newLabel({ex=true,font=20,color=cc.c3b(255,255,255)})
        l_btn_speak:addChild(l_label_voice)
        l_label_voice:setPosition(cc.p(60,25))
        l_item.ptr_label_voice=l_label_voice;

        table.insert( self.list_record, l_item )
        return l_item;
    end
 end

function UIChatSend:init_common_chat(param_table)
    self:clear_common_label();
    for k,v in pairs(param_table) do    
        local l_item=self:get_a_common_label(v);

    end

    local l_total_height=0;
    for k,v in pairs(self.list_common) do 
        local l_label_size=v.ptr_label:getContentSize()
        local l_height=l_label_size.height;
        l_total_height=l_total_height+l_height+10;
        v.ptr_line:setPosition(cc.p(424/2,0))
    end
    
    local the_scrollview_size=cc.size(self.ptr_scrollview_chat:getContentSize().width,l_total_height)

    if the_scrollview_size.height< self.ptr_scrollview_chat:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview_chat:getContentSize().height
    end
    self.ptr_scrollview_chat:setInnerContainerSize(the_scrollview_size)

    local l_y=the_scrollview_size.height;
    for k,v in pairs(self.list_common) do
        local l_label_size=v.ptr_label:getContentSize()
        v.ptr_label:setPosition(cc.p(5,l_y))
        l_y=l_y-l_label_size.height-10;
    end
    self.ptr_scrollview_chat:jumpToTop();

end

function UIChatSend:on_btn_emoji(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local l_str=""
    if param_sender.id<10 then 
        l_str="[EM]0"..param_sender.id
    else
        l_str="[EM]"..param_sender.id
    end
    print("hjjlog>>on_btn_emoji",param_sender.id);
    bind_function.send_user_chat(l_str)
    self:ShowGui(false)
end


function UIChatSend:on_btn_common(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    bind_function.send_user_chat(bp_utf2gbk(param_sender.text))
end

function UIChatSend:on_btn_choose_view(param_sender,param_touchType)
    self.ptr_btn_title_common:setBright(true)
    self.ptr_btn_title_record:setBright(true)
    if param_sender.id==0 then 
        self.ptr_btn_title_record:setBright(false)
        self.ptr_scrollview_chat:setVisible(true)
        self.ptr_scrollview_record:setVisible(false)
    else
        self.ptr_btn_title_common:setBright(false)
        self.ptr_scrollview_chat:setVisible(false)
        self.ptr_scrollview_record:setVisible(true)
    end
end
function UIChatSend:on_btn_send(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local l_str_message=self.ptr_edit_chat:getText();
    if #l_str_message==0 then 
        bp_show_hinting("发送消息不可为空")
        return ;
    end
    bind_function.send_user_chat(bp_utf2gbk(l_str_message))
end
function UIChatSend:on_btn_voice(param_sender,param_touchType)
    if param_touchType==_G.TOUCH_EVENT_BEGAN then
        --hjj_for_wait:语音真机调试。
        self.ptr_img_voice:loadTexture(g_path.."bg_voice.png")
        self.ptr_img_voice:setVisible(true)
        self.ptr_label_voice:setString("0")
        self.m_int_time=0;
        if self._schedule==nil then 
            self._schedule=self.sharedScheduler:scheduleScriptFunc(function(dt) self:update_voice_time(dt) end ,1,false) 
        end
        return 
    elseif param_touchType==_G.TOUCH_EVENT_MOVED then 
        local l_pos=self.ptr_btn_voice:getWorldPosition();
        local move_pos = param_sender:getTouchMovePosition()
        if move_pos.x>=l_pos.x-50 and move_pos.x<=l_pos.x+50 and move_pos.y>l_pos.y-35 and move_pos.y<l_pos.y+35 then 
            self.ptr_img_voice:loadTexture(g_path.."bg_voice.png")
            self.ptr_img_voice:setVisible(true)
            self.ptr_label_voice:setVisible(true)
        else
            self.ptr_img_voice:loadTexture(g_path.."bg_cancel.png")
            self.ptr_label_voice:setVisible(false)
        end
    elseif param_touchType==_G.TOUCH_EVENT_CANCELED then 
        if self._schedule~=nil then
            self.sharedScheduler:unscheduleScriptEntry(self._schedule)
            self._schedule=nil
        end
        self.ptr_img_voice:setVisible(false)
        self.ptr_label_voice:setString("")
        bp_show_hinting("录音取消")
        return ;
    elseif param_touchType==_G.TOUCH_EVENT_ENDED then 
        if self._schedule~=nil then
            self.sharedScheduler:unscheduleScriptEntry(self._schedule)
            self._schedule=nil
        end
        self.ptr_img_voice:setVisible(false)
        if m_int_time<2 then 
            bp_show_hinting("录音失败")
            return 
        end

        --语音成功。 真实数据。
        bp_show_loading(1)
        local req =HTTP_PUT_USER_RESOURCES
        req=bp_make_url(req)
        req=bp_string_replace_key(req,"&quot;","\"");
        local post=""
        bp_http_post("HTTP_PUT_USER_RESOURCES","",req,post,function(param_identifier,param_success,param_code,param_header,context) self:on_http_upload_talking(param_identifier,param_success,param_code,param_header,context) end,1)

        return ;
    end
end
function UIChatSend:on_http_upload_talking(param_identifier,param_success,param_code,param_header,context)

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


end
function UIChatSend:update_voice_time(param_dt)
    self.m_int_time=self.m_int_time+1;
    self.ptr_label_voice:setString(""..self.m_int_time);
end

function UIChatSend:on_event_user_chat(eventCustom)
    if eventCustom==nil then 
        return ;
    end
    local l_table={}
    l_table.chat=eventCustom.chat;
    l_table.userid=eventCustom.userid;
    l_table.username=eventCustom.username;

    local l_name=l_table.username;

    local l_item_record=self:get_a_record_label()
    if #l_table.chat==6 then 
        local l_key=string.sub(l_table.chat,1,4)
        local l_value=string.sub(l_table.chat,5,6)
        print("hjjlog>>on_event",l_key,l_value);
        if l_key=="[EM]"   then 
            l_item_record.ptr_label:setTextEx(l_name..":",254,1)
            local l_size=l_item_record.ptr_label:getContentSize();
            l_item_record.ptr_emoji:setVisible(true)
            l_item_record.ptr_emoji:setPosition(cc.p(l_size.width+20,l_size.height/2))
            l_item_record.ptr_emoji:loadTexture(g_path.."emoji/emoji_"..tonumber(l_value)..".png")
            self:update_layout_record()
            return ;
        end    
    end

    local l_begin_1,l_end_1=string.find( l_table.chat,"mp3_file" )
    local l_begin_2,l_end_2=string.find( l_table.chat,"mp3_time" )
    print("hjjlog>>start_end:",l_begin_1,l_end_1,l_begin_2,l_end_2);
    --语音
    if l_begin_1~=nil and l_end_1~=nil and l_begin_2~=nil and l_end_2~=nil then 
        local l_voice=json.decode(l_table.chat)
        l_item_record.ptr_speak:setVisible(true)
        l_item_record.ptr_speak.mp3_file=l_voice.mp3_file
        l_item_record.ptr_speak.mp3_time=l_voice.mp3_time
        l_item_record.ptr_label_voice:setString(l_voice.mp3_time.."”")

        l_item_record.ptr_label:setTextEx(l_name..":",175,1)
        local l_size=l_item_record.ptr_label:getContentSize();
        l_item_record.ptr_speak:setPosition(cc.p(l_size.width+70,l_size.height/2))
        self:update_layout_record()
    else 
        l_item_record.ptr_emoji:setVisible(false)
        l_item_record.ptr_label:setTextEx(l_name..":"..l_table.chat,315,3)
        self:update_layout_record()
    end
end
function UIChatSend:on_btn_voice(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    --假装有声音播放了。
    audio_engine.playEffect(param_sender.mp3_file)
end

function UIChatSend:update_layout_record()
    local l_total_height=0;
    for k,v in pairs(self.list_record) do 
        local l_label_size=v.ptr_label:getContentSize()
        local l_height=l_label_size.height;
        l_total_height=l_total_height+l_height+10;
    end
    
    local the_scrollview_size=cc.size(self.ptr_scrollview_record:getContentSize().width,l_total_height)

    if the_scrollview_size.height< self.ptr_scrollview_record:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview_record:getContentSize().height
    end
    self.ptr_scrollview_record:setInnerContainerSize(the_scrollview_size)

    local l_y=the_scrollview_size.height;
    for k,v in pairs(self.list_record) do
        local l_label_size=v.ptr_label:getContentSize()
        v.ptr_label:setPosition(cc.p(5,l_y))
        l_y=l_y-l_label_size.height-10;
    end
    self.ptr_scrollview_record:jumpToTop();

end



function UIChatSend.ShowChatCenter(param_show)
    if sptr_chat_send==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_chat_send=UIChatSend:create();
        main_layout:addChild(sptr_chat_send)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_chat_send:ShowGui(param_show)
    return sptr_chat_send;
end

function UIChatSend.Instance()
    if sptr_chat_send==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_chat_send=UIChatSend:create();
        main_layout:addChild(sptr_chat_send)
    end
    return sptr_chat_send;
end


return UIChatSend