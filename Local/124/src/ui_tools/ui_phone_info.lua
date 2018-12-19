
--------------------------------------------------------------------------------
-- 手机信息
--------------------------------------------------------------------------------
local UIPhoneInfo = class("UIPhoneInfo",function() return ccui.ImageView:create() end)

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
function UIPhoneInfo:ctor()
    self._get_wifi_time = 60
    --self._get_battery_time=180
    self:init()
end

function UIPhoneInfo:init()
    self:loadTexture("bg_phone_info.png", 1)
    
    self._m_data = control_tools.newImg({path ="4G3.png", ctype = 1})
    self._m_data:setPosition(cc.p(self:getContentSize().width/2 - 45, self:getContentSize().height/2 + 1))
    self._m_data:setVisible(false)
    self:addChild(self._m_data)

    self._wifi = control_tools.newImg({path = "wifi3.png", ctype = 1})
    self._wifi:setPosition(cc.p(self:getContentSize().width/2 - 45, self:getContentSize().height/2 + 1))
    self._wifi:setVisible(false)
    self:addChild(self._wifi)

    self._horologe = control_tools.newLabel({fnt = g_path .. "text_font/number_doudizhu_shijian.fnt"})
    self._horologe:setPosition(cc.p(self:getContentSize().width/2 + 18, self:getContentSize().height/2 - 7))
    self:addChild(self._horologe)

    self:setVisible(false)
end

function UIPhoneInfo:showPhoneInfo()
    local wifi_status = 0 --[[json.decode(bp_get_wifi_status())--]]
    if wifi_status == 0 then
        self._wifi:setVisible(false)
        self._m_data:setVisible(true)
    else
        self._m_data:setVisible(false)
       self._wifi:setVisible(true)
    end

--    local battery=json.decode(get_curr_battery())
--    battery=(battery*26/100+3)*100/32
--    self._bg_battery:setPercentage(battery)
--    self._bg_battery:setVisible(true)

    self._get_wifi_time = 60
    self._horologe:setString(os.date("%H:%M"))
    if self._schedule then
        CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._schedule)
        self._schedule = nil
    end
    self._schedule = CCDirector:getInstance():getScheduler():scheduleScriptFunc(function(dt) self:scheduleHorologe(dt) end , 1,false)
    self:setVisible(true)
end

function UIPhoneInfo:hidePhoneInfo()
    self:setVisible(false)
end

function UIPhoneInfo:scheduleHorologe(dt)
    self._horologe:setString(os.date("%H:%M"))
    self._get_wifi_time = self._get_wifi_time - dt
    if self._get_wifi_time == 0 then
        self._get_wifi_time = 60
        local wifi_status = 0--[[json.decode(get_wifi_status())--]]
        if wifi_status == 0 then
            self._wifi:setVisible(false)
            self._m_data:setVisible(true)
        else
            self._m_data:setVisible(false)
            self._wifi:setVisible(true)
        end
    end
--    self._get_battery_time=self._get_battery_time-1
--    if self._get_battery_time==0 then
--        self._get_battery_time=180
--        local battery=json.decode(get_curr_battery())
--        battery=(battery*26/100+3)*100/32
--        self._bg_battery:setPercentage(battery)
--    end
end
function UIPhoneInfo:destory()
    if self._schedule then
        CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._schedule)
        self._schedule=nil
    end
end

return UIPhoneInfo
