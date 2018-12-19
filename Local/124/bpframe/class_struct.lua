class_struct={}

function class_struct.room_data()
    local l_room_data={}


    return l_room_data;
end

function class_struct.make_struct(param_table,param_index)
end
CMD_GAME_LOGON3={}
function CMD_GAME_LOGON3.toBuffer(param_table)
    print("hjjlog>>CMD_GAME_LOGON3:",json.encode(param_table))
    bp_pack_start();
	bp_pack(4, param_table.code);
	bp_pack(4, param_table.gameversion);
	bp_pack(4, param_table.userid);
    bp_pack(0, param_table.password,33);
    bp_pack(0, param_table.session,33);
    bp_pack(2,0)--补位置
    CMD_BASE_INFO.bp_pack(param_table.base)
	local array = bp_pack_end();
    return array
end
CMD_BASE_INFO={}
function CMD_BASE_INFO.toBuffer(param_table)

end
function CMD_BASE_INFO.bp_pack(param_table)
    bp_pack(4,param_table.int_client_type)
    bp_pack(4,param_table.int_area_id)
    bp_pack(4,param_table.int_channel_id)
    bp_pack(4,param_table.int_kind_id)
    bp_pack(4,param_table.int_version)
end

CMD_USER_SIT={}
function CMD_USER_SIT.toBuffer(param_table)
    print("hjjlog>>check CMD_USER_SIT:",json.encode(param_table))
    bp_pack_start();
    bp_pack(2,param_table.tableid)
    bp_pack(2,param_table.chairid)
    bp_pack(2,param_table.delay)
    bp_pack(1,param_table.len)
    local array=bp_pack_end();
    return array
end 

tagUserInfoHead={}
function tagUserInfoHead.fromBuffer(param_data)
    local l_table={}
    local l_size=bp_unpack_start(param_data);
    --print("hjjlog>>tagUserInfoHead size:",l_size)
    l_table.wFaceID=bp_unpack(2,true);
    l_table.cbGender =bp_unpack(1,false)  
    l_table.cbMember =bp_unpack(1,false);  
    l_table.dwUserID =bp_unpack(4,false) 
    l_table.dwGroupID =bp_unpack(4,false) 
    l_table.dwUserRight =bp_unpack(4,false)
    l_table.dwMasterRight=bp_unpack(4,false)
    l_table.wTableID=bp_unpack(2,false);
    l_table.wChairID=bp_unpack(2,false);
    l_table.wNetDelay=bp_unpack(2,false);
    l_table.cbUserStatus=bp_unpack(1,false)
    local l_reserved1=bp_unpack(0,5);
    l_table.UserScoreInfo={}
    l_table.UserScoreInfo.lGold=bp_unpack(8)
    l_table.UserScoreInfo.lScore=bp_unpack(4,true)
    l_table.UserScoreInfo.lWinCount=bp_unpack(4,true)
    l_table.UserScoreInfo.lLostCount=bp_unpack(4,true)
    l_table.UserScoreInfo.lDrawCount=bp_unpack(4,true)
    l_table.UserScoreInfo.lFleeCount=bp_unpack(4,true)
    l_table.UserScoreInfo.lExperience=bp_unpack(4,true)
    l_table.UserScoreInfo.reserved=bp_unpack(0,76)
    l_table.UserScoreInfo.dwGameTime=bp_unpack(4,false)
    l_table.UserScoreInfo.nCharm=bp_unpack(4,true)
    l_table.UserScoreInfo.nLogonCount=bp_unpack(4,true)
    l_table.UserScoreInfo.nPraise=bp_unpack(4,true)
    l_table.UserScoreInfo.reservedbyte=bp_unpack(0,4)
    l_table.gametime=bp_unpack(4,false)
    local l_reserved2=bp_unpack(0,4)
    l_table.szMemberOverTime=bp_unpack(8,true)
    local l_reserved3=bp_unpack(0,60)
    l_table.cbCameraStatus=bp_unpack(1,false);
    l_table.cbFaceEnable=bp_unpack(1,false);
    local l_reserved4=bp_unpack(2,true);
    l_table.lCharm=bp_unpack(4,true)
    l_table.lPraise=bp_unpack(4,true);
    local int_left=l_size-248
    for i=1,int_left do 
        local  l_buffer=bp_unpack(2,false)
        local   l_reserved5=bp_unpack(2,false)
        if l_reserved5==10 then 
            l_table.name=bp_unpack(0,l_buffer)
            break;
        end
        local l_reserved6=bp_unpack(0,l_buffer)
        int_left=int_left-l_buffer
        if int_left<=4 then 
            break;
        end
    end
    bp_unpack_end()    
    --print("hjjlog>>name:",bp_gbk2utf(l_table.name))
    return l_table
end 

CMD_USER_STATUS={}

function CMD_USER_STATUS.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data)
    l_table.userid=bp_unpack(4,true)
    l_table.tableid=bp_unpack(2,false)
    l_table.chairid=bp_unpack(2,false)
    l_table.delay=bp_unpack(2,false)
    l_table.status=bp_unpack(1,false)
    l_table.reserve1=bp_unpack(1,false)
    bp_unpack_end()
    return l_table;
end 
CMD_USER_SCORE={}
function CMD_USER_SCORE.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data);
    l_table.userid=bp_unpack(4,false)
    local l_reserved1=bp_unpack(4,false)
    l_table.data={}
    l_table.data.lGold=bp_unpack(8)
    l_table.data.lScore=bp_unpack(4,true)
    l_table.data.lWinCount=bp_unpack(4,true)
    l_table.data.lLostCount=bp_unpack(4,true)
    l_table.data.lDrawCount=bp_unpack(4,true)
    l_table.data.lFleeCount=bp_unpack(4,true)
    l_table.data.lExperience=bp_unpack(4,true)
    l_table.data.reserved=bp_unpack(0,76)
    l_table.data.dwGameTime=bp_unpack(4,false)
    l_table.data.nCharm=bp_unpack(4,true)
    l_table.data.nLogonCount=bp_unpack(4,true)
    l_table.data.nPraise=bp_unpack(4,true)
    l_table.data.reservedbyte=bp_unpack(0,4)
    bp_unpack_end();
    return l_table;
end
CMD_REDPACKET_INFO={}
function CMD_REDPACKET_INFO.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data);
    l_table.userid=bp_unpack(4,false);
    l_table.finish_count=bp_unpack(4,false)
    l_table.totle_count=bp_unpack(4,false)
    l_table.pass_time=bp_unpack(4,false)
    l_table.interval=bp_unpack(4,false)
    l_table.sendtime=bp_unpack(4,false)
    bp_unpack_end()
    return l_table;
end 
CMD_FRAME_REDPACK={}
function CMD_FRAME_REDPACK.fromBuffer(data)
    local l_table={}
    bp_unpack_start(data);
    l_table.userid=bp_unpack(4,false)
    l_table.redpack=bp_unpack(4,false)
    l_table.reserve=bp_unpack(0,16)
    l_table.message=bp_unpack(0,1024);
    bp_unpack_end();
    return l_table;
end
CMD_TABLE_STATUS={}
function CMD_TABLE_STATUS.fromBuffer(data)
    local l_table={}
    bp_unpack_start(data);
    l_table.tableid=bp_unpack(2,false)
    l_table.start=bp_unpack(1,false)
    l_table.lock=bp_unpack(1,false)
    l_table.reserve1=bp_unpack(4,false)
    bp_unpack_end()
    return l_table
end 
CMD_SYSTEM_MESSAGE={}
function CMD_SYSTEM_MESSAGE.fromBuffer(data)
    local l_table={}
    bp_unpack_start(data);
    l_table.type=bp_unpack(2,false)
    l_table.len=bp_unpack(2,false)
    l_table.message=bp_unpack(0,1024)
    bp_unpack_end()
    return l_table;
end 


CMD_FRAME_CHAT={}
function CMD_FRAME_CHAT.toBuffer(param_table)
    bp_pack_start();
    bp_pack(2, param_table.len);
	bp_pack(2, 0);
	bp_pack(4, param_table.color);
    bp_pack(4, param_table.userid);
	bp_pack(4, param_table.touserid);
    bp_pack(0, param_table.chat,param_table.len);

	local array = bp_pack_end();
    return array
end
function CMD_FRAME_CHAT.fromBuffer(data)
    local l_table={}
    bp_unpack_start(data);
    l_table.len=bp_unpack(2,false)
    local tt=bp_unpack(2,false)
    l_table.color=bp_unpack(4,false)
    l_table.userid=bp_unpack(4,false)
    l_table.touserid=bp_unpack(4,false)
    l_table.chat=bp_unpack(0,l_table.len)
    bp_unpack_end()
    return l_table;
end

CMD_FRAME_REPORT={}
function CMD_FRAME_REPORT.toBuffer(param_table)
    bp_pack_start();
    local l_count=0
    for k,v in pairs(param_table.userid) do
        if l_count==8 then 
	        bp_pack(4, v);
            break;
        end
    end
    for i=l_count,8 do
        bp_pack(4, 0);
    end
	bp_pack(4, param_table.count);
    bp_pack(4, param_table.kind);
    local array = bp_pack_end();
    return array
end
CMD_FRAME_KICKOUT={}
function CMD_FRAME_KICKOUT.toBuffer(param_table)
    bp_pack_start()
    bp_pack(4,param_table.userid)
    bp_pack(4,param_table.touserid)
    local array=bp_pack_end();
    return array;
end
CMD_FRAME_KICKOUT_RET={}
function CMD_FRAME_KICKOUT_RET.fromBuffer(data)
    local l_table={}
    bp_unpack_start(data);
    l_table.flag=bp_unpack(4,false)
    l_table.userid=bp_unpack(4,false)
    l_table.touserid=bp_unpack(4,false)
    bp_unpack_end()
    return l_table;
end
CMD_FRAME_KICKOUT_NOTICE={}
function CMD_FRAME_KICKOUT_NOTICE.fromBuffer(data)
    local l_table={}
    bp_unpack_start(data);
    l_table.userid=bp_unpack(4,false)
    l_table.touserid=bp_unpack(4,false)
    bp_unpack_end()
    return l_table;
end
CMD_FRAME_PRAISE={}
function CMD_FRAME_PRAISE.toBuffer(param_table)
    bp_pack_start()
    bp_pack(4,param_table.userid)
    bp_pack(4,param_table.touserid)
    local array=bp_pack_end();
    return array;
end
CMD_FRAME_PRAISE_RET={}
function CMD_FRAME_PRAISE_RET.fromBuffer(data)
    local l_table={}
    bp_unpack_start(data);
    l_table.flag=bp_unpack(4,false)
    l_table.userid=bp_unpack(4,false)
    l_table.touserid=bp_unpack(4,false)
    bp_unpack_end()
    return l_table;
end
CMD_FRAME_PRAISE_NOTICE={}
function CMD_FRAME_PRAISE_NOTICE.fromBuffer(data)
    local l_table={}
    bp_unpack_start(data);
    l_table.userid=bp_unpack(4,false)
    l_table.touserid=bp_unpack(4,false)
    bp_unpack_end()
    return l_table;
end
CMD_FRAME_READY_ERROR={}

function CMD_FRAME_READY_ERROR.fromBuffer(data)
    local l_table={}
    bp_unpack_start(data);
    l_table.flag=bp_unpack(4,false)
    l_table.error=bp_unpack(0,128)
    bp_unpack_end()
    return l_table;
end




