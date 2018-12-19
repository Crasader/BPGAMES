
local UIControl=require("src/ui_control")
local UIUserProp=class("UIUserProp",function() return ccui.Layout:create() end)
local UIPropsDetail=require("src/ui_propsdetail")
local g_path=BPRESOURCE("res/props/")
local g_path_common=BPRESOURCE("res/common/",10000)

function UIUserProp:ctor()
    print("UIUserProp 2222"); 
    --self.super:ctor(self);
    self.ptr_scrollview=nil;
    self.list_prop_item_sleep={}
    self.list_prop_item={}
    self:init()
end
function UIUserProp:init()
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

    self.ptr_btn_buy=control_tools.newBtn({normal=g_path.."btn_buy_prop.png",pressed=g_path.."btn_buy_prop.png"})
    self:addChild(self.ptr_btn_buy)
    self.ptr_btn_buy:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_show_shop(param_sender,param_touchType) end)
    self.ptr_btn_buy:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:on_update_user_data()
end
function UIUserProp:on_btn_show_shop(param_sender,param_touchType) 
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return;
    end
    local event = cc.EventCustom:new("MSG_DO_TASK");
    event.command = "open:2"
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
 end 
 function UIUserProp:on_btn_props(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return;
    end
    print("hjjlog>>on_btn_props",param_sender.id,param_sender.cnt);
    UIPropsDetail.ShowPropsDetail(param_sender.id,param_sender.cnt,"",3,function(param_id,param_value) self:on_btn_use_props(param_id,param_value) end)
 end
 function UIUserProp:clear_item()
    for k,v in pairs(self.list_prop_item) do
        v.bg:setVisible(false)
        table.insert( self.list_prop_item_sleep, v )
    end
    self.list_prop_item={}
 end

 function UIUserProp:get_a_prop_item()
    if #self.list_prop_item_sleep >0 then 
        local l_item=self.list_prop_item_sleep[#self.list_prop_item_sleep]
        table.remove( self.list_prop_item_sleep,#self.list_prop_item_sleep )
        table.insert( self.list_prop_item,l_item )
        return l_item;
    else 
        local l_item={}
        local l_item_bg=control_tools.newImg({path=g_path.."prop_bg.png"})
        self.ptr_scrollview:addChild(l_item_bg)
        l_item.bg=l_item_bg;
        local l_item_prop=control_tools.newBtn({})
        l_item_bg:addChild(l_item_prop);
        l_item_prop:setPosition(cc.p(100,100+5))
        l_item.prop=l_item_prop;   
        l_item_prop:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_props(param_sender,param_touchType) end) 

        local l_item_label=control_tools.newLabel({font=22})
        l_item_bg:addChild(l_item_label)
        l_item_label:setPosition(cc.p(100,175))
        l_item.name=l_item_label;
        table.insert(self.list_prop_item,l_item)
        local l_item_btn_bg=control_tools.newImg({path=g_path.."btn_prop.png"})
        l_item_bg:addChild(l_item_btn_bg)
        l_item_btn_bg:setPosition(cc.p(100,35))
        local l_item_count=control_tools.newLabel({fnt=g_path.."number_zhangbao.fnt"});
        l_item_bg:addChild(l_item_count)
        l_item_count:setPosition(cc.p(100,35))
        l_item.cnt=l_item_count
        return l_item;
    end
 end

function UIUserProp:on_update_user_data()
    local l_data=bp_get_self_prop_count(0)
   -- print("hjjlog>>UIUserProp:",l_data);
    local user_prop_count=json.decode(l_data)
    
    local l_list_props_data={};
    for k,v in pairs(user_prop_count) do
        if  bp_get_prop_data(v.id)~="" then 
            local t_status_data=json.decode(bp_get_prop_data(v.id))
            table.insert( l_list_props_data,t_status_data )
        end
    end
    if #l_list_props_data==0 then 
        self.ptr_btn_buy:setVisible(true)
    else 
        self.ptr_btn_buy:setVisible(false)
    end

    local int_line_count=math.ceil((#l_list_props_data)/4)
    local the_item_size=cc.size(200,200)
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
    --先能用的
    local l_list_item={}
    for k,v in pairs(user_prop_count) do
        if  bp_get_prop_data(v.id)~="" then 
            local t_status_data=json.decode(bp_get_prop_data(v.id))
            if t_status_data.mask==1 then 
                local l_item=self:get_a_prop_item()    
                l_item.name:setString(t_status_data.name)
                l_item.prop.id=v.id
                l_item.prop.cnt=v.cnt
                l_item.prop:loadTextures(g_path_common.."prop_"..v.id..".png",g_path_common.."prop_"..v.id..".png")
                l_item.bg:setVisible(true) 
                l_item.cnt:setString(v.cnt.."个")
            end
        end
    end
    for k,v in pairs(user_prop_count) do
        if  bp_get_prop_data(v.id)~="" then 
            local t_status_data=json.decode(bp_get_prop_data(v.id))
            if t_status_data.mask~=1 then     
                local l_item=self:get_a_prop_item()    
                l_item.name:setString(t_status_data.name)
                l_item.prop.id=v.id
                l_item.prop.cnt=v.cnt
                l_item.prop:loadTextures(g_path_common.."prop_"..v.id..".png",g_path_common.."prop_"..v.id..".png")
                l_item.bg:setVisible(true) 
                l_item.cnt:setString(v.cnt.."个")
            end
        end
    end

    local int_index=0;
    for k,v in pairs(self.list_prop_item) do 
        v.bg:setVisible(true)
        v.bg:setPosition(float_pos_x,float_pos_y)
        float_pos_x=float_pos_x+float_space_x
        if (int_index+1)%4==0 then 
            float_pos_x = float_space_x/2
            float_pos_y =float_pos_y- float_space_y;
        end
        int_index=int_index+1
    end
end

function UIUserProp:on_btn_use_props(param_id,param_value)
    print("hjjlog>>on_btn_use_props",param_id,param_value);
    if param_id==PROP.ID_PROP_RECARD then 
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_RECARD_ONE then 
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_SMALL_BUGLE then 
        bp_show_hinting("该道具只能在游戏房间中使用")
    elseif param_id==PROP.ID_PROP_BIG_BUGLE then 
        --hjj_for_wait
    elseif param_id==PROP.ID_PROP_VIP_1 then 
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_VIP_2 then 
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_VIP_3 then 
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_VIP_4 then 
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_SCOREDOUBLE then 
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_SCORESHIELD then 
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_PACKAGE then 
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_CHARMCLEAR then 
        
        local l_user_data=json.decode(bp_get_self_user_data());
        if l_user_data.charm>=0 then 
            bp_show_hinting("您的魅力大于零，无需清零")
            return ;
        end
        self:request_use_prop(param_id, 1);
    elseif param_id==PROP.ID_PROP_SCORECLEAR then 
        bp_show_hinting("该道具只能在游戏房间中使用")
    else
    end
end
function UIUserProp:request_use_prop(param_id,param_count)
    local req = URL.HTTP_USE_PROP
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{PROPID}",param_id);
    req=bp_string_replace_key(req,"{PARAM}","");
    bp_http_get(""..param_id,"",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_use_prop(param_identifier,param_success,param_code,param_header,context) end,1)

end

function UIUserProp:on_http_use_prop(param_identifier,param_success,param_code,param_header,context)
   
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>request_task_data   fail");
        bp_show_hinting("道具失败("..param_identifier..")")
        return  ;
    end
    
    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    bp_update_user_data(1);
    bp_show_hinting("道具已使用成功")
end

return UIUserProp