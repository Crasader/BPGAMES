local UIPrivateCreate=class("UIPrivateCreate",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/privateroom/")
require("src/class_game_auxi")

function UIPrivateCreate:ctor()
    print("hjjlog>>UIPrivateCreate")
    self.m_int_type=0
    self.m_int_count_index=0;
    self.m_int_game_id=0;
    self:init();
end
function UIPrivateCreate:destory()
end

function UIPrivateCreate:init()
    local   l_lister= cc.EventListenerCustom:create("BACK_AUXI_RESULT", function (eventCustom)
        self:on_back_auxi_result(eventCustom);
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    self.the_size=cc.size(735,400);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);
    

    local l_img_type=control_tools.newImg({path=g_path.."tip_type.png"})
    self:addChild(l_img_type)
    l_img_type:setPosition(cc.p(100,360))

    self.ptr_type={}
    self.ptr_type[1]=self:get_check_item();
    self.ptr_type[1]:setPosition(cc.p(170,360))
    self.ptr_type[1]:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_geme_type(param_sender,param_touchType) end)

    self.ptr_type[2]=self:get_check_item();
    self.ptr_type[2]:setPosition(cc.p(430,360))
    self.ptr_type[2]:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_geme_type(param_sender,param_touchType) end)
    

    local l_img_count=control_tools.newImg({path=g_path.."tip_count.png"})
    self:addChild(l_img_count)
    l_img_count:setPosition(cc.p(100,285))

    self.ptr_game_count={}
    local l_x=170;
    local l_y=285
    for i=1,4 do
       self.ptr_game_count[i]=self:get_check_item();
       self.ptr_game_count[i].id=i; 
       self.ptr_game_count[i]:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_game_count(param_sender,param_touchType) end)
       self.ptr_game_count[i]:setPosition(cc.p(l_x,l_y))
       
       l_x=l_x+230
       if i==2 then 
            l_x=170
            l_y=230
       end 
    end


    local l_img_desc=control_tools.newImg({path=g_path.."tip_desc.png"})
    self:addChild(l_img_desc)
    l_img_desc:setPosition(cc.p(100,170))

    self.ptr_label_desc=control_tools.newLabel({ex=true,font=26,color=cc.c3b(208,103,46),anchor=cc.p(0,1)})
    self:addChild(self.ptr_label_desc)
    self.ptr_label_desc:setPosition(cc.p(150,165))


    local l_label_hint=control_tools.newLabel({font=20,color=cc.c3b(194,160,119)})
    self:addChild(l_label_hint)
    l_label_hint:setPosition(cc.p(735/2,100))

    self.ptr_btn_create=control_tools.newBtn({normal=g_path.."btn_create.png",small=true})
    self:addChild(self.ptr_btn_create)
    self.ptr_btn_create:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_create_room(param_sender,param_touchType) end)
    self.ptr_btn_create:setPosition(cc.p(735/2,40))


end
function UIPrivateCreate:set_friendsite_data(param_game_id)
    self.m_int_game_id=param_game_id
    local l_site_data=json.decode(bp_get_friendsite_data(param_game_id))
    print("hjjlog>>set_friendsite_data:",bp_get_friendsite_data(param_game_id));


    local l_count=0;
    self.ptr_type[1].tabel_data=nil
    self.ptr_type[2].table_data=nil;
    for k,v in pairs(l_site_data.items) do
        if  l_count>=2 then 
            break;
        end
        self.ptr_type[k].table_data=v;
        self.ptr_type[k].ptr_label:setString(v.name);
    end   
    self:deal_game_type(self.ptr_type[1])
    self.m_int_type=self.ptr_type[1].table_data.kind
end


function UIPrivateCreate:get_check_item()

    local l_btn=control_tools.newBtn({normal=g_path.."test_green.png",pressed=g_path.."test_green.png",size=cc.size(220,40),anchor=cc.p(0,0.5)})
    self:addChild(l_btn)

    local l_img_check=control_tools.newImg({path=g_path.."img_check_1.png"})
    l_btn:addChild(l_img_check)
    l_img_check:setPosition(cc.p(15,20))
    l_btn.ptr_check=l_img_check;

    local l_label_count=control_tools.newLabel({font=26,color=cc.c3b(170,91,59),anchor=cc.p(0,0.5)})
    l_btn:addChild(l_label_count)
    l_label_count:setPosition(cc.p(40,20))
    l_btn.ptr_label=l_label_count;

    return l_btn
end
function UIPrivateCreate:set_check_type(param_item,parma_type)
    if parma_type==true then 
        param_item.ptr_check:loadTexture(g_path.."img_check_2.png")
        param_item.ptr_label:setTextColor(cc.c3b(237,9,9))
    else
        param_item.ptr_check:loadTexture(g_path.."img_check_1.png")
        param_item.ptr_label:setTextColor(cc.c3b(170,91,59))
    end
end

function UIPrivateCreate:deal_game_type(param_sender)
    self:set_check_type(param_sender,true)
    local the_data=param_sender.table_data; 
    self.m_int_count_index=the_data.kind
    self.ptr_label_desc:setTextEx(the_data.describe,500,3)

    for k,v in pairs(self.ptr_game_count) do
        self:set_check_type(v,false)
    end
    for k,v in pairs(the_data.items) do
        if k>4 then 
            break;
        end
        self.ptr_game_count[k].data=v;
        self.ptr_game_count[k].ptr_label:setString(v.describe)
        self.ptr_game_count[k]:setVisible(true)
    end

    self:set_check_type(self.ptr_game_count[1],true)
    self.m_int_count_index=self.ptr_game_count[1].data.id;
end
function UIPrivateCreate:on_btn_geme_type(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    self:set_check_type(self.ptr_type[1],false)
    self:set_check_type(self.ptr_type[2],false)

    self.m_int_type=param_sender.table_data.kind
    self:deal_game_type(param_sender)
end



function UIPrivateCreate:on_btn_game_count(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    for k,v in pairs(self.ptr_game_count) do
        self:set_check_type(v,false)
    end
    self:set_check_type(param_sender,true)
    self.m_int_count_index=param_sender.data.id;
end

function UIPrivateCreate:on_btn_create_room(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    get_share_game_auxi():create_private_room(self.m_int_game_id,self.m_int_type,self.m_int_count_index)
end
function UIPrivateCreate:on_back_auxi_result(param_result)
    print("hjjlog>>on_back_auxi_result:",json.encode(param_result.value));
    if param_result.tag==1 then 
        local event = cc.EventCustom:new("MSG_DO_TASK");
        event.command = "enter_private_room:"..param_result.value.gameid*1000+param_result.value.roomid.."|"..param_result.value.code
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
    elseif param_result.tag==2 then  
        bp_show_hinting((param_result.value.message))
    end


end




return UIPrivateCreate