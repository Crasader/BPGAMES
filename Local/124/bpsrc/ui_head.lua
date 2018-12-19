local UIHead = class("UIHead", function() return ccui.ImageView:create() end)
local g_path = BPRESOURCE("bpres/head/")
local PlayerSex = {girl = 0, boy = 1}

function UIHead:ctor(config_data)
    print("BPSRC -- DY Log>>UIHead")
    self.param_user_data = nil
    self._extura_function = nil
    self.emotion_armature = nil
    self.direction = 0
    self._scale = 1
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(BPRESOURCE("bpres/bugle/") .."dh_dt_ltbq/dh_dt_ltbq.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(BPRESOURCE("bpres/head/") .."voice_armature/dh_dt_yuyin1.ExportJson")
    self:init(config_data)
    self:init_chat_bg()
    self:init_voice_bg()
end

function UIHead:init(config_data)
	self:setScale9Enabled(true)
	self:setContentSize(config_data.csize)
	self:addTouchEventListener(function (sender, eventType) self:touch_event(sender, eventType) end)
	self:setTouchEnabled(true)

	self.head_img = control_tools.newImg({path = g_path .. "unknow_sex_big.png", ctype = 0})
	self:addChild(self.head_img)
	self.head_img:setPosition(cc.p(self:getContentSize().width/2, self:getContentSize().height/2))
	self.head_img:setScale9Enabled(true)

	self.head_back = control_tools.newImg({path = config_data.path, ctype = config_data.ctype, size = config_data.size})
    self:addChild(self.head_back)
    self.head_back:setPosition(cc.p(self:getContentSize().width/2, self:getContentSize().height/2))

    
end

function UIHead:set_direction(direction)
	self.direction = direction
end

function UIHead:touch_event(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return 
	end
	if not self._extura_function then
		return 
	end
	self._extura_function()
end

function UIHead:set_head(param_width, param_height, param_user_data, bool_unkown)
	local bool_unkown_head = bool_unkown or false
	self.param_user_data = param_user_data

	-- 头像 
	if bool_unkown_head == true then
		self.head_img:loadTexture(g_path .. "unknow_sex_big.png", 0)
	else 
		self:set_real_head(self.param_user_data.wFaceID, self.param_user_data.cbGender)
    end
    
    -- 头像适配
    self._scale = param_width / self.head_img:getContentSize().width
    self.head_img:setScaleX(param_width / self.head_img:getContentSize().width)
    self.head_img:setScaleY(param_height / self.head_img:getContentSize().height)
end

function UIHead:update_head()
	if self.param_user_data == nil then
		return 
	end

	self:set_real_head(self.param_user_data.wFaceID, self.param_user_data.cbGender)
end

function UIHead:set_real_head(param_face_id, param_sex_id)
	if param_face_id == 0 then
		if param_sex_id == PlayerSex.girl then 
			self.head_img:loadTexture(g_path .. "girl_big.png", 0)
		elseif param_sex_id == PlayerSex.boy then
			self.head_img:loadTexture(g_path .. "boy_big.png", 0)
		end	
	else 
    	self.head_img:loadTexture("http://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png", 0)
    end
end

function UIHead:init_chat_bg()
	self.img_chat_bg = {}
	local pos = {cc.p(self:getContentSize().width - 24, self:getContentSize().height - 14), 
				cc.p(self:getContentSize().width - 24, 0), 
				cc.p(24, self:getContentSize().height - 14), 
				cc.p(24, 0)}
	local anchor_point = {cc.p(0, 0), cc.p(0, 1), cc.p(1, 0), cc.p(1, 1)}
	for i=1, 4 do
		local img = control_tools.newImg({path = g_path .. "chat_" .. i ..  ".png", ctype = 0, anchor = anchor_point[i]})
		self:addChild(img)
		img:setPosition(pos[i])
        img:setScale9Enabled(true)
		img:setVisible(false)
		table.insert(self.img_chat_bg, img)

		img.layout = control_tools.newLayout({clip = true, size = cc.size(200, 26), anchor = cc.p(0, 0.5)})
		img.layout:setPosition(cc.p(8, i % 2 ~= 0 and 32 or 22))
		img:addChild(img.layout)
	end
end

function UIHead:init_voice_bg()
	self.img_voice_bg = {}
	local pos = {cc.p(self:getContentSize().width - 25, self:getContentSize().height - 15), 
				cc.p(self:getContentSize().width - 25, 5), 
				cc.p(28, self:getContentSize().height - 15), 
				cc.p(28, 5)}
	local anchor_point = {cc.p(0, 0), cc.p(0, 1), cc.p(1, 0), cc.p(1, 1)}
	for i=1, 4 do
		local img = control_tools.newImg({path = g_path .. "voice_" .. i ..  ".png", ctype = 0, anchor = anchor_point[i]})
		self:addChild(img)
		img:setPosition(pos[i])
        img:setScale9Enabled(true)
		img:setVisible(false)
		table.insert(self.img_voice_bg, img)

		img.voice_armature = ccs.Armature:create("dh_dt_yuyin1")
	    img:addChild(img.voice_armature)  
	    img.voice_armature:setPosition(40, img:getContentSize().height/2+ (i%2 ~= 0 and 10 or 1)  )

	    img.second = control_tools.newLabel({str = "5''", size = 20, color = cc.c3b(125, 125, 125)})
	    img:addChild(img.second)
	    img.second:setPosition(cc.p(120, img.voice_armature:getPositionY()))

	    img:setTouchEnabled(true)
	    img:addTouchEventListener(function (sender, eventType) self:touch_voice(sender, eventType) end)
	end
end

function UIHead:play_emotion(index)
	-- 连续点击 清除之前表情（若不清楚 则之前表情继续播放）
	if self.emotion_armature ~= nil then
		self.emotion_armature:removeFromParent()
		self.emotion_armature = nil
	end

    self.emotion_armature = ccs.Armature:create("dh_dt_ltbq")
    self:addChild(self.emotion_armature )  
    self.emotion_armature :setPosition(self:getContentSize().width/2, self:getContentSize().height/2)  
    self.emotion_armature :getAnimation():play("dh_dt_ltbq" .. index, -1, 1)    
    self.emotion_armature :setScale(self._scale)

    local function animationEvent(armatureBack, movementType, movementID)
        if movementType ~= ccs.MovementEventType.START then
            armatureBack:removeFromParent()
            self.emotion_armature = nil
        end
    end
    self.emotion_armature:getAnimation():setMovementEventCallFunc(animationEvent)
end

function UIHead:play_chat(chat, direction)
	if not chat or chat == "" then return end

	if direction < 0 or direction > 4 then return end

	-- clear status
	for i = 1, 4 do
		self.img_chat_bg[i].layout:removeAllChildren()
		self.img_chat_bg[i]:stopAllActions()
		self.img_chat_bg[i]:setVisible(false)
	end

	local font_size = 26
	local chat_bg = self.img_chat_bg[direction]
	local label = control_tools.newLabel({str = chat--[["在见到传送阵还安然存在, 韩立心里一阵安慰"--]], font = font_size, color = cc.c3b(125, 125, 125), anchor = cc.p(0, 0.5)})
	label:setPosition(cc.p(0, chat_bg.layout:getContentSize().height/2))
	chat_bg.layout:addChild(label)

	-- 动作
	local function callback() 
		if label ~= nil then
			label:removeFromParent()
			label = nil
		end
		chat_bg:setVisible(false)		
	end
	local delay1 = action_tools.CCDelayTime(1)
	local callfunc = action_tools.CCCallFunc(callback)

	-- 文字的长度
	local text_len = label:getContentSize().width
	-- 移动距离
	local move_len = text_len - chat_bg.layout:getContentSize().width

	if move_len < 0 then
		if direction == 1 or direction == 4 then
        	chat_bg:setCapInsets(cc.rect(30, 24, 160, 40))
        else
        	chat_bg:setCapInsets(cc.rect(24, 15, 170, 40))
        end
        chat_bg:setContentSize(cc.size(label:getContentSize().width + 20, chat_bg:getContentSize().height))

		chat_bg:setVisible(true)
		chat_bg:runAction(action_tools.CCSequence(delay1, callfunc))
		return 
	end
	-- 一秒移动多少个文字的距离
	local speed = 2 
	-- 移动所需时间
	local time = math.floor(move_len/font_size/speed)

	local move_by = action_tools.CCMoveBy(time, cc.p(-move_len, 0))
	local delay2 = action_tools.CCDelayTime(1)

	chat_bg:setVisible(true)
	label:runAction(action_tools.CCSequence(delay1, move_by, delay2, callfunc))
end

function UIHead:touch_voice(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return 
	end

	if self.voice_second <= 0 then return end 

	if not self.voice_file or self.voice_file == "" then return end

	-- 播放语音 待添加
    AudioEngine.playEffect(self.voice_file)

	-- 播放语音动画
    sender.voice_armature:getAnimation():play("Animation1", -1, 1)    

    -- 时间显示
	local time = self.voice_second
	local function callback()
		time = time - 1
		sender.second:setString(tostring(time) .. "''")
		if time <= 0 then
			self.voice_second = 0

			sender.voice_armature:getAnimation():gotoAndPause(0)
			sender.second:stopAllActions()

			sender:stopAllActions()
			sender:runAction(action_tools.CCSequence(action_tools.CCDelayTime(1), action_tools.CCHide()))
		end
	end
	sender.second:runAction(action_tools.CCRepeatForever(action_tools.CCSequence(action_tools.CCDelayTime(1), action_tools.CCCallFunc(callback))))
end

function UIHead:play_voice(voice, second, direction)
	-- if not voice or voice == "" then return end

	if direction < 0 or direction > 4 then return end

	if second < 0 then return end

	-- clear status
	for i = 1, 4 do
		self.img_voice_bg[i].second:stopAllActions()
		self.img_voice_bg[i]:stopAllActions()
		self.img_voice_bg[i]:setVisible(false)
	end

	self.voice_second = second
	self.voice_file = voice

	-- 显示底框
	self.img_voice_bg[direction]:setVisible(true)
	-- 显示数字
	self.img_voice_bg[direction].second:setString(tostring(second) .. "''")
end

function UIHead:play_chat_by_type(chat, dir)
	print("=======================DY Log >> 根据聊天类型播放")
	temp_dir = dir or self.direction
	-- 表情
    if #chat == 6 then  
        local i, j = string.find(chat, "[EM]")
        if i ~= nil then 	
            self:play_emotion(tonumber(string.sub(chat, 5)))
            return 
        end
    end

    local begin_1, end_1 = string.find( chat, "mp3_file" )
    local begin_2, end_2 = string.find( chat, "mp3_time" )

    -- 语音
    if begin_1 ~= nil and end_1 ~= nil and begin_2 ~= nil and end_2 ~= nil then 
        local voice = json.decode(chat)
        self:play_voice(voice.mp3_file, voice.mp3_time, temp_dir)
        return 
    end
    
    -- 聊天
    self:play_chat(chat, temp_dir)
end

function UIHead:setExtraFunc(cb_function)
    if cb_function and type(cb_function) == "function" then
        self._extura_function = cb_function
    end
end

function UIHead:destory()
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(BPRESOURCE("bpres/bugle/") .."dh_dt_ltbq/dh_dt_ltbq.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(BPRESOURCE("bpres/head/") .."voice_armature/dh_dt_yuyin1.ExportJson")
end

return UIHead
