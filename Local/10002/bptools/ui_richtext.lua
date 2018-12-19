
local UIRichTextEx = class("UIRichTextEx", function() return ccui.RichText:create() end)

--------------------------------------------------------------------------------
-- RRGGBB to c3b
--------------------------------------------------------------------------------
local function c3b_parse(s)
	local r, g, b = tonumber(string.sub(s, 1, 2), 16),
					tonumber(string.sub(s, 3, 4), 16),
					tonumber(string.sub(s, 5, 6), 16)
	return cc.c3b(r, g, b)
end

--------------------------------------------------------------------------------
-- string to opacity
--------------------------------------------------------------------------------
local function opacity_parse(s)
	return tonumber(string.sub(s, 1, 2), 16)
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
function UIRichTextEx:ctor(font_size, font_color, font_type, text_size)
	self:init(font_size, font_color, font_type, text_size)
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
function UIRichTextEx:init(font_size, font_color, font_type, text_size)
	self._fontSize		= font_size or 26
	self._textColor		= font_color or cc.c3b(255, 255, 255)
	self._fontType 		= font_type or "Arial"
	self._textSize		= text_size or cc.size(99999999, self._fontSize)
	self._elements		= {}

	self:setContentSize(self._textSize)
	--self:setMultiLineMode(true)
	self:setAnchorPoint(cc.p(0, 0))
    self:setTouchEnabled(false)
    if font_size==nil then 
        self:ignoreContentAdaptWithSize(true)
    else
        self:ignoreContentAdaptWithSize(false)
    end
end

-----------------------------------------------------------------------------
-- 多行模式，要设置 ignoreContentAdaptWithSize(false) 和设置 setContentSize()
-----------------------------------------------------------------------------
function UIRichTextEx:setMultiLineMode(b)
	self:ignoreContentAdaptWithSize(not b)
end
-----------------------------------------------------------------------------
-- 设置默认颜色
-----------------------------------------------------------------------------
function UIRichTextEx:setNormalColor(param_color)
	self._textColor=param_color;
end
-----------------------------------------------------------------------------
-- 显示文本
-----------------------------------------------------------------------------
function UIRichTextEx:setTextEx(text)
	assert(text)
	-- clear
	for i, v in pairs(self._elements) do
		self:removeElement(v)
	end
	self._elements = {}

	if string.len(text) < 24 or string.find(text, "<color value=0x") == nil then
		local element = ccui.RichElementText:create(0, self._textColor, 255, text, self._textFont, self._fontSize)
		self:pushBackElement(element)
        table.insert(self._elements, element)
        self:formatText()
        self._textSize = self:getVirtualRendererSize()
        self:setContentSize(self._textSize)
		return 
	end
	
	-- 寻找字体颜色位置 
	local i, color_count, color_pos = 1, 0, {}
	while i < string.len(text) do
		local pos = {}
		pos[1], pos[2] = string.find(text, "<color value=0x", i)
		if pos[1] == nil and pos[2] == nil then
			break
		else
			table.insert(color_pos, pos)
			color_count = color_count + 1
			i = pos[2] + 9
		end	
	end

	-- 根据字体颜色位置 显示文本内容
	for i,v in ipairs(color_pos) do
		local element = nil
		if (i == 1 and color_pos[1][1] ~= 1) then
			element = ccui.RichElementText:create(0, self._textColor, 255, string.sub(text, 1, v[1] - 1), self._textFont, self._fontSize)
			self:pushBackElement(element)
			table.insert(self._elements, element)

			element = nil
		end
		
		local color_str = string.sub(text, v[2] + 1, v[2] + 8)	
		local opacity = opacity_parse(string.sub(color_str, 1, 2))
		local color = c3b_parse(string.sub(color_str, 3, 8))
		if (i ~= color_count) then
			element = ccui.RichElementText:create(0, color, opacity, string.sub(text, v[2]+10, color_pos[i+1][1] - 1), self._textFont, self._fontSize)
		else 
			element = ccui.RichElementText:create(0, color, opacity, string.sub(text, v[2]+10, string.len(text)), self._textFont, self._fontSize)
		end

		if element ~= nil then
			self:pushBackElement(element)
			table.insert(self._elements, element)
		end
	end

	-- 更新文本框实际大小
	self:formatText()
    self._textSize = self:getVirtualRendererSize()
	self:setContentSize(self._textSize)
end

-----------------------------------------------------------------------------
-- 富文本渐显渐隐action
-----------------------------------------------------------------------------
function UIRichTextEx:setFadeAction(bool_FadeIn)
	if bool_FadeIn == true then
		for k,v in pairs(self._elements) do
			v:setOpacity(0)
			v:stopAllActions();
			v:runAction(cc.FadeIn:create(1))
		end
	else
		for k,v in pairs(self._elements) do
			v:setOpacity(255)
			v:stopAllActions();
			v:runAction(cc.FadeOut:create(1))
		end
	end
end

-----------------------------------------------------------------------------
-- 获取文本大小
-----------------------------------------------------------------------------
function UIRichTextEx:getTextSize()
	return self._textSize
end


return UIRichTextEx