local UIChangeUserName=class("UIChangeUserName",function() return ccui.Layout:create() end)
local g_path=BPRESOURCE("res/usercenter/")
function UIChangeUserName:ctor()
   print("hjjlog>>UIChangeUserName")
   self.the_size=nil;
   self.ptr_label_nickname=nil
   self.ptr_bg_edit_nickname=nil;
   self.ptr_edit_box=nil;
   self.ptr_label_sex=nil
   self.ptr_check_sex={};
   self.user_data=nil
   self.ptr_btn_change_name=nil
   self.ptr_btn_save=nil
   self.m_int_sex=0;
   self.str_new_nickname="";

   self:init();
end
function UIChangeUserName:destory()
end


function UIChangeUserName:init()
    self.the_size=cc.size(520,104);
    self:setContentSize(self.the_size)
    local test_bg=control_tools.newImg({path=TESTCOLOR.g,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

    local l_user_data=json.decode(bp_get_self_user_data());
    self.user_data=l_user_data;

    local l_img_nickname=control_tools.newImg({path=g_path.."label_nickname.png",anchor=cc.p(0,0.5)})
    self:addChild(l_img_nickname)
    l_img_nickname:setPosition(cc.p(20,75))

    self.ptr_label_nickname=control_tools.newLabel({font=26,color=cc.c3b(175,94,22),anchor=cc.p(0,0.5)})
    self:addChild(self.ptr_label_nickname)
    self.ptr_label_nickname:setPosition(cc.p(90,75))
    self.ptr_label_nickname:setString(l_user_data.nickname)


    self.ptr_bg_edit_nickname=control_tools.newImg({path=g_path.."edit_back.png",anchor=cc.p(0,0.5)})
    self:addChild(self.ptr_bg_edit_nickname)
    self.ptr_bg_edit_nickname:setPosition(cc.p(90,75))
    self.ptr_bg_edit_nickname:setVisible(false)

    local l_img=control_tools.newImg({path=g_path.."img_edit.png"})
    self.ptr_bg_edit_nickname:addChild(l_img)
    l_img:setPosition(cc.p(30,22))

    self.ptr_edit_account = ccui.EditBox:create(cc.size(170,40),g_path.."kong.png")
    self.ptr_edit_account:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
    self.ptr_bg_edit_nickname:addChild(self.ptr_edit_account)
    self.ptr_edit_account:setPosition( cc.p(126,21) )
    self.ptr_edit_account:setPlaceHolder(l_user_data.nickname)
    self.ptr_edit_account:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.ptr_edit_account:setPlaceholderFontSize(26)
    self.ptr_edit_account:setPlaceholderFontColor(cc.c3b(185,143,89))
    self.ptr_edit_account:setFontSize(28)
    self.ptr_edit_account:setFontColor(cc.c3b(185,143,89))
    self.ptr_edit_account:setMaxLength(16)




    local l_img_sex=control_tools.newImg({path=g_path.."label_sex.png",cc.p(0,0.5)})
    self:addChild(l_img_sex)
    l_img_sex:setPosition(cc.p(20,25))
    
    self.ptr_label_sex=control_tools.newLabel({font=26,color=cc.c3b(175,94,22),anchor=cc.p(0,0.5)})
    self:addChild(self.ptr_label_sex)
    self.ptr_label_sex:setPosition(cc.p(90,25))
    if l_user_data.sex==0 then 
        self.ptr_label_sex:setString("女")
    else
        self.ptr_label_sex:setString("男")
    end

    local l_btn_boy=control_tools.newBtn({normal=g_path.."disabled.png",pressed=g_path.."selected.png"})
    l_btn_boy.id=1
    l_btn_boy:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_check_sex(param_sender,param_touchType) end)
    l_btn_boy:setPosition(cc.p(110,25))
    self:addChild(l_btn_boy)
    local l_img_boy=control_tools.newImg({path=g_path.."img_boy.png"})
    l_btn_boy:addChild(l_img_boy)
    l_img_boy:setPosition(cc.p(50,15))
    l_btn_boy:setVisible(false)
    self.ptr_check_sex.boy=l_btn_boy;


    local l_btn_girl=control_tools.newBtn({normal=g_path.."disabled.png",pressed=g_path.."selected.png"})
    l_btn_girl.id=0
    l_btn_girl:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_check_sex(param_sender,param_touchType) end)
    l_btn_girl:setPosition(cc.p(200,25))
    self:addChild(l_btn_girl)
    local l_img_girl=control_tools.newImg({path=g_path.."img_girl.png"})
    l_btn_girl:addChild(l_img_girl)
    l_img_girl:setPosition(cc.p(50,15))
    l_btn_girl:setVisible(false)
    self.ptr_check_sex.girl=l_btn_girl;

    self.ptr_btn_change_name=control_tools.newBtn({normal=g_path.."btn_alter.png",pressed=g_path.."btn_alter.png"})
    self:addChild(self.ptr_btn_change_name)
    self.ptr_btn_change_name:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_change(param_sender,param_touchType) end)
    self.ptr_btn_change_name:setPosition(cc.p(470,45))

    self.ptr_btn_save=control_tools.newBtn({normal=g_path.."btn_save.png",pressed=g_path.."btn_save.png"})
    self:addChild(self.ptr_btn_save)
    self.ptr_btn_save:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_seve(param_sender,param_touchType) end)
    self.ptr_btn_save:setPosition(cc.p(470,45))
    self.ptr_btn_save:setVisible(false)

end
function UIChangeUserName:on_btn_check_sex(param_sender,param_touchType)
   if param_touchType~=_G.TOUCH_EVENT_ENDED then
       return 
   end
   self.m_int_sex=param_sender.id;
   if param_sender.id==0 then 
        self.ptr_check_sex.girl:setBright(false)
        self.ptr_check_sex.boy:setBright(true)
    else
        self.ptr_check_sex.girl:setBright(true)
        self.ptr_check_sex.boy:setBright(false)
    end     
      
end

function UIChangeUserName:on_btn_change(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self.ptr_btn_change_name:setVisible(false)
    self.ptr_btn_save:setVisible(true)
    self.ptr_label_nickname:setVisible(false)
    self.ptr_label_sex:setVisible(false);
    self.ptr_bg_edit_nickname:setVisible(true)
    self.ptr_check_sex.boy:setVisible(true)
    self.ptr_check_sex.girl:setVisible(true)

    if self.user_data.sex==0 then 
        self.ptr_check_sex.girl:setBright(false)
        self.ptr_check_sex.boy:setBright(true)
        self.m_int_sex=0
    else
        self.ptr_check_sex.girl:setBright(true)
        self.ptr_check_sex.boy:setBright(false)
        self.m_int_sex=1
    end

 end
 function UIChangeUserName:on_btn_seve(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end

    local l_user_data=json.decode(bp_get_self_user_data())

    local l_str_old_nickname=l_user_data.nickname
    local l_str_old_sex=l_user_data.sex

    self.str_new_nickname=self.ptr_edit_account:getText();
    local l_new_sex=self.m_int_sex;

    if self.str_new_nicknamev==l_str_old_nickname and l_str_old_sex==l_new_sex then 
        self.ptr_btn_change_name:setVisible(true)
        self.ptr_btn_save:setVisible(false)
        self.ptr_label_nickname:setVisible(true)
        self.ptr_label_sex:setVisible(true);
        self.ptr_bg_edit_nickname:setVisible(false)
        self.ptr_check_sex.boy:setVisible(false)
        self.ptr_check_sex.girl:setVisible(false)
        return ;
    end
    if class_tools.have_special_characters(self.str_new_nickname) ==true then 
        bp_show_hinting("昵称中不允许包含特殊字符")
        return ;
    end
    if #self.str_new_nickname==0 then 
        bp_show_hinting("昵称不能为空")
        return ;
    end
    if #self.str_new_nickname>24 then 
        bp_show_hinting("昵称不能超过24个字符")
        return ;
    end

    bp_show_message_box("提示","修改昵称和性别需100万金币，是否要修改？",1,
    "修改","取消",
    function(param_1,param_2)  self:on_btn_change_ok(param_1,param_2)  end,
    function(param_1,param_2) end,self.m_int_sex,"") 
 end
function UIChangeUserName:on_btn_change_ok(param_1,param_2)

    bp_show_loading(1)
    local req = URL.HTTP_CHANGE_NICKNAME_NEW
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{NEWNICKNAME}",self.str_new_nickname);
    req=bp_string_replace_key(req,"{NEWSEX}",self.m_int_sex);
    bp_http_get("HTTP_CHANGE_ACCOUNT","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_change_result(param_identifier,param_success,param_code,param_header,context) end,1)
    
end
function UIChangeUserName:on_http_change_result(param_identifier,param_success,param_code,param_header,context)
    print("hjjlog>>context:",context);

    bp_show_loading(0)
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>on_http_change_realname   fail");
        bp_show_hinting("修改账号失败...")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        self.ptr_btn_change_name:setVisible(true)
        self.ptr_btn_save:setVisible(false)
        self.ptr_label_nickname:setVisible(true)
        self.ptr_label_sex:setVisible(true);
        self.ptr_bg_edit_nickname:setVisible(false)
        self.ptr_check_sex.boy:setVisible(false)
        self.ptr_check_sex.girl:setVisible(false)
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    l_data=l_data.resdata

    local l_data={}
    l_data.nickname=self.str_new_nickname
    l_data.sex=self.m_int_sex;
    local l_right=bp_get_self_right()
    l_right=bit._or(l_right,US.UR_MASK_CHANGE_NAME)
    l_data.masterright=l_right
    bp_update_user_data(false)
    bp_set_self_user_data(json.encode(l_data))
    bp_show_hinting("昵称性别修改成功")
    self.ptr_btn_change_name:setVisible(true)
    self.ptr_btn_save:setVisible(false)
    self.ptr_label_nickname:setVisible(true)
    self.ptr_label_sex:setVisible(true);
    self.ptr_bg_edit_nickname:setVisible(false)
    self.ptr_check_sex.boy:setVisible(false)
    self.ptr_check_sex.girl:setVisible(false)
end
function UIChangeUserName:on_btn_change_cancel(param_1,param_2)
    self.ptr_btn_change_name:setVisible(true)
    self.ptr_btn_save:setVisible(false)
    self.ptr_label_nickname:setVisible(true)
    self.ptr_label_sex:setVisible(true);
    self.ptr_bg_edit_nickname:setVisible(false)
    self.ptr_check_sex.boy:setVisible(false)
    self.ptr_check_sex.girl:setVisible(false)
end


return UIChangeUserName