UiTimeClock=class("UiTimeClock",function() return control_tools.newImg({}) end)

function UiTimeClock:ctor()
    self._time = nil
    self._time_schedule = nil
    self._timeup_function = nil
    self._cur_time = 0
    self:init()
end

function UiTimeClock:init()
    self:loadTexture(BPRESOURCE("res/time_clock.png"))

    self._time_clock_text= control_tools.newLabel({fnt=BPRESOURCE("res/text_font/number_shuangkou_daojishi.fnt")})
    self._time_clock_text:setPosition(cc.p(42,44.5))
    self:addChild(self._time_clock_text)
    --self._time_clock_text:setVisible(false)
end

-- 自动计时器
---@param dt number @deltaT
function UiTimeClock:scheduleTimer(dt)
    self._time=self._time-dt
    self._cur_time = self._cur_time + dt
    if self._time<-0.1 then
        self:setTime(0)
        if self._time_schedule then
            CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
            --CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self._time_schedule)
            self._time_schedule=nil
            if self._timeup_function then
                self._timeup_function()
            end
        end
    elseif self._time<0 then
        self:setTime(0)
    else
        local num=math.modf(self._time)
        self:setTime(num+1)
    end
end


-- 设置计时器数字
---@param int_num int
---@param bool_auto_count_down bool @是否自动倒计时
function UiTimeClock:setTime(int_num, bool_auto_count_down)
    if int_num > 99 then int_num = 99 end
    if int_num < 0 then int_num = 0 end
    if int_num < 10 then
        self._time_clock_text:setString("0"..math.floor(int_num))
    else
        self._time_clock_text:setString(""..math.floor(int_num))
    end
    if bool_auto_count_down then
        self._time = int_num
        self._cur_time = 0
        if self._time_schedule then
            CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
            self._time_schedule=nil
        end
        self._time_schedule=CCDirector:getInstance():getScheduler():scheduleScriptFunc(function(dt) self:scheduleTimer(dt) end , 0.1,false)
    end
end

-- 设置计时器结束的callback
---@param cb_function function @function() 计时器结束以后会调用
function UiTimeClock:setTimeUpFunc(cb_function)
    if cb_function and type(cb_function) == "function" then
        self._timeup_function = cb_function
    end
end


function UiTimeClock:hide()
    self:setVisible(false)
    if self._time_schedule then
        CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
        self._time_schedule=nil
    end
end

function UiTimeClock:destroy()
    if self._time_schedule then
        CCDirector:getInstance():getScheduler():unscheduleScriptEntry(self._time_schedule)
        self._time_schedule=nil
    end
end

return UiTimeClock