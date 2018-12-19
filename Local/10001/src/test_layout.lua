local Test_Layout=class("Test_Layout",function() return ccui.Layout:create() end)
local g_path=BPRESOURCE("res/")


function Test_Layout:ctor()
   print("hjjlog>>Test_Layout")
   self:init();
end
function Test_Layout:destory()
end


function Test_Layout:init()
--    local l_btn=control_tools.newBtn({normal=g_path.."test_green.png",pressed=g_path.."test_green.png",size=cc.size(200,200)})
--    self:addChild(l_btn)
--    l_btn:setPosition(cc.p(400,200))
--    l_btn:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_test(param_sender,param_touchType) end)

   local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA22", function (eventCustom)
            print("hjjlog>>lua   NOTICE_UPDATE_USER_DATA11111111111111");
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA22", function (eventCustom)
        print("hjjlog>>lua   NOTICE_UPDATE_USER_DATA222222222222");
        
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    local  Sprite=require("src/sprite_card2") 
    local tt=Sprite:create();
    self:addChild(tt)

    -- local  Sprite1=require("src/sprite_card1")
    -- local tt1=Sprite1:create();
    -- self:addChild(tt1)
    -- tt1:setPosition(cc.p(100,100))

end
function Test_Layout:on_btn_test(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    bp_update_user_data(1)
 end 


return Test_Layout