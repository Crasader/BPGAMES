local UIControl=require("src/ui_control")
local UITaskGuide=class("UITaskGuide",UIControl)
local g_path=BPRESOURCE("res/taskguide/")
local UITaskDay=require("src/ui_taskday")
local UIGoldRain=require("src/ui_goldrain")
local UIRichText=require("bptools/ui_richtext")

local BTN_TYPE={
    COMMENT=1,
    UPDATE=2,
    LUCK=3,
    GIFT=4,
    BIND=5,
    VIP=6,
    WXLINE=7,
    WXFRIEND=8,
    TASK=9
}
function UITaskGuide:ctor(...)
    print("hjjlog>>UITaskGuide")
    self.super:ctor(self)
    self.list_item_sleep={}
    self.list_item={}
    self:init();
end
function UITaskGuide:destory()

end
function UITaskGuide:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_task_guide.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();

    
    local the_scrollview=cc.size(740,420)

    local test_bg=control_tools.newImg({path=TESTCOLOR.g,size=the_scrollview,anchor=cc.p(0,0)})
   -- test_bg:setPosition(cc.p(the_scrollview.width/2,the_scrollview.height/2))
    l_bg:addChild(test_bg);
    test_bg:setPosition(cc.p(15,15))

    self.ptr_scrollview=ccui.ScrollView:create();
    l_bg:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(the_scrollview)
    self.ptr_scrollview:setPosition(cc.p(15,15))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)

    --以下有一定的顺序。
    --评论奖励
    local l_table_comment={
        icon="icon_comment.png",
        title="评论奖励",
        describe="五星好评并留下精彩评论，奖励<color value=0xfff69812>1000<color value=0xffb37d52>金币",
        btngui="btn_comment.png",
        id=BTN_TYPE.COMMENT,
        visible=false,
        touch=true;
    }
    local l_item_comment=self:get_a_item(l_table_comment)
    if bp_get_areaid()==2 then 
        --bp_get_save_value
        --bp_set_local_value
        local l_local_comment_version=bp_get_save_value("comment_version","0")
        local l_int_curr_comment_version=tonumber(l_local_comment_version)
        if bp_get_cur_version()<=bp_get_version() and l_int_curr_comment_version < bp_get_cur_version() then 
            local l_int_award_version=tonumber(bp_get_save_value("comment_award","0"))
            if l_int_award_version==1 then 
                self:update_item_data(l_item_comment,{visible=true,btngui="btn_receive.png"})
            elseif l_int_award_version==0 then 
                self:update_item_data(l_item_comment,{visible=true,btngui="btn_comment.png"})
            else
                self:update_item_data(l_item_comment,{visible=false})

            end
        end
    end
    --升级奖励
    local l_table_update={
        icon="icon_update.png",
        title="升级奖励",
        describe="升级奖励文案。。。",
        btngui="btn_comment.png",
        id=BTN_TYPE.UPDATE,
        visible=false,
        touch=true;
    }
    local l_item_update=self:get_a_item(l_table_update)
    local int_update_version=tonumber(bp_get_save_value("update_version", "0"))
    if int_update_version<bp_get_cur_version() then 
        if bp_get_cur_version()<=bp_get_version() then 
            self:update_item_data(l_item_update,{visible=true,btngui="btn_receive.png"})
        else
            self:update_item_data(l_item_update,{visible=true,btngui="btn_update.png"})
        end
    end
    --幸运转盘
    local l_table_luck={
        icon="icon_luck.png",
        title="幸运转盘",
        describe="幸运转盘。。。文案",
        btngui="btn_receive.png",
        id=BTN_TYPE.LUCK,
        visible=false,
        touch=true;
    }
    local l_item_luck=self:get_a_item(l_table_luck)
    if bp_have_mask_module(LC.MASK_MODULE_SIGN) then 
        self:update_item_data(l_item_luck,{visible=true})
    else 
        self:update_item_data(l_item_luck,{visible=false})
    end
    --新手礼包
    local l_table_gift={
        icon="icon_new_player.png",
        title="新手礼包",
        describe="新手礼包。。。文案",
        btngui="btn_receive.png",
        id=BTN_TYPE.GIFT,
        visible=false,
        touch=true;
    }
    local l_item_gift=self:get_a_item(l_table_gift)
    if bp_have_mask_module(LC.MASK_MODULE_NEWPLAYER_PACK) and json.decode(bp_get_self_user_data()).paycount  <=0  then 
        self:update_item_data(l_item_gift,{visible=true})
    else
        self:update_item_data(l_item_gift,{visible=false})    
    end
    --微信绑定
    local l_table_bind={
        icon="icon_wechat.png",
        title="微信绑定",
        describe="微信绑定。。。文案",
        btngui="btn_receive.png",
        id=BTN_TYPE.BIND,
        visible=false,
        touch=true;
    }
    local l_item_bind=self:get_a_item(l_table_bind)
    if bp_have_mask_module(LC.MASK_MODULE_BIND_WECHAT) and bp_have_self_right(UC.UR_MASK_CHECK_WECHAT)==0 then 
        self:update_item_data(l_item_bind,{visible=true})
    else 
        self:update_item_data(l_item_bind,{visible=false})
    end
    --会员签到
    local l_table_vip={
        icon="icon_vip.png",
        title="会员签到",
        describe="会员签到。。。文案",
        btngui="btn_receive.png",
        id=BTN_TYPE.VIP,
        visible=false,
        touch=true;
    }
    local l_item_vip=self:get_a_item(l_table_vip)

    if bp_have_mask_module(LC.MASK_MODULE_VIP) and bp_have_mask_module(LC.MASK_MODULE_SIGN) then 
        if class_tools.get_vip()>0 then 
            self:update_item_data(l_item_vip,{visible=true})
        else
            self:update_item_data(l_item_vip,{visible=false})
        end
    else 
        self:update_item_data(l_item_vip,{visible=false})
    end
    --分享有礼
    local l_table_wxline={
        icon="icon_wechat.png",
        title="分享有礼",
        describe="每次首次分享可获得<color value=0xfff69812>2000金币",
        btngui="btn_share.png",
        id=BTN_TYPE.WXLINE,
        visible=false,
        touch=true;
    }
    local l_item_wxline=self:get_a_item(l_table_wxline)
    if bp_have_mask_module(LC.MASK_MODULE_SHARE_WECHAT) then 
        self:update_item_data(l_item_wxline,{visible=true})
    end
    --好友邀请
    local l_table_wxfriend={
        icon="icon_wechat.png",
        title="好友邀请",
        describe="可以通过微信邀请好友一起参与游戏",
        btngui="btn_invite.png",
        id=BTN_TYPE.WXFRIEND,
        visible=false,
        touch=true;
    }
    local l_item_wxfriend=self:get_a_item(l_table_wxfriend)
    if bp_have_mask_module(LC.MASK_MODULE_SHARE_WECHAT) then 
        self:update_item_data(l_item_wxfriend,{visible=true})
    end    
    --每日任务
    local l_table_task={
        icon="icon_task.png",
        title="每日任务",
        describe="每日完成对局任务都可以获得丰厚奖励",
        btngui="btn_look.png",
        id=BTN_TYPE.TASK,
        visible=false,
        touch=true
    }
    local l_item_task=self:get_a_item(l_table_task)
    if bp_have_mask_module(LC.MASK_MODULE_TASKS) then 
        self:update_item_data(l_item_task,{visible=true})
    end     
    self:update_layout()
end
function UITaskGuide:clear_item()
    for k,v in pairs(self.list_item) do
        table.insert( self.list_item_sleep,v)
        --v:setVisible(false)
    end
    self.list_item={};
end

function UITaskGuide:get_a_item(param_table)
    --print("hjjlog>>get_a_item:",#self.list_item)
    local l_item=nil
    if #self.list_item_sleep >0 then 
        l_item=self.list_item_sleep[#self.list_item_sleep]
        table.remove( self.list_item_sleep,#self.list_item_sleep)
        table.insert( self.list_item,l_item )
    else
        l_item={}
        local l_img_bg=control_tools.newImg({path=g_path.."bg_item.png"})
        self.ptr_scrollview:addChild(l_img_bg)
        l_item.bg=l_img_bg;    
        local l_img_flag=control_tools.newImg({path=g_path.."icon_bg.png"})
        l_img_bg:addChild(l_img_flag)
        l_img_flag:setPosition(cc.p(55,50))

        local l_img_icon=control_tools.newImg({path=g_path.."icon_task.png"})
        l_img_flag:addChild(l_img_icon)
        l_img_icon:setPosition(cc.p(50,60))
        l_item.icon=l_img_icon;

        local l_bg_label=control_tools.newImg({path=g_path.."bg_title.png"})
        l_img_bg:addChild(l_bg_label)
        l_bg_label:setPosition(cc.p(230,75))
    
        local l_label_name=control_tools.newLabel({font=25,color=cc.c3b(179,125,82),anchor=cc.p(0,0.5)})
        l_bg_label:addChild(l_label_name)
        l_label_name:setPosition(cc.p(10,20))
        l_item.title=l_label_name;

        local l_rich_desc=UIRichText:create(24,cc.c3b(179, 125, 82),"Arial",cc.size(460,40))
        l_img_bg:addChild(l_rich_desc)
        l_rich_desc:setAnchorPoint(cc.p(0,0.5))
        l_rich_desc:setPosition(cc.p(117,35))
        l_item.desc=l_rich_desc;
    
        local l_btn=control_tools.newBtn({normal=g_path.."btn_look.png",small=true})
        l_img_bg:addChild(l_btn)
        l_btn:setPosition(cc.p(650,55))
        l_btn:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_item(param_sender,param_touchType) end)
        l_item.btn=l_btn
        
        table.insert( self.list_item, l_item );
    end
    self:update_item_data(l_item,param_table)
    return l_item;
end
function UITaskGuide:update_item_data(param_item,param_table)
    if param_table.icon~=nil then 
        param_item.icon:loadTexture(g_path..param_table.icon)
    end
    if param_table.title~=nil then 
        param_item.title:setString(param_table.title)
    end
    if param_table.describe~=nil then 
        param_item.desc:setTextEx(param_table.describe)
    end
    if param_table.btngui~=nil then 
        param_item.btn:loadTextures(g_path..param_table.btngui,g_path..param_table.btngui)
    end
    if param_table.id then 
        param_item.id=param_table.id;
        param_item.btn.id=param_table.id;
    end
    if param_table.visible~=nil then 
        param_item.visible=param_table.visible;
        param_item.bg:setVisible(param_table.visible)
    end
    if param_table.touch~=nil then 
        param_item.btn:setTouchEnabled(param_table.touch)
    end
end
function UITaskGuide:update_layout()
    print("hjjlog>>update_layout",#self.list_item);


    local int_line_count=0
    for k,v in pairs(self.list_item) do 
        if v.visible==true then 
            int_line_count=int_line_count+1;
        end
    end

    local the_item_size=cc.size(740,120)
    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,the_item_size.height*int_line_count)

    if the_scrollview_size.height< self.ptr_scrollview:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)

    local float_space_y = the_item_size.height;

	local float_pos_x = the_item_size.width/2
    local float_pos_y = the_scrollview_size.height - the_item_size.height/2 ;
    local int_index=0;
    for k,v in pairs(self.list_item) do 
        if v.visible==true then 
            v.bg:setVisible(true);
            v.bg:setPosition(float_pos_x,float_pos_y)
            float_pos_y =float_pos_y- float_space_y;
        end
    end

end


function UITaskGuide:on_btn_item(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("hjjlog>>",param_sender.id);
    local l_item=nil;
    for k,v in pairs(self.list_item) do
        if v.id==param_sender.id then 
            l_item=v;
            break;
        end
    end
    if param_sender.id==BTN_TYPE.COMMENT then 
        self:deal_comment_award(l_item)
    elseif param_sender.id==BTN_TYPE.UPDATE then 
        self.deal_update(param_item)
    elseif param_sender.id==BTN_TYPE.LUCK then 
        self:ShowGui(false)
        --hjj_for_wait:显示幸运大转盘。
    elseif param_sender.id==BTN_TYPE.GIFT then 
        --hjj_for_wait:新手礼包。
    elseif param_sender.id==BTN_TYPE.BIND then 
        UIUserCenter.ShowUserCenter(true)
    elseif param_sender.id==BTN_TYPE.VIP then 
        --hjj_for_wait:显示幸运大转盘。
    elseif param_sender.id==BTN_TYPE.WXLINE then 
        self:deal_share_wxline(param_item)
    elseif param_sender.id==BTN_TYPE.WXFRIEND then 
        self:deal_share_wxfriend(param_item)
    elseif param_sender.id==BTN_TYPE.TASK then 
        UITaskDay.ShowTask(true)
    end
end

function UITaskGuide:deal_comment_award(param_item)
    local req = URL.HTTP_CLIENT_AWARD
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{TYPEID}",310);
    local post=req.."8062e5d0872bc6f6"
    post=bp_md5(post)
    bp_http_post(""..param_item.id,"",req,post,function(param_identifier,param_success,param_code,param_header,context) self:on_http_comment_award(param_identifier,param_success,param_code,param_header,context) end,1)
end
function UITaskGuide:on_http_comment_award(param_identifier,param_success,param_code,param_header,context)
    --print("hjjlog>>on_http_comment_award",context);

    if param_success~=true or param_code~=200 then 
        print("hjjlog>>on_http_comment_award   fail");
        bp_show_hinting("请求失败！")
        return  ;
    end

    local l_id=tonumber(param_identifier);
    local l_item=nil;
    for k,v in pairs(self.list_item) do
        if v.id==param_sender.id then 
            l_item=v;
            break;
        end
    end

    local l_data=json.decode(context);
    if l_data.Result_code~=1 then 
        bp_show_hinting(l_data.Result_msg)
        self:update_item_data(l_item,{visible=false})
        self:update_layout()
        return ;
    end
    bp_set_local_value("comment_award","2")
    self:update_item_data(l_item,{visible=false})
    bp_update_user_data(1);
    bp_show_hinting("已成功领取"..l_data.Result_data.."评论奖励!")
    self:update_layout()
    UIGoldRain.ShowGoldRain(true)
end
function UITaskGuide:deal_update(param_item)
    local int_update_version=tonumber(bp_get_save_value("update_version", "0"))
    if int_update_version<bp_get_cur_version() then 
        if bp_get_cur_version()<=bp_get_version() then 
            --领奖
            self:update_item_data(param_item,{visible=true,btngui="btn_receive.png"})
            
            local req = URL.HTTP_CLIENT_AWARD
            req=bp_make_url(req)
            req=bp_string_replace_key(req,"&quot;","\"");
            req=bp_string_replace_key(req,"{TYPEID}",311);
            local post=req.."8062e5d0872bc6f6"
            post=bp_md5(post)
            bp_http_post(""..param_item.id,"",req,post,function(param_identifier,param_success,param_code,param_header,context) self:on_http_comment_award(param_identifier,param_success,param_code,param_header,context) end,1)
        
        else
            --跳转到更新。
            --hjj_for_wait.  更新地址。
            bp_show_url("");
            
        end
    end
end
function UITaskGuide:on_http_update_award(param_identifier,param_success,param_code,param_header,context)
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>on_http_comment_award   fail");
        bp_show_hinting("请求失败！")
        return  ;
    end

    local l_id=tonumber(param_identifier);
    local l_item=nil;
    for k,v in pairs(self.list_item) do
        if v.id==param_sender.id then 
            l_item=v;
            break;
        end
    end

    local l_data=json.decode(context);
    if l_data.Result_code~=1 then 
        if l_data.Result_code~=10 then
            bp_set_local_value("update_version",bp_get_cur_version().."")
        end
        bp_show_hinting(l_data.Result_msg)
        --self:update_item_data(l_item,{visible=false})
        self:update_layout()
        return ;
    end
    bp_set_local_value("update_version",bp_get_cur_version().."")
    self:update_item_data(l_item,{touch=false,btngui="btn_alreceive.png"})
    self:update_layout();
    bp_show_hinting("已成功领取"..l_data.Result_data.."更新奖励!")
    self:update_layout()
    UIGoldRain.ShowGoldRain(true)
end

function UITaskGuide:deal_share_wxline(param_item)
    local l_share_data=bp_get_local_text(1);
    l_share_data=bp_url_decode(l_share_data)
    print("hjjlog>>deal_share_wxlin:",l_share_data);
    l_share_data=json.decode(l_share_data)
    local share_data={}
    for k,v in pairs(l_share_data) do 
        if v.id==1 then 
            share_data=v;
            break;
        end
    end
    self:share_wechat(share_data,1)
end
function UITaskGuide:deal_share_wxfriend(param_item)
    local l_share_data=bp_get_local_text(1);
    l_share_data=bp_url_decode(l_share_data)
    print("hjjlog>>deal_share_wxlin:",l_share_data);
    l_share_data=json.decode(l_share_data)
    local share_data={}
    for k,v in pairs(l_share_data) do 
        if v.id==2 then 
            share_data=v;
            break;
        end
    end
    self:share_wechat(share_data,0)
end
function UITaskGuide:share_wechat(param_share_data,param_type)
    local share_data=param_share_data
    local l_share_text={}
    if share_data.mode==0 then 
        l_share_text.title=share_data.title
        local l_message_count=#share_data.message;
        math.randomseed(os.time())
        l_share_text.message=share_data.message[math.random(1,#share_data.message)]
        local l_str_icon=share_data.icon
        l_str_icon=bp_string_replace_key(l_str_icon,"{ICON}",BPRESOURCE("res/icon/"..bp_get_keyword()..".png"))
        l_share_text.icon=l_str_icon
        l_share_text.url=bp_make_url(share_data.url)
        l_share_text.type=param_type
        print("hjjlog>>share_text:",json.encode(l_share_text))
        bp_wechat_share_text(json.encode(l_share_text),function(param_code)  bp_show_hinting("分享回调:"..param_code)  end)
    else
        --图片
        l_share_text.type=param_type
        l_share_text.image=bp_make_url(share_data.image)
        local l_url=bp_make_url(share_data.url)
        l_url=bp_url_encode(l_url)
        l_share_text.image=bp_string_replace_key(l_share_text.image,"{SHAREVALUE}",l_url)
        bp_wechat_share_image(json.encode(l_share_text),function(param_code)  bp_show_hinting("分享回调:"..param_code)  end)
    end

end

function UITaskGuide:request_comment_award(param_type,param_item)
    local req = URL.HTTP_USE_PROP
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{PROPID}",param_id);
    req=bp_string_replace_key(req,"{PARAM}","");
    bp_http_get(""..param_id,"",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_comment_award(param_identifier,param_success,param_code,param_header,context) end,1)
end
function UITaskGuide:on_http_comment_award2222(param_identifier,param_success,param_code,param_header,context)
    print("hjjlog>>on_http_comment_award",context);
    
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>on_http_comment_award   fail");
        bp_show_hinting("请求失败！")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    


end


return UITaskGuide