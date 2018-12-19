local UIMoneyRain=class("UIMoneyRain",function() return ccui.Layout:create() end);

function UIMoneyRain:ctor()
    print("hjjlog>>UIMoneyRain")
    self:init();
end
function UIMoneyRain:destory()
end

function UIMoneyRain:init()
    local  the_size=CCDirector:getInstance():getVisibleSize();
    self.the_size=the_size;
    self:setContentSize(self.the_size)

    
end

function UIExchangeCenter.ShowExchangeCenter(param_show,param_id)
    if sptr_exchange_center==nil  then 
        local main_layout=bp_get_main_layout();
        sptr_exchange_center=UIExchangeCenter:create();
        main_layout:addChild(sptr_exchange_center)
    end
    if param_show==nil then 
        param_show=true;
    end
    sptr_exchange_center:ShowGui(param_show)
    if param_id~=nil then 
        sptr_exchange_center:switch_item(param_id)
    end
    return sptr_exchange_center;
end




return UIMoneyRain