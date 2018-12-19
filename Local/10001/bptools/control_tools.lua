--[[
*部分常用组件的封装。
*组件功能查看：全局搜索  tolua_usertype(tolua_S,"ccui.
]]--
local UILabelEx2=require("bptools/uilabelex2")
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
    elseif config_data.ex==true then 
        label=UILabelEx2:create();
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

function control_tools.XMLHttpRequest(param_url,param_fun)
    local xhr = cc.XMLHttpRequest:new() --创建一个请求
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING --设置返回数据格式为字符串
    print("hjjlog>>req:",param_url);
    xhr:open("GET", param_url) --设置请求方式  GET     或者  POST
    local function onReadyStateChange()  --请求响应函数
        bp_show_loading(0,"")
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                local statusString = "Http Status Code:"..xhr.statusText
                print("请求返回状态码"..statusString)
                local s = xhr.response
                print("返回的数据",s) 
                param_fun(s);
        end
    end
    xhr:registerScriptHandler(onReadyStateChange) --注册请求响应函数
    xhr:send()
    return xhr
end

-- -----------------
-- DY ADD
-- -----------------
function control_tools.newLayout(config_data)
    local layout = ccui.Layout:create()
    if config_data.clip ~= nil then
    	layout:setClippingEnabled(config_data.clip)
    end
    if config_data.size then
    	layout:setContentSize(config_data.size)
    end
    return layout
end

function control_tools.newScrollView(config_data)
	local scroll = ccui.ScrollView:create() 
	if config_data.direction then
		scroll:setDirection(config_data.direction)
	else
		scroll:setDirection(_G.SCROLLVIEW_DIR_VERTICAL)
	end
	if config_data.size then
		scroll:setContentSize(config_data.size)
	end
	if config_data.csize then
		scroll:setInnerContainerSize(config_data.csize)
	end
	return scroll
end

