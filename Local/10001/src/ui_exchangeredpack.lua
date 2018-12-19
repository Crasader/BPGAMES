local UIExchangeRedpack=class("UIExchangeRedpack",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/exchange/")
function UIExchangeRedpack:ctor()
    print("hjjlog>>UIExchangeRedpack")
    self.list_item_sleep={}
    self.list_item={}
    self:init();
end
function UIExchangeRedpack:destory()
end

function UIExchangeRedpack:init()
    self.the_size=cc.size(770,420);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

    local l_label_hint=control_tools.newLabel({font=25,color=cc.c3b(144,69,46)})
    self:addChild(l_label_hint)
    l_label_hint:setPosition(cc.p(self.the_size.width/2,60))
    l_label_hint:setString("领取红包，请关注公众号:大眼游戏(微信号：dayangame)")

    
    self.ptr_scrollview=ccui.ScrollView:create();
    self:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(cc.size(self.the_size.width,300))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)
    self.ptr_scrollview:setPosition(cc.p(0,100))

    self:request_exchange_record();
end
function UIExchangeRedpack:clear_item()
    for k,v in pairs(self.list_item) do
        v.ptr_bg:setVisible(false)
        table.insert( self.list_item_sleep,v ) 
    end
    self.list_item={};
end

function UIExchangeRedpack:get_a_item()
    if #self.list_item_sleep >0 then 
        local l_item=self.list_item_sleep[#self.list_item_sleep]
        table.remove( self.list_item_sleep,#self.list_item_sleep )
        table.insert( self.list_item,l_item )
        return l_item;
    else 
        local l_item={}
        local l_item_bg=control_tools.newImg({path=g_path.."bg_redpack.png",anchor=cc.p(0,0)})
        self.ptr_scrollview:addChild(l_item_bg)
        l_item.ptr_bg=l_item_bg;
        l_item_bg:setTouchEnabled(true)
        l_item_bg:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_redpacket(param_sender,param_touchType) end) 
        

        local l_label_name=control_tools.newLabel({fnt=g_path.."num_dhjb.fnt"});
        l_item_bg:addChild(l_label_name)
        l_label_name:setPosition(cc.p(91,65))
        l_item.ptr_name=l_label_name

        local l_label_num=control_tools.newLabel({font=25,color=cc.c3b(255,231,158)})
        l_item_bg:addChild(l_label_num)
        l_label_num:setPosition(cc.p(91,25))
        l_item.ptr_num=l_label_num;

        table.insert(self.list_item,l_item)
        return l_item;
    end
end

function UIExchangeRedpack:request_exchange_record()
    bp_show_loading(1)
    local req = URL.HTTP_EXCHANGE_REDPACKET_LIST
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    bp_http_get("hjj_task_data","",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_exchange_record(param_identifier,param_success,param_code,param_header,context) end,1)
    self.m_bool_active=true;
end
function UIExchangeRedpack:on_http_exchange_record(param_identifier,param_success,param_code,param_header,context)
    print("hjjlog>>UIExchangeRedpack：on_http_exchange_record",context);
    bp_show_loading(0)
    self.m_bool_active=false;
    if param_success~=true or param_code~=200 then 
        bp_show_hinting("兑换列表请求失败")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    self:clear_item()

    local the_value=l_data.resdata.fund_all;

    for k,v in pairs(the_value) do   
        local l_item=self:get_a_item();
        l_item.ptr_bg.the_fund_data=v
        l_item.ptr_name:setString(v.fund_name)
        if v.left_num>10 then 
            l_item.ptr_num:setString("库存:充足")
        else
            l_item.ptr_num:setString("库存:"..v.left_num)
        end
    end
    self:update_layout();
 
end

function UIExchangeRedpack:update_layout()

    local int_line_count=math.ceil((#self.list_item)/4)
    local the_item_size=cc.size(182,260)
    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,the_item_size.height*int_line_count)

    if the_scrollview_size.height< self.ptr_scrollview:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)

    local float_space_x = (self.ptr_scrollview:getContentSize().width - the_item_size.width * 4) / 4+the_item_size.width;
    local float_space_y = the_item_size.height;

	local float_pos_x = float_space_x/2-the_item_size.width/2
    local float_pos_y = the_scrollview_size.height - the_item_size.height ;
    local int_index=0;
    for k,v in pairs(self.list_item) do 
        v.ptr_bg:setVisible(true);
        v.ptr_bg:setPosition(float_pos_x,float_pos_y)
        float_pos_x=float_pos_x+float_space_x
        if (int_index+1)%4==0 then 
            float_pos_x = float_space_x/2-the_item_size.width/2
            float_pos_y =float_pos_y- float_space_y;
        end
        int_index=int_index+1
    end
end
function UIExchangeRedpack:on_btn_redpacket(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return;
    end
    --redpacket
    
    local l_user_data=json.decode(bp_get_self_user_data());
    if param_sender.the_fund_data.left_num<1 then 
        bp_show_hinting("剩余库存不足，请稍后再试")
        return ;
    end
    if l_user_data.redpacket< param_sender.the_fund_data.need_num then 

        bp_show_hinting("您的红包不足，无法兑换")
        return ;
    end


    bp_show_message_box("提示","您确定需要兑换"..param_sender.the_fund_data.fund_name.."吗？",
    1,
    "确定","取消",
    function(param_1,param_2) self:request_exchange(param_sender.the_fund_data.fundid)  end,
    function(param_1,param_2) end,0,"")
end
function  UIExchangeRedpack:request_exchange(param_id)
    bp_show_loading(1)
    local req = URL.HTTP_EXCHANGE_REDPACKET
    req=bp_make_url(req)
    req=bp_string_replace_key(req,"&quot;","\"");
    req=bp_string_replace_key(req,"{FUNDID}",param_id);
  print("hjjlog>>request_exchange:",req);
  
    bp_http_get(""..param_id,"",req,function(param_identifier,param_success,param_code,param_header,context) self:on_http_exchange(param_identifier,param_success,param_code,param_header,context) end,1)
end
function UIExchangeRedpack:on_http_exchange(param_identifier,param_success,param_code,param_header,context)
    --print("hjjlog>>UIExchangeRedpack:on_http_exchange:",context);
    
    bp_show_loading(0)
    self.m_bool_active=false;
    if param_success~=true or param_code~=200 then 
        bp_show_hinting("兑换失败,请稍后再试")
        return  ;
    end

    local l_data=json.decode(context);
    if l_data.rescode~=1 then 
        bp_show_hinting(l_data.resmsg)
        return ;
    end
    local l_resdata=l_data.resdata

    for k,v in pairs(self.list_item) do
        if v.ptr_bg.the_fund_data.fundid==tonumber(param_identifier)  then 
            if l_resdata.left_num>10 then 
                v.ptr_num:setString("库存:充足")
            else
                v.ptr_num:setString("库存:".. l_resdata.left_num)
            end
            break;
        end
    end
    print("hjjlog>>redpacket1111111：",l_resdata.redpacket);

    bp_set_self_redpacket(l_resdata.redpacket)
    bp_update_user_data(0)

end





return UIExchangeRedpack