-----------------------------------------------------------------
-- 单款游戏入口
-----------------------------------------------------------------
local gameMain = class("gameMain")
local g_path = BPRESOURCE("res/")

function gameMain:ctor()
    print("gamelog>>gameMain:ctor")
    self.ptr_game_frame = nil
    self:init()
end

function gameMain:init()
    print("gamelog>>gameMain:init")
    -- 初始化场景
    local main_layout = bp_get_main_layout();
end

function gameMain:destory()
    print("gamelog>>gameMain:destory")

end

function gameMain:set_game_frame(param_game_frame)
    print("gamelog>>gameMain:set_game_frame")
    self.ptr_game_frame = param_game_frame
end

---------------游戏通知----------------
function gameMain:on_game_message(int_main_id,data)
    print("gamelog>>gameMain:on_game_message",int_main_id,data)
    local param_data = {}
    if data ~= nil and data ~= "" then
        param_data = json.decode(data or "")
    end
end

function gameMain:on_game_user_left(ptr_user_data,bool_look)
    print("gamelog>>gameMain:on_game_user_left",json.encode(ptr_user_data))

end

--用户状态改变
function gameMain:on_game_user_status(ptr_user_data,bool_look)
    print("gamelog>>gameMain:on_game_user_status",json.encode(ptr_user_data))

end 

function gameMain:on_game_user_enter(ptr_user_data,bool_look)
    print("gamelog>>gameMain:on_game_user_enter",json.encode(ptr_user_data))

end

function gameMain:on_game_user_data(ptr_user_data,bool_look)
    print("gamelog>>on_game_user_data",json.encode(ptr_user_data))

end

function gameMain:on_game_user_score(ptr_user_data,boo_look)
    print("gamelog>>on_game_user_score",json.encode(ptr_user_data))

end

function gameMain:on_game_user_chat(ptr_user_data,string_chat)
    print("gamelog>>on_game_user_chat",json.encode(ptr_user_data))

end

return gameMain