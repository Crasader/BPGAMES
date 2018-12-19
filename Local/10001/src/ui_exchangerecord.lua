local UIExchangeRecord=class("UIExchangeRecord",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/exchange/")
function UIExchangeRecord:ctor()
    print("hjjlog>>UIExchangeRecord")
    self.list_item_sleep={}
    self.list_item={}
    self.m_int_curr_page=1;
    self.m_int_curr_page_count=10;
    self.m_int_total_count=0;
    self.m_int_type=0;
    self.m_bool_active=false;
    self:init();
end
function UIExchangeRecord:destory()
end

function UIExchangeRecord:init()
    self.the_size=cc.size(770,420);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

    local l_img=control_tools.newImg({path=g_path.."img_message.png"})
    self:addChild(l_img)
    l_img:setPosition(cc.p(self.the_size.width/2,self.the_size.height-25+6))

    local l_img_time=control_tools.newImg({path=g_path.."img_time.png"})
    self:addChild(l_img_time)
    l_img_time:setPosition(cc.p(133,self.the_size.height-25+6))
    
    local l_img_name=control_tools.newImg({path=g_path.."img_name.png"})
    self:addChild(l_img_name)
    l_img_name:setPosition(cc.p(335,self.the_size.height-25+6))
    
    local l_img_order=control_tools.newImg({path=g_path.."img_order.png"})
    self:addChild(l_img_order)
    l_img_order:setPosition(cc.p(525,self.the_size.height-25+6))
    
    local l_img_status=control_tools.newImg({path=g_path.."img_status.png"})
    self:addChild(l_img_status)
    l_img_status:setPosition(cc.p(710,self.the_size.height-25+6))


    self.ptr_scrollview=ccui.ScrollView:create();
    self:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(cc.size(self.the_size.width,self.the_size.height-55))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)
    self.ptr_scrollview:setBounceEnabled(true)
    self.ptr_scrollview:addEventListener(function(param_obj,param_type) self:on_btn_drag_event(param_obj,param_type) end )

    self.ptr_img_record_hint=control_tools.newImg({path=g_path.."img_no_record.png"})
    self:addChild(self.ptr_img_record_hint)
    self.ptr_img_record_hint:setPosition(cc.p(self.the_size.width/2,400))
    self.ptr_img_record_hint:setVisible(false)

    self:request_exchange_record(self.m_int_curr_page,self.m_int_curr_page_count);
end

function UIExchangeRecord:clear_item()
    for k,v in pairs(self.list_item) do
        v.bg:setVisible(false)
        table.insert( self.list_item_sleep,v ) 
    end
    self.list_item={};
end

function UIExchangeRecord:get_a_item()
    if #self.list_item_sleep >0 then 
        local l_item=self.list_item_sleep[#self.list_item_sleep]
        table.remove( self.list_item_sleep,#self.list_item_sleep )
        table.insert( self.list_item,l_item )
        return l_item;
    else 
        local l_item={}
        local l_item_bg=control_tools.newImg({path=TESTCOLOR.g,size=cc.size(770,60),anchor=cc.p(0,0)})
        self.ptr_scrollview:addChild(l_item_bg)
        l_item.bg=l_item_bg;

        local l_label_time=control_tools.newLabel({font=22,color=cc.c3b(148,103,44)})
        l_item_bg:addChild(l_label_time)
        l_label_time:setPosition(cc.p(125,30))
        l_item.time=l_label_time;

        local l_label_name=control_tools.newLabel({font=22,color=cc.c3b(148,103,44)})
        l_item_bg:addChild(l_label_name)
        l_label_name:setPosition(cc.p(325,30))
        l_item.name=l_label_name;

        local l_label_order=control_tools.newLabel({font=22,color=cc.c3b(148,103,44)})
        l_item_bg:addChild(l_label_order)
        l_label_order:setPosition(cc.p(520,30))
        l_item.order=l_label_order;

        local l_label_status=control_tools.newLabel({font=22,color=cc.c3b(148,103,44)})
        l_item_bg:addChild(l_label_status)
        l_label_status:setPosition(cc.p(700,30))
        l_item.status=l_label_status;

        local l_img_line=control_tools.newImg({path=g_path.."img_line.png"})
        l_item_bg:addChild(l_img_line)
        l_img_line:setPosition(cc.p(770/2,0))

        table.insert(self.list_item,l_item)
        return l_item;
    end
end

function UIExchangeRecord:request_exchange_record(param_page,param_count)
    bp_show_loading(1)
    local req = URL.HTTP_EXCHANGE_RECORD
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{PAGENO}",param_page);
    req=bp_string_replace_key(req,"{PAGESIZE}",param_count);
    bp_http_get("HTTP_EXCHANGE_RECORD","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_exchange_record(param_identifier,param_success,param_code,param_header,context) end,1)
    self.m_bool_active=true;
end
function UIExchangeRecord:on_http_exchange_record(param_identifier,param_success,param_code,param_header,context)
    print("hjjlog>>on_http_exchange_record",context);
    bp_show_loading(0)
    self.m_bool_active=false;
    if param_success~=true or param_code~=200 then 
        print("hjjlog>>on_http_exchange_record   fail");
        bp_show_hinting("兑换列表请求失败")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    self:clear_item()
    local the_value=l_data.resdata.list
    self.m_int_total_count=l_data.resdata.count;

    if #the_value==0 then  
        self.ptr_img_record_hint:setVisible(true)
    else
        self.ptr_img_record_hint:setVisible(false)
    end
    
    for k,v in pairs(the_value) do 
        local l_item=self:get_a_item();
        l_item.bg:setVisible(true) 
        l_item.time:setString(v.create_time)
        l_item.name:setString(v.fund_name)
        l_item.order:setString(v.order_no)
        if v.status==1 then 
            l_item.status:setString("待审核")
        elseif v.status==2 then 
            l_item.status:setString("已经发放")
        else
            l_item.status:setString("审核中")
        end
    end

    self:update_layout();
end
function UIExchangeRecord:on_btn_drag_event(param_obj,param_type)
  --  print("hjjlog>>on_btn_drag_event0000000000:",param_type);
    if self.m_bool_active==true then 

        return ;
    end
    if param_type==ccui.ScrollviewEventType.bounceTop then 
        print("hjjlog>>on_btn_drag_event1111111111111:",self.m_int_curr_page);
        if self.m_int_curr_page>1 then 
            self.m_int_curr_page=self.m_int_curr_page-1;
            self:request_exchange_record(self.m_int_curr_page,self.m_int_curr_page_count)
            self.m_int_type=param_type;
        end
    elseif param_type==ccui.ScrollviewEventType.bounceBottom then 
        print("hjjlog>>on_btn_drag_event2222222222222:",self.m_int_curr_page);
        if self.m_int_curr_page*self.m_int_curr_page_count<self.m_int_total_count then  
            self.m_int_curr_page=self.m_int_curr_page+1;
            self:request_exchange_record(self.m_int_curr_page,self.m_int_curr_page_count)
            self.m_int_type=param_type;
        end
    end
end
function UIExchangeRecord:update_layout()

    local int_line_count=#self.list_item
    local the_item_size=cc.size(760,60)
    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,the_item_size.height*int_line_count)

    if the_scrollview_size.height< self.ptr_scrollview:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)

    local float_space_y = the_item_size.height;

	local float_pos_x = 0
    local float_pos_y = the_scrollview_size.height - the_item_size.height ;
    local int_index=0;
    for k,v in pairs(self.list_item) do 
        v.bg:setVisible(true);
        v.bg:setPosition(float_pos_x,float_pos_y)
        float_pos_y =float_pos_y- float_space_y;
    end

    if param_type==ccui.ScrollviewEventType.bounceTop then 
        self.ptr_scrollview:jumpToBottom();
    elseif param_type==ccui.ScrollviewEventType.bounceBottom then 
        self.ptr_scrollview:jumpToTop()
    else
        self.ptr_scrollview:jumpToTop()
    end
end

return UIExchangeRecord