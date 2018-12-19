local UIPrivateRoom=class("UIPrivateRoom",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/privateroom/")
require("src/class_game_auxi")
function UIPrivateRoom:ctor()
    print("hjjlog>>UIPrivateRoom")
    self.list_item_sleep={}
    self.list_item={}
    self.m_int_game_id=0;
    self:init();
end
function UIPrivateRoom:destory()
end

function UIPrivateRoom:init()
    local   l_lister= cc.EventListenerCustom:create("BACK_AUXI_RESULT", function (eventCustom)
        self:on_back_auxi_result(eventCustom);
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    self.the_size=cc.size(735,400);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size}) 
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

    
    self.ptr_scrollview=ccui.ScrollView:create();
    self:addChild(self.ptr_scrollview);
    self.ptr_scrollview:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview:setContentSize(cc.size(self.the_size.width,self.the_size.height))
    self.ptr_scrollview:setScrollBarAutoHideEnabled(false)

    self.ptr_btn_create_room=control_tools.newBtn({normal=g_path.."btn_create_room.png",pressed=g_path.."btn_create_room.png"})
    self:addChild(self.ptr_btn_create_room)
    self.ptr_btn_create_room:setPosition(cc.p(self.the_size.width/2,230))
    self.ptr_btn_create_room:setVisible(false)
    self.ptr_btn_create_room:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_create_room(param_sender,param_touchType) end)

end
function UIPrivateRoom:set_game_id(param_id)
    self.m_int_game_id=param_id
end
function UIPrivateRoom:clear_item()
    for k,v in pairs(self.list_item) do
        v.ptr_bg:setVisible(false)
        table.insert( self.list_item_sleep,v ) 
    end
    self.list_item={};
end

function UIPrivateRoom:get_a_item(param_table)
    local l_item={}
    if #self.list_item_sleep >0 then 
        l_item=self.list_item_sleep[#self.list_item_sleep]
        table.remove( self.list_item_sleep,#self.list_item_sleep )
        table.insert( self.list_item,l_item )
    else 
        local item_bg=control_tools.newImg({path=g_path.."bg_myroom.png"})
        self.ptr_scrollview:addChild(item_bg)
        l_item.ptr_bg=item_bg;

        local l_img_room_id=control_tools.newImg({path=g_path.."img_room_id.png"})
        item_bg:addChild(l_img_room_id)
        l_img_room_id:setPosition(cc.p(85,75))

        local l_img_label_bg=control_tools.newImg({path=g_path.."img_label_bg.png"})
        item_bg:addChild(l_img_label_bg)
        l_img_label_bg:setPosition(cc.p(85,40))

        local l_lable_room_id=control_tools.newLabel({font=26,color=cc.c3b(255,247,225)})
        item_bg:addChild(l_lable_room_id)
        l_lable_room_id:setPosition(cc.p(85,40))
        l_item.ptr_label_room_id=l_lable_room_id;

        local l_img_room_name=control_tools.newImg({path=g_path.."img_room_name.png"})
        item_bg:addChild(l_img_room_name)
        l_img_room_name:setPosition(cc.p(240,75))

        l_img_label_bg=control_tools.newImg({path=g_path.."img_label_bg.png"})
        item_bg:addChild(l_img_label_bg)
        l_img_label_bg:setPosition(cc.p(240,40))

        local l_lable_room_name=control_tools.newLabel({font=26,color=cc.c3b(255,247,225)})
        item_bg:addChild(l_lable_room_name)
        l_lable_room_name:setPosition(cc.p(240,40))
        l_item.ptr_label_room_name=l_lable_room_name;

        local l_img_room_type=control_tools.newImg({path=g_path.."img_room_type.png"})
        item_bg:addChild(l_img_room_type)
        l_img_room_type:setPosition(cc.p(400,75))

        l_img_label_bg=control_tools.newImg({path=g_path.."img_label_bg.png"})
        item_bg:addChild(l_img_label_bg)
        l_img_label_bg:setPosition(cc.p(400,40))

        local l_lable_room_type=control_tools.newLabel({font=26,color=cc.c3b(255,247,225)})
        item_bg:addChild(l_lable_room_type)
        l_lable_room_type:setPosition(cc.p(400,40))
        l_item.ptr_label_room_type=l_lable_room_type;

        local l_btn_enter=control_tools.newBtn({normal=g_path.."btn_enter.png",small=true})
        item_bg:addChild(l_btn_enter)
        l_btn_enter:setPosition(cc.p(545,60))
        l_btn_enter:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_enter(param_sender,param_touchType) end)
        l_item.ptr_btn_enter=l_btn_enter;

        local l_btn_dismiss=control_tools.newBtn({normal=g_path.."btn_dismiss.png",small=true})
        item_bg:addChild(l_btn_dismiss)
        l_btn_dismiss:setPosition(cc.p(650,60))
        l_btn_dismiss:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_dismiss(param_sender,param_touchType) end)
        l_item.ptr_btn_dismiss=l_btn_dismiss;

        table.insert( self.list_item,l_item)
    end
    self:update_item(l_item,param_table)

    return l_item
end
function UIPrivateRoom:update_item(param_item,param_table)
    param_item.ptr_bg:setVisible(true);
    if param_table.code~=nil then 
        param_item.ptr_label_room_id:setString(param_table.code)
    end
    if param_table.tallyname~=nil then 
        param_item.ptr_label_room_type:setString(param_table.tallyname)
    end
    param_item.table_data=param_table;
    param_item.ptr_btn_enter.table_data=param_table;
    param_item.ptr_btn_dismiss.table_data=param_table;
    if bp_get_game_data(param_table.gameid)~="" then 
        local l_game_data=json.decode(bp_get_game_data(param_table.gameid))
        param_item.ptr_label_room_name:setString(l_game_data.name)
    else
        print("hjjlog>>skfjdlfjalsjdflkj");
        
    end
end

function UIPrivateRoom:on_btn_enter(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    get_share_game_auxi():enter_private_room(param_sender.table_data.code)
end
function UIPrivateRoom:on_btn_dismiss(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    get_share_game_auxi():dismiss_private_room(param_sender.table_data.code); 
end
function UIPrivateRoom:on_btn_create_room(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    local UIPrivateCenter=require("src/ui_privatecenter")
    UIPrivateCenter.GetPrivateCenter():switch_item(0)
end 

function UIPrivateRoom:request_private_room()
    get_share_game_auxi():select_private_room(); 
end
function UIPrivateRoom:on_back_auxi_result(param_result)
    if param_result.tag==3 then 
        self:request_private_room()
    elseif param_result.tag==4 then 
        bp_show_hinting((param_result.message))
    elseif param_result.tag==7 then 
        local l_data=param_result.value;
        self:update_private_room(l_data)
    elseif param_result.tag==8 then 
        bp_show_hinting((param_result.value.message))
    end
end

function UIPrivateRoom:update_private_room(param_data)
    self:clear_item();
    for k,v in pairs(param_data) do
        local l_item=self:get_a_item(v)
    end
    if #self.list_item==0 then 
        self.ptr_btn_create_room:setVisible(true)
    else
        self.ptr_btn_create_room:setVisible(false)
    end

    local int_line_count=#self.list_item
    local the_scrollview_size=cc.size(self.ptr_scrollview:getContentSize().width,110*int_line_count)

    if the_scrollview_size.height< self.ptr_scrollview:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview:getContentSize().height
    end
    self.ptr_scrollview:setInnerContainerSize(the_scrollview_size)

    local l_y=the_scrollview_size.height-110/2
    for k,v in pairs(self.list_item) do
        v.ptr_bg:setPosition(cc.p(735/2,l_y))
        l_y=l_y-110
    end
end







return UIPrivateRoom