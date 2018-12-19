
cc.FileUtils:getInstance():setPopupNotify(false)
require "cocos.init"
require("bptools/lobby_config")
require("bptools/class_struct")
require("bptools/control_tools")
local class_game_push=require("src/class_game_push")
local UIChatCenter=require("src/ui_chatcenter")
sptr_main_layout=nil;
local function main()

end

function bpinit(param_data)
    print("hjjlog>>bpinit---10002",param)
    sptr_main_layout=bp_get_main_layout();
    get_share_game_push();
end

function bpsignal(param_int,param_str1,param_str2)
    print("hjjlog>>10002   bpsignal:",param_int,param_str1);
    if param_str1=="INSERT_MESSAGE" then 
        if param_str2~="" then 
            local l_table_data=json.decode(param_str2)
            get_share_game_push():insert_message(l_table_data)
        end
    elseif param_str1=="SHOW_ROOM_BUGLE" then
        if param_str2~="" then 
            local l_table_data=json.decode(param_str2)
            UIChatCenter.ShowChatCenter(true,l_table_data);
        end
    end

end

function start()
    get_share_game_push();
end

function destory()
    bp_application_destory(0)
end
local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end


