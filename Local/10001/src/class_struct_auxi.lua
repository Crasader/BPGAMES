


 MDM_AUXI						= 10000       --主命令
 SUB_AUXI_CREATE_TABLE		= MDM_AUXI + 1       -- 创建桌子
 SUB_AUXI_DISMISS_TABLE		= MDM_AUXI + 2       -- 解散桌子
 SUB_AUXI_JOIN_TABLE			= MDM_AUXI + 3       -- 加入桌子
 SUB_AUXI_QUERY_TABLE			= MDM_AUXI + 4       -- 查询桌子
 SUB_AUXI_CREATE_TABLE_SUCCESS= MDM_AUXI + 11       --创建桌子成功
 SUB_AUXI_CREATE_TABLE_FAIL	= MDM_AUXI + 12       --创建桌子失败
 SUB_AUXI_DISMISS_TABLE_SUCCESS=MDM_AUXI + 13       --解散桌子成功
 SUB_AUXI_DISMISS_TABLE_FAIL	= MDM_AUXI + 14       --解散桌子失败
 SUB_AUXI_JOIN_TABLE_SUCCESS	= MDM_AUXI + 15       --加入桌子成功
 SUB_AUXI_JOIN_TABLE_FAIL		= MDM_AUXI + 16       --加入桌子失败
 SUB_AUXI_QUERY_TABLE_SUCCESS = MDM_AUXI + 17       --查询桌子成功
 SUB_AUXI_QUERY_TABLE_FAIL	= MDM_AUXI + 18       --查询桌子失败


CMD_BASE_INFO={}
function CMD_BASE_INFO.toBuffer(param_table)

end
function CMD_BASE_INFO.bp_pack(param_table)
    bp_pack(4,param_table.clienttype)
    bp_pack(4,param_table.area)
    bp_pack(4,param_table.channel)
    bp_pack(4,param_table.app)
    bp_pack(4,param_table.version)
    bp_pack(4,param_table.package)
    bp_pack(0,param_table.keyword,32)
end

--创建房间
CMD_AUXI_CREATE_TABLE={}
function CMD_AUXI_CREATE_TABLE.toBuffer(param_data)
    bp_pack_start();
    CMD_BASE_INFO.bp_pack(param_data.base)
    bp_pack(4,param_data.userid)
    bp_pack(0,param_data.session,33)
    bp_pack(0,param_data.mac,33)
    --bp_pack(2,0)
    bp_pack(4,param_data.gameid)
    bp_pack(4,param_data.ruleitem)
    bp_pack(4,param_data.tallykind)

    local array=bp_pack_end();
    return array;

end
function CMD_AUXI_CREATE_TABLE.fromBuffer(param_data)

end
CMD_AUXI_CREATE_TABLE_SUCCESS={}
function CMD_AUXI_CREATE_TABLE_SUCCESS.toBuffer(param_data)
end

function CMD_AUXI_CREATE_TABLE_SUCCESS.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data)
    l_table.gameid=bp_unpack(4,false)
    l_table.roomid=bp_unpack(4,false)
    l_table.code=bp_unpack(0,12)
    bp_unpack_end()
    return l_table;
end
CMD_AUXI_CREATE_TABLE_FAIL={}
function CMD_AUXI_CREATE_TABLE_FAIL.toBuffer(param_data)
end
function CMD_AUXI_CREATE_TABLE_FAIL.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data)
    l_table.flag=bp_unpack(4,false)
    l_table.message=bp_gbk2utf(bp_unpack(0,128))
    bp_unpack_end()
    return l_table;
end
--解散房间
CMD_AUXI_DISMISS_TABLE={}
function CMD_AUXI_DISMISS_TABLE.toBuffer(param_data)
    bp_pack_start();
    CMD_BASE_INFO.bp_pack(param_data.base)
    bp_pack(4,param_data.userid)
    bp_pack(0,param_data.session,33)
    bp_pack(0,param_data.code,12)
    local array=bp_pack_end();
    return array;
end
function CMD_AUXI_DISMISS_TABLE.fromBuffer(param_data)
end

CMD_AUXI_DISMISS_TABLE_SUCCESS={}
function CMD_AUXI_DISMISS_TABLE_SUCCESS.toBuffer(param_data)
end
function CMD_AUXI_DISMISS_TABLE_SUCCESS.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data)
    l_table.flag=bp_unpack(4,false)
    bp_unpack_end()
    return l_table;
end

CMD_AUXI_DISMISS_TABLE_FAIL={}
function CMD_AUXI_DISMISS_TABLE_FAIL.toBuffer(param_data)
end
function CMD_AUXI_DISMISS_TABLE_FAIL.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data)
    l_table.flag=bp_unpack(4,false)
    l_table.message=bp_gbk2utf(bp_unpack(0,128))
    bp_unpack_end()
    return l_table;
end
--加入房间
CMD_AUXI_JOIN_TABLE={}
function CMD_AUXI_JOIN_TABLE.toBuffer(param_data)
    bp_pack_start();
    CMD_BASE_INFO.bp_pack(param_data.base)
    bp_pack(0,param_data.code,12)
    local array=bp_pack_end();
    return array;
end
function CMD_AUXI_JOIN_TABLE.fromBuffer(param_data)
end

CMD_AUXI_JOIN_TABLE_SUCCESS={}
function CMD_AUXI_JOIN_TABLE_SUCCESS.toBuffer(param_data)
end
function CMD_AUXI_JOIN_TABLE_SUCCESS.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data)
    l_table.userid=bp_unpack(4,false)
    l_table.nickname=bp_gbk2utf(bp_unpack(0,32))
    l_table.gameid=bp_unpack(4,true)
    l_table.roomid=bp_unpack(4,true)
    l_table.kind=bp_unpack(4,true)
    l_table.totalcount=bp_unpack(4,true)
    l_table.currcount=bp_unpack(4,true)
    l_table.tallykind=bp_unpack(4,false)
    l_table.tallyname=bp_gbk2utf(bp_unpack(0,32))
    l_table.rule=bp_unpack(0,256)
    bp_unpack_end()
    return l_table;
end

CMD_AUXI_JOIN_TABLE_FAIL={}
function CMD_AUXI_JOIN_TABLE_FAIL.toBuffer(param_data)
end
function CMD_AUXI_JOIN_TABLE_FAIL.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data)
    l_table.flag=bp_unpack(4,false)
    l_table.message=bp_gbk2utf(bp_unpack(0,128))
    bp_unpack_end()
    return l_table;
end
--查询房间
CMD_AUXI_QUERY_TABLE={}
function CMD_AUXI_QUERY_TABLE.toBuffer(param_data)
    bp_pack_start();
    CMD_BASE_INFO.bp_pack(param_data.base)
    bp_pack(4,param_data.userid)
    bp_pack(0,param_data.session,33)
    -- bp_pack(1,0)
    -- bp_pack(2,0)
    local array=bp_pack_end();
    return array;
end

function CMD_AUXI_QUERY_TABLE.fromBuffer(param_data)
end

CMD_AUXI_QUERY_TABLE_SUCCESS={}
function CMD_AUXI_QUERY_TABLE_SUCCESS.toBuffer(param_data)
end
function CMD_AUXI_QUERY_TABLE_SUCCESS.fromBuffer(param_data)
    local l_table={}
    local l_size=bp_unpack_start(param_data)
    print("hjjlog>>CMD_AUXI_QUERY_TABLE_SUCCESS:size:",l_size);
    for i=1,l_size/68 do 
        local l_item={}
        l_item.code=bp_unpack(0,12)
        l_item.gameid=bp_unpack(4,true)
        l_item.roomid=bp_unpack(4,true)
        l_item.kind=bp_unpack(4,true)
        l_item.totalcount=bp_unpack(4,true)
        l_item.currcount=bp_unpack(4,true)
        l_item.tallykind=bp_unpack(4,false)
        l_item.tallyname=bp_gbk2utf( bp_unpack(0,32))
        table.insert(l_table,l_item)
    end
    bp_unpack_end()
    return l_table;
end


CMD_AUXI_QUERY_TABLE_FAIL={}
function CMD_AUXI_QUERY_TABLE_FAIL.toBuffer(param_data)
end
function CMD_AUXI_QUERY_TABLE_FAIL.fromBuffer(param_data)
    local l_table={}
    bp_unpack_start(param_data)
    l_table.flag=bp_unpack(4,false)
    l_table.message=bp_gbk2utf(bp_unpack(0,128))
    bp_unpack_end()
    return l_table;
end



