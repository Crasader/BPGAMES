CMD_PUSH_REGISTER={}
function CMD_PUSH_REGISTER.toBuffer(param_data)
    print("hjjlog>>CMD_PUSH_REGISTER,CHECK:",json.encode(param_data));
    
    bp_pack_start();
    bp_pack(4,param_data.userid)
    bp_pack(4,param_data.right)
    CMD_BASE_INFO.bp_pack(param_data.base)
    bp_pack(0,param_data.ext,1024)
    local array=bp_pack_end();
    return array;
end
function CMD_PUSH_REGISTER.fromBuffer(param_data)

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


CMD_PUSH_ENTERROOM={}
function CMD_PUSH_ENTERROOM.toBuffer(param_data)
    bp_pack_start()
    bp_pack(4,param_data.userid)
    bp_pack(4,param_data.gameid)
    bp_pack(4,param_data.roomid)
    local array=bp_pack_end();
    return array
end

CMD_PUSH_MESSAGE={}

function CMD_PUSH_MESSAGE.fromBuffer(param_data)
    local l_table={}
    local l_size=bp_unpack_start(param_data)
    l_table.message=bp_unpack(0,2048)
    bp_unpack_end()
    return l_table;
end


