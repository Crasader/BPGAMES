cc.FileUtils:getInstance():setPopupNotify(false)
require "src/g_tools/control_tools"
require "cocos.init"
local class_game_room_impl=require "bpframe/class_game_room_impl"
local ptr_the_game_room_impl=nil;

local function main()
end
function bpinit(param)
    print("hjjlog>>bpinit---107",param)


    ptr_the_game_room_impl=class_game_room_impl:new();
    ptr_the_game_room_impl:init_game_room(2)
    ptr_the_game_room_impl:setExtraFunc("room_impl_listener",function(param_type,param_data) on_room_listener(param_type,param_data) end )
    ptr_the_game_room_impl:setExtraFunc("start_game",function() start_game_client() end )
end
--room监听
function on_room_listener(param_type,param_data)

end
function bpsignal(param_int,param_str)
    print("hjjlog>>127 bpsignal:",param_int,param_str)
    if param_str=="destory" then 
        destory()
    end 
end
function destory()
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


