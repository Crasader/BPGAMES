local UIControl=require("src/ui_control")
local UIPhoneBind=class("UIPhoneBind",UIControl)
local g_path=BPRESOURCE("res/phonebind/")
sptr_phone_bind=nil
function UIPhoneBind:ctor(...)
    print("hjjlog>>UIPhoneBind")
    self.super:ctor(self)
    self.m_int_action_time=0
    self.str_phone="";
    self:init();
end
function UIPhoneBind:destory()

end
function UIPhoneBind:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_check_phone.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();

    local l_img_account=control_tools.newImg({path=g_path.."img_label_phone.png"})
    l_bg:addChild(l_img_account)
    l_img_account:setPosition(cc.p(95,250))

    local l_img_edit_bg=control_tools.newImg({path=g_path.."edit_back_1.png"})
    l_bg:addChild(l_img_edit_bg)
    l_img_edit_bg:setPosition(cc.p(360,250))

    local l_icon=control_tools.newImg({path=g_path.."img_phone.png"})
    l_img_edit_bg:addChild(l_icon)
    l_icon:setPosition(cc.p(40,35))

    self.ptr_edit_phone = ccui.EditBox:create(cc.size(340,40),g_path.."kong.png")
    self.ptr_edit_phone:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
    l_img_edit_bg:addChild(self.ptr_edit_phone)
    self.ptr_edit_phone:setPosition( cc.p(225,35) )
    self.ptr_edit_phone:setPlaceHolder("请输入正确的手机号码")
    self.ptr_edit_phone:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.ptr_edit_phone:setPlaceholderFontSize(28)
    self.ptr_edit_phone:setPlaceholderFontColor(cc.c3b(185,143,89))
    self.ptr_edit_phone:setFontSize(28)
    self.ptr_edit_phone:setFontColor(cc.c3b(185,143,89))
    self.ptr_edit_phone:setMaxLength(11)


    local l_img_password=control_tools.newImg({path=g_path.."img_label_phone_check.png"})
    l_bg:addChild(l_img_password)
    l_img_password:setPosition(cc.p(95,160))

    l_img_edit_bg=control_tools.newImg({path=g_path.."edit_back_2.png"})
    l_bg:addChild(l_img_edit_bg)
    l_img_edit_bg:setPosition(cc.p(275,160))

    l_icon=control_tools.newImg({path=g_path.."img_edit.png"})
    l_img_edit_bg:addChild(l_icon)
    l_icon:setPosition(cc.p(40,35))

    self.ptr_edit_code = ccui.EditBox:create(cc.size(170,40),g_path.."kong.png")
    self.ptr_edit_code :setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
    l_img_edit_bg:addChild(self.ptr_edit_code)
    self.ptr_edit_code:setPosition( cc.p(140,35) )
    self.ptr_edit_code:setPlaceHolder("请输入验证码")
    self.ptr_edit_code:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC);
    self.ptr_edit_code:setPlaceholderFontSize(28)
    self.ptr_edit_code:setPlaceholderFontColor(cc.c3b(185,143,89))
    self.ptr_edit_code:setFontSize(28)
    self.ptr_edit_code:setFontColor(cc.c3b(185,143,89))
    self.ptr_edit_code:setMaxLength(8)

    self.ptr_btn_get_code=control_tools.newBtn({normal=g_path.."btn_get_code_1.png",pressed=g_path.."btn_get_code_1.png"})
    self.ptr_btn_get_code:loadTextureDisabled(g_path.."btn_get_code_2.png")
    l_bg:addChild(self.ptr_btn_get_code)
    self.ptr_btn_get_code:addTouchEventListener(function(param_sender,param_touchType) self:get_phone_code(param_sender,param_touchType) end)
    self.ptr_btn_get_code:setPosition(cc.p(490,160))

    self.ptr_label_time=control_tools.newLabel({font=22})
    self.ptr_btn_get_code:addChild(self.ptr_label_time)
    self.ptr_label_time:setPosition(cc.p(136,42))


    local l_btn_change=control_tools.newBtn({normal=g_path.."btn_true.png",small=true})
    l_btn_change:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_change(param_sender,param_touchType) end)
    l_bg:addChild(l_btn_change)
    l_btn_change:setPosition(cc.p(l_bg_size.width/2,55))

end
function UIPhoneBind:get_phone_code(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local str_phone = self.ptr_edit_phone:getText();
	if (class_tools.is_phone_characters(str_phone) == false) then 
	
		bp_show_hinting("请输入有效的手机号码");
		return;
    end
    bp_show_loading(1,"")

    local req = URL.HTTP_GET_PHONE_CODE
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{PHONE}",str_phone);
    req=bp_string_replace_key(req,"{PHONE_TYPE}",3);
    control_tools.XMLHttpRequest(req,function(param_res) self:on_http_phone_login_result(param_res) end)
end
function UIPhoneBind:on_btn_change(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local str_phone = self.ptr_edit_phone:getText();
	if (class_tools.is_phone_characters(str_phone) == false) then 
	
		bp_show_hinting("请输入有效的手机号码");
		return;
    end

    local str_code =self.ptr_edit_code:getText();
    if (str_code == "") then 
        bp_show_hinting("请输入正确的验证码");
        return
    end
    bp_show_loading(1,"")

    local req = URL.HTTP_GET_PHONE_CODE
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{PHONE}",str_phone);
    req=bp_string_replace_key(req,"{PHONE_TYPE}",3);
    control_tools.XMLHttpRequest(req,function(param_res) self:on_http_change_result(param_res) end)
end
function UIPhoneBind:on_http_change_result(param_string)
    local l_data=json.decode(param_string);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    local the_value=l_data.resdata
    self.str_phone=self.ptr_edit_phone:getText();
    local l_data={}
    l_data.phone=self.str_phone;
    local l_right=bp_get_self_right()
    l_right=bit._or(l_right,US.UR_MASK_CHECK_PHONE)
    l_data.masterright=l_right
    bp_set_self_user_data(json.encode(l_data))
    bp_update_user_data(1);
end

function UIPhoneBind:on_http_phone_login_result(param_string)
    local l_data=json.decode(param_string);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    local the_value=l_data.resdata
    self.m_int_action_time=60;
    self:on_action_step();
end
function UIPhoneBind:on_action_step()
    if self.m_int_action_time> 0 then 
        self.m_int_action_time=self.m_int_action_time-1;
        self.ptr_btn_get_code:setTouchEnabled(false)
        self.ptr_btn_get_code:setBright(false);
        self.ptr_label_time:setString("("..self.m_int_action_time..")")
        local l_ac_delay=cc.DelayTime:create(1)
        local l_ac_fun=cc.CallFunc:create(function() self:on_action_step() end)
        self:runAction(cc.Sequence:create(l_ac_delay,l_ac_fun))
    else 
        self.ptr_label_time:setString("")
        self.ptr_btn_get_code:setTouchEnabled(true)
        self.ptr_btn_get_code:setBright(true);
    end
end

function UIPhoneBind.ShowPhoneBind(param_show)
    if sptr_phone_bind==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_phone_bind=UIPhoneBind:create();
        main_layout:addChild(sptr_phone_bind)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_phone_bind:ShowGui(param_show)
    return sptr_phone_bind;
end


return UIPhoneBind