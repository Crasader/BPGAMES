--[[
*部分常用组件的封装。
*组件功能查看：全局搜索  tolua_usertype(tolua_S,"ccui.
]]--
control_tools={}
function control_tools.newBtn(config_data)
    local btn=ccui.Button:create()
    config_data.ctype=config_data.ctype or 0
    if config_data.normal then
        if config_data.pressed then
			btn:loadTextures(config_data.normal,config_data.pressed,config_data.pressed,config_data.ctype)
		else
			btn:loadTextures(config_data.normal,"","",config_data.ctype)
		end
    end
    
	if config_data.small==true  then
            btn:setZoomScale(-0.1);
	end
    if config_data.size then
		btn:setScale9Enabled(true)
		btn:setContentSize(config_data.size)
	end
	if config_data.opacity then
		btn:setOpacity(config_data.opacity)
	end
	if config_data.scale then
		btn:setScale(config_data.scale)
	end
	if config_data.anchor then
		btn:setAnchorPoint(config_data.anchor)
	end
	return btn
end

function control_tools.newImg(config_data)  
    local img=ccui.ImageView:create();
	config_data.ctype=config_data.ctype or 0

	if config_data.path then
		img:loadTexture(config_data.path,config_data.ctype)
	end
	if config_data.cap_insert then
		img:setCapInsets(config_data.cap_insert)
	end
	if config_data.size then
		img:setScale9Enabled(true)
		img:setContentSize(config_data.size)
	end
	if config_data.opacity then
		img:setOpacity(config_data.opacity)
	end
	if config_data.scale then
		img:setScale(config_data.scale)
	end
	if config_data.anchor then
		img:setAnchorPoint(config_data.anchor)
	end
	return img
end

function control_tools.newSpri(config_data)
	if not config_data.path then
		return
	end
	local sprite=nil
	if config_data.ctype==1 then
		sprite=cc.Sprite:createWithSpriteFrameName(config_data.path)
	else
		sprite=cc.Sprite:create(config_data.path)
	end
	if config_data.opacity then
		sprite:setOpacity(config_data.opacity)
	end
	if config_data.scale then
		sprite:setScale(config_data.scale)
	end
	if config_data.anchor then
		sprite:setAnchorPoint(config_data.anchor)
	end
	return sprite
end

function control_tools.newProgress(config_data)
	if not config_data.path then
		return
	end
	config_data.ctype=config_data.ctype or 0
	local spri=control_tools.newSpri({path=config_data.path,ctype=config_data.ctype})
	local progress=cc.ProgressTimer:create(spri)
	if config_data.type then
		progress:setType(config_data.type)
	end
	if config_data.changerate then
		progress:setBarChangeRate(config_data.changerate)
	end
	if config_data.midpoint then
		progress:setMidpoint(config_data.midpoint)
	end
	if config_data.reverse then
		progress:setReverseProgress(config_data.reverse)
	end
	return progress
end

function control_tools.newLabel(config_data)
    local label=nil;
    if config_data.fnt then 
        label=cc.Label:createWithBMFont(config_data.fnt,"")
    else 
        label =cc.Label:create();
    end
    if config_data.font then 
        label:setSystemFontSize(config_data.font)
    end
    if config_data.color then 
        label:setTextColor(config_data.color)
    end
    if config_data.str then 
        label:setString(config_data.str)
    end
    if config_data.anchor then
		label:setAnchorPoint(config_data.anchor)
	end
    return label

end

function control_tools.newScroll(config_data)
	local scroll=ccui.ScrollView:create() 
	if config_data.direction then
		scroll:setDirection(config_data.direction)
	else
		scroll:setDirection(_G.SCROLLVIEW_DIR_VERTICAL)
	end
	if config_data.size then
		scroll:setSize(config_data.size)
	end
	if config_data.csize then
		scroll:setInnerContainerSize(config_data.csize)
	end
	return scroll
end


