cc.FileUtils:getInstance():setPopupNotify(false)

require "cocos.init"
require "bptools/control_tools"
require "bptools/action_tools"
require "bptools/bit_tools"
require "bptools/ui_tools"
require "bptools/audio_engine"

local class_game_room_impl = require "bpframe/class_game_room_impl"
local ptr_the_game_room_impl = nil

local function main()

end

function bpinit(param)
    print("hjjlog>>bpinit---124",param)
    ptr_the_game_room_impl=class_game_room_impl:new();
end

function bpsignal(param_id,param_key,param_value)
    print("hjjlog>>game:bpsignal:"..param_key.."  value:"..param_value)
    if param_key=="destory" then 
        bpdestory()
    elseif param_key=="init_game_room" then 
        ptr_the_game_room_impl:init_game_room(json.decode(param_value))
    elseif param_key=="init_game_room_with_code" then 
        local l_data=json.decode(param_value)
        ptr_the_game_room_impl:init_game_room_with_code(l_data,l_data.code)
    end 
end

function bpdestory()
    print("hjjlog>>127  destory")
    if ptr_the_game_room_impl~=nil then 
        ptr_the_game_room_impl:destory();
        ptr_the_game_room_impl=nil;
    end
    bp_application_destory(0)
end

function start_game_client()

end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
