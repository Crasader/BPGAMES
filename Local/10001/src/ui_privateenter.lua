local UIPrivateEnter=class("UIPrivateEnter",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/privateroom/")
local UIPrivateDetail=require("src/ui_privatedetail")
require("src/class_game_auxi")
function UIPrivateEnter:ctor()
    print("hjjlog>>UIPrivateEnter")
     self.m_int_index=1;
     self.m_str_room_code=""
    self:init();
end
function UIPrivateEnter:destory()
end

function UIPrivateEnter:init()
    local   l_lister= cc.EventListenerCustom:create("BACK_AUXI_RESULT", function (eventCustom)
          self:on_back_auxi_result(eventCustom);
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    self.the_size=cc.size(735,400);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

    self.ptr_label_hint=control_tools.newLabel({font=30,color=cc.c3b(158,101,64)})
    self:addChild(self.ptr_label_hint)
    self.ptr_label_hint:setPosition(cc.p(370,370))
    self.ptr_label_hint:setString("请输入6位房间号")

    self.list_label={}
    local l_x=735/2-70*2-35;
    for i =1,6 do
        local l_label=control_tools.newLabel({fnt=g_path.."num_jbc_jiesuan.fnt"});
        self:addChild(l_label)
        l_label:setPosition(cc.p(l_x,375))
        l_x=l_x+70;
        table.insert( self.list_label, l_label )
    end

    local l_img_line=control_tools.newImg({path=g_path.."img_line.png"})
    self:addChild(l_img_line)
    l_img_line:setPosition(cc.p(370,350))

    local float_begin_pos_x = 735/2-230;
	local float_begin_pos_y = 300;
	local float_percent_width = 230;
    local float_percent_height = 84; 
    for i=1,12 do
        local l_btn_num=control_tools.newBtn({normal=g_path.."mun_"..i.."_1.png",pressed=g_path.."mun_"..i.."_2.png"})
        self:addChild(l_btn_num)
        l_btn_num.tag=i;
        l_btn_num:setPosition(cc.p(float_begin_pos_x,float_begin_pos_y))
        l_btn_num:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_number(param_sender,param_touchType) end)
        float_begin_pos_x=float_begin_pos_x+float_percent_width
        if i%3==0 then
            float_begin_pos_y=float_begin_pos_y-float_percent_height;
            float_begin_pos_x=735/2-230;
        end
    end
end
function UIPrivateEnter:on_btn_number(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if param_sender.tag==10 then 
        self.m_int_index=1
        for i=1,6 do
            self.list_label[i]:setString("")
        end 
        self.ptr_label_hint:setVisible(true)
    elseif param_sender.tag==11 then 
        if self.m_int_index<7 then 
            self.list_label[self.m_int_index]:setString("0")
            self.m_int_index=self.m_int_index+1
            self.ptr_label_hint:setVisible(false)
        else
            bp_show_hinting("房间号最长输入6位数字")
        end
    elseif param_sender.tag==12 then
        if self.m_int_index>1 then 
            self.m_int_index=self.m_int_index-1;
            self.list_label[self.m_int_index]:setString("")
            if self.m_int_index==1 then 
                self.ptr_label_hint:setVisible(true)
            end
        else
            self.m_int_index=1
            self.ptr_label_hint:setVisible(true)
        end
    else
        if self.m_int_index<7 then 
            self.list_label[self.m_int_index]:setString(param_sender.tag)
            self.m_int_index=self.m_int_index+1
            self.ptr_label_hint:setVisible(false)
        else
            bp_show_hinting("房间号最长输入6位数字")
        end
    end
    if self.m_int_index>6 then 
        self.m_str_room_code=""
        for i=1,6 do
            self.m_str_room_code=self.m_str_room_code..self.list_label[i]:getString()
        end 
        get_share_game_auxi():enter_private_room(self.m_str_room_code)
    end
end
function UIPrivateEnter:on_back_auxi_result(param_result)
    if param_result.tag==5 then 
        self.m_int_index=1
        for i=1,6 do
            self.list_label[i]:setString("")
        end 
        self.ptr_label_hint:setVisible(true)
        param_result.value.code=get_share_game_auxi().m_str_enter_code;
        UIPrivateDetail.ShowPrivateDetail(true,param_result.value)
    elseif param_result.tag==6 then 
        bp_show_hinting(bp_gbk2utf(param_result.message))

    end
end




return UIPrivateEnter