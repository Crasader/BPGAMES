local UITaskDayItem=class("UITaskDayItem",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/taskday/")
local UILabelEx2=require("bptools/uilabelex2")
function UITaskDayItem:ctor()
    print("hjjlog>>UITaskDayItem")
   self.the_size=nil;
    self.m_int_id=0;
    self._extra_func={}--注册的外部函数
    self:init();
end
function UITaskDayItem:destory()
end

function UITaskDayItem:init()
    self.the_size=cc.size(780,110);
    self:setContentSize(self.the_size)

    local l_btn_bg=control_tools.newBtn({normal=g_path.."item_bg.png",pressed=g_path.."item_bg.png"})
    self:addChild(l_btn_bg)
    l_btn_bg:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_item_bg(param_sender,param_touchType) end)
    l_btn_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))



    local l_img_flag=control_tools.newImg({path=g_path.."img_flag.png"})
    self:addChild(l_img_flag)
    l_img_flag:setPosition(cc.p(55,55))

    self.ptr_img_task_type=control_tools.newImg({path=g_path.."task_type.png"})
    self:addChild(self.ptr_img_task_type)
    self.ptr_img_task_type:setPosition(cc.p(55,55))

    self.ptr_label_task_name=control_tools.newLabel({font=26,color=cc.c3b(156,102,50),anchor=cc.p(0,0.5)})
    self:addChild(self.ptr_label_task_name)
    self.ptr_label_task_name:setPosition(cc.p(105,75))

    local  l_y=40
    local l_img_progress_level_bg=control_tools.newImg({path=g_path.."progress_back.png"})
    self:addChild(l_img_progress_level_bg)
    l_img_progress_level_bg:setPosition(cc.p(210,l_y));

    self.ptr_progess_level=ccui.LoadingBar:create();
    self.ptr_progess_level:loadTexture(g_path.."progress.png")
    self.ptr_progess_level:setPosition(cc.p(210,l_y))
    self:addChild(self.ptr_progess_level);

    self.ptr_label_progress_number=control_tools.newLabel({font=24})
    self:addChild(self.ptr_label_progress_number)
    self.ptr_label_progress_number:setPosition(cc.p(200,l_y))

    local l_img_gift_bg=control_tools.newImg({path=g_path.."img_gift_bg.png"})
    self:addChild(l_img_gift_bg);
    l_img_gift_bg:setPosition(cc.p(525,55))

    local l_img_gift=control_tools.newImg({path=g_path.."img_gift.png"})
    l_img_gift_bg:addChild(l_img_gift)
    l_img_gift:setPosition(cc.p(35,30))

    self.ptr_label_gift=control_tools.newLabel({font=24,color=cc.c3b(255,252,219),anchor=cc.p(0,0.5)})
    l_img_gift_bg:addChild(self.ptr_label_gift)
    self.ptr_label_gift:setPosition(cc.p(72,30))

    self.ptr_img_hint=control_tools.newImg({path=g_path.."img_hint_bg.png"})
    self:addChild(self.ptr_img_hint)
    self.ptr_img_hint:setPosition(cc.p(275,55))
    self.ptr_img_hint:setVisible(false)

    self.ptr_label_hint=control_tools.newLabel({ex=true,font=26,color=cc.c3b(156,102,50),anchor=cc.p(0,0.5)})
    self.ptr_img_hint:addChild(self.ptr_label_hint)
    self.ptr_label_hint:setPosition(cc.p(30,55))

    self.ptr_btn_award=control_tools.newBtn({normal=g_path.."btn_award.png",small=true})
    self:addChild(self.ptr_btn_award)
    self.ptr_btn_award:setPosition(cc.p(690,55))
    self.ptr_btn_award:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_award(param_sender,param_touchType) end)
    self.ptr_btn_award:setVisible(true);
end
function UITaskDayItem:set_item_id(param_id)
    self.m_int_item_id=param_id;
end
function UITaskDayItem:get_item_id()
    return self.m_int_item_id;
end
function UITaskDayItem:set_task_data(param_value)
    self.m_task_data=param_value;
    self.ptr_img_hint:setVisible(false)
    self.ptr_img_task_type:loadTexture(BPRESOURCE("res/common/")..param_value.task_logo_url);
    self.ptr_label_hint:setTextEx(param_value.task_desc,315,3)

    self.ptr_label_task_name:setString(param_value.task_name)

    self.ptr_label_progress_number:setString(param_value.curr_count.."//"..param_value.complete_count)
    local l_reward=bp_string_replace_key(param_value.reward_name,"\\n","\n")

    self.ptr_label_gift:setString(l_reward)
    local int_percent=0;
    if param_value.complete_count~=0 then 
        int_percent=param_value.curr_count*100/param_value.complete_count
        if int_percent>0 and int_percent<17 then 
            int_percent=17
        elseif int_percent>100 then 
            int_percent=100
        end
    end
    if int_percent==0 then 
        self.ptr_progess_level:setVisible(false)
    else
        self.ptr_progess_level:setVisible(true)
    end
    self.ptr_progess_level:setPercent(int_percent)
    if param_value.status==1 then 
        self.ptr_btn_award:loadTextureNormal(g_path.."btn_do_task.png")
        self.ptr_btn_award:loadTexturePressed(g_path.."btn_do_task.png")
        self.ptr_btn_award:setTouchEnabled(true)
    elseif param_value.status==2 then 
        self.ptr_btn_award:loadTextureNormal(g_path.."btn_award.png")
        self.ptr_btn_award:loadTexturePressed(g_path.."btn_award.png")
        self.ptr_btn_award:setTouchEnabled(true)
    elseif param_value.status==4 then 
        self.ptr_btn_award:loadTextureNormal(g_path.."btn_finish.png")
        self.ptr_btn_award:loadTexturePressed(g_path.."btn_finish.png")
        self.ptr_btn_award:setTouchEnabled(false)
    end
end
function UITaskDayItem:hide_message()
    self.ptr_img_hint:setVisible(false);
end


function UITaskDayItem:on_btn_item_bg(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self._extra_func["call_on_btn_item"](self.m_int_item_id,{});
    if self.ptr_img_hint:isVisible() ==true then 
        self.ptr_img_hint:setVisible(false);
    else 
        self.ptr_img_hint:setVisible(true)
    end
 end 

 function UITaskDayItem:on_btn_award(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if self.m_task_data.status==1 then 
        if self.m_task_data.task_url~="" then 
            local event = cc.EventCustom:new("MSG_DO_TASK");
            event.command = self.m_task_data.task_url
            cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
        end
        self._extra_func["call_hide_task"]();
    elseif self.m_task_data.status==2 then 
        self.ptr_btn_award:loadTextureNormal(g_path.."btn_awarding.png")
        self.ptr_btn_award:loadTexturePressed(g_path.."btn_awarding.png")
        self.ptr_btn_award:setTouchEnabled(false);
        self:request_task_award()
    else
    end
 end 

 function UITaskDayItem:request_task_award()
    local req = URL.HTTP_TASK_REWARD
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{TASKID}",self.m_task_data.task_id);
    control_tools.XMLHttpRequest(req,function(param_res) self:on_http_task_award(param_res) end)

 end
function UITaskDayItem:on_http_task_award(param_string)
    local l_data=json.decode(param_string);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    local l_str="已成功领取任务奖励【"..self.m_task_data.reward_name.."】"
    l_str=bp_string_replace_key(l_str,"\\n","+");
    bp_show_hinting(l_str)

    local the_value=l_data.resdata;
    --hjj_for_wait。
end

 function UITaskDayItem:setExtraFunc(param_key,param_func)
    self._extra_func[param_key]=param_func
end




return UITaskDayItem