local UIControl=require("src/ui_control")
local UITaskDay=class("UITaskDay",UIControl)
local g_path=BPRESOURCE("res/taskday/")
local UITaskDayItem=require("src/ui_taskday_item")
sptr_task=nil;
function UITaskDay:ctor(...)
    print("hjjlog>>UITaskDay")
    self.super:ctor(self)
    self.ptr_scrollview=nil;
    self.list_task_day_item={}
    self.list_task_day_item_sleep={}
    self.int_item_id=0;
    self:init();
end
function UITaskDay:destory()

end
--重载。
function UITaskDay:ShowGui(param_bool)
    if param_bool==true then 
        self:open_popups()
        self:request_task_data();
    else 
        self:close_popus()
    end
end
function UITaskDay:init()
    local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA", function (eventCustom)
          self:on_update_user_data();
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_task_day.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();

    local the_scrollview=cc.size(780,430)

    local test_bg=control_tools.newImg({path=TESTCOLOR.g,size=the_scrollview,anchor=cc.p(0,0)})
   -- test_bg:setPosition(cc.p(the_scrollview.width/2,the_scrollview.height/2))
    l_bg:addChild(test_bg);
    test_bg:setPosition(cc.p(25,80))

    self.ptr_scrollview=ccui.ScrollView:create();
    l_bg:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(the_scrollview)
    self.ptr_scrollview:setPosition(cc.p(25,80))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)

    -- self:get_a_task_day_item();
    -- self:get_a_task_day_item();
    -- self:clear_task_day_item();

    -- self:get_a_task_day_item();
    -- self:get_a_task_day_item();

    -- self:on_btn_item_bg(0,"");
end
function UITaskDay:clear_task_day_item()
    for k,v in pairs(self.list_task_day_item) do
        table.insert( self.list_task_day_item_sleep,v)
        --v:setVisible(false)
    end
    self.list_task_day_item={};
end

function UITaskDay:get_a_task_day_item()
    if #self.list_task_day_item_sleep >0 then 
        local l_item=self.list_task_day_item_sleep[#self.list_task_day_item_sleep]
        table.remove( self.list_task_day_item_sleep,#self.list_task_day_item_sleep)
        table.insert( self.list_task_day_item,l_item )
        return l_item;
    else 
        local l_day_data=UITaskDayItem:create();
        l_day_data:set_item_id(self.int_item_id)
        self.int_item_id=self.int_item_id+1;
        
        l_day_data:setExtraFunc("call_on_btn_item",function(param_id,parma_value) self:on_btn_item_bg(param_id,parma_value) end)
        l_day_data:setExtraFunc("call_hide_task",function() self:on_hide_task() end)

        self.ptr_scrollview:addChild(l_day_data)
        table.insert( self.list_task_day_item, l_day_data );
        return l_day_data;
    end
end
function UITaskDay:request_task_data()

    local req = URL.HTTP_TASK_DATA
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{TASKTYPE}",2);
    bp_http_get("hjj_task_data","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_task_data(param_identifier,param_success,param_code,param_header,context) end,1)

end
function UITaskDay:on_http_task_data(param_identifier,param_success,param_code,param_header,context)
    print("hjjlog>>00000000000",param_header,context);
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>request_task_data   fail");
        bp_show_hinting("任务请求失败。")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    print("hjjlog>>11111111111111111");
    
    --处理数据
    local the_list_task_data={}

    local the_value=l_data.resdata
    local int_count=0;
    for i=1,#the_value do 
        local the_task_value=the_value[i];
        local int_kind_id=the_task_value.complete_kindid;

        if int_kind_id==100 and bp_have_mask_module(LC.MASK_MODULE_SHOP) then 
            table.insert( the_list_task_data, the_task_value )
            int_count=int_count+1;
        end
        if bp_have_mask_module(LC.MASK_MODULE_BIND_PHONE)==0 then 
            local int_app_id=bp_get_appid();
            if int_app_id==int_kind_id then 
                int_count=int_count+1;
                table.insert( the_list_task_data, the_task_value )
            end
        else 
            local l_find=self:is_real_game(int_kind_id)
            if l_find==true then 
                int_count=int_count+1;
                table.insert( the_list_task_data, the_task_value )
            end
        end
    end
   self:clear_task_day_item();
    local int_line_count=int_count;
    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,110*int_line_count);
    if the_scrollview_size.height<self.ptr_scrollview:getContentSize().height then 
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height;
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)

    --排序

    local int_status={1,2,4}
    for n=1,3 do  
        for i=1,#the_list_task_data do
            local the_task_value=the_list_task_data[i];
            if the_task_value.status==int_status[n] then 
                --print("hjjlog>>8888:");
                local l_item=self:get_a_task_day_item()
                l_item:setVisible(true)
                l_item:set_task_data(the_task_value)
            end
        end
    end
    local float_pos_y= the_scrollview_size.height - 110;
    for k,v in pairs(self.list_task_day_item) do  
        v:setVisible(true)
        v:setPosition(cc.p(float_pos_x,float_pos_y));
        float_pos_y=float_pos_y-110;
    end

end
function UITaskDay:is_real_game(param_kind_id)
    local l_game_list=json.decode(bp_get_game_list());
    for i=1,#l_game_list do 
        local  l_list=l_game_list[i].list
        for j=1,#l_list do
            if param_kind_id==l_list[j] then 
                return true;
            end
        end
    end
    return  false;
end
function UITaskDay:on_hide_task()
    self:ShowGui(false)
end


function UITaskDay:on_btn_item_bg(param_id,parma_value)
    print("hjjlog>>jjjjjjjjjj:",param_id);
    
    for k,v in pairs(self.list_task_day_item) do 
        if v:get_item_id() ~=param_id then  
            v:hide_message();
        end
    end
end
function UITaskDay.ShowTask(param_show)
    if sptr_task==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_task=UITaskDay:create();
        main_layout:addChild(sptr_task)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_task:ShowGui(param_show)
    if param_id~=nil then 
        sptr_task:switch_item(param_id)
    end
    return sptr_task;
end

return UITaskDay