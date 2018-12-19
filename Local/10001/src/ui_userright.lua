
local UIControl=require("src/ui_control")
local UIUserRight=class("UIUserRight",function() return ccui.Layout:create() end)
local g_path=BPRESOURCE("res/usercenter/")
local UIPropsDetail=require("src/ui_propsdetail")
function UIUserRight:ctor()
    print("UIUserRight 2222"); 
    --self.super:ctor(self);
    self.ptr_scrollview=nil;
    self.list_status_item_sleep={}
    self.list_status_item={}
    self:init()
end
function UIUserRight:init()
    local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA", function (eventCustom)
        self:on_update_user_data();
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)


    self.the_size=cc.size(770,430);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.g,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

    self.ptr_scrollview=ccui.ScrollView:create();
    self:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(cc.size(self.the_size.width-20,self.the_size.height-20))
    self.ptr_scrollview:setPosition(cc.p(10,10))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)

    self.ptr_btn_buy=control_tools.newBtn({normal=g_path.."btn_buy_right.png",pressed=g_path.."btn_buy_right.png"})
    self:addChild(self.ptr_btn_buy)
    self.ptr_btn_buy:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_show_shop(param_sender,param_touchType) end)
    self.ptr_btn_buy:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:on_update_user_data()
end
function UIUserRight:on_btn_show_shop(param_sender,param_touchType) 
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return;
    end
    local event = cc.EventCustom:new("MSG_DO_TASK");
    event.command = "open:8"
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
 end 

 function UIUserRight:clear_item()
    for k,v in pairs(self.list_status_item) do
        v.bg:setVisible(false)
        table.insert( self.list_status_item_sleep, v )
    end
    self.list_status_item={}
 end

 function UIUserRight:get_a_right_item()
    if #self.list_status_item_sleep >0 then 
        local l_item=self.list_status_item_sleep[#self.list_status_item_sleep]
        table.remove( self.list_status_item_sleep,#self.list_status_item_sleep)
        table.insert( self.list_status_item,l_item )
        return l_item;
    else 
        local l_item={}
        local l_item_bg=control_tools.newImg({path=g_path.."bg_status_item.png"})
        self.ptr_scrollview:addChild(l_item_bg)
        l_item.bg=l_item_bg;
        local l_item_prop=control_tools.newBtn({normal=g_path.."kong.png",pressed=g_path.."kong.png"})
        l_item_prop:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_props(param_sender,param_touchType) end) 
        l_item_bg:addChild(l_item_prop);
        l_item_prop:setPosition(cc.p(75,75))
        l_item.prop=l_item_prop;    
        local l_item_label=control_tools.newLabel({font=22})
        l_item_bg:addChild(l_item_label)
        l_item_label:setPosition(cc.p(75,33))
        l_item.name=l_item_label;
        table.insert(self.list_status_item,l_item)
        return l_item;
    end
 end
 function UIUserRight:on_btn_props(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return;
    end
    print("hjjlog>>on_btn_props",param_sender.id,param_sender.cnt);
    UIPropsDetail.ShowPropsDetail(param_sender.id,param_sender.cnt,"",4,function(param_id,param_value) self:on_btn_use_props(param_id,param_value) end)
 end
 function UIUserRight:on_btn_use_props(param_id,param_value)
    print("hjjlog>>on_btn_use_props",param_id,param_value);
 end

function UIUserRight:on_update_user_data()
    local l_data=bp_get_self_prop_status(0)
    --print("hjjlog>>userright:",l_data);
    
    local user_prop_status=json.decode(l_data)
    
    local l_list_status_data={};
    for k,v in pairs(user_prop_status) do
        if bp_get_prop_status_data(v.id)~="" then 
            local t_status_data=json.decode(bp_get_prop_status_data(v.id))
            if t_status_data.type==1 then 
                table.insert( l_list_status_data,t_status_data )
            end
        end
    end
    if #l_list_status_data==0 then 
        self.ptr_btn_buy:setVisible(true)
    else 
        self.ptr_btn_buy:setVisible(false)
    end



    local int_line_count=math.ceil((#l_list_status_data)/4)
    local the_item_size=cc.size(150,150)
    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,the_item_size.height*int_line_count)

    if the_scrollview_size.height< self.ptr_scrollview:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)

    local float_space_x = (self.ptr_scrollview:getContentSize().width - the_item_size.width * 4) / 4+the_item_size.width;
    local float_space_y = the_item_size.height;

	local float_pos_x = float_space_x/2
	local float_pos_y = the_scrollview_size.height - the_item_size.height/2 ;

    self:clear_item()
    --先 能领取的
    local l_list_item={}
    for k,v in pairs(user_prop_status) do
        if bp_get_prop_status_data(v.id)~="" then 
            local t_status_data=json.decode(bp_get_prop_status_data(v.id))
            if t_status_data.type==1 then 
                if v.time>os.time() then 
                    local l_last_time=v.time-os.time();
                    local l_last_day=math.ceil(l_last_time/(24*3600))
                    local l_str_time="剩"..l_last_day.."天"
                    local l_item=self:get_a_right_item()
                    l_item.prop.id=v.id
                    l_item.prop.cnt=l_last_day
                    l_item.name:setString(l_str_time)
                    l_item.prop:loadTextures(BPRESOURCE("res/usercenter/status_"..v.id..".png"),BPRESOURCE("res/usercenter/status_"..v.id..".png"))
                    l_item.bg:setVisible(true)
                end
            end
        end
    end
    for k,v in pairs(user_prop_status) do
        if bp_get_prop_status_data(v.id)~="" then 
            local t_status_data=json.decode(bp_get_prop_status_data(v.id))
            if t_status_data.type==1 then 
                if v.time<=os.time() then 
                    local l_str_time="已过期"
                    local l_item=self:get_a_right_item()
                    l_item.name:setString(l_str_time)
                    l_item.prop.id=v.id
                    l_item.prop.cnt=-1
                    l_item.prop:loadTextures(BPRESOURCE("res/usercenter/status_"..v.id..".png"),BPRESOURCE("res/usercenter/status_"..v.id..".png"))
                    l_item.bg:setVisible(true)

                end
            end
        end
    end

    local int_index=0;
    for k,v in pairs(self.list_status_item) do 
        v.bg:setVisible(true)
        v.bg:setPosition(float_pos_x,float_pos_y)
        float_pos_x=float_pos_x+float_space_x
        if (int_index+1)%4==0 then 
            float_pos_x = float_space_x/2
            float_pos_y =float_pos_y- float_space_y;
        end
        int_index=int_index+1
    end
    
    -- for i=1,6 do
    --     for k=1,3 do 
    --         local l_item=self:get_a_right_item()
    --         l_item.bg:setVisible(true)
    --         l_item.bg:setPosition(float_pos_x,float_pos_y)
    --         float_pos_x=float_pos_x+float_space_x
    --         if (int_index+1)%4==0 then 
    --             float_pos_x = float_space_x/2
    --             float_pos_y =float_pos_y- float_space_y;
    --         end
    --         int_index=int_index+1
    --     end
    -- end
end


return UIUserRight