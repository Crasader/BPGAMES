local UIShopProp=class("UIShopProp",function() return ccui.Layout:create() end)
local g_path=BPRESOURCE("res/props/")
local g_path_common=BPRESOURCE("res/common/",10000)
local UIPropsDetail=require("src/ui_propsdetail")

require("bptools/class_tools")
function UIShopProp:ctor()
   print("hjjlog>>UIShopProp")
   self.list_item_sleep={}
   self.list_item={}
   self:init();

end
function UIShopProp:destory()
end


function UIShopProp:init()

    self.the_size=cc.size(770,420);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

    self.ptr_scrollview=ccui.ScrollView:create();
    self:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(cc.size(self.the_size.width,self.the_size.height))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)

    self:update_layout()
end

function UIShopProp:clear_item()
    for k,v in pairs(self.list_item) do
        v:setVisible(false)
        table.insert( self.list_item_sleep,v ) 
    end
    self.list_item={};
end

function UIShopProp:get_a_gold_item()
    if #self.list_item_sleep >0 then 
        local l_item=self.list_item_sleep[#self.list_item_sleep]
        table.remove( self.list_item_sleep,#self.list_item_sleep )
        table.insert( self.list_item,l_item )
        return l_item;
    else 
        local l_item={}
        local l_item_bg=control_tools.newImg({path=g_path.."prop_bg.png"})
        self.ptr_scrollview:addChild(l_item_bg)
        l_item.ptr_bg=l_item_bg;
        local l_item_prop=control_tools.newBtn({})
        l_item_bg:addChild(l_item_prop);
        l_item_prop:setPosition(cc.p(100,100+5))
        l_item.ptr_prop=l_item_prop;   
        l_item_prop:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_props(param_sender,param_touchType) end) 
        local l_item_label=control_tools.newLabel({font=22})
        l_item_bg:addChild(l_item_label)
        l_item_label:setPosition(cc.p(100,175))
        l_item.ptr_name=l_item_label;

        local l_img_desc_bg=control_tools.newImg({path=g_path.."img_desc_bg.png"})
        l_item_bg:addChild(l_img_desc_bg)
        l_img_desc_bg:setPosition(cc.p(143,130))
        l_item.ptr_bgdesc=l_img_desc_bg;
        local l_label_desc=control_tools.newLabel({font=16,anchor=cc.p(0,0.5)})
        l_img_desc_bg:addChild(l_label_desc)
        l_label_desc:setPosition(cc.p(12,30))
        l_item.ptr_labledesc=l_label_desc;
        local l_item_btn_bg=control_tools.newImg({path=g_path.."btn_prop.png"})
        l_item_bg:addChild(l_item_btn_bg)
        l_item_btn_bg:setPosition(cc.p(100,35))
        local l_item_count=control_tools.newLabel({fnt=g_path.."number_zhangbao.fnt"});
        l_item_bg:addChild(l_item_count)
        l_item_count:setPosition(cc.p(100,35))
        l_item.ptr_price=l_item_count
        table.insert(self.list_item,l_item)
        return l_item;
    end
end

function UIShopProp:update_layout()
    local l_product_table=PROPS
    
    for k,v in pairs(l_product_table) do
        local l_item=self:get_a_gold_item();
        l_item.ptr_bg:setVisible(true)
        l_item.ptr_prop.id=v.id
        l_item.ptr_prop.cnt=v.prop_count
        l_item.ptr_prop.price=v.price
        l_item.ptr_name:setString(v.prop_name);
        l_item.ptr_prop:loadTextures(g_path_common.."prop_"..v.id..".png",g_path_common.."prop_"..v.id..".png")
        l_item.ptr_price:setString(v.fund_price)
        if v.fund_desc==""then 
            l_item.ptr_bgdesc:setVisible(false)
        else 
            l_item.ptr_bgdesc:setVisible(true)
            l_item.ptr_labledesc:setString(v.fund_desc)
        end
        --l_item:set_item_data(v);
    end

    local int_line_count=math.ceil((#self.list_item)/4)
    local the_item_size=cc.size(202,202)
    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,the_item_size.height*int_line_count)

    if the_scrollview_size.height< self.ptr_scrollview:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)

    local float_space_x = (self.ptr_scrollview:getContentSize().width - the_item_size.width * 4) / 4+the_item_size.width;
    local float_space_y = the_item_size.height;

	local float_pos_x = float_space_x/2
    local float_pos_y = the_scrollview_size.height - the_item_size.height/2 ;
    local int_index=0;
    for k,v in pairs(self.list_item) do 
        v.ptr_bg:setVisible(true);
        v.ptr_bg:setPosition(float_pos_x,float_pos_y)
        float_pos_x=float_pos_x+float_space_x
        if (int_index+1)%4==0 then 
            float_pos_x = float_space_x/2
            float_pos_y =float_pos_y- float_space_y;
        end
        int_index=int_index+1
    end
end

function UIShopProp:on_btn_props(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return;
    end
    print("hjjlog>>on_btn_props",param_sender.id,param_sender.cnt);
    UIPropsDetail.ShowPropsDetail(param_sender.id,param_sender.cnt,{id=param_sender.id,price=param_sender.price},1,function(param_id,param_value) self:on_btn_exchange_ok(param_id,param_value) end)
 end
function UIShopProp:on_btn_exchange_ok(param_id,param_value)
    print("hjjlog>>UIShopProp:on_btn_exchange_ok111:",param_id,param_value);
    print("hjjlog>>UIShopProp:on_btn_exchange_ok22:",param_value);
    
    local l_user_data=json.decode(bp_get_self_user_data());

    if l_user_data.ingot<param_value then 
        bp_show_message_box("提示","您的元宝不足，是否立即充值？",
        1,
        "立即充值","稍后再说",
        function(param_1,param_2) 
            local event = cc.EventCustom:new("MSG_DO_TASK");
            event.command = "open:3"
            cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
        end,
        function(param_1,param_2) end,0,"")
    end
    self:request_exchange(param_id)
end
function UIShopProp:request_exchange(param_id)

  bp_show_loading(1)
    local req = URL.HTTP_PROP_SHOP
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{SHOPID}",param_id);

    bp_http_get(""..param_id,"",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_exchange(param_identifier,param_success,param_code,param_header,context) end,1)

end
function UIShopProp:on_http_exchange(param_identifier,param_success,param_code,param_header,context)
    print("hjjlog>>on_http_exchange",context);
     bp_show_loading(0)
     if param_success~=true or param_code~=200 then 
         bp_show_hinting("兑换数据请求失败")
         return  ;
     end
 
     local l_data=json.decode(context);
     if l_data.rescode~=1 then 
         bp_show_hinting(l_data.resmsg)
         return ;
     end
     if tonumber(param_identifier)==PROP.ID_PROP_RECARD or tonumber(param_identifier)==PROP.ID_PROP_RECARD_ONE then 
        
        bp_show_message_box("提示","你已成功购买了【记牌器】，是否立即使用？",
        1,
        "立即使用","稍后再说",
        function(param_1,param_2) 
            self:request_use_prop(tonumber(param_identifier), 1);
        end,
        function(param_1,param_2) end,0,"")
    else
        bp_show_hinting("购买成功")
     end
     bp_update_user_data(1) 
end

function UIShopProp:request_use_prop(param_id,param_count)
    local req = URL.HTTP_USE_PROP
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{PROPID}",param_id);
    req=bp_string_replace_key(req,"{PARAM}","");
    bp_http_get(""..param_id,"",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_use_prop(param_identifier,param_success,param_code,param_header,context) end,1)

end
function UIShopProp:on_http_use_prop(param_identifier,param_success,param_code,param_header,context)
   
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




return UIShopProp
