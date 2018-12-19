local UIUserInfo=class("UIUserInfo",function() return ccui.Layout:create() end)
local UIHead=require("src/ui_head");
local g_path=BPRESOURCE("res/usercenter/")
local UIChangeUserName=require("src/ui_changeusername")
local UIVipShop=require("src/ui_vipshop")
local UIShopCenter=require("src/ui_shopcenter")
local UIRealName=require("src/ui_realname")
local UIPhoneBind=require("src/ui_phonebind")
local UIChangeAccount=require("src/ui_changeaccount")
local UIChangePassword=require("src/ui_changepassword")
require("bptools/class_tools")
function UIUserInfo:ctor()
   print("hjjlog>>UIUserInfo")
   self.the_size=nil;
   self.user_data=nil
   self.list_btn={};
   self.m_bool_show_accout=true;
   self:init();
   self:on_update_user_data()
end
function UIUserInfo:destory()
end


function UIUserInfo:init()
    local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA", function (eventCustom)
        self:on_update_user_data();
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)


    self.the_size=cc.size(770,430);
    self:setContentSize(self.the_size)
    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

    local l_head=ccui.Layout:create()
    self:addChild(l_head)
    l_head:setPosition(cc.p(95 + 22, 350))
    
    local l_img_head=UIHead:create();
    l_img_head:set_head(140,140)
    l_head:addChild(l_img_head);

    local l_head_frame=control_tools.newBtn({normal=g_path.."head_frame.png",pressed=g_path.."head_frame.png"})
    l_head:addChild(l_head_frame);
    l_head_frame:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_head(param_sender,param_touchType) end);

    local l_head_change_back=control_tools.newImg({path=g_path.."change_head.png"})
    l_head:addChild(l_head_change_back);
    l_head_change_back:setPosition(cc.p(0,-70+34/2))
    --赞
    local l_img_praise=control_tools.newImg({path=g_path.."btn_praise.png"})
    l_head:addChild(l_img_praise)
    l_img_praise:setPosition(cc.p(46,65))

    local l_img=control_tools.newImg({path=g_path.."img_praise.png"})
    l_img_praise:addChild(l_img)
    l_img:setPosition(cc.p(30,34/2))

    local l_label=control_tools.newLabel({font=20})
    l_img_praise:addChild(l_label)
    l_label:setPosition(cc.p(60,34/3))
    l_label:setString("赞")

    self.ptr_label_praise=control_tools.newLabel({font=20,color=cc.c3b(255,212,19)})
    self.ptr_label_praise:setPosition(cc.p(80,34/3))
    l_img_praise:addChild(self.ptr_label_praise)
    
    local l_user_data=json.decode(bp_get_self_user_data());
    self.user_data=l_user_data;
    self.ptr_label_praise:setString("("..l_user_data.praise..")")

    local l_label_id=control_tools.newLabel({font=26,color=cc.c3b(175,94,22),anchor=cc.p(0,0)})
    self:addChild(l_label_id)
    l_label_id:setPosition(cc.p(35,237))
    l_label_id:setString("ID:"..l_user_data.userid)

    self.ptr_label_account=control_tools.newLabel({font=26,color=cc.c3b(175,94,22),anchor=cc.p(0,0)})
    self:addChild(self.ptr_label_account)
    self.ptr_label_account:setPosition(cc.p(35,204))
    self.ptr_label_account:setString("账号:"..l_user_data.account)

    self.ptr_btn_realname=control_tools.newBtn({normal=g_path.."btn_smrz.png",pressed=g_path.."btn_smrz.png",small=true})
    self:addChild(self.ptr_btn_realname)
    self.ptr_btn_realname:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_realname(param_sender,param_touchType) end)
    self.ptr_btn_realname:setPosition(cc.p(130,158))

    self.ptr_img_realname=control_tools.newImg({path=g_path.."aleady_realname.png"})
    self:addChild(self.ptr_img_realname);
    self.ptr_img_realname:setPosition(cc.p(130,158))
    if bp_have_self_right(UC.UR_MASK_CERTIFICATION)==true then 
        self.ptr_img_realname:setVisible(true)
        self.ptr_btn_realname:setVisible(false)
        self.ptr_btn_realname:setTouchEnabled(false)
    else
        self.ptr_img_realname:setVisible(false)
        self.ptr_btn_realname:setVisible(true)
        self.ptr_btn_realname:setTouchEnabled(true)
    end

    --右边
    local l_bg_info=control_tools.newImg({path=g_path.."info_gui_back.png"})
    self:addChild(l_bg_info)
    l_bg_info:setPosition(cc.p(500,250))

    local l_change_name=UIChangeUserName:create();
    l_bg_info:addChild(l_change_name);
    l_change_name:setPosition(cc.p(0,220))
    
    local l_y=185
    --金币
    local l_img_label_gold=control_tools.newImg({path=g_path.."label_gold.png"})
    l_bg_info:addChild(l_img_label_gold)
    l_img_label_gold:setPosition(cc.p(40,l_y))
    
    local l_bg_gold=control_tools.newImg({path=g_path.."img_gold_back.png"})
    l_bg_info:addChild(l_bg_gold)
    l_bg_gold:setPosition(cc.p(190,l_y))

    local l_img_gold_icon=control_tools.newImg({path=g_path.."img_gold.png"})
    l_bg_gold:addChild(l_img_gold_icon)
    l_img_gold_icon:setPosition(cc.p(20,15))

    self.ptr_label_gold=control_tools.newLabel({fnt=g_path.."num_dt_wjxx_jb.fnt",anchor=cc.p(0,0.5)});
    l_bg_gold:addChild(self.ptr_label_gold)
    self.ptr_label_gold:setPosition(cc.p(30,15));
    self.ptr_label_gold:setString(self.user_data.gold)

    local l_btn_add=control_tools.newBtn({normal=g_path.."btn_add.png",pressed=g_path.."btn_add.png"})
    l_btn_add.id=0;
    l_bg_gold:addChild(l_btn_add)
    l_btn_add:setPosition(cc.p(185,10))
    l_btn_add:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_show_shop(param_sender,param_touchType) end)
    
    l_y=l_y-40;
    --等级
    local l_img_label_level=control_tools.newImg({path=g_path.."label_ingot.png"})
    l_bg_info:addChild(l_img_label_level)
    l_img_label_level:setPosition(cc.p(40,l_y))

    local l_img_progress_level_bg=control_tools.newImg({path=g_path.."progress_back.png"})
    l_bg_info:addChild(l_img_progress_level_bg)
    l_img_progress_level_bg:setPosition(cc.p(210,l_y));

    self.ptr_progess_level=ccui.LoadingBar:create();
    self.ptr_progess_level:loadTexture(g_path.."progress.png")
    self.ptr_progess_level:setPosition(cc.p(210,l_y))
    l_bg_info:addChild(self.ptr_progess_level);

    self.ptr_label_progress_number=control_tools.newLabel({font=26,color=cc.c3b(96,9,9)})
    l_bg_info:addChild(self.ptr_label_progress_number)
    self.ptr_label_progress_number:setPosition(cc.p(200,l_y))

    self.ptr_label_progress_level=control_tools.newLabel({font=26,color=cc.c3b(175,94,22),anchor=cc.p(0,0.5)})
    self.ptr_label_progress_level:setPosition(cc.p(310,l_y))
    l_bg_info:addChild(self.ptr_label_progress_level)

    l_y=l_y-40;
    --元宝
    local l_img_label_ingot=control_tools.newImg({path=g_path.."label_ingot.png"})
    l_bg_info:addChild(l_img_label_ingot)
    l_img_label_ingot:setPosition(cc.p(40,l_y))
    
    local l_bg_ingot=control_tools.newImg({path=g_path.."img_gold_back.png"})
    l_bg_info:addChild(l_bg_ingot)
    l_bg_ingot:setPosition(cc.p(190,l_y))

    local l_img_ingot_icon=control_tools.newImg({path=g_path.."img_ingot.png"})
    l_bg_ingot:addChild(l_img_ingot_icon)
    l_img_ingot_icon:setPosition(cc.p(20,15))

    self.ptr_label_ingot=control_tools.newLabel({fnt=g_path.."num_dt_wjxx_jb.fnt",anchor=cc.p(0,0.5)});
    l_bg_ingot:addChild(self.ptr_label_ingot)
    self.ptr_label_ingot:setPosition(cc.p(30,10));
    self.ptr_label_ingot:setString(self.user_data.ingot)

    local l_btn_add_ingot=control_tools.newBtn({normal=g_path.."btn_add.png",pressed=g_path.."btn_add.png"})
    l_btn_add_ingot.id=1;
    l_bg_ingot:addChild(l_btn_add_ingot)
    l_btn_add_ingot:setPosition(cc.p(185,15))
    l_btn_add_ingot:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_show_shop(param_sender,param_touchType) end)
    
    l_y=l_y-40;
    --魅力
    local l_img_label_praise=control_tools.newImg({path=g_path.."label_charm.png"})
    l_bg_info:addChild(l_img_label_praise)
    l_img_label_praise:setPosition(cc.p(40,l_y))

    local l_label_praise=control_tools.newLabel({font=26,color=cc.c3b(175,94,22),anchor=cc.p(0,0.5)})
    l_label_praise:setPosition(cc.p(90,l_y))
    l_bg_info:addChild(l_label_praise)
    l_label_praise:setString(self.user_data.praise)

    l_y=l_y-40;
    --手机
    local l_img_label_phone=control_tools.newImg({path=g_path.."label_phone.png"})
    l_bg_info:addChild(l_img_label_phone)
    l_img_label_phone:setPosition(cc.p(40,l_y))

    self.ptr_label_phone=control_tools.newLabel({font=26,color=cc.c3b(175,94,22),anchor=cc.p(0,0.5)})
    self.ptr_label_phone:setPosition(cc.p(90,l_y))
    l_bg_info:addChild(self.ptr_label_phone)
    if self.user_data.phone=="" then 
        self.ptr_label_phone:setString("未填写")
    else 
        self.ptr_label_phone:setString(self.user_data.phone)
    end

    local l_x=133
    --显示账号
    self.ptr_show_account=control_tools.newBtn({normal=g_path.."btn_show_account.png",small=true})
    self:addChild(self.ptr_show_account)
    self.ptr_show_account:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_show_accout(param_sender,param_touchType) end)
    table.insert( self.list_btn, self.ptr_show_account )
    self.ptr_show_account:setVisible(false)
    --切换账号
    self.ptr_btn_change_account=control_tools.newBtn({normal=g_path.."btn_change_account.png",small=true})
    self:addChild(self.ptr_btn_change_account)
    table.insert( self.list_btn, self.ptr_btn_change_account);
    self.ptr_btn_change_account:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_change_account(param_sender,param_touchType) end)
    self.ptr_btn_change_account:setVisible(false)
    --修改账号 密码
    if bp_have_self_right(UC.UR_MASK_FORMAL_USER) then 
        self.ptr_btn_alter_password_account=control_tools.newBtn({normal=g_path.."btn_alter_account.png",small=true})
    else
        self.ptr_btn_alter_password_account=control_tools.newBtn({normal=g_path.."btn_change_password.png",small=true})
    end
    self.ptr_btn_alter_password_account:setVisible(false)
    self:addChild(self.ptr_btn_alter_password_account)
    self.ptr_btn_alter_password_account:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_change_password(param_sender,param_touchType) end)
    --self.ptr_btn_change_password:setPosition(cc.p())
    if bp_have_mask_auth(AC.MASK_AUTH_CHANNEL)==false then 
        table.insert( self.list_btn, self.ptr_btn_alter_password_account);
    end

    --绑定微信
    if bp_have_self_right(UC.UR_MASK_CHECK_WECHAT)==true then 
        self.ptr_btn_bind_wechat=control_tools.newBtn({normal=g_path.."btn_bind_wechat_2.png",small=true})
        self.ptr_btn_bind_wechat:setTouchEnabled(true);
    else
        self.ptr_btn_bind_wechat=control_tools.newBtn({normal=g_path.."btn_bind_wechat_1.png",small=true})
        self.ptr_btn_bind_wechat:setTouchEnabled(true);
    end
    self.ptr_btn_bind_wechat:setVisible(false)
    self:addChild(self.ptr_btn_bind_wechat)
    self.ptr_btn_bind_wechat:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_bind_wechat(param_sender,param_touchType) end)
    if bp_have_mask_module(LC.MASK_MODULE_BIND_WECHAT) then 
        table.insert( self.list_btn, self.ptr_btn_bind_wechat);
    end

    
    if bp_have_self_right(UC.UR_MASK_CHECK_PHONE)==true then 
        self.ptr_btn_bind_phone=control_tools.newBtn({normal=g_path.."btn_bind_phone_2.png",small=true})
        self.ptr_btn_bind_phone:setTouchEnabled(true)
    else 
        self.ptr_btn_bind_phone=control_tools.newBtn({normal=g_path.."btn_bind_phone_1.png",small=true})
        self.ptr_btn_bind_phone:setTouchEnabled(true)
    end
    self:addChild(self.ptr_btn_bind_phone)
    self.ptr_btn_bind_phone:setVisible(false)
    self.ptr_btn_bind_phone:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_bind_phone(param_sender,param_touchType) end)
    if bp_have_mask_module(LC.MASK_MODULE_BIND_PHONE) then 
        table.insert( self.list_btn, self.ptr_btn_bind_phone);
    end
    self:on_btn_layout();

end
function UIUserInfo:on_btn_layout()
    local l_float_x=610;
	local l_float_space = 240;
    local float_begin_x = 130;
    print("hjjlog>>on_btn_layout:",#self.list_btn);
    
    if #self.list_btn >3 then 
        for i=#self.list_btn-2,#self.list_btn do
            print("hjjlog>>on_btn_layout:",i);
            self.list_btn[i]:setVisible(true)
            self.list_btn[i]:setPosition(cc.p(float_begin_x,40))
            float_begin_x = float_begin_x + l_float_space;
        end
    else
        for k,v in pairs(self.list_btn) do
            v:setVisible(true)
            v:setPosition(cc.p(l_float_x,40))
            float_begin_x = float_begin_x + l_float_space;
        end
    end
end

function UIUserInfo:on_btn_head(param_sender,param_touchType)
   if param_touchType~=_G.TOUCH_EVENT_ENDED then
       return 
   end
   local l_vip=class_tools.get_vip();
   if l_vip == 0 then 
        bp_show_message_box("提示","只有会员才能上传自定义头像，是否立即开通？",1,
        "立即开通","稍后再说",
        function(param_1,param_2)  self:on_btn_show_vipshow(param_1,param_2)  end,
        function(param_1,param_2) end,param_sender.id,"")
   else 
        bp_create_image_data(240,240,function(parma_code,parma_filename) self:on_create_custom_image(parma_code,parma_filename)   end)
   end
end
function UIUserInfo:on_create_custom_image(parma_code,parma_filename)
    print("hjjlog>>on_create_custom_image",parma_code,parma_filename);
    bp_show_hinting("真机调试，还未处理.")
end


function UIUserInfo:on_btn_show_vipshow(param_1,param_2)
    UIVipShop.ShowVipShop(true)
end

function UIUserInfo:on_btn_realname(param_sender,param_touchType)
   if param_touchType~=_G.TOUCH_EVENT_ENDED then
       return 
   end
   UIRealName.ShowRealName(true)
end

function UIUserInfo:on_btn_show_shop(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    UIShopCenter.ShowShopCenter(true,param_sender.id)
 end 

 function UIUserInfo:on_btn_show_accout(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
   if self.m_bool_show_accout==true then 
        set_local_value("show_account","0");
        m_bool_show_accout=false;
        self.ptr_show_account:loadTextureNormal(g_path.."btn_show_account.png")
        self.ptr_label_account:setString("账号:******")
        self.ptr_label_phone:setString("********")

   else 
        set_local_value("show_account","1");
        m_bool_show_accout=true;
        self.ptr_show_account:loadTextureNormal(g_path.."btn_hide_account.png")
        
        local l_user_data=json.decode(bp_get_self_user_data());
        self.ptr_label_account:setString("账号:"..l_user_data.account)

        if self.user_data.phone=="" then 
            self.ptr_label_phone:setString("未填写")
        else 
            self.ptr_label_phone:setString(self.user_data.phone)
        end
   end

 end 
 
 function UIUserInfo:on_btn_change_account(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    UIChangeAccount.ShowChangePassword(true)
 end 
  
 function UIUserInfo:on_btn_change_password(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    UIChangePassword.ShowChangePassword(true)
 end 

 function UIUserInfo:on_btn_bind_wechat(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    bp_show_loading(1)
    local l_success=bp_wechat_auth(function(param_code,param_data) self:on_call_back_bind_wechat(param_code,param_data) end )
    if l_success==false then 
        bp_show_loading(0)
        bp_show_hinting("微信绑定接口调用失败，请重试...")
    end
 end 
 function UIUserInfo:on_call_back_bind_wechat(param_code,param_data)
    --hjj_for_wait:
    print("hjjlog>>on_call_back_bind_wechat:",param_code,param_data);
    bp_show_loading(0)
    bp_show_hinting("微信绑定，手机测试。真机写")
 end

 function UIUserInfo:on_btn_bind_phone(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    UIPhoneBind.ShowPhoneBind(true)
 end 
 function UIUserInfo:on_btn_change_phone(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("hjjlog>>wait!!!!uiuserinfo  on_btn_change_phone");  
 end 

 function UIUserInfo:on_update_user_data()
    --self.user_data
    
    self.user_data=json.decode(bp_get_self_user_data());
    self.ptr_label_praise:setString("("..self.user_data.praise..")")

    if bp_have_self_right(UC.UR_MASK_CERTIFICATION)==true then 
        self.ptr_img_realname:setVisible(true)
        self.ptr_btn_realname:setVisible(false)
        self.ptr_btn_realname:setTouchEnabled(false)
    else
        self.ptr_img_realname:setVisible(false)
        self.ptr_btn_realname:setVisible(true)
        self.ptr_btn_realname:setTouchEnabled(true)
    end

    self.ptr_label_gold:setString(self.user_data.gold)
    self.ptr_label_ingot:setString(self.user_data.ingot)


    local  the_level_data = class_tools.get_level_data(self.user_data.gold);
	local int_percent = 0;
    if the_level_data._long_next_level_gold ~= -1  and the_level_data._long_next_level_gold ~= 0 then 
    
		int_percent = self.user_data.gold * 100 / the_level_data._long_next_level_gold;

		if int_percent == 0 then 
			int_percent = 0;
		elseif int_percent > 0 and int_percent < 15 then
			int_percent = 15;
		elseif int_percent > 100 then 
			int_percent = 100;
		else
			int_percent = int_percent;
        end
    end
    
    self.ptr_progess_level:setPercent(int_percent);

    self.ptr_label_progress_level:setString(the_level_data._str_level_name.."("..the_level_data._int_level..")")
    self.ptr_label_progress_number:setString(self.user_data.gold.."/"..the_level_data._long_next_level_gold)

 end



return UIUserInfo