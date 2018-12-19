UiPhoneInfo=class("UiPhoneInfo",function() return control_tools.newImg({}) end)

function UiPhoneInfo:ctor()
    self._get_wifi_time=60
    self._get_battery_time=180
    self:init()
end

function UiPhoneInfo:init()
    self._m_data=control_tools.newImg({path=BPRESOURCE("res/phone_info/m_data.png")})
    self._m_data:setPosition(cc.p(-100,0))
    self._m_data:setVisible(false)
    self:addChild(self._m_data)

    self._wifi=control_tools.newImg({path=BPRESOURCE("res/phone_info/wifi.png")})
    self._wifi:setPosition(cc.p(-90,0))
    self._wifi:setVisible(false)
    self:addChild(self._wifi)

    self._time=control_tools.newImg({path=BPRESOURCE("res/phone_info/time.png")})
    self._time:setPosition(cc.p(-50,0))
    self:addChild(self._time)
    
    self._horologe=control_tools.newLabel({color=cc.c3b(116,164,144),font=22,str="10:32"})
    self._horologe:setPosition(cc.p(0,0))
    self:addChild(self._horologe)

    self._battery = control_tools.newImg({path=BPRESOURCE("res/phone_info/battery_2.png")})
    self._battery:setPosition(cc.p(65,0))
    self:addChild(self._battery)

    self:setVisible(false)
end

function UiPhoneInfo:scheduleHorologe(dt)
    self._horologe:setString(os.date("%H:%M"))
    self._get_wifi_time=self._get_wifi_time-dt
    if self._get_wifi_time==0 then
        self._get_wifi_time=60
        local wifi_status=0--game_tools.decode(get_wifi_status())
        if wifi_status==0 then
            self._wifi:setVisible(false)
            self._m_data:setVisible(true)
        else
            self._m_data:setVisible(false)
            self._wifi:setVisible(true)
        end
    end

    self._get_battery_time=self._get_battery_time-1

    if self._get_battery_time==0 then
        self._get_battery_time=180
        if get_curr_battery then
            local battery=100--game_tools.decode(get_curr_battery())
            battery=(battery*26/100+3)*100/32
            local level,_ = math.modf(battery/40)
            self._battery:loadTexture(the_path.."battery_"..(level+1)..".png")
        end
    end

end

function UiPhoneInfo:showPhoneInfo()
    local wifi_status=0--game_tools.decode(get_wifi_status())
    if wifi_status==0 then
        self._wifi:setVisible(false)
        self._m_data:setVisible(true)
    else
        self._m_data:setVisible(false)
        self._wifi:setVisible(true)
    end

    if get_curr_battery then
         local battery=100--game_tools.decode(get_curr_battery())
         battery=(battery*26/100+3)*100/32
         local level,_ = math.modf(battery/40)
         self._battery:loadTexture(the_path.."battery_"..(level+1)..".png")
    end

    self._get_wifi_time=60
    self._horologe:setString(os.date("%H:%M"))
    if self._schedule then
        sharedScheduler:unscheduleScriptEntry(self._schedule)
        self._schedule=nil
    end

    self._schedule=sharedScheduler:scheduleScriptFunc(function(dt) self:scheduleHorologe(dt) end , 1,false)

    self:setVisible(true)
end


function UiPhoneInfo:hidePhoneInfo()
    self:setVisible(false)
end

function UiPhoneInfo:destroy()
    if self._schedule then
        sharedScheduler:unscheduleScriptEntry(self._schedule)
        self._schedule=nil
    end
end

return UiPhoneInfo