local UIControl=require("src/ui_control")
local UIChangeAccount=class("UIChangeAccount",UIControl)
local g_path=BPRESOURCE("res/changeaccount/")
sptr_change_account=nil
function UIChangeAccount:ctor(...)
    print("hjjlog>>UIChangeAccount")
    self.super:ctor(self)
    self:init();
end
function UIChangeAccount:destory()

end
function UIChangeAccount:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_change_account.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getSize();

    local l_img_account=control_tools.newImg({path=g_path.."img_label_account.png"})
    l_bg:addChild(l_img_account)
    l_img_account:setPosition(cc.p(80,250))

    local l_img_edit_bg=control_tools.newImg({path=g_path.."img_label_bg.png"})
    l_bg:addChild(l_img_edit_bg)
    l_img_edit_bg:setPosition(cc.p(315,250))

    local l_icon=control_tools.newImg({path=g_path.."img_user.png"})
    l_img_edit_bg:addChild(l_icon)
    l_icon:setPosition(cc.p(40,35))

    self.ptr_edit_account = ccui.EditBox:create(cc.size(300,40),g_path.."kong.png")
    self.ptr_edit_account:setInputFlag(cc.EDITBOX_INPUT_FLAG_SENSITIVE)
    l_img_edit_bg:addChild(self.ptr_edit_account)
    self.ptr_edit_account:setPosition( cc.p(215,35) )
    self.ptr_edit_account:setPlaceHolder("请输入登录账号")
    self.ptr_edit_account:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.ptr_edit_account:setPlaceholderFontSize(28)
    self.ptr_edit_account:setPlaceholderFontColor(cc.c3b(185,143,89))
    self.ptr_edit_account:setFontSize(28)
    self.ptr_edit_account:setFontColor(cc.c3b(185,143,89))
    self.ptr_edit_account:setMaxLength(16)


    local l_img_password=control_tools.newImg({path=g_path.."img_label_password.png"})
    l_bg:addChild(l_img_password)
    l_img_password:setPosition(cc.p(80,160))

    l_img_edit_bg=control_tools.newImg({path=g_path.."img_label_bg.png"})
    l_bg:addChild(l_img_edit_bg)
    l_img_edit_bg:setPosition(cc.p(315,160))

    l_icon=control_tools.newImg({path=g_path.."img_lock.png"})
    l_img_edit_bg:addChild(l_icon)
    l_icon:setPosition(cc.p(40,35))

    self.ptr_edit_password = ccui.EditBox:create(cc.size(300,40),g_path.."kong.png")
    self.ptr_edit_password :setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
    l_img_edit_bg:addChild(self.ptr_edit_password)
    self.ptr_edit_password:setPosition( cc.p(215,35) )
    self.ptr_edit_password:setPlaceHolder("请输入登陆密码")
    self.ptr_edit_password:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE);
    self.ptr_edit_password:setPlaceholderFontSize(28)
    self.ptr_edit_password:setPlaceholderFontColor(cc.c3b(185,143,89))
    self.ptr_edit_password:setFontSize(28)
    self.ptr_edit_password:setFontColor(cc.c3b(185,143,89))
    self.ptr_edit_password:setMaxLength(16)

    local l_btn_change=control_tools.newBtn({normal=g_path.."btn_change.png",small=true})
    l_btn_change:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_change(param_sender,param_touchType) end)
    l_bg:addChild(l_btn_change)
    l_btn_change:setPosition(cc.p(l_bg_size.width/2,55))

end
function UIChangeAccount:on_btn_change(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local l_str_account=self.ptr_edit_account:getText();
    local l_str_password=self.ptr_edit_password:getText()
    print("hjjlog>>on_btn_change:",l_str_account,l_str_password);
    if class_tools.is_simple_characters(l_str_account)==false or #l_str_account<=4 or #l_str_account>16 then 
        bp_show_hinting("帐号必须由4到16位数字或字母组成")
        return;
    end
    if class_tools.is_simple_characters(l_str_password)==false or #l_str_password<6 or #l_str_password>16 then 
        bp_show_hinting("帐号必须由4到16位数字或字母组成")
        return;
    end

    bp_show_loading(1)
    local req = URL.HTTP_CHANGE_ACCOUNT
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{NEWACCOUNTS}",l_str_account);
    req=bp_string_replace_key(req,"{NEWPASSWORD}",l_str_password);
    bp_http_get("HTTP_CHANGE_ACCOUNT","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_change_account(param_identifier,param_success,param_code,param_header,context) end,1)

end
function UIChangeAccount:on_http_change_account(param_identifier,param_success,param_code,param_header,context)

    bp_show_loading(0)
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>on_http_change_realname   fail");
        bp_show_hinting("修改账号失败...")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    bp_show_message_box("提示","",0,
    "重新登录","",
    function(param_1,param_2)  self:on_back_ok(param_1,param_2)  end,
    function(param_1,param_2) end,param_sender.id,"")
    self:ShowGui(false)

end

function UIChangeAccount:on_back_ok(param_1,param_2)
--hjj_for_wait:重新登录

end


function UIChangeAccount.ShowChangePassword(param_show)
    if sptr_change_account==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_change_account=UIChangeAccount:create();
        main_layout:addChild(sptr_change_account)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_change_account:ShowGui(param_show)
    return sptr_change_account;
end



return UIChangeAccount