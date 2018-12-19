local UIGoldRain=class("UIGoldRain",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/goldrain/")
sptr_gold_rain=nil;
function UIGoldRain:ctor()
    print("hjjlog>>UIGoldRain")
    self.list_coin={};
    self:init();
end
function UIGoldRain:destory()
end

function UIGoldRain:init()
    local  the_size=CCDirector:getInstance():getVisibleSize();
    self.the_size=the_size;
    self:setContentSize(self.the_size)
    for i=1,80 do
        local l_icon = cc.Sprite:create(g_path.."kong.png")
        self:addChild(l_icon);
        table.insert( self.list_coin,l_icon)
    end
end
function UIGoldRain:get_a_gold_animation()
    --local l_coin=cc.Sprite:create(g_path.."kong.png");
    local l_animation= cc.Animation:create()
   local l_start=math.random(1,8)
   local l_name="";
   for i=l_start,8 do
        l_name=g_path.."gold_frame_"..i..".png";
        l_animation:addSpriteFrameWithFile(l_name)
   end
   for i=1,l_start-1 do
        l_name=g_path.."gold_frame_"..i..".png";
        l_animation:addSpriteFrameWithFile(l_name)
   end

   l_animation:setDelayPerUnit(0.7 / 7.0)
   l_animation:setRestoreOriginalFrame(true)
   l_animation:setLoops(-1)
   local l_action = cc.Animate:create(l_animation)
   return l_action;
end
function UIGoldRain:show_gold_rain()
    math.randomseed(os.time())
    --hjj_for_wait:音效
    for k,v in pairs(self.list_coin) do 
        v:stopAllActions();
        v:setVisible(true)
        v:runAction(self:get_a_gold_animation())
        local  int_pos_x=math.random(0,self.the_size.width)
        local  int_pos_y=self.the_size.height+50+math.random(0,100)
        v:setPosition(cc.p(int_pos_x,int_pos_y))

        local move_time=math.random(0,50)/100+0.8
        local delay_time=math.random(0,150)/100

        local l_ac_1=cc.DelayTime:create(delay_time)
        local l_ac_2=cc.MoveTo:create(move_time, cc.p(int_pos_x, 0))
        local l_ac_3=cc.EaseBounceOut:create(l_ac_2)
        local l_ac_4=cc.MoveTo:create(0.2,cc.p(int_pos_x,-150))
        local l_ac_5=cc.DelayTime:create(1);
        local l_ac_6=cc.CallFunc:create(function(param_sender) self:on_play_finish(param_sender) end) 
        v:runAction(cc.Sequence:create(l_ac_1,l_ac_3,l_ac_4,l_ac_6))
    end
end
function UIGoldRain:on_play_finish(param_sender)
    --print("hjjlog>>on_play_finish",param_sender)
    param_sender:stopAllActions()
    param_sender:setVisible(false)
end



function UIGoldRain.ShowGoldRain(param_show)
    if sptr_gold_rain==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_gold_rain=UIGoldRain:create();
        main_layout:addChild(sptr_gold_rain)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_gold_rain:setLocalZOrder(bp_identifier())
    sptr_gold_rain:show_gold_rain()
    return sptr_gold_rain;
end

return UIGoldRain


