
cc.FileUtils:getInstance():setPopupNotify(false)
require "cocos.init"
require("bptools/lobby_config")
local Layout_room=require "src/Layout_room"
local Test_Layout=require("src/test_layout")
local UISimpleShop=require("src/ui_simpleshop")


sptr_main_layout=nil;
local ptr_layout_room=nil;
local function main()
end
function bpinit(param)
    print("hjjlog>>bpinit---10001",param)
    sptr_main_layout=bp_get_main_layout();
    ptr_layout_room=Layout_room:create();
    sptr_main_layout:addChild(ptr_layout_room)
end
function bpsignal(param_int,param_str,param_value)
    print("hjjlog>>10001 bpsignal:",param_int,param_str,param_value)
    if param_str=="destory" then 
        bpdestory();
    elseif param_str=="enter_room_finish" then 
        
    elseif param_str=="MSG_DO_TASK" then 
        if ptr_layout_room~=nil then 
            ptr_layout_room:on_do_task(json.decode(param_value))
        end
    elseif param_str=="MSG_SHOW_SIMPLE_SHOP"  then 
        local l_table_data=json.decode(param_value)
        UISimpleShop.ShowSimpleShop(true,l_table_data,l_table_data.game_id)
    elseif param_str=="MSG_SHOW_GIFT_SHOP"  then 
        local l_table_data=json.decode(param_value)
        UISimpleShop.ShowSimpleShop(true,l_table_data,l_table_data.game_id)
    end
end
function bpdestory()
    if ptr_layout_room~=nil then 
        print("gamelog>>gameMain:destory")
        ptr_layout_room:destory();
        ptr_layout_room:removeFromParent();
    end
    bp_application_destory(0)
end
local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end


