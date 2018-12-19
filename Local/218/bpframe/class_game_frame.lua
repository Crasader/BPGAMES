local class_game_frame=class("class_game_frame");
local gameMain=require "src/gamemain"
require "bpframe/class_struct"
require("bpframe/CMD_GAME_V10")
require("bpframe/GlobalDefine")



function class_game_frame:ctor()
    self._the_game_room_impl=nil
    self._the_server_info=nil 
    self._int_user_id=nil
    self._ptr_frame_user_data={}
    self._extra_func={}           --外部函数
    self._the_option={}          --游戏配置
    self._ptr_game_main=gameMain:new()
    self._ptr_game_main:set_game_frame(self);
    self.sharedScheduler = CCDirector:getInstance():getScheduler()
    self._schedule=nil;
    --注册可用函数
end
function class_game_frame:destory()
    if self._ptr_game_main~=nil then 
        self._ptr_game_main:destory();
        self._ptr_game_main:set_game_frame(nil)
        self._ptr_game_main=nil;
    end 
end
function class_game_frame:set_room_impl(param_room_impl)
    self._the_game_room_impl=param_room_impl
end 

function class_game_frame:on_channel_message(int_main_id,int_sub_id,param_data)
    --print("hjjlog>>on_channel_message:",int_main_id,int_sub_id)
    if int_main_id==GF.IPC_MAIN_SOCKET then 
        return self:on_socket_message(int_main_id,int_sub_id,param_data)
    elseif int_main_id==GF.IPC_MAIN_CONFIG then 
        return self:on_config_message(int_main_id,int_sub_id,param_data)
    elseif int_main_id==GF.IPC_MAIN_USER then 
        return self:on_user_message(int_main_id,int_sub_id,param_data)
    elseif int_main_id==GF.IPC_MAIN_CONCTROL then 
        return self:on_control_message(int_main_id,int_sub_id,param_data)
    end
    return true ;
end 
  
--
function class_game_frame:on_socket_message(int_main_id,int_sub_id,data)
    if int_sub_id==GF.IPC_SUB_SOCKET_RECV then 
        return self:on_game_message(data.wSubCmdID,data.cbBuffer)
    elseif  int_sub_id==GF.IPC_SUB_SOCKET_FRAME then 
        return  self:on_frame_message(int_main_id,int_sub_id,data.cbBuffer)
    end 
    return true;
end 
function class_game_frame:on_config_message(int_main_id,int_sub_id,data)
    if int_sub_id ==GF.IPC_SUB_SERVER_INFO then 
        self._the_server_info=data
        self._int_user_id=self._the_server_info.dwUserID
        print("hjjlog>>game_frame:config_message:",json.encode(data))
    end 
    return true;
end 
function class_game_frame:on_user_message(int_main_id,int_sub_id,data)
    if int_sub_id==GF.IPC_SUB_USER_COME then 
        local  the_user_data=data   
        local   the_user={}
        the_user.wFaceID = the_user_data.wFaceID;
        the_user.wTableID = the_user_data.wTableID;
        the_user.wChairID = the_user_data.wChairID;
        the_user.wNetDelay = the_user_data.wNetDelay;
        the_user.cbGender = the_user_data.cbGender;
        the_user.cbMember = the_user_data.cbMember;
        the_user.cbUserStatus = the_user_data.cbUserStatus;
        the_user.dwUserID = the_user_data.dwUserID;
        the_user.dwGroupID = the_user_data.dwGroupID;
        the_user.dwUserRight = the_user_data.dwUserRight;
        the_user.dwMasterRight = the_user_data.dwMasterRight;
        the_user.lGold = the_user_data.lGold;
        the_user.lScore = the_user_data.lScore;
        the_user.lWinCount = the_user_data.lWinCount;
        the_user.lLostCount = the_user_data.lLostCount;
        the_user.lDrawCount = the_user_data.lDrawCount;
        the_user.lFleeCount = the_user_data.lFleeCount;
        the_user.lExperience = the_user_data.lExperience;
        the_user.cbFaceEnable = the_user_data.cbFaceEnable;
        the_user.lCharm = the_user_data.lCharm;
        the_user.lPraise = the_user_data.lPraise;
        the_user.cbCameraStatus = the_user_data.cbCameraStatus;
        the_user.szName= the_user_data.szName;
        the_user.szGroupName= the_user_data.szGroupName;
        self:insert_user_data(the_user);
    elseif int_sub_id==GF.IPC_SUB_USER_STATUS then 
        local ptr_user_status=data;
        print("hjjlog>>game_frame:IPC_SUB_USER_STATUS",json.encode(data))
        if ptr_user_status.cbUserStatus <GF.US_SIT then 
            if ptr_user_status.dwUserID~=self._int_user_id then 
                self:delete_user_data(ptr_user_status.dwUserID)
                return true ;
            end
        else 
            self:update_user_data(ptr_user_status.dwUserID,ptr_user_status.cbUserStatus,ptr_user_status.wNetDelay)
        end 
        return true;
    elseif int_sub_id==GF.IPC_SUB_USER_SCORE then 
        local ptr_user_score=data;
        local ptr_user_data=self:get_user_data_by_user_id(ptr_user_score.userid)
        if ptr_user_data ==nil  then 
            print("hjjlog>>IPC_SUB_USER_SCORE:user_data==nil")
            return true;
        end 
        local bool_notice=0
        if ptr_user_score.data.lGold ~=ptr_user_data.lGold or ptr_user_score.data.lScore~=ptr_user_data.lScore then 
            bool_notice=1
        end 
        ptr_user_data.lGold = ptr_user_score.data.lGold;
        ptr_user_data.gametime = ptr_user_score.data.dwGameTime;
        ptr_user_data.lScore = ptr_user_score.data.lScore;
        ptr_user_data.lWinCount = ptr_user_score.data.lWinCount;
        ptr_user_data.lLostCount = ptr_user_score.data.lLostCount;
        ptr_user_data.lDrawCount = ptr_user_score.data.lDrawCount;
        ptr_user_data.lFleeCount = ptr_user_score.data.lFleeCount;
        ptr_user_data.lExperience = ptr_user_score.data.lExperience;
        ptr_user_data.lCharm = ptr_user_score.data.nCharm;
        ptr_user_data.lPraise = ptr_user_score.data.nPraise;
        if bool_notice==1 then 
            self:on_game_user_score(ptr_user_data,ptr_user_data.cbUserStatus==GF.US_LOOKON)
        end 
        if ptr_user_data.dwUserID==self._int_user_id then 
            --hjj_for_need:如果是自己，那么得通知上层有数据更新；
        end 
        return true ;
    elseif int_sub_id == GF.IPC_SUB_GAME_START then 
        for k,v in pairs(self._ptr_frame_user_data) do 
            v.cbUserStatus =GF.US_PLAY
            self:on_game_user_status(v,false)
        end 
        return true ;
    elseif int_sub_id ==GF.IPC_SUB_GAME_FINISH then
        for k,v in pairs(self._ptr_frame_user_data) do 
            v.cbUserStatus =GF.US_SIT
            self:on_game_user_status(v,false)
        end 
        return true ;
    elseif int_sub_id== GF.IPC_SUB_REDPACKET_INFO then 
        --hjj_for_need 红包信息
    end 
    return true;
end 
function class_game_frame:on_control_message(int_main_id,int_sub_id,data)
    if int_sub_id== GF.IPC_SUB_START_FINISH then 
        local  the_data={}
        bp_pack_start();
        bp_pack(1,self._the_option.bAllowLookon)
        local array = bp_pack_end();
        self:send_data(V10.MDM_FRAME,V10.SUB_FRAME_INFO,array)
    elseif int_sub_id==GF.IPC_SUB_CLOSE_FRAME then 
        if data==nil then 
            
        else
        end 
    else 
        print("hjjlog>>game_frame:on_control_message:not ")
    end 

    return true;
end 
--------------------
function class_game_frame:on_frame_message(int_main_id,int_sub_id,data)
    --hjj_for_need  未完成：框架通知到游戏消息-踢人
    print("hjjlog>>on_frame_message:",int_main_id,int_sub_id,json.encode(data))
    if int_sub_id==V10.SUB_FRAME_OPTION then 
        bp_unpack_start(data)
        self._the_option.bGameStatus=bp_unpack(1,true)
        self._the_option.bAllowLookon=bp_unpack(1,true)
        bp_unpack_end();
    else 
        print("hjjlog>>need:on_frame_message:",int_sub_id)
    end 

    return true;
end


function class_game_frame:insert_user_data(ptr_user_data)
    if ptr_user_data.wTableID== GF.INVALID_TABLE then 
        if self._int_user_id~= ptr_user_data.dwUserID then 
            return false;
        else 
            self._ptr_frame_user_data={}
        end
    end 
    if not self._the_server_info or ptr_user_data.wChairID>= self._the_server_info.wChairCount then 
        return false
    end
    table.insert(self._ptr_frame_user_data, ptr_user_data)
    self:on_game_user_enter(ptr_user_data,ptr_user_data.cbUserStatus==GF.US_LOOKON)
end 
function class_game_frame:delete_user_data(param_user_id)
    for k,v in pairs(self._ptr_frame_user_data) do
        if v.dwUserID==param_user_id then 
            self:on_game_user_left(v,v.cbUserStatus==GF.US_LOOKON)
            table.remove( self._ptr_frame_user_data,k)
            return true;
        end
    end
    return true;
end
function class_game_frame:update_user_data(param_user_id,param_status,param_net_delay)
    local ptr_user_data=self:get_user_data_by_user_id(param_user_id)
    if ptr_user_data==nil then 
        print("hjjlog>>gamem_frame:update_user_data:==nil")
        return false;
    end
    ptr_user_data.wNetDelay=param_net_delay;
    ptr_user_data.cbUserStatus=param_status;
    self:on_game_user_status(ptr_user_data,param_status==GF.US_LOOKON)

end


function class_game_frame:send_data(mainCmdID,subCmdID,data)
    self._the_game_room_impl:sendData(mainCmdID,subCmdID,data);
end 
function class_game_frame:close_frame()
    self._ptr_frame_user_data={}
    self._int_user_id=0
end
function class_game_frame:close_room()
    self._the_game_room_impl:close_room();
end 




------HjjNote:游戏内允许使用的接口。
--发送 协议
function class_game_frame:send_game_data(param_id,param_json)
    self:send_data(V10.MDM_GAME,param_id,param_json)
end
function class_game_frame:send_ready_data()
    self:send_data(V10.MDM_FRAME,V10.SUB_FRAME_READY,nil)
end
function class_game_frame:re_sit_down()
    self._the_game_room_impl:sit_down();
end
function class_game_frame:close_game()
    self._schedule=self.sharedScheduler:scheduleScriptFunc(function(dt) self:schedule_once_close_game(dt) end ,0.01,false)
end
function class_game_frame:schedule_once_close_game(dt)
    self:close_frame();
    self:close_room();
    if self._schedule then
        self.sharedScheduler:unscheduleScriptEntry(self._schedule)
        self._schedule=nil
    end
end
function class_game_frame:get_user_data_by_user_id(param_user_id)
    local ptr_user_data=nil;
    for k,v in pairs(self._ptr_frame_user_data) do 
        if v.dwUserID==param_user_id then 
            ptr_user_data=v;
            return v;
        end
    end 
    return ptr_user_data;
end
function class_game_frame:get_user_data_by_chair_id(param_chair_id)
    local ptr_user_data=nil;
    if self._ptr_frame_user_data==nil then 
        self._ptr_frame_user_data={}
    end 
    for k,v in pairs(self._ptr_frame_user_data) do 
        if v.wChairID ==param_chair_id then 
            ptr_user_data=v;
            return ptr_user_data;
        end 
    end 
    return ptr_user_data;
end 
function  class_game_frame:get_game_status()
    return self._the_option.bGameStatus;
end
function class_game_frame:set_game_frame(param_status)
    self._the_option.bGameStatus=param_status
end
function class_game_frame:pause_message()
    return self._the_game_room_impl:pause_message()
end
function class_game_frame:restore_message()
    return self._the_game_room_impl:restore_message();
end
function class_game_frame:get_room_data()
    return self._the_game_room_impl._the_room_data;
end
function class_game_frame:get_self_user_data()
    return self:get_user_data_by_user_id(self._int_user_id)
end
function class_game_frame:switch_to_chair_id(param_view_id)
    local ptr_user_data=self:get_self_user_data();
    if ptr_user_data==nil  then 
        print("hjjlog>>error>>switch_to_chair_id:ptr_user_data==nil")
        return -1;
    end
    local int_chair_count=self._the_server_info.wChairCount;
    local int_chair_id=param_view_id+int_chair_count;

    if int_chair_count==2 then 
        int_chair_id=int_chair_id-1;
    elseif int_chair_count==3 then 
        int_chair_id=int_chair_id-1
    elseif int_chair_count==4 then 
        int_chair_id=int_chair_id-2
    elseif int_chair_count==5 then 
        int_chair_id=int_chair_id-2
    elseif int_chair_count==6 then 
        int_chair_id=int_chair_id-3
    elseif int_chair_count==7 then 
        int_chair_id=int_chair_id-3
    elseif int_chair_count==8 then 
        int_chair_id=int_chair_id-4
    end
    local chair_id=(int_chair_id+ptr_user_data.wChairID)%int_chair_count;
    return chair_id;
end
function class_game_frame:switch_to_view_id(param_chair_id)
    local ptr_user_data=self:get_self_user_data();
    if ptr_user_data==nil  then 
        print("hjjlog>>error>>switch_to_chair_id:ptr_user_data==nil")
        return -1;
    end
    local int_chair_count=self._the_server_info.wChairCount;
    local int_view_id=param_chair_id+int_chair_count-ptr_user_data.wChairID;

    if int_chair_count ==2 then 
        int_view_id=int_view_id+1;
    elseif int_chair_count==3 then
        int_view_id=int_view_id+1; 
    elseif int_chair_count==4 then
        int_view_id=int_view_id+2; 
    elseif int_chair_count==5 then
        int_view_id=int_view_id+2; 
    elseif int_chair_count==6 then
        int_view_id=int_view_id+3; 
    elseif int_chair_count==7 then
        int_view_id=int_view_id+3 
    elseif int_chair_count==8 then
        int_view_id=int_view_id+4; 
    end
    return int_view_id%int_chair_count;
end



--通知cocos game scene
function class_game_frame:on_game_message(int_main_id,data)
    if self._ptr_game_main==nil then 
        print("hjjlog>>_ptr_game_main:game_message is nil")
        return ;
    end 
    self._ptr_game_main:on_game_message(int_main_id,data)
    return true;
end

function class_game_frame:on_game_user_left(ptr_user_data,bool_look)
    if self._ptr_game_main==nil then 
        print("hjjlog>>_ptr_game_main:on_game_user_left is nil")
        return ;
    end 
    self._ptr_game_main:on_game_user_left(ptr_user_data,bool_look)
    return true;
end
function class_game_frame:on_game_user_status(ptr_user_data,bool_look)
    if self._ptr_game_main==nil then 
        print("hjjlog>>_ptr_game_main:on_game_user_status is nil")
        return ;
    end 
    self._ptr_game_main:on_game_user_status(ptr_user_data,bool_look)
    return true;
end
function class_game_frame:on_game_user_enter(ptr_user_data,bool_look)
    if self._ptr_game_main==nil then 
        print("hjjlog>>_ptr_game_main:on_game_user_enter is nil")
        return ;
    end 
    self._ptr_game_main:on_game_user_enter(ptr_user_data,bool_look)
    return true;
end
function class_game_frame:on_game_user_data(ptr_user_data,bool_look)
    if self._ptr_game_main==nil then 
        print("hjjlog>>_ptr_game_main:on_game_user_data is nil")
        return ;
    end 
    self._ptr_game_main:on_game_user_data(ptr_user_data,bool_look)
    return true;
end  
function class_game_frame:on_game_user_score(ptr_user_data,bool_look)
    if self._ptr_game_main==nil then 
        print("hjjlog>>_ptr_game_main:on_game_user_score is nil")
        return ;
    end 
    self._ptr_game_main:on_game_user_score(ptr_user_data,bool_look)
    return true;
end
function class_game_frame:on_game_user_chat(ptr_user_data,string_chat)
    if self._ptr_game_main==nil then 
        print("hjjlog>>_ptr_game_main:on_game_user_chat is nil")
        return ;
    end 
    self._ptr_game_main:on_game_user_chat(ptr_user_data,bool_look)
    return true;
end
--设置外部函数
function class_game_frame:setExtraFunc(param_key,param_func)
    self._extra_func[param_key]=param_func
end

return class_game_frame