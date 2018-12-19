local UIShopProp=class("UIShopProp",function() return ccui.Layout:create() end)
local g_path=BPRESOURCE("res/props/")
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

        local l_img_desc_bg=control_tools.newImg({path=g_path.."img_desc_bg.png"})
        l_item_bg:addChild(l_img_desc_bg)
        l_img_desc_bg:setPosition(cc.p(143,130))
        l_item.bgdesc=l_img_desc_bg;
        local l_label_desc=control_tools.newLabel({font=16,anchor=cc.p(0,0.5)})
        l_img_desc_bg:addChild(l_label_desc)
        l_label_desc:setPosition(cc.p(12,30))
        l_item.labledesc=l_label_desc;
        local l_item_btn_bg=control_tools.newImg({path=g_path.."btn_prop.png"})
        l_item_bg:addChild(l_item_btn_bg)
        l_item_btn_bg:setPosition(cc.p(100,35))
        local l_item_count=control_tools.newLabel({fnt=g_path.."number_zhangbao.fnt"});
        l_item_bg:addChild(l_item_count)
        l_item_count:setPosition(cc.p(100,35))
        l_item.price=l_item_count
        table.insert(self.list_item,l_item)
        return l_item;
    end
end

function UIShopProp:update_layout()
    local l_product_table=PROPS
    
    for k,v in pairs(l_product_table) do
        local l_item=self:get_a_gold_item();
        l_item.bg:setVisible(true)
        l_item.prop.id=v.id
        l_item.prop.cnt=v.prop_count
        l_item.prop.price=v.fund_price
        l_item.name:setString(v.prop_name);
        l_item.prop:loadTextures(g_path.."prop_"..v.id..".png",g_path.."prop_"..v.id..".png")
        l_item.price:setString(v.fund_price)
        if v.fund_desc==""then 
            l_item.bgdesc:setVisible(false)
        else 
            l_item.bgdesc:setVisible(true)
            l_item.labledesc:setString(v.fund_desc)
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
        v.bg:setVisible(true);
        v.bg:setPosition(float_pos_x,float_pos_y)
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
    UIPropsDetail.ShowPropsDetail(param_sender.id,param_sender.cnt,param_sender.price,1,function(param_id,param_value) self:on_btn_use_props(param_id,param_value) end)
 end


return UIShopProp
