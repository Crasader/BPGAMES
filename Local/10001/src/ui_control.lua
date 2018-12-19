local UIControl=class("UIControl",function() return ccui.Layout:create() end)
local g_path=BPRESOURCE("res/popup/")
function UIControl:ctor(param_self)
    if param_self~=nil then 
        self=param_self;
    end
    print("hjjlog>>UIControl")
    self.ptr_bg=nil;
    self.the_size=nil;
    self.ptr_gui=nil;
    self.ptr_close=nil;
    self.bool_action=false
    self.list_item_and_layout={}--{btn=BTN,btn.id=ID,layout=LAYOUT}
    self.ptr_img_choose=nil;
    self.ptr_img_title=nil;
    self.ptr_img_title_name=nil;

    self:init_control();
end
function UIControl:destory()

end


function UIControl:init_control()
    local  the_size=CCDirector:getInstance():getVisibleSize();
    self.the_size=the_size;
    
    self.ptr_bg=control_tools.newImg({path=BPRESOURCE("res/mask.png"),size=self.the_size})
    self:addChild(self.ptr_bg)
    self.ptr_bg:setPosition(cc.p(self.the_size.width/2,the_size.height/2))
    self.ptr_bg:setTouchEnabled(true)
    self.ptr_bg:setVisible(false);
    
    self.ptr_gui=control_tools.newImg({path=g_path.."gui.png"})
    self.ptr_gui:setPosition(cc.p(the_size.width/2,the_size.height/2))
    self:addChild(self.ptr_gui)
    local the_bg_size=self.ptr_gui:getContentSize()
    self.ptr_gui:setVisible(false)

    self.ptr_close=control_tools.newBtn({normal=g_path.."close.png",small=true})
    self.ptr_close:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_close(param_sender,param_touchType) end)
    self.ptr_gui:addChild(self.ptr_close);
    self.ptr_close:setPosition(cc.p(the_bg_size.width-10,the_bg_size.height-10))
    self.ptr_close:setLocalZOrder(100)

    self.ptr_img_choose=control_tools.newImg({path=g_path.."uitabtop_3.png"})
    self.ptr_gui:addChild(self.ptr_img_choose)
    self.ptr_img_choose:setPosition(cc.p(the_bg_size.width/2,the_bg_size.height-10))

    self.ptr_img_title=control_tools.newImg({path=g_path.."titlebg.png"})
    self.ptr_gui:addChild(self.ptr_img_title)
    self.ptr_img_title:setPosition(cc.p(the_bg_size.width/2,the_bg_size.height-10))

    self.ptr_img_title_name=control_tools.newImg({})
    self.ptr_img_title:addChild(self.ptr_img_title_name)
    self.ptr_img_title_name:setPosition(cc.p(278/2,56/2))
end

function UIControl:on_btn_close(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self:ShowGui(false)
end

function UIControl:ShowGui(param_bool)
    if param_bool==nil then 
        param_bool=true;
    end
    if param_bool==true then 
        self:open_popups()
    else 
        self:close_popus()
    end
end

function UIControl:open_popups()
    if self.bool_action==true then 
        return 
    end
    self:setLocalZOrder(bp_identifier())
    self.bool_action=true;
    self.ptr_gui:setScale(0)
    self.ptr_gui:setVisible(true)
    self.ptr_bg:setVisible(true);
    local l_ac_scale_1=cc.ScaleTo:create(0.1,1)
    local l_ac_fun_1=cc.CallFunc:create(function() self:on_open_finish() end)
    self.ptr_gui:runAction(cc.Sequence:create(l_ac_scale_1,l_ac_fun_1))
end
function UIControl:close_popus()
    if self.bool_action==true then 
        return ;
    end
    self.bool_action=true;
    local l_ac_scale_1=cc.ScaleTo:create(0.05,1.1)
    local l_ac_scale_2=cc.ScaleTo:create(0.1,0)
    local l_ac_fun_1=cc.CallFunc:create(function() self:on_close_finish() end)
    self.ptr_gui:runAction(cc.Sequence:create(l_ac_scale_1,l_ac_scale_2,l_ac_fun_1))
end
function UIControl:on_open_finish()
    self.bool_action=false
end
function UIControl:on_close_finish()
    self.bool_action=false
    self.ptr_bg:setVisible(false)
end
--就一个的情况下 用这个
function UIControl:set_item(param_str_file,param_layer)
    self.ptr_img_choose:setVisible(false)
    self.ptr_img_title:setVisible(true)
    self.ptr_img_title_name:loadTexture(param_str_file);
    self.ptr_gui:addChild(param_layer)
    local l_bg_size=self.ptr_gui:getContentSize();
    local l_layout_size=param_layer:getContentSize();
    param_layer:setPosition(cc.p(l_bg_size.width/2-l_layout_size.width/2,35))
end
function UIControl:set_title(param_str_file)
    self.ptr_img_choose:setVisible(false)
    self.ptr_img_title:setVisible(true)
    self.ptr_img_title_name:loadTexture(param_str_file);
end
function UIControl:get_gui()
    return self.ptr_gui;
end
--有多个的情况下
function UIControl:insert_item(param_int_item,param_str_file,param_str_bright,param_layer,param_x,param_y)
    if param_x==nil then 
        param_x=0
    end
    if param_y==nil then 
        param_y=0
    end

    local l_item_btn_and_layout={}
    local l_btn_item=control_tools.newBtn({normal=param_str_file,pressed=param_str_bright})
    self.ptr_img_choose:addChild(l_btn_item);
    l_btn_item:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_item(param_sender,param_touchType)  end)
    l_btn_item.id=param_int_item;
    l_item_btn_and_layout.btn=l_btn_item;
    l_item_btn_and_layout.layout=param_layer;
    self.ptr_gui:addChild(param_layer)
    param_layer:setVisible(false)
    local l_layout_size=param_layer:getContentSize();
    local l_bg_size=self.ptr_gui:getContentSize();
    param_layer:setPosition(cc.p(l_bg_size.width/2-l_layout_size.width/2+param_x,23+param_y))

    table.insert(self.list_item_and_layout,l_item_btn_and_layout)
end
function UIControl:update_layout()    
    self.ptr_img_choose:setVisible(true)
    self.ptr_img_title:setVisible(false)

    if #self.list_item_and_layout==1 then 
        self.ptr_img_choose:loadTexture(g_path.."uitabtop_1.png")
    elseif #self.list_item_and_layout==2 then 
        self.ptr_img_choose:loadTexture(g_path.."uitabtop_2.png")
    elseif #self.list_item_and_layout==3 then 
        self.ptr_img_choose:loadTexture(g_path.."uitabtop_3.png")
    elseif #self.list_item_and_layout==4 then 
        self.ptr_img_choose:loadTexture(g_path.."uitabtop_4.png")
    end
    
    local l_x=182/2+10
    local l_space_x=182
    for k,v in pairs(self.list_item_and_layout) do 
        v.btn:setPosition(cc.p(l_x,32)) 
        l_x=l_x+l_space_x;
    end
    if #self.list_item_and_layout>0 then 
        self:switch_item(self.list_item_and_layout[1].btn.id)
    end
end
function UIControl:set_bg(param_str_file)
    self.ptr_gui:loadTexture(param_str_file)
    local the_bg_size=self.ptr_gui:getContentSize()
    self.ptr_close:setPosition(cc.p(the_bg_size.width-10,the_bg_size.height-10))
    self.ptr_img_choose:setPosition(cc.p(the_bg_size.width/2,the_bg_size.height-7))
    self.ptr_img_title:setPosition(cc.p(the_bg_size.width/2,the_bg_size.height+14))
end

function UIControl:switch_item(param_int_item)
    local l_bool_find=false;
    for k,v in pairs(self.list_item_and_layout) do 
        if param_int_item==v.btn.id then 
            v.btn:setBright(false)
            v.layout:setVisible(true)
            l_bool_find=true;
        else
            v.btn:setBright(true)
            v.layout:setVisible(false)
        end
    end
    if l_bool_find==false then 
        if #self.list_item_and_layout>0 then 
            self.list_item_and_layout.btn:setBright(false)
            self.list_item_and_layout.layout:setVisible(true)
        end
    end
end
function UIControl:on_btn_item(param_sender,param_touchType)
   if param_touchType~=_G.TOUCH_EVENT_ENDED then
       return 
   end
   self:switch_item(param_sender.id)
   self:on_back_switch_item(param_sender.id)
   
end
function UIControl:on_back_switch_item(param_id)

end


return UIControl