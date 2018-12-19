local class_game_room_impl=class("class_game_room_impl");
local class_game_frame=require "bpframe/class_game_frame"
require "bpframe/class_struct"
require("bpframe/CMD_GAME_V10")
require("bpframe/GlobalDefine")



function class_game_room_impl:ctor()
    print("ldhlog>>class_game_room_impl:ctor")
    self._the_room_data=nil;
    self._the_game_socket=nil
    self._int_user_id=0;
    self._map_user_data={};--用户列表，数组
    self._list_frame_message={};  --发送客服端协议集
    self._extra_func={}           --外部函数
    self._ptr_scene_game=nil;
    self._socket_index=nil;
    self._int_pause_message=0;

    self.sharedScheduler = CCDirector:getInstance():getScheduler()
    self._schedule=self.sharedScheduler:scheduleScriptFunc(function(dt) self:update(dt) end ,0.05,false)

end
function class_game_room_impl:destory()
    print("hjjlog>>class_game_room_impl.destory")
    if self._schedule then
        self.sharedScheduler:unscheduleScriptEntry(self._schedule)
        self._schedule=nil
    end
    if self._ptr_scene_game~=nil then 
        self._ptr_scene_game:destory();
        self._ptr_scene_game:set_room_impl(nil)
        self._ptr_scene_game=nil;
    end
end
function class_game_room_impl:re_init_game_room()   
    if self._ptr_scene_game~=nil then 
        self._ptr_scene_game:destory();
        self._ptr_scene_game=nil;
    end
    self:init_game_room(self._the_room_data);
end

function class_game_room_impl:init_game_room(param_room_data)

    self._the_room_data=param_room_data;
    self._the_room_data={}
    self._the_room_data._int_id=12411
	self._the_room_data._int_room_id=101			
	self._the_room_data._str_name="初级场"				
	self._the_room_data._int_online_count=0		
	self._the_room_data._str_address="demo.bookse.cn"		
	self._the_room_data._int_port=22411				
	self._the_room_data._int_game_id=124			
	self._the_room_data._int_room_mode=1			
	self._the_room_data._int_room_kind=16			
	self._the_room_data._int_limit_mask=0		
	self._the_room_data._int_min_score=0			
	self._the_room_data._int_max_score=0			
	self._the_room_data._int_min_gold=0			
	self._the_room_data._int_max_gold=0			
	self._the_room_data._int_min_charm=0			
	self._the_room_data._int_max_charm=0			
	self._the_room_data._str_rule=""				
	self._the_room_data._int_game_genre=16		
	self._the_room_data._int_table_count=50		
	self._the_room_data._int_chair_count=3		
    self._the_room_data._int_game_version=0		
    
    --print("hjjlog>>init_game_room:",param_room_data)
    self._int_pause_message=0;
    if self._the_game_socket ~=nil then
        bp_socket_release(self._the_game_socket)
        self._the_game_socket=nil;
    end
    self._the_game_socket= bp_socket_create(function(index, code) self:on_socket_connect(index, code) end, function(index, mainid, subid, data) self:on_socket_receive(index, mainid, subid, data) end, function(index, code) self:on_socket_close(index, code) end)

    --self._the_game_socket= bp_socket_create(self.on_socket_connect, self.on_socket_receive, self.on_socket_close);

    bp_socket_connect(self._the_game_socket, "demo.bookse.cn", 12411);-- 127.0.0.1  demo.bookse.cn
end
function class_game_room_impl:listener()


end

 function class_game_room_impl:on_socket_connect(index, code)
    print("hjjlog>>on_socket_connect:",index,code)
    self._socket_index=index;
    if code ==0 then 
        local struct_logon={}
        local self_data=json.decode(bp_get_self_user_data())
        print("hjjlog>>on_socket_connect:",self_data,self_data.userid,self_data.password,self_data.session)

        struct_logon.code=0
        struct_logon.userid=self_data.userid;
        struct_logon.password=bp_md5(self_data.password);
        struct_logon.session=self_data.session
        struct_logon.base={}
        struct_logon.base.int_client_type=2
        struct_logon.base.int_area_id=bp_get_areaid();
        struct_logon.base.int_channel_id=bp_get_channelid();
        struct_logon.base.int_kind_id=bp_get_appid();
        struct_logon.base.int_version=bp_get_version();
        local buffer=CMD_GAME_LOGON3.toBuffer(struct_logon);
        local bool_send=bp_socket_send_data(index, V10.MDM_GAME_LOGON, V10.SUB_GAME_LOGON3, buffer);    
	    print(string.format("gameframe => send_data(%d)", bool_send))
    else 
        print("hjjlog>>on_socket_connect: fail ")
    end
end

function class_game_room_impl:on_socket_receive(index, mainCmdID, subCmdID, data)
    -- bp_pack_start();
    print("hjjlog>>on_socket_receive:", mainCmdID, subCmdID)
    local bool_ret=true;
    if mainCmdID==V10.MDM_GAME_LOGON then --1
        bool_ret=self:on_socket_main_logon(mainCmdID,subCmdID,data)
    elseif mainCmdID==V10.MDM_USER then --2
        bool_ret=self:on_socket_main_user(mainCmdID,subCmdID,data)
    elseif mainCmdID==V10.MDM_CONFIG then --3
        bool_ret=self:on_socket_main_info(mainCmdID, subCmdID, data);
    elseif mainCmdID==V10.MDM_TABLE then --4
        bool_ret=self:on_socket_main_status(mainCmdID, subCmdID, data);
    elseif mainCmdID==V10.MDM_SYSTEM then --10
        bool_ret=self:on_socket_main_system(mainCmdID, subCmdID, data)
    elseif mainCmdID==V10.MDM_GAME then --100
        bool_ret=self:on_socket_main_game_frame(mainCmdID, subCmdID, data);
    elseif mainCmdID==V10.MDM_FRAME then --101
        bool_ret=self:on_socket_main_frame_message(mainCmdID, subCmdID, data);
    end
end

function class_game_room_impl:on_socket_close(index, code)
    print("hjjlog>>on_socket_close",index, code)
end
--1 房间登陆
function class_game_room_impl:on_socket_main_logon(mainCmdID, subCmdID, data)
    if  subCmdID==V10.SUB_GAME_LOGON_SUCCESS then 
        bp_unpack_start(data)
        self._int_user_id=bp_unpack(4,true)
        bp_unpack_end();
    elseif subCmdID==V10.SUB_GAME_LOGON_ERROR then 
        bp_unpack_start(data);
        local l_flag=bp_unpack(4,true)
        local l_error=bp_unpack(0,128)
        bp_unpack_end();
        --hjj_for_wait
    elseif subCmdID==V10.SUB_GAME_LOGON_FINISH then 
        local ptr_self_user_data=self:select_user_data(self._int_user_id)
        if ptr_self_user_data==nil then 
           print("hjjlog>>SUB_GAME_LOGON_FINISH :self_user_data==null");
        end
        if ptr_self_user_data.wTableID~= GF.INVALID_TABLE then 
            self:start_game_client()
        else 
            self:sit_down();
        end 
    end
    return true;
end
--2 用户信息
function class_game_room_impl:on_socket_main_user(mainCmdID, subCmdID, data)
    local l_ret_bool=false;
    if subCmdID==V10.SUB_USER_COME then 
        l_ret_bool=self:on_socket_sub_user_come(mainCmdID, subCmdID, data)
    elseif subCmdID==V10.SUB_USER_STATUS then 
        l_ret_bool=self:on_socket_sub_status(mainCmdID,subCmdID,data)
    elseif subCmdID==V10.SUB_USER_SCORE then 
        l_ret_bool=self:on_socket_sub_score(mainCmdID,subCmdID,data)
    elseif subCmdID==V10.SUB_USER_SITFAILED then 
        l_ret_bool=self:on_socket_sub_sit_failed(mainCmdID,subCmdID,data)
    elseif subCmdID==V10.SUB_USER_PROP then 
        l_ret_bool=self:on_socket_sub_prop(mainCmdID,subCmdID,data)
    elseif subCmdID==V10.SUB_USER_MEMBER then 
        l_ret_bool=self:on_socket_sub_member(mainCmdID,subCmdID,data)
    elseif subCmdID==V10.SUB_USER_CHAT then 
        l_ret_bool=self:on_socket_sub_chat(mainCmdID,subCmdID,data)
    elseif subCmdID==V10.SUB_USER_REDPACKET_INFO then 
        l_ret_bool=self:on_socket_sub_redpacket_info(mainCmdID,subCmdID,data)
    elseif subCmdID==V10.SUB_USER_REDPACK then 
        l_ret_bool=self:on_socket_sub_redpacket_receive(mainCmdID,subCmdID,data)
    else 
        l_ret_bool=true;
    end 
    return true;
end
--3//配置信息
function class_game_room_impl:on_socket_main_info(mainCmdID, subCmdID, data)
    --选座场 暂时不坐  不关心
    return true;
end
--4//桌子状态信息
function class_game_room_impl:on_socket_main_status(mainCmdID, subCmdID, data)
    if subCmdID==V10.SUB_TABLE_STATUS then 
        local ptr_table_status=CMD_TABLE_STATUS.fromBuffer(data)
        print("hjjlog>>check CMD_TABLE_STATUS:",json.encode(ptr_table_status))
        local ptr_self_user_data=self:select_user_data(self._int_user_id)
        if  ptr_self_user_data==nil then 
            print("hjjlog>> on_socket_main_status:self_user_data==nil")
            return true;
        end 
        if ptr_self_user_data.wTableID==ptr_table_status.tableid then 
            if  ptr_table_status.start>0 then 
                self:send_data_to_client(GF.IPC_MAIN_USER,GF.IPC_SUB_GAME_START,nil);
            else 
                self:send_data_to_client(GF.IPC_MAIN_USER,GF.IPC_SUB_GAME_FINISH,nil);
            end 
        end     
    end  
    return true;
end
--10/系统信息
function class_game_room_impl:on_socket_main_system(mainCmdID, subCmdID, data)
    if subCmdID==V10.SUB_SYSTEM_MESSAGE then 
        local ptr_message=CMD_SYSTEM_MESSAGE.fromBuffer(data)
        if bit._and(ptr_message.type ,GF.KIND_MESSAGE_CLOSE) then 
            self:send_data_to_client(GF.IPC_MAIN_CONCTROL,GF.IPC_SUB_CLOSE_FRAME,ptr_message)
        else 
            self:send_data_to_client(GF.IPC_MAIN_CONCTROL,GF.IPC_SUB_NOTICT_FRAME,ptr_message)
        end
    end 
    return true;
end
--100//游戏消息
function class_game_room_impl:on_socket_main_game_frame(mainCmdID, subCmdID, data)
    local l_table={}
    l_table.wMainCmdID=mainCmdID;
    l_table.wSubCmdID=subCmdID;
    l_table.cbBuffer=data;
    self:send_data_to_client(GF.IPC_MAIN_SOCKET,GF.IPC_SUB_SOCKET_RECV,l_table);
    return true;
end
function class_game_room_impl:on_socket_main_frame_message()
    local l_table={}
    l_table.wMainCmdID=mainCmdID;
    l_table.wSubCmdID=subCmdID;
    l_table.cbBuffer=data;
    self:send_data_to_client(GF.IPC_MAIN_SOCKET,GF.IPC_SUB_SOCKET_FRAME,l_table);
    return true;
end

---------用户信息----
function class_game_room_impl:on_socket_sub_user_come(mainCmdID, subCmdID, data)
    local ptr_user_info_head=tagUserInfoHead.fromBuffer(data)
    print("hjjlog>>on_socket_sub_user_come",json.encode(ptr_user_info_head))
    local  ptr_user_data = {}
    ptr_user_data.dwUserID = ptr_user_info_head.dwUserID;
    ptr_user_data.wTableID = ptr_user_info_head.wTableID;
    ptr_user_data.wChairID = ptr_user_info_head.wChairID;
    ptr_user_data.cbUserStatus =bit._and(ptr_user_info_head.cbUserStatus,0x0F) 
    ptr_user_data.dwUserRight = ptr_user_info_head.dwUserRight;
    ptr_user_data.dwMasterRight = ptr_user_info_head.dwMasterRight;

    ptr_user_data.wFaceID = ptr_user_info_head.wFaceID;
    ptr_user_data.cbGender = ptr_user_info_head.cbGender;
    ptr_user_data.cbMember = ptr_user_info_head.cbMember;
    ptr_user_data.dwGroupID = ptr_user_info_head.dwGroupID;
    ptr_user_data.lScore = ptr_user_info_head.UserScoreInfo.lScore;
    ptr_user_data.lGold = ptr_user_info_head.UserScoreInfo.lGold;

    ptr_user_data.lWinCount = ptr_user_info_head.UserScoreInfo.lWinCount;
    ptr_user_data.lLostCount = ptr_user_info_head.UserScoreInfo.lLostCount;
    ptr_user_data.lDrawCount = ptr_user_info_head.UserScoreInfo.lDrawCount;
    ptr_user_data.lFleeCount = ptr_user_info_head.UserScoreInfo.lFleeCount;
    ptr_user_data.lExperience = ptr_user_info_head.UserScoreInfo.lExperience;
    ptr_user_data.lCharm = ptr_user_info_head.UserScoreInfo.nCharm;
    ptr_user_data.lPraise = ptr_user_info_head.UserScoreInfo.nPraise;
    ptr_user_data.szName=bp_gbk2utf(ptr_user_info_head.name);
    self:insert_user_data(ptr_user_data)
    local ptr_self_user_data=self:select_user_data(self._int_user_id)
    if ptr_self_user_data==nil then 
        print("hjjlog>>on_socket_sub_user_come: self_user_data==null", self._int_user_id)
    end 
    if ptr_self_user_data.wTableID~= GF.INVALID_TABLE and ptr_self_user_data.dwUserID ~= ptr_user_data.dwUserID and ptr_self_user_data.wTableID == ptr_user_data.wTableID then 
        self:send_table_user_to_client(ptr_user_data);
    end 
end
function class_game_room_impl:on_socket_sub_status(mainCmdID, subCmdID, data)
    local ptr_user_status=CMD_USER_STATUS.fromBuffer(data)
    local ptr_user_data=self:select_user_data(ptr_user_status.userid)
    local ptr_self_user_data=self:select_user_data(self._int_user_id)
    if ptr_user_data==nil  then 
        print("hjjlog>>on_socket_sub_status:user_data111==nil",json.encode(ptr_user_status))
        return true;
    end 
    if ptr_self_user_data==nil then 
        print("hjjlog>>on_socket_sub_status:user_data==nil",self._int_user_id,table.getn(self._map_user_data))
        return true;
    end 
    local int_new_table_id=ptr_user_status.tableid
    local int_new_chair_id=ptr_user_status.chairid
    local int_new_status=ptr_user_status.status;

    local  int_old_table_id=ptr_user_data.wTableID;
    local  int_old_chair_id=ptr_user_data.wChairID;
    local  int_old_status=ptr_user_data.cbUserStatus;

    if int_new_status==GF.US_NULL then  
        if ptr_self_user_data.wTableID~=GF.INVALID_TABLE and ptr_self_user_data.wTableID==int_old_table_id then 
            local the_data={}    --IPC_UserStatus
            the_data.dwUserID=ptr_user_data.dwUserID;
            the_data.wNetDelay=ptr_user_data.wNetDelay;
            the_data.cbUserStatus=ptr_user_data.cbUserStatus
            self:send_data_to_client(GF.IPC_MAIN_USER,GF.IPC_SUB_USER_STATUS,the_data)
        end 
        self:delete_user_data(ptr_user_data.dwUserID)
        return true;
    end 

    ptr_user_data.wTableID=int_new_table_id;
    ptr_user_data.wChairID=int_new_chair_id;
    ptr_user_data.cbUserStatus=int_new_status;
    ptr_user_data.wNetDelay=ptr_user_status.delay
    --设置新状态
    if int_new_table_id~=GF.INVALID_TABLE and (int_new_table_id~=int_old_table_id or int_new_chair_id~=int_old_chair_id) then 
        if ptr_user_data.dwUserID ~=self._int_user_id and ptr_self_user_data.wTableID==int_new_table_id then 
            self:send_table_user_to_client(ptr_user_data)
        end
    end 
    local bool_notify_game=false;
    if ptr_user_data.dwUserID==self._int_user_id then 
        bool_notify_game=true;
    elseif ptr_self_user_data.wTableID~=GF.INVALID_TABLE and ptr_self_user_data.wTableID ==int_new_table_id then 
        bool_notify_game=true;
    elseif ptr_self_user_data.wTableID~=GF.INVALID_TABLE and ptr_self_user_data.wTableID==int_old_table_id then 
        bool_notify_game=true;
    else 
    end 
    if bool_notify_game==true then 
        local the_data={}  --IPC_UserStatus
        the_data.dwUserID=ptr_user_data.dwUserID;
        the_data.wNetDelay=ptr_user_data.wNetDelay;
        the_data.cbUserStatus=ptr_user_data.cbUserStatus;
        self:send_data_to_client(GF.IPC_MAIN_USER,GF.IPC_SUB_USER_STATUS,the_data)
    end 
    if ptr_user_data.dwUserID==self._int_user_id then 
        if int_new_table_id~=GF.INVALID_TABLE and (int_new_table_id~=int_old_table_id or int_new_chair_id~=int_old_chair_id) then 
            self:start_game_client();
        end 
    end 
    return true;
end
function class_game_room_impl:on_socket_sub_score(mainCmdID, subCmdID, data)
    local ptr_user_score=CMD_USER_SCORE.fromBuffer(data)
    local ptr_user_data=self:select_user_data(ptr_user_score.userid)
    if ptr_user_data==nil then 
        print("hjjlog>>on_socket_sub_score:user_data==nil")
        return true;
    end
    ptr_user_data.lGold = ptr_user_score.data.lGold;
    ptr_user_data.lScore = ptr_user_score.data.lScore;
    ptr_user_data.lWinCount = ptr_user_score.data.lWinCount;
    ptr_user_data.lLostCount = ptr_user_score.data.lLostCount;
    ptr_user_data.lDrawCount = ptr_user_score.data.lDrawCount;
    ptr_user_data.lFleeCount = ptr_user_score.data.lFleeCount;
    ptr_user_data.lExperience = ptr_user_score.data.lExperience;
    ptr_user_data.lPraise = ptr_user_score.data.nPraise;
    ptr_user_data.lCharm = ptr_user_score.data.nCharm;
    if ptr_user_score.userid==bp_get_self_user_data().userid then 
        local bool_update=false;
        
        bp_set_self_charm(ptr_user_score.data.nCharm)
        
        if bit._and(self._the_room_data._int_room_mode,GF.ROOM_MODE_REDPACKET) then 
            bp_set_self_bean(ptr_user_score.data.lGold)
        else
            bp_set_self_gold(ptr_user_score.data.lGold)
        end
        bp_update_user_data();
    end 
    local ptr_self_user_data=self:select_user_data(self._int_user_id)
    if ptr_self_user_data==nil then 
        print("hjjlog>>sub_score:self_user_data==nil")
        return true;
    end 
    if ptr_self_user_data.wTableID~=GF.INVALID_TABLE and ptr_self_user_data.wTableID== ptr_user_data.wTableID then 
        self:send_data_to_client(GF.IPC_MAIN_USER,GF.IPC_SUB_USER_SCORE,ptr_user_score)
    end 
end
function class_game_room_impl:on_socket_sub_sit_failed(mainCmdID, subCmdID, data)
    --hjj_for_useless
    --坐下失败，一般用来选座场的。通知上层坐下失败 
    print("hjjlog>> socket_sub_sit_failed");
end
function class_game_room_impl:on_socket_sub_prop(mainCmdID, subCmdID, data)
        local l_size=bp_unpack_start(data)
        local the_value=bp_unpack(0,l_size)
        bp_unpack_end();
        the_value=bp_gbk2utf(the_value)
        print("hjjlog>>check on_sub_prop:",the_value)
        local table_data=json.decode(the_value)
        local int_user_id=table_data.userid;
        if int_user_id~=self._int_user_id then 
            return ;
        end
        if table_data.prop~=nil then 
            for v,k in pairs(table_data.prop) do
                bp_get_self_prop_count(v.id,v.cnt);
            end
        end 
        bp_update_user_data();
end
function class_game_room_impl:on_socket_sub_member(mainCmdID, subCmdID, data) 
    local ptr_user_member={}
    bp_unpack_start(data);
    ptr_user_member.userid=bp_unpack(4,false)
    ptr_user_member.member=bp_unpack(4,false)
    bp_unpack_end();
    print("hjjlog>>check on_socket_sub_member:",json.encode(ptr_user_member))
    local ptr_user_data=self:select_user_data(ptr_user_member.userid)
    if ptr_user_data==nil then 
        print("hjjlog>>sub_member:user_data==nil")
        return ;
    end 
    ptr_user_data.cbMember=ptr_user_member.member;
    local ptr_self_user_data=self:select_user_data(self._int_user_id);
    if ptr_self_user_data.wTableID~=INVALID_TABLE and ptr_self_user_data.wTableID==ptr_user_data.wTableID then 
        self:send_data_to_client(GF.IPC_MAIN_USER,GF.IPC_SUB_USER_MEMBER,ptr_user_member)
    end 
    return true;
end
function class_game_room_impl:on_socket_sub_chat(mainCmdID, subCmdID, data)
    return true;
end
function class_game_room_impl:on_socket_sub_redpacket_info(mainCmdID, subCmdID, data)
    local ptr_user_redpacket=CMD_REDPACKET_INFO.fromBuffer(data)
    print("hjjlog>>check on_redpacket_info:",json.encode(ptr_user_redpacket))
    --hjj_for_wait
    --ptr_user_redpacket.sendtime=Date();
    self:send_data_to_client(GF.IPC_MAIN_USER,GF.IPC_SUB_REDPACKET_INFO,ptr_user_redpacket)
end
function class_game_room_impl:on_socket_sub_redpacket_receive(mainCmdID, subCmdID, data)
    local ptr_user_redpacket=CMD_FRAME_REDPACK.fromBuffer(data)
    --hjj_for_wait 收到一个红包
    bp_set_self_redpacket(bp_get_self_user_data().redpacket+ptr_user_redpacket.redpack)
end
function class_game_room_impl:sendData(mainCmdID,subCmdID,data)
    local bool_send=bp_socket_send_data(self._socket_index, mainCmdID, subCmdID, data);    
    if bool_send==0 then 
        print("hjjlog>>sendData",bool_send)
    else 
        print("hjjlog>>sendData",bool_send,self._socket_index, mainCmdID, subCmdID)
    end
end

----用户信息end------
function class_game_room_impl:insert_user_data(param_user_data)
    if  param_user_data==nil or param_user_data=={} then 
        return ;
    end 
    for k,v in pairs(self._map_user_data) do 
        if v.dwUserID ==param_user_data.dwUserID then 
           table.remove( self._map_user_data,k)
            break;
        end 
    end
    table.insert( self._map_user_data, param_user_data)
end
function class_game_room_impl:delete_user_data(param_user_id)
    for k,v in pairs(self._map_user_data) do 
        if v.dwUserID==param_user_id then 
            table.remove( self._map_user_data, k)
            break;
        end 
    end 
end
function class_game_room_impl:select_user_data(param_user_id )
    local l_user_data=nil;
    for k,v in pairs(self._map_user_data) do 
        if v.dwUserID==param_user_id then 
            l_user_data=v;
            break;
        end 
    end
    return l_user_data;
end 
function class_game_room_impl:send_table_user_to_client(param_user_data)
    self:send_data_to_client(GF.IPC_MAIN_USER,GF.IPC_SUB_USER_COME,param_user_data)
end
function class_game_room_impl:send_data_to_client(param_main_id,param_sub_id,param_data)
    local l_message={}
    l_message.int_main_id=param_main_id;
    l_message.int_sub_id=param_sub_id;
    l_message.ptr_data=param_data;
    table.insert(self._list_frame_message,l_message)
end 
function class_game_room_impl:sit_down()
    local ptr_self_user_data=self:select_user_data(self._int_user_id)
    if ptr_self_user_data==nil then 
        print("hjjlog>>sit_down: self_user_data==nil")
        return false;
    end 
    --清空用户数据
    self._map_user_data={};
    self:insert_user_data(ptr_self_user_data)

    --清空框架消息
    self._list_frame_message={}
    local the_data={}
    the_data.tableid=ptr_self_user_data.wTableID
    the_data.chairid=GF.INVALID_CHAIR
    the_data.delay=0
    the_data.len=0;

    local buffer=CMD_USER_SIT.toBuffer(the_data);
    local bool_send=bp_socket_send_data(self._socket_index, V10.MDM_USER, V10.SUB_USER_SIT, buffer);    
    print("hjjlog>>send_data(sit_down)",bool_send)
end
function class_game_room_impl:start_game_client()
    if self._ptr_scene_game~=nil then 
        self._ptr_scene_game:destory();
        self._ptr_scene_game=nil;
    end
    self._ptr_scene_game=class_game_frame:new()
    local l_this=self;
    self:on_frame_start();
end 
function class_game_room_impl:on_frame_start()
    self._ptr_scene_game:set_room_impl(self)
    self:send_game_info_to_client()
    self:send_table_users_to_client()
    self:send_data_to_client(GF.IPC_MAIN_CONCTROL,GF.IPC_SUB_START_FINISH,nil)
end 
function class_game_room_impl:clear_room()
    --hjj_for_need: 关闭 这个游戏
    if self._the_game_socket ~=nil then
        bp_socket_release(self._the_game_socket)
        self._the_game_socket=nil;
    end
end
function class_game_room_impl:close_room()
    --hjj_for_need:  关闭 这个游戏。
    self:clear_room()
    bp_application_signal(0,"destory");
end
function class_game_room_impl:stand_up(bool_force)
    if bool_force==1 then 
        self:sendData(V10.MDM_USER,V10.SUB_USER_LEFT,nil)
    else 
        self:sendData(V10.MDM_USER,V10.SUB_USER_STANDUP,nil);
    end
    return true;
end

function class_game_room_impl:send_game_info_to_client()
    local ptr_self_user_data=self:select_user_data(self._int_user_id)
    if ptr_self_user_data==nil then 
        print("hjjlog>>send_game_info_to_client:self_user_data==nil")
        return ;
    end 
    local the_server_info={}
    the_server_info.dwUserID=self._int_user_id;
    the_server_info.wTableID=ptr_self_user_data.wTableID;
    the_server_info.wChairID=ptr_self_user_data.wChairID;
    the_server_info.wKindID=self._the_room_data._int_game_id;
    the_server_info.wGameGenre=self._the_room_data._int_game_genre;
    the_server_info.wChairCount=self._the_room_data._int_chair_count;
    the_server_info.wServerID=self._the_room_data._int_room_id;
    print("hjjlog>>check the_server_info",json.encode(the_server_info))
    self:send_data_to_client(GF.IPC_MAIN_CONFIG,GF.IPC_SUB_SERVER_INFO,the_server_info);
end 
function class_game_room_impl:send_table_users_to_client()
    local ptr_self_user_data=self:select_user_data(self._int_user_id)
    if ptr_self_user_data==nil then 
        print("hjjlog>>send_table_users_to_client self_user_data==nil ")
        return ;
    end 
    --自己
    self:send_table_user_to_client(ptr_self_user_data)
    --其他
    for k,v in pairs(self._map_user_data) do 
        if v.dwUserID~=self._int_user_id then 
            if v.wTableID==ptr_self_user_data.wTableID and v.cbCameraStatus~=GF.US_LOOKON then 
                self:send_table_user_to_client(v)
            end
        end 
    end 
    --旁观
    for k,v in pairs(self._map_user_data) do 
        if v.dwUserID~=self._int_user_id then 
            if v.wTableID==ptr_self_user_data.wTableID and v.cbCameraStatus==GF.US_LOOKON then 
                self:send_table_user_to_client(v)
            end
        end 
    end 
end 
function class_game_room_impl:pause_message()
    self._int_pause_message=self._int_pause_message+1;
    return self._int_pause_message;
end     
function class_game_room_impl:restore_message()
    self._int_pause_message=self._int_pause_message-1;
    if  self._int_pause_message<0 then 
        self._int_pause_message=0
    end 
    return self._int_pause_message; 
end 

--设置外部函数
function class_game_room_impl:setExtraFunc(param_key,param_func)
    self._extra_func[param_key]=param_func
end
function class_game_room_impl:update(dt)
    --print("hjjlog>>update  :",dt)
    if self._int_pause_message>0 then 
        return ;
    end 
    if self._ptr_scene_game==nil then 
        return 
    end 
    if table.getn(self._list_frame_message) >0 then 
        local ptr_frame_message=self._list_frame_message[1]
        --print("hjjlog>>update:",ptr_frame_message.int_main_id,ptr_frame_message.int_sub_id,json.encode(ptr_frame_message.ptr_data))
        self._ptr_scene_game:on_channel_message(ptr_frame_message.int_main_id,ptr_frame_message.int_sub_id,ptr_frame_message.ptr_data)
        table.remove( self._list_frame_message,1 )
    end
end 

return class_game_room_impl