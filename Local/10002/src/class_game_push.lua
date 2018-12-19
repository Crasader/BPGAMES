local class_game_push=class("class_game_push");
ptr_game_push=nil

function class_game_push:ctor()
    self._the_push_socket=nil
    self.m_bool_ready=nil
    self.m_bool_push_right=true;
    self.m_bool_push_room=true;
    self.m_int_right=0;
    self._socket_index=nil;
    self.m_int_game_id=0
    self.m_int_room_id=0;
    self.m_list_messages={}
    self.sharedScheduler = CCDirector:getInstance():getScheduler()
    self._schedule=self.sharedScheduler:scheduleScriptFunc(function(dt) self:update(dt) end ,0.05,false)
end

function class_game_push:init_game_push()
    self:reset_right();
    local l_user_data=json.decode(bp_get_self_user_data(33));
    self:add_right(l_user_data.right)
    if self._the_push_socket ~=nil then
        bp_socket_release(self._the_push_socket)
        self._the_push_socket=nil;
    end
    local l_push_address=bp_get_push_address();
--    print("hjjlog>>init_game_push:",l_push_address);  
    self._the_push_socket= bp_socket_create(function(index, code) self:on_socket_connect(index, code) end, 
                                            function(index, mainid, subid, data) self:on_socket_receive(index, mainid, subid, data) end, 
                                            function(index, code) self:on_socket_close(index, code) end)                               
    bp_socket_connect(self._the_push_socket, l_push_address, 10001);

end


function class_game_push:on_socket_connect(index, code)
    print("hjjlog>>push_socket_connect:",index,code);
    self._socket_index=index;
    if code==0 then 
        self.m_bool_ready=true;
        self.m_bool_push_right=true;
        self.m_bool_push_room=true;
    else
        self:init_game_push()
    end
end

function class_game_push:on_socket_receive(index, mainCmdID, subCmdID, data) 
    local bool_ret=true;
    if mainCmdID~= PUSH.MDM_PUSH then 
        return true;
    end
    print("hjjlog>>push_receive:",subCmdID);
    if subCmdID==SUB_PUSH_REGISTER_RET then 
    elseif subCmdID==SUB_PUSH_MESSAGE then 
        self:on_socket_push_message(mainCmdID,subCmdID,data)
    elseif subCmdID==SUB_PUSH_BUGLE then 
        self:on_socket_push_bugle(mainCmdID,subCmdID,data)
    end

    if bool_ret==false then 
        self.m_bool_ready=false;
        if self._the_push_socket ~=nil then
            bp_socket_release(self._the_push_socket)
            self._the_push_socket=nil;
        end
    end 
    return true;
end
function class_game_push:on_socket_close(index, code)
    --print("hjjlog>>on_socket_close",index, code)
    if self._the_push_socket ~=nil then
        self._the_push_socket=nil;
        self._socket_index=nil;
    end
    
    self:init_game_push()
    self:reset_right();
    local l_user_data=json.decode(bp_get_self_user_data());
    self:add_right(l_user_data.right)
end

function class_game_push:add_right(param_right)
    self.m_int_right=bit._or(self.m_int_right,param_right)
    print("hjjlog>>int_right:",param_right,self.m_int_right);
    
    self.m_bool_push_right=true;
    return  true;
end
function class_game_push:remove_right(param_right)
    self.m_int_right=self.m_int_right-bit._and(self.m_int_right,param_right)
    self.m_bool_push_right=true;
    return true; 
end
function class_game_push:reset_right()
    self.m_int_right=0;
    self.m_bool_push_right=true;
    return true ;
end

function class_game_push:enter_room(param_gameid,param_roomid)
    self.m_int_game_id=param_gameid;
    self.m_int_room_id=param_roomid;
    self.m_bool_push_room=true;
end

function class_game_push:leave_room()
    self.m_int_game_id=0
    self.m_int_room_id=0
    self.m_bool_push_room=true;
end
function class_game_push:insert_message(param_message)
    if #self.m_list_messages>=20 then 
        table.remove( self.m_list_messages,1 )
    end
    table.insert(self.m_list_messages,param_message)

end

function class_game_push:update(dt)
    local l_user_data=json.decode(bp_get_self_user_data());
    if self.m_bool_ready==true and self.m_bool_push_right then 
        local the_data={}
        the_data.userid=l_user_data.userid
        the_data.right=self.m_int_right;
        the_data.base={}
        the_data.base.int_client_type=2
        the_data.base.int_area_id=bp_get_areaid();
        the_data.base.int_channel_id=bp_get_channelid();
        the_data.base.int_kind_id=bp_get_appid();
        the_data.base.int_version=bp_get_version();
        local str_msec=bp_get_save_value("friend_chat_"..l_user_data.userid,"0")
        local str_udid=bp_get_save_value("friend_list_"..l_user_data.userid,"")

        local the_value={}
        the_value.chatid=tonumber(str_msec);
        the_value.udid=str_udid;
        the_value.module=bp_get_mask_module();
        local l_ext=json.encode(the_value)
        the_data.ext=l_ext;
        local buffer=CMD_PUSH_REGISTER.toBuffer(the_data);
        local bool_send=bp_socket_send_data(self._socket_index, PUSH.MDM_PUSH, PUSH.SUB_PUSH_REGISTER, buffer); 
        self.m_bool_push_right=false  
    end
    if self.m_bool_ready and self.m_bool_push_room then 
        local the_data={}
        the_data.userid=l_user_data.userid
        the_data.gameid=self.m_int_game_id;
        the_data.roomid=self.m_int_room_id;
        local buffer=CMD_PUSH_ENTERROOM.toBuffer(the_data)
        local bool_send=bp_socket_send_data(self._socket_index, PUSH.MDM_PUSH, PUSH.SUB_PUSH_ENTER_ROOM, buffer); 
        self.m_bool_push_room=false;        
    end
end

function class_game_push:on_socket_push_message(param_main_id,param_sub_id,param_data)
    local l_the_message=CMD_PUSH_MESSAGE.fromBuffer(param_data)
    local the_data={}
    the_data.id=0
    the_data.message=bp_gbk2utf(l_the_message.message)
    if #self.m_list_messages>=20 then 
        table.remove( self.m_list_messages,1 )
    end
    table.insert(self.m_list_messages,the_data)

    local event = cc.EventCustom:new(PUSH_NOTIE_MESSAGE);
    event.message = the_data.message
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end

function class_game_push:on_socket_push_bugle(param_main_id,param_sub_id,param_data)
    local l_user_data=json.decode(bp_get_self_user_data());

    local l_the_message=CMD_PUSH_MESSAGE.fromBuffer(param_data)
    l_the_message=bp_gbk2utf(l_the_message.message);

    local the_table=json.decode(l_the_message)
    if the_table.userid==nil or the_table.msg==nil then 
        return true;
    end
    if the_table.userid==l_user_data.userid then 
        return true;
    end
    if the_table.msg=="" then 
        return true ;
    end
    if bp_have_self_right(UC.UR_RIGHT_FULLGAME)==false then 
        return true ;
    end
    local str_chat=bp_base64_decode(l_user_data.msg)

    local the_data={}
    the_data.id=1
    the_data.message=str_chat
    if #self.m_list_messages>=20 then 
        table.remove( self.m_list_messages,1 )
    end
    table.insert(self.m_list_messages,the_data)

    local event = cc.EventCustom:new(PUSH_NOTIE_BUGLE);
    event.message = the_data.message
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end
function class_game_push:insert_bugle_message(param_message)
    local the_data={}
    the_data.id=1
    the_data.message=param_message
    if #self.m_list_messages>=20 then 
        table.remove( self.m_list_messages,1 )
    end
    table.insert(self.m_list_messages,the_data)

    local event = cc.EventCustom:new(PUSH_NOTIE_BUGLE);
    event.message = the_data.message
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(event)
end


function get_share_game_push()
    if ptr_game_push==nil then 
        ptr_game_push=class_game_push:new()
        ptr_game_push:init_game_push()
    end
    return ptr_game_push;

end

return class_game_push;