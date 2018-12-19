local UIMiniUserData=class("UIMiniUserData",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/miniuserdata/")
local UIRichText=require("bptools/ui_richtext")
function UIMiniUserData:ctor()
    print("hjjlog>>UIMiniUserData")
    self:init();
    self:on_update_user_data()
end
function UIMiniUserData:destory()
end

function UIMiniUserData:init()

    local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA", function (eventCustom)
        self:on_update_user_data();
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    self.the_size=cc.size(800,60);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

    --金币
    self.ptr_bg_gold=control_tools.newImg({path=g_path.."img_bg.png"});
    self:addChild(self.ptr_bg_gold)

    local l_img_icon=control_tools.newImg({path=g_path.."img_gold.png"})
    self.ptr_bg_gold:addChild(l_img_icon)
    l_img_icon:setPosition(cc.p(25,18))

    self.ptr_label_gold=control_tools.newLabel({fnt=g_path.."num_dt_jbyb.fnt",anchor=cc.p(0,0.5)});
    self.ptr_bg_gold:addChild(self.ptr_label_gold)
    self.ptr_label_gold:setPosition(cc.p(40,13))

    --元宝
    self.ptr_bg_ingot=control_tools.newImg({path=g_path.."img_bg.png"});
    self:addChild(self.ptr_bg_ingot)

    local l_img_icon=control_tools.newImg({path=g_path.."img_ingot.png"})
    self.ptr_bg_ingot:addChild(l_img_icon)
    l_img_icon:setPosition(cc.p(25,18))

    self.ptr_label_ingot=control_tools.newLabel({fnt=g_path.."num_dt_jbyb.fnt",anchor=cc.p(0,0.5)});
    self.ptr_bg_ingot:addChild(self.ptr_label_ingot)
    self.ptr_label_ingot:setPosition(cc.p(40,13))
    --金豆
    self.ptr_bg_beans=control_tools.newImg({path=g_path.."img_bg.png"});
    self:addChild(self.ptr_bg_beans)

    local l_img_icon=control_tools.newImg({path=g_path.."img_beans.png"})
    self.ptr_bg_beans:addChild(l_img_icon)
    l_img_icon:setPosition(cc.p(25,18))

    self.ptr_label_beans=control_tools.newLabel({fnt=g_path.."num_dt_jbyb.fnt",anchor=cc.p(0,0.5)});
    self.ptr_bg_beans:addChild(self.ptr_label_beans)
    self.ptr_label_beans:setPosition(cc.p(40,13))

    --奖券
    self.ptr_bg_ticket=control_tools.newImg({path=g_path.."img_bg.png"});
    self:addChild(self.ptr_bg_ticket)

    local l_img_icon=control_tools.newImg({path=g_path.."img_ticket.png"})
    self.ptr_bg_ticket:addChild(l_img_icon)
    l_img_icon:setPosition(cc.p(25,18))

    self.ptr_label_ticket=control_tools.newLabel({fnt=g_path.."num_dt_jbyb.fnt",anchor=cc.p(0,0.5)});
    self.ptr_bg_ticket:addChild(self.ptr_label_ticket)
    self.ptr_label_ticket:setPosition(cc.p(40,13))


    self.ptr_img_hint_gold=control_tools.newImg({path=g_path.."img_hint_gold.png"})
    self:addChild(self.ptr_img_hint_gold)
    self.ptr_img_hint_gold:setPosition(cc.p(510,30))
    self.ptr_img_hint_gold:setVisible(false)

    --self.
    self.ptr_rich_text=UIRichText:create(20,cc.c3b(249, 246, 222),"Arial",cc.size(240,40))
    self:addChild(self.ptr_rich_text)
    self.ptr_rich_text:setAnchorPoint(cc.p(0,0.5))
    self.ptr_rich_text:setPosition(cc.p(400,30))

    self.ptr_btn_customer=control_tools.newBtn({normal=g_path.."btn_customer.png",small=true})
    self:addChild(self.ptr_btn_customer)
    self.ptr_btn_customer:setPosition(cc.p(715,30))
    self.ptr_btn_customer:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_customer(param_sender,param_touchType) end)
    self.ptr_btn_customer:setVisible(false)

end
function UIMiniUserData:switch_type(param_type,param_value)
    param_value=param_value or "";
    self.ptr_bg_gold:setVisible(false)
    self.ptr_bg_ingot:setVisible(false)
    self.ptr_bg_beans:setVisible(false)
    self.ptr_bg_ticket:setVisible(false)

    self.ptr_rich_text:setVisible(false)
    self.ptr_img_hint_gold:setVisible(false)
    self.ptr_btn_customer:setVisible(false)

    -- self.ptr_bg_gold:setPosition(cc.p(110,30))
    -- self.ptr_bg_ingot:setPosition(cc.p(300,30))
    -- self.ptr_bg_beans:setPosition(cc.p(490,30))
    -- self.ptr_bg_ticket:setPosition(cc.p(680,30))

    --1x  shop穿参数。
    if param_type==10 then
        self.ptr_bg_gold:setVisible(true)
        self.ptr_bg_gold:setPosition(cc.p(110,30))
        self.ptr_img_hint_gold:setVisible(true)
        self.ptr_btn_customer:setVisible(true)
    elseif param_type==11 then 
        self.ptr_bg_ingot:setVisible(true)
        self.ptr_bg_ingot:setPosition(cc.p(110,30))
        self.ptr_btn_customer:setVisible(true)
    elseif param_type==12 then 
        self.ptr_bg_beans:setVisible(true)
        self.ptr_bg_beans:setPosition(cc.p(110,30))
        self.ptr_btn_customer:setVisible(true)
    elseif param_type==13 then 

    elseif param_type==14 then 
        self.ptr_bg_gold:setVisible(true)
        self.ptr_bg_gold:setPosition(cc.p(110,30))
        self.ptr_bg_ingot:setVisible(true)
        self.ptr_bg_ingot:setPosition(cc.p(300,30))
        self.ptr_rich_text:setVisible(true)
        self.ptr_rich_text:setTextEx(param_value)
        self.ptr_btn_customer:setVisible(true)

    end


end
function UIMiniUserData:on_btn_customer(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
end



function UIMiniUserData:on_update_user_data()
    local l_user_data=json.decode(bp_get_self_user_data());
    self.ptr_label_gold:setString(l_user_data.gold)
    self.ptr_label_ingot:setString(l_user_data.ingot)
    self.ptr_label_beans:setString(l_user_data.bean)
    local l_array_prop=json.decode(bp_get_self_prop_count())
    for k,v in pairs(l_array_prop) do 
        if v.id==1002 then  
            self.ptr_label_ticket:setString(l_array_prop.cnt)
        end
    end
end

return UIMiniUserData