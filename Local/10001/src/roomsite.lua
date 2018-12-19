local RoomSite=class("RoomSite",function() return ccui.Layout:create() end);
require "bptools/control_tools"
local g_path=BPRESOURCE("res/scene_room/roomitem/")
local RoomItem=require("src/ui_roomitem")
local UIPrivateCenter=require("src/ui_privatecenter")

function RoomSite:ctor()
    self.the_size=nil;
    self._int_site_id=0;
    self.ptr_item_bg=nil
    self._list_site_top={}
    self._list_site_item={}
    self._btn_top_site=nil;
    self:init();
end
function RoomSite:destory()
end

function RoomSite:init()
    local  the_size=CCDirector:getInstance():getVisibleSize();
    self.the_size=the_size;
    self:setContentSize(the_size);

    local l_site_bg=control_tools.newImg({path=g_path.."roomitembg.png"})
    l_site_bg:setPosition(cc.p(self.the_size.width/2,300))
    self:addChild(l_site_bg)

    self.ptr_item_bg=control_tools.newImg({path=g_path.."kong.png",size=cc.size(815,362)})
    l_site_bg:addChild(self.ptr_item_bg)
    self.ptr_item_bg:setPosition(cc.p(815/2,352/2))

    for i=1,3 do 
        local l_table={}
        l_table.btn=control_tools.newBtn({normal=g_path.."site_top_item_2.png",pressed=g_path.."site_top_item_1.png"});
        l_table.btn:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_top_site(param_sender,param_touchType) end)
        l_table.btn.id=0;
        l_table.name=control_tools.newLabel({fnt=g_path.."num_fjlb_biaoti.fnt"});
        l_table.name:setPosition(cc.p(220/2,60/2))
        l_table.btn:addChild(l_table.name)
        l_site_bg:addChild(l_table.btn)
        l_table.btn:setPosition(cc.p(110+(i-1)*220,362+30))
        table.insert( self._list_site_top, l_table)
    end

    for i=1,6 do 
        local l_room_item=RoomItem:create();
        self.ptr_item_bg:addChild(l_room_item);
        l_room_item:setScale9Enabled(true)
		l_room_item:setContentSize(cc.size(266,180))
        l_room_item:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_site_item(param_sender,param_touchType) end)
        table.insert( self._list_site_item, l_room_item)
    end

end

function RoomSite:show_game_site(param_game_id,param_sub_id)
    local l_sub_id=0
    if param_sub_id~=nil then
        l_sub_id=param_sub_id;
    end

    local l_config_game=json.decode(bp_get_game_list())
    local l_site_data=nil;
    for k,v in pairs(l_config_game) do 
        if v.id==param_game_id then 
            l_site_data=v;
        end
    end
    self:clear_room();

    for k,v in pairs(l_site_data.list) do 
        if k>3 then 
            return ;
        end
        if l_sub_id==0 then 
            l_sub_id=v;
        end
        local l_game_data=json.decode(bp_get_game_data(v));
        self._list_site_top[k].name:setString(l_game_data.name);
        self._list_site_top[k].btn.id=v;
        self._list_site_top[k].btn:setVisible(true);    
    end

    for k,v in pairs(self._list_site_top) do 
        v.btn:setBright(true)
        v.btn:setTouchEnabled(true)   
        if v.btn.id == l_sub_id then 
            v.btn:setBright(false)
            v.btn:setTouchEnabled(true)
        end
    end
    self:on_switch_item(l_sub_id)
end


function RoomSite:on_btn_top_site(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("hjjlog>>on_btn_top_site",param_sender.id);    
    for k,v in pairs(self._list_site_top) do 
        v.btn:setBright(true)
        v.btn:setTouchEnabled(true)   
    end
    self._int_site_id=param_sender.id
    param_sender:setBright(false)
    param_sender:setTouchEnabled(false);
    
    local l_ac_fadeout_1=cc.FadeOut:create(0.2)
    local l_ac_fun_1=cc.CallFunc:create(function(param_sender) self:on_switch_item(self._int_site_id)  end)
    local l_ac_fadein_1=cc.FadeIn:create(0.2)
    self.ptr_item_bg:runAction(cc.Sequence:create(l_ac_fadeout_1,l_ac_fun_1,l_ac_fadein_1))
end

function RoomSite:on_btn_site_item(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    --[[
   {
      "address" : "demo.bookse.cn",
      "chaircount" : 5,
      "gameid" : 207,
      "id" : 20741,
      "kind" : 48,
      "limit" : [
         {
            "id" : 4,
            "value" : 100000
         }
      ],
      "mode" : 1,
      "name" : "大师场",
      "port" : 20741,
      "roomid" : 401,
      "rule" : "level=3;caption=\"防作弊场 10万以上\";caption_ex=\"大师对决场\";gift=\"1000,2000,5000,1000,2000\";",
      "tablecount" : 200
   }
    ]]--
    print("hjjlog>>on_Btn_site_item",json.encode(param_sender.the_site_data));
    local param_site_data=param_sender.the_site_data
    --好友房
    local l_type=(param_site_data.roomid-param_site_data.roomid%100)/100
    if l_type==5 then 
        UIPrivateCenter.ShowPrivateCenter(true,param_site_data.gameid);
        return ;
    end
    --普通房间
    local event = cc.EventCustom:new("MSG_DO_TASK");
    event.command = "enter:"..(param_site_data.gameid*1000+param_site_data.roomid)
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

function RoomSite:on_switch_item(param_id)
    for k,v in pairs(self._list_site_item) do 
        v:setVisible(false)
    end

    local l_room_data=json.decode(bp_get_room_data_by_gameid(param_id))
    local l_list_site={}
    --遍历金豆场
    --普通场
    for k,v in pairs(l_room_data) do 
        local l_site_type= (v.roomid-v.roomid%100)/100;
        if l_site_type<=6 then   
            self._list_site_item[l_site_type]:set_site_data(v)
            
            if self._list_site_item[l_site_type]:isVisible()==false then 
                table.insert( l_list_site,self._list_site_item[l_site_type] )
            end
            self._list_site_item[l_site_type]:setVisible(true);
        end
    end
    local l_x=14+266/2;
    local l_y=300-30
    for k,v in pairs(l_list_site) do 
        v:setVisible(true)
        v:setPosition(cc.p(l_x,l_y))
        l_x=l_x+4+266
        if k==3 then 
            l_x=14+266/2
            l_y=90;
        end
    end
    
end
function RoomSite:clear_room()
    for k,v in pairs(self._list_site_top) do   
        v.btn:setVisible(false)
    end
    for k,v in pairs(self._list_site_item) do 
        v:setVisible(false)
    end
end




return RoomSite