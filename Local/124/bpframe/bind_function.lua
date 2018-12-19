bind_function={}
bind_function.ptr_game=nil

function bind_function.set_game_frame(param_game_frame)
    bind_function.ptr_game=param_game_frame;
end

--[[
--------------2018/12/14-----
可用函数：


选用监听事件：
    NOTICE_GAME_KICKOUT  踢人消息
    NOTICE_GMAE_START    游戏开始消息
    NOTICE_USER_CHAT     聊天消息
------------------------------
]]

-- -----------------
-- 函数名称:  switch_to_view_id
-- 函数描述:  用于将逻辑位置转化为视图位置
-- 参数说明:  int型 逻辑位置
-- 返回说明:  int型 视图位置
-- -----------------
function bind_function.switch_to_view_id(param_chair_id)
    if bind_function.ptr_game==nil then 
        print("hjjerr>>bind_function.switch_to_view_id is nil")
        return -1;
    end
    return bind_function.ptr_game:switch_to_view_id(param_chair_id)   
end

-- -----------------
-- 函数名称:  send_user_chat
-- 函数描述:  用于发送聊天消息到服务端
-- 参数说明:  string型  聊天内容
-- 返回说明:  无
-- 事件返回： NOTICE_USER_CHAT
--[[
    TABLE={
        chat=chat,
        userid=userid,
        username=username
    }
]]
-- -----------------
function bind_function.send_user_chat(param_str)
    if bind_function.ptr_game==nil then 
        print("hjjerr>>bind_function.send_user_chat is nil")
        return false;
    end
    bind_function.ptr_game:send_user_chat(param_str)
end

-- -----------------
-- 函数名称:  get_user_data_by_user_id
-- 函数描述:  用于通过用户ID获取玩家信息
-- 参数说明:  int型 用户ID
-- 返回说明:  table
-- -----------------
function bind_function.get_user_data_by_user_id(param_user_id)
    if bind_function.ptr_game==nil then 
        print("hjjerr>>bind_function.get_user_data_by_user_id is nil")
        return {};
    end
    return bind_function.ptr_game:get_user_data_by_user_id(param_user_id)
end

-- -----------------
-- 函数名称:  send_data
-- 函数描述:  用于发送数据到服务端
-- 参数说明:  int型 协议ID
-- 参数说明:  string型  协议具体内容
-- 返回说明:  无
-- -----------------
function bind_function.send_data(param_id, param_json)
    if bind_function.ptr_game == nil then
        return 
    end
    bind_function.ptr_game:send_game_data(param_id, param_json)
end

-- -----------------
-- 函数名称:  send_ready_data
-- 函数描述:  用于发送准备消息到服务端
-- 参数说明:  无
-- 返回说明:  无
-- -----------------
function bind_function.send_ready_data()
    if bind_function.ptr_game == nil then
        return 
    end
    bind_function.ptr_game:send_ready_data()
end

-- -----------------
-- 函数名称:  re_sit_down
-- 函数描述:  用于完成重新坐下操作
-- 参数说明:  无
-- 返回说明:  无
-- -----------------
function bind_function.re_sit_down()
    if bind_function.ptr_game == nil then
        return 
    end
    bind_function.ptr_game:re_sit_down()
end

-- -----------------
-- 函数名称:  close_game
-- 函数描述:  用于完成离开游戏操作，按断线处理
-- 参数说明:  无
-- 返回说明:  无
-- -----------------
function bind_function.close_game()
    if bind_function.ptr_game == nil then
        return 
    end
    bind_function.ptr_game:close_game()
end

-- -----------------
-- 函数名称:  bp_get_self_user_data
-- 函数描述:  用于获取自己的玩家信息
-- 参数说明:  无
-- 返回说明:  table
-- -----------------
function bind_function.get_user_data_by_chair_id(param_chair_id)
    if bind_function.ptr_game == nil then
        print("DY Err>>bind_function.get_user_data_by_chair_id is nil")
        return {}
    end
    return bind_function.ptr_game:get_user_data_by_chair_id(param_chair_id)
end

-- -----------------
-- 函数名称:  get_game_status
-- 函数描述:  用于当前游戏状态
-- 参数说明:  无
-- 返回说明:  int型 游戏状态
-- -----------------
function bind_function.get_game_status()
    if bind_function.ptr_game == nil then
        return -1
    end
    return bind_function.ptr_game:get_game_status()
end

-- -----------------
-- 函数名称:  set_game_status
-- 函数描述:  用于当前游戏状态
-- 参数说明:  int型 游戏状态
-- 返回说明:  无
-- -----------------
function bind_function.set_game_status(param_status)
    if bind_function.ptr_game == nil then
        return 
    end
    bind_function.ptr_game:set_game_status(param_status)
end

-- -----------------
-- 函数名称:  pause_message
-- 函数描述:  用于暂停消息循环
-- 参数说明:  无
-- 返回说明:  int型 暂停消息次数
-- -----------------
function bind_function.pause_message()
    if bind_function.ptr_game == nil then
        return -1
    end
    return bind_function.ptr_game:pause_message()
end

-- -----------------
-- 函数名称:  restore_message
-- 函数描述:  用于恢复已暂停的消息循环
-- 参数说明:  无
-- 返回说明:  int型 暂停消息数
-- -----------------
function bind_function.restore_message()
    if bind_function.ptr_game == nil then
        return -1
    end
    return bind_function.ptr_game:restore_message()    
end

-- -----------------
-- 函数名称:  get_room_data
-- 函数描述:  用于获取当前房间信息
-- 参数说明:  无
-- 返回说明:  table
-- -----------------
function bind_function.get_room_data()
    if bind_function.ptr_game == nil then
        return {}
    end
    return bind_function.ptr_game:get_room_data()    
end

-- -----------------
-- 函数名称:  bp_get_self_user_data
-- 函数描述:  用于获取自己的玩家信息
-- 参数说明:  无
-- 返回说明:  table 
-- -----------------
function bind_function.get_self_user_data()
    if bind_function.ptr_game == nil then
        return {}
    end
    return bind_function.ptr_game:get_self_user_data()    
end

-- -----------------
-- 函数名称:  switch_to_chair_id
-- 函数描述:  用于将视图位置转化为逻辑位置
-- 参数说明:  int型 视图位置
-- 返回说明:  int型 逻辑位置
-- -----------------
function bind_function.switch_to_chair_id(param_view_id)
    if bind_function.ptr_game == nil then
        return -1
    end
    return bind_function.ptr_game:switch_to_chair_id(param_view_id)    
end

-- -----------------
-- 函数名称:  get_status_time_by_id
-- 函数描述:  用于获取指定道具状态的失效时间
-- 参数说明:  int型 状态ID
-- 返回说明:  int型 时效时间 （参数为0时除外 参数为0时 返回道具table {｛id, time｝, ...}）
-- -----------------
function bind_function.get_status_time_by_id(param_prop_id)
    if param_prop_id < 0 then
        return 0
    end
    return bp_get_self_prop_status(param_prop_id)
end

-- -----------------
-- 函数名称:  get_self_prop_status
-- 函数描述:  用于判断指定的道具是否在有效期内
-- 参数说明:  int型 状态ID
-- 返回说明:  bool型 false:否 true:是
-- -----------------
function bind_function.get_self_prop_status(param_prop_id)
    if param_prop_id < 0 then
        return false
    end

    local time = bp_get_self_prop_status(param_prop_id)

    return os.time() < time
end

-- -----------------
-- 函数说明：get_module_mask
-- 函数描述：获取功能模块管控
-- 参数说明：无
-- 返回说明：返回值 MASK_MODULE_BIND_PHONE|MASK_MODULE_BIND_WECHAT... 包含的功能块的或运算结果
-- -----------------
function bind_function.get_module_mask()
    return bp_get_module_mask()
end

-- -----------------
-- have_mask_module
-- 函数描述：是否开启相关功能模块管控 
-- 参数说明：MASK_MODULE_BIND_PHONE|MASK_MODULE_BIND_WECHAT... 包含的功能块的或运算结果
-- 返回说明：bool型  
-- -----------------
function bind_function.have_mask_module(param_module)
    return bp_have_mask_module(param_module)
end

-- -----------------
-- 函数名称:  get_self_prop_count
-- 函数描述:  用于获取指定道具的数量
-- 参数说明:  int型 道具ID 
-- 返回说明:  int型 道具数目 （参数为0时除外 参数为0时 返回道具table {｛id, cnt}, ...}）
-- -----------------
function bind_function.get_self_prop_count(param_prop_id)
    if param_prop_id < 0 then
        return 0
    end

    return bp_get_self_prop_count(param_prop_id)
end

-- -----------------
-- 函数名称:  show_hinting
-- 函数描述:  用于显示提示信息
-- 参数说明:  string型 信息内容
-- 返回说明:  无
-- -----------------
function bind_function.show_hinting(param_string)
    bp_show_hinting(param_string)
end

-- -----------------
-- 函数名称:  send_user_report
-- 函数描述:  发送举报事件
-- 参数说明:  table ={userid=[],count,kind}
--                   举报对象数组，举报对象数目，举报类型
-- 举报类型说明：1昵称不文明 2辱骂 3合作作弊
-- 返回说明:  bool  是否发送成功
-- -----------------
function bind_function.send_user_report(param_table_data)
    if bind_function.ptr_game == nil then
        return -1
    end
    return bind_function.ptr_game:send_user_report(param_table_data)    
end
-- -----------------
-- 函数名称:  send_user_kick
-- 函数描述:  点赞行为
-- 参数说明:  param_userid 主动踢人ID
-- 参数说明:  param_userid 被踢人ID
-- 返回说明:  bool  是否发送成功
-- 操作后事件返回：NOTICE_GAME_KICKOUT
--[[    //踢人 Flag 0:OK 1:游戏已经开始 2.权限不够 3.道具不足 4.玩家不存在
    TABLE={
        userid=userid,
        touserid=touserid,
        flag=flag
    }
--]]
-- -----------------
function bind_function.send_user_kick(param_userid, param_to_user_id)
    if bind_function.ptr_game == nil then
        return -1
    end
    return bind_function.ptr_game:send_user_kick(param_userid, param_to_user_id)    

end
-- -----------------
-- 函数名称:  send_user_praise
-- 函数描述:  点赞行为
-- 参数说明:  param_userid 点赞人
-- 参数说明:  param_userid 被赞人
-- 返回说明:  bool  是否发送成功
-- -----------------
function bind_function.send_user_praise(param_userid, param_to_user_id)
    if bind_function.ptr_game == nil then
        return -1
    end
    return bind_function.ptr_game:send_user_praise(param_userid, param_to_user_id)    
end

-- -----------------
-- 函数名称:  show_shop
-- 函数描述:  用于显示商城面板
-- 参数说明:  param_index 1 金币商城
                        -- 2 道具商场
                        -- 3 元宝 
                        -- 4 活动 +可以带参数
                        -- 5 任务
                        -- 6 兑换
                        -- 7 个人中心
                        -- 8 vip
                        -- 9 推荐
                        -- 10 排行
                        -- 11 无  我也不知道以前是干嘛的
                        -- 12 金豆商城
-- 返回说明:  无
-- -----------------
function bind_function.show_shop(param_index)
    if bind_function.ptr_game == nil then
        return -1
    end
    return bind_function.ptr_game:show_shop(param_index)    
end