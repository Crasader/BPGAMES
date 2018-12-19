local UIControl=require("src/ui_control")
local UIRealName=class("UIRealName",UIControl)
local g_path=BPRESOURCE("res/realname/")
sptr_real_name=nil
function UIRealName:ctor(...)
    print("hjjlog>>UIRealName")
    self.super:ctor(self)
    self:init();
end
function UIRealName:destory()

end
function UIRealName:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_real_name.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();

    local l_img_hint=control_tools.newImg({path=g_path.."img_hint_bg.png"})
    l_bg:addChild(l_img_hint)
    l_img_hint:setPosition(cc.p(l_bg_size.width/2,315))

    local l_label_hint=control_tools.newLabel({font=20,color=cc.c3b(147,45,21)})
    l_img_hint:addChild(l_label_hint)
    l_label_hint:setPosition(cc.p(380/2,40/2))
    l_label_hint:setString("我们不会泄露您的资料，请放心填写。")

    local l_img_edit_bg=control_tools.newImg({path=g_path.."img_label_bg.png"})
    l_bg:addChild(l_img_edit_bg)
    l_img_edit_bg:setPosition(cc.p(l_bg_size.width/2,260))

    local l_icon=control_tools.newImg({path=g_path.."img_user.png"})
    l_img_edit_bg:addChild(l_icon)
    l_icon:setPosition(cc.p(40,35))

    self.ptr_edit_name = ccui.EditBox:create(cc.size(360,40),g_path.."kong.png")
    self.ptr_edit_name:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
    l_img_edit_bg:addChild(self.ptr_edit_name)
    self.ptr_edit_name:setPosition( cc.p(235,35) )
    self.ptr_edit_name:setPlaceHolder("请输入真实姓名")
    self.ptr_edit_name:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.ptr_edit_name:setPlaceholderFontSize(28)
    self.ptr_edit_name:setPlaceholderFontColor(cc.c3b(185,143,89))
    self.ptr_edit_name:setFontSize(28)
    self.ptr_edit_name:setFontColor(cc.c3b(185,143,89))
    self.ptr_edit_name:setMaxLength(6)

    local l_lable_mask=control_tools.newLabel({font=20,color=cc.c3b(147,45,21)})
    l_bg:addChild(l_lable_mask)
    l_lable_mask:setPosition(cc.p(520,250))
    l_lable_mask:setString("*")

    l_label_hint=control_tools.newLabel({font=20,color=cc.c3b(147,45,21),anchor=cc.p(0,0.5)})
    l_bg:addChild(l_label_hint)
    l_label_hint:setPosition(cc.p(70,210))
    l_label_hint:setString("真实姓名是您权益的重要保证，请务必正确填写。")

    l_img_edit_bg=control_tools.newImg({path=g_path.."img_label_bg.png"})
    l_bg:addChild(l_img_edit_bg)
    l_img_edit_bg:setPosition(cc.p(l_bg_size.width/2,160))

    l_icon=control_tools.newImg({path=g_path.."img_user.png"})
    l_img_edit_bg:addChild(l_icon)
    l_icon:setPosition(cc.p(40,35))

    self.ptr_edit_num = ccui.EditBox:create(cc.size(360,40),g_path.."kong.png")
    self.ptr_edit_num :setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
    l_img_edit_bg:addChild(self.ptr_edit_num)
    self.ptr_edit_num:setPosition( cc.p(235,35) )
    self.ptr_edit_num:setPlaceHolder("请输入登陆密码")
    self.ptr_edit_num:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.ptr_edit_num:setPlaceholderFontSize(28)
    self.ptr_edit_num:setPlaceholderFontColor(cc.c3b(185,143,89))
    self.ptr_edit_num:setFontSize(28)
    self.ptr_edit_num:setFontColor(cc.c3b(185,143,89))
    self.ptr_edit_num:setMaxLength(18)

    l_lable_mask=control_tools.newLabel({font=20,color=cc.c3b(147,45,21)})
    l_bg:addChild(l_lable_mask)
    l_lable_mask:setPosition(cc.p(520,160))
    l_lable_mask:setString("*")

    l_label_hint=control_tools.newLabel({font=20,color=cc.c3b(147,45,21),anchor=cc.p(0,0.5)})
    l_bg:addChild(l_label_hint)
    l_label_hint:setPosition(cc.p(70,110))
    l_label_hint:setString("请如实填些您的15位或18位身份证号码。")

    local l_btn_change=control_tools.newBtn({normal=g_path.."btn_check.png",small=true})
    l_btn_change:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_change(param_sender,param_touchType) end)
    l_bg:addChild(l_btn_change)
    l_btn_change:setPosition(cc.p(l_bg_size.width/2,45))

end
function UIRealName:on_btn_change(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local l_str_name=self.ptr_edit_name:getText();
    local l_str_num=self.ptr_edit_num:getText()
    print("hjjlog>>on_btn_change:",l_str_name,l_str_num);
    if  #l_str_name<2  then 
        bp_show_hinting("请正确输入您的身份证号码")
        return ;
    end
    if #l_str_num<15 then 
        bp_show_hinting("请正确输入您的身份证号码")
        return ;

    end
    bp_show_loading(1)
    local req = URL.HTTP_REG_REAL_NAME
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{NEWIDCARD}",l_str_num);
    req=bp_string_replace_key(req,"{REALNAME}",l_str_name);
    bp_http_get("HTTP_REG_REAL_NAME","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_change_realname(param_identifier,param_success,param_code,param_header,context) end,1)

end
function UIRealName:on_http_change_realname(param_identifier,param_success,param_code,param_header,context)

    bp_show_loading(0)
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>on_http_change_realname   fail");
        bp_show_hinting("实名认证失败...")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    local l_right=bp_get_self_right()
    l_right=bit._or(l_right,US.UR_MASK_CERTIFICATION)
    bp_update_user_data(0);
    self:ShowGui(false)
end


function UIRealName.ShowRealName(param_show)
    if sptr_real_name==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_real_name=UIRealName:create();
        main_layout:addChild(sptr_real_name)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_real_name:ShowGui(param_show)
    return sptr_real_name;
end

return UIRealName