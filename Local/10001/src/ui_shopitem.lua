local UIShopItem=class("UIShopItem",function() return ccui.ImageView:create() end)
local UIPay=require("src/ui_pay")
local g_path=BPRESOURCE("res/shop/")
function UIShopItem:ctor()
   print("hjjlog>>UIShopItem")
   self.m_item_data=nil;
   self:init();
end
function UIShopItem:destory()
end


function UIShopItem:init()
    self.the_size=cc.size(200,200);
    self:setContentSize(self.the_size)
    self:setScale9Enabled(true)
    self:loadTexture(TESTCOLOR.g)

    local l_item_bg=control_tools.newImg({path=g_path.."item_back.png"})
    self:addChild(l_item_bg)
    l_item_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    l_item_bg:setTouchEnabled(true)
    l_item_bg:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_bg(param_sender,param_touchType) end)

    self.ptr_label_name=control_tools.newLabel({font=26})
    self:addChild(self.ptr_label_name)
    self.ptr_label_name:setPosition(cc.p(100,175))

    self.ptr_img_type=control_tools.newImg({path=g_path.."item_type_1.png"})
    self:addChild(self.ptr_img_type)
    self.ptr_img_type:setPosition(cc.p(30,150))

    self.ptr_img_icon=control_tools.newImg({path=g_path.."img_gold_1.png"})
    self:addChild(self.ptr_img_icon)
    self.ptr_img_icon:setPosition(cc.p(100,100))

    self.ptr_img_desc_bg=control_tools.newImg({path=g_path.."img_desc_bg.png"})
    self:addChild(self.ptr_img_desc_bg)
    self.ptr_img_desc_bg:setPosition(cc.p(143,130))

    self.ptr_label_desc=control_tools.newLabel({font=16,anchor=cc.p(0,0.5)})
    self.ptr_img_desc_bg:addChild(self.ptr_label_desc)
    self.ptr_label_desc:setPosition(cc.p(12,30))

    self.ptr_img_price_bg=control_tools.newImg({path=g_path.."img_btn_price.png"})
    self:addChild(self.ptr_img_price_bg)
    self.ptr_img_price_bg:setPosition(cc.p(100,35))

    self.ptr_label_price=control_tools.newLabel({fnt=g_path.."number_zhangbao.fnt"});
    self.ptr_img_price_bg:addChild(self.ptr_label_price)
    self.ptr_label_price:setPosition(cc.p(170/2,70/2+3))

end
function UIShopItem:set_item_data(param_data)
    self.m_item_data=param_data;
    self.ptr_label_name:setString(param_data.name)
    self.ptr_label_price:setString(param_data.price.."元")
    
    if param_data.mask~= 0 then 
        self.ptr_img_type:setVisible(true)
        self.ptr_img_type:loadTexture(g_path.."item_type_"..param_data.mask..".png")
    else 
        self.ptr_img_type:setVisible(false)
    end

    if param_data.caption=="" then 
        self.ptr_img_desc_bg:setVisible(false)
    else
        self.ptr_img_desc_bg:setVisible(true)
        self.ptr_label_desc:setString(param_data.caption)
    end
    
    if param_data.type==1 then 
        self.ptr_img_icon:loadTexture(g_path.."img_gold_6.png")
        self.ptr_img_icon:loadTexture(g_path.."img_gold_"..param_data.icon..".png")
    elseif param_data.type==6 then 
        self.ptr_img_icon:loadTexture(g_path.."img_beans_6.png")
        self.ptr_img_icon:loadTexture(g_path.."img_beans_"..param_data.icon..".png")
    elseif param_data.type==2 then 
        self.ptr_img_icon:loadTexture(g_path.."img_ingot_6.png")
        self.ptr_img_icon:loadTexture(g_path.."img_ingot_"..param_data.icon..".png")
    end

end

function UIShopItem:on_btn_seve(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self.ptr_btn_change_name:setVisible(true)
    self.ptr_btn_save:setVisible(false)
    self.ptr_label_nickname:setVisible(true)
    self.ptr_label_sex:setVisible(true);
    self.ptr_bg_edit_nickname:setVisible(false)
    self.ptr_check_sex.boy:setVisible(false)
    self.ptr_check_sex.girl:setVisible(false)
       
 end
 function UIShopItem:on_btn_bg(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("hjjlog>>on_btn_bg");
    
    UIPay.ShowPay(self.m_item_data,true)
end


return UIShopItem