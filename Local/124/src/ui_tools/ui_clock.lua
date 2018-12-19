--------------------------------------------------------------------------------
-- 计时器
--------------------------------------------------------------------------------
local ui_clock = class("ui_clock",function() return control_tools.newImg({}) end)

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function ui_clock:ctor(config_data)
    self._time = nil
    self._time_schedule = nil
    self._timeup_function = nil
    self._cur_time = 0
    self:init(config_data)
end

-- 初始化
function ui_clock:init(config_data)
    self:loadTexture(config_data.path, config_data.ctype)
    self:setScale(config_data.scale)

    self._time_clock_text= control_tools.newLabel({fnt = config_data.fnt, str = "15"})
    self._time_clock_text:setPosition(cc.p(self:getContentSize().width*config_data.scale/2, self:getContentSize().height*config_data.scale/2 + 1))
    self:addChild(self._time_clock_text)

    self.scheduler = CCDirector:getInstance():getScheduler()
end

-- 自动计时器
---@param dt number @deltaT
function ui_clock:scheduleTimer(dt)
    self._time=self._time-dt
    self._cur_time = self._cur_time + dt

    if self._time<-0.1 then
        self:setTime(0)
        if self._time_schedule then
            self.scheduler:unscheduleScriptEntry(self._time_schedule)
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
function ui_clock:setTime(int_num, bool_auto_count_down)
    if int_num > 99 then int_num = 99 end
    if int_num < 0 then int_num = 0 end
    if int_num < 10 then
        self._time_clock_text:setString("0"..math.floor(int_num))
    else
        self._time_clock_text:setString(""..math.floor(int_num))
    end
    self:setVisible(true)
    if bool_auto_count_down then
        self._time = int_num
        self._cur_time = 0
        if self._time_schedule then
            self.scheduler:unscheduleScriptEntry(self._time_schedule)
            self._time_schedule = nil
        end
        self._time_schedule = self.scheduler:scheduleScriptFunc(function(dt) self:scheduleTimer(dt) end , 0.1, false)
    end
end

-- 设置计时器结束的callback
---@param cb_function function @function() 计时器结束以后会调用
function ui_clock:setTimeUpFunc(cb_function)
    if cb_function and type(cb_function) == "function" then
        self._timeup_function = cb_function
    end
end

-- 隐藏
function ui_clock:hide()
    self:setVisible(false)
    if self._time_schedule then
        self.scheduler:unscheduleScriptEntry(self._time_schedule)
        self._time_schedule = nil
    end
    if self._timeup_function then
        self._timeup_function = nil
    end
end

function ui_clock:destroy()
    if self._time_schedule then
        self.scheduler:unscheduleScriptEntry(self._time_schedule)
        self._time_schedule = nil
    end
    if self._timeup_function then
        self._timeup_function = nil
    end
end

function ui_clock:getTime()
    if self:isVisible() then
        return tonumber(self._time_clock_text:getString())
    end
    return 0
end 

function ui_clock:pauseTime()
    if self._time_schedule then
        self.scheduler:unscheduleScriptEntry(self._time_schedule)
        self._time_schedule = nil
    end
end

function ui_clock:resumeTime()
    if self.scheduler then
        self:setTime(self:getTime(), true)
    end
end

return ui_clock
