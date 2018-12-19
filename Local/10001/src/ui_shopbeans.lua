local UIShopBeans=class("UIShopBeans",function() return ccui.Layout:create() end)
local UIShopItem=require("src/ui_shopitem")
local g_path=BPRESOURCE("res/usercenter/")
require("bptools/class_tools")
function UIShopBeans:ctor()
   print("hjjlog>>UIShopBeans")
   self.list_item={}
   self.list_item_sleep={};
   self:init();

end
function UIShopBeans:destory()
end


function UIShopBeans:init()

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

function UIShopBeans:clear_item()
    for k,v in pairs(self.list_item) do
        v:setVisible(false)
        table.insert( self.list_item_sleep,v ) 
    end
    self.list_item={};
end

function UIShopBeans:get_a_gold_item()
    if #self.list_item_sleep >0 then 
        local l_item=self.list_item_sleep[#self.list_item_sleep]
        table.remove( self.list_item_sleep,#self.list_item_sleep )
        table.insert( self.list_item,l_item )
        return l_item;
    else 
        local l_item=UIShopItem:create();
        self.ptr_scrollview:addChild(l_item);
        table.insert( self.list_item,l_item)
        return l_item
    end
end

function UIShopBeans:update_layout()
    local l_product_table=json.decode(bp_get_product_data())
    --print("hjjlog>>UIShopBeans：",bp_get_product_data());
    for k,v in pairs(l_product_table) do
        if v.type==6 then 
            local l_item=self:get_a_gold_item();
            l_item:setVisible(true)
            l_item:set_item_data(v);
        end
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
        v:setVisible(true);
        v:setPosition(float_pos_x,float_pos_y)
        float_pos_x=float_pos_x+float_space_x
        if (int_index+1)%4==0 then 
            float_pos_x = float_space_x/2
            float_pos_y =float_pos_y- float_space_y;
        end
        int_index=int_index+1
    end
end


return UIShopBeans