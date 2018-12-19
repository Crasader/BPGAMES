local class_game_auxi=class("class_game_auxi");
require("src/class_struct_auxi")
sptr_private_connect=nil

local  PRI_ROOM_TYPE_CREATE =0 
local  PRI_ROOM_TYPE_ENTER =1
local  PRI_ROOM_TYPE_DISMISS =2
local  PRI_ROOM_TYPE_SELECT =3
local  CODE_PRI_ROOM_CONNECT_FAIL =1


function class_game_auxi:ctor()
    self._the_auxi_socket=nil;
    self._socket_index=nil;
    self.m_int_dismiss_code=0;
    self._privater_room_type=-1;
    --
    self.m_int_enter_game_id=0
    self.m_int_enter_room_id=0;
    self.m_private_code="";--创建房间成功。


    --创建房间。
    self.m_int_game_id=nil
    self.m_int_item_index=nil
    self.m_int_base_index=nil
    --
    self.m_str_dismiss_code=""
    

end
function class_game_auxi:close_socket()
    if self._the_auxi_socket ~=nil then
        bp_socket_release(self._the_auxi_socket)
        self._the_auxi_socket=nil;
        self._socket_index=nil;
    end
end
function class_game_auxi:enter_private_room(param_code)
    self.m_str_enter_code=param_code;
    self._privater_room_type=PRI_ROOM_TYPE_ENTER;

    if self._the_auxi_socket ~=nil then
        bp_socket_release(self._the_auxi_socket)
        self._the_auxi_socket=nil;
        self._socket_index=nil;
    end
    self._the_auxi_socket= bp_socket_create(function(index, code) self:on_socket_connect(index, code) end, 
                                            function(index, mainid, subid, data) self:on_socket_receive(index, mainid, subid, data) end, 
                                            function(index, code) self:on_socket_close(index, code) end)                               
    bp_socket_connect(self._the_auxi_socket, bp_get_auxi_address(), 9003);
end

function class_game_auxi:create_private_room(param_game_id,parma_game_type,param_base_id)
    self.m_int_game_id=param_game_id;
    self.m_int_item_index=parma_game_type;
    self.m_int_base_index=param_base_id;
    
    self._privater_room_type=PRI_ROOM_TYPE_CREATE;

    if self._the_auxi_socket ~=nil then
        bp_socket_release(self._the_auxi_socket)
        self._the_auxi_socket=nil;
        self._socket_index=nil;
    end

    self._the_auxi_socket= bp_socket_create(function(index, code) self:on_socket_connect(index, code) end, 
                                            function(index, mainid, subid, data) self:on_socket_receive(index, mainid, subid, data) end, 
                                            function(index, code) self:on_socket_close(index, code) end)                               
    bp_socket_connect(self._the_auxi_socket, bp_get_auxi_address(), 9003);
    --bp_socket_connect(self._the_auxi_socket, "192.168.1.141", 9003);

    print("hjjlog>>bp_get_auxi_address:",bp_get_auxi_address());
    

end
function class_game_auxi:select_private_room()
    
    self._privater_room_type=PRI_ROOM_TYPE_SELECT;

    if self._the_auxi_socket ~=nil then
        bp_socket_release(self._the_auxi_socket)
        self._the_auxi_socket=nil;
        self._socket_index=nil;
    end

    self._the_auxi_socket= bp_socket_create(function(index, code) self:on_socket_connect(index, code) end, 
                                            function(index, mainid, subid, data) self:on_socket_receive(index, mainid, subid, data) end, 
                                            function(index, code) self:on_socket_close(index, code) end)                               
    bp_socket_connect(self._the_auxi_socket, bp_get_auxi_address(), 9003);
end
function class_game_auxi:dismiss_private_room(param_code)
    self.m_str_dismiss_code=param_code
    self._privater_room_type=PRI_ROOM_TYPE_DISMISS;
    if self._the_auxi_socket ~=nil then
        bp_socket_release(self._the_auxi_socket)
        self._the_auxi_socket=nil;
        self._socket_index=nil;
    end

    self._the_auxi_socket= bp_socket_create(function(index, code) self:on_socket_connect(index, code) end, 
                                            function(index, mainid, subid, data) self:on_socket_receive(index, mainid, subid, data) end, 
                                            function(index, code) self:on_socket_close(index, code) end)                               
    bp_socket_connect(self._the_auxi_socket, bp_get_auxi_address(), 9003);
end



function class_game_auxi:on_socket_connect(index, code)
    print("hjjlog>>push_socket_connect:",index,code);
    self._socket_index=index;
    if code==0 then 
        
        
        local self_data=json.decode(bp_get_self_user_data())
        if self._privater_room_type==PRI_ROOM_TYPE_CREATE then 
            local the_data={};
            the_data.base={}
            the_data.base.clienttype=2
            the_data.base.area=bp_get_areaid();
            the_data.base.channel=bp_get_channelid();
            the_data.base.app=bp_get_appid();
            the_data.base.version=bp_get_version();
            the_data.base.package=bp_get_packageid();
            the_data.base.keyword=bp_get_keyword();

            the_data.userid=self_data.userid
            the_data.session=self_data.session
            the_data.mac=bp_mac();
            the_data.gameid=self.m_int_game_id
            the_data.ruleitem=self.m_int_base_index
            the_data.tallykind=self.m_int_item_index;
            print("hjjlog>>CMD_AUXI_CREATE_TABLE:",json.encode(the_data));
            local buffer=CMD_AUXI_CREATE_TABLE.toBuffer(the_data);
            bp_pack_check();            
            print("hjjlog>>bp_socket_send_data:",MDM_AUXI,SUB_AUXI_CREATE_TABLE);
            
            local bool_send=bp_socket_send_data(self._socket_index, MDM_AUXI, SUB_AUXI_CREATE_TABLE, buffer);   

        elseif self._privater_room_type==PRI_ROOM_TYPE_ENTER then 
            local the_data={}
            the_data.base={}
            the_data.base.clienttype=2
            the_data.base.area=bp_get_areaid();
            the_data.base.channel=bp_get_channelid();
            the_data.base.app=bp_get_appid();
            the_data.base.version=bp_get_version();
            the_data.base.package=bp_get_packageid();
            the_data.base.keyword=bp_get_keyword();
            the_data.code=self.m_str_enter_code;

            local buffer=CMD_AUXI_JOIN_TABLE.toBuffer(the_data);
            bp_pack_check();
            local bool_send=bp_socket_send_data(self._socket_index, MDM_AUXI, SUB_AUXI_JOIN_TABLE, buffer);   
            print("hjjlog>>CMD_AUXI_JOIN_TABLE",bool_send);
        elseif self._privater_room_type==PRI_ROOM_TYPE_DISMISS then 
            local the_data={}
            the_data.base={}
            the_data.base.clienttype=2
            the_data.base.area=bp_get_areaid();
            the_data.base.channel=bp_get_channelid();
            the_data.base.app=bp_get_appid();
            the_data.base.version=bp_get_version();
            the_data.base.package=bp_get_packageid();
            the_data.base.keyword=bp_get_keyword();
            
            the_data.userid=self_data.userid
            the_data.session=self_data.session
            the_data.code=self.m_str_dismiss_code
            print("hjjlog>>PRI_ROOM_TYPE_DISMISS:",json.encode(the_data));
            
            local buffer=CMD_AUXI_DISMISS_TABLE.toBuffer(the_data);
            local bool_send=bp_socket_send_data(self._socket_index, MDM_AUXI, SUB_AUXI_DISMISS_TABLE, buffer);   
        elseif self._privater_room_type==PRI_ROOM_TYPE_SELECT then 
            local the_data={}
            the_data.base={}
            the_data.base.clienttype=2
            the_data.base.area=bp_get_areaid();
            the_data.base.channel=bp_get_channelid();
            the_data.base.app=bp_get_appid();
            the_data.base.version=bp_get_version();
            the_data.base.package=bp_get_packageid();
            the_data.base.keyword=bp_get_keyword();

            the_data.userid=self_data.userid
            the_data.session=self_data.session
            print("hjjlog>>CMD_AUXI_QUERY_TABLE:",json.encode(the_data));            
            local buffer=CMD_AUXI_QUERY_TABLE.toBuffer(the_data);
            bp_pack_check();    
            local bool_send=bp_socket_send_data(self._socket_index, MDM_AUXI, SUB_AUXI_QUERY_TABLE, buffer);   
        end
    else
        --hjj_for_auxi:

    end

end
function class_game_auxi:on_socket_close(index, code)
print("hjjlog>>on_socket_close:class_game_auxi");

    if self._the_auxi_socket ~=nil then
        self._the_auxi_socket=nil;
        self._socket_index=nil;
    end
 --hjj_for_auxi:

end

function class_game_auxi:on_socket_receive(index, mainCmdID, subCmdID, data) 
    local bool_ret=true
    print("hjjlog>>on_socket_receive:",mainCmdID,subCmdID);

    if mainCmdID~=MDM_AUXI then 
        return true ;
    end
    if subCmdID==SUB_AUXI_CREATE_TABLE_SUCCESS then 
        local the_table=CMD_AUXI_CREATE_TABLE_SUCCESS.fromBuffer(data)
        print("hjjlog>>用户创建房间成功2",json.encode(the_table));
        self.m_int_enter_game_id=the_table.gameid
        self.m_int_enter_room_id=the_table.roomid
        self.m_private_code=the_table.code
        self:close_socket();
        local event = cc.EventCustom:new("BACK_AUXI_RESULT");
        event.tag=1
        event.value = the_table
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
    elseif subCmdID==SUB_AUXI_CREATE_TABLE_FAIL then 
        local the_table=CMD_AUXI_CREATE_TABLE_FAIL.fromBuffer(data)
        print("hjjlog>>用户创建房间失败",the_table.flag);
        self:close_socket();
        local event = cc.EventCustom:new("BACK_AUXI_RESULT");
        event.tag=2
        event.value = the_table
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
    elseif subCmdID==SUB_AUXI_DISMISS_TABLE_SUCCESS then 
        print("hjjlog>>用户解散房间成功");
        local the_table=CMD_AUXI_DISMISS_TABLE_SUCCESS.fromBuffer(data)
        self:close_socket();
        local event = cc.EventCustom:new("BACK_AUXI_RESULT");
        event.tag=3
        event.value = the_table
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
        
    elseif subCmdID==SUB_AUXI_DISMISS_TABLE_FAIL then 
        local the_table=CMD_AUXI_DISMISS_TABLE_FAIL.fromBuffer(data)
        print("hjjlog>>用户解散房间失败",the_table.flag);
        self:close_socket();
        local event = cc.EventCustom:new("BACK_AUXI_RESULT");
        event.tag=4
        event.value = the_table
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
    elseif subCmdID==SUB_AUXI_JOIN_TABLE_SUCCESS then 
        print("hjjlog>>用户加入房间成功");
        local the_table=CMD_AUXI_JOIN_TABLE_SUCCESS.fromBuffer(data)
        self:close_socket();
        local event = cc.EventCustom:new("BACK_AUXI_RESULT");
        event.tag=5
        event.value = the_table
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)

    elseif subCmdID==SUB_AUXI_JOIN_TABLE_FAIL then 
        local the_table=CMD_AUXI_JOIN_TABLE_FAIL.fromBuffer(data)
        print("hjjlog>>用户加入房间失败",the_table.flag,the_table.message);
        print("hjjlog>>用户加入房间失败22",bp_gbk2utf( the_table.message));

        self:close_socket();
        local event = cc.EventCustom:new("BACK_AUXI_RESULT");
        event.tag=6
        event.value = the_table
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)

    elseif subCmdID==SUB_AUXI_QUERY_TABLE_SUCCESS then 
        local the_table=CMD_AUXI_QUERY_TABLE_SUCCESS.fromBuffer(data)
        print("hjjlog>>用户查询房间成功");
        self:close_socket();
        local event = cc.EventCustom:new("BACK_AUXI_RESULT");
        event.tag=7
        event.value = the_table
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
    elseif subCmdID==SUB_AUXI_QUERY_TABLE_FAIL then 
        local the_table=CMD_AUXI_QUERY_TABLE_FAIL.fromBuffer(data)
        print("hjjlog>>用户查询房间失败",the_table.flag);
        self:close_socket();
        local event = cc.EventCustom:new("BACK_AUXI_RESULT");
        event.tag=8
        event.value = the_table
        cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
    else

    end

    return true;
end



function get_share_game_auxi()
    if sptr_private_connect==nil then 
        sptr_private_connect=class_game_auxi:new()
    end
    return sptr_private_connect;

end

return class_game_auxi;