--region MyUILabel.lua
--Author : ss
--Date   : 2016/11/29
--此文件由[BabeLua]插件自动生成
UILabelEx2=class("UILabelEx2",function() return cc.Label:create() end)

function UILabelEx2:ctor()
    self:init()
end

function UILabelEx2:init()
    return true
end

function UILabelEx2:setTextEx(param_str,param_width,param_type)
    if param_type==nil then 
        param_type=0;
    end
    self:setString(param_str)
    if self:getContentSize().width<=param_width then
        return
    end
    local id=1
    local table_text={}
    while id<=#param_str do
    	local byte_value=string.byte(string.sub(param_str,id,id))
    	if byte_value>=0xF0 then
    		table.insert(table_text,string.sub(param_str,id,id+3))
            id=id+4
    	elseif byte_value>=0xE0 then
    		table.insert(table_text,string.sub(param_str,id,id+2))
            id=id+3
    	elseif byte_value>=0xC0 then
    		table.insert(table_text,string.sub(param_str,id,id+1))
            id=id+2
    	else
    		table.insert(table_text,string.sub(param_str,id,id))
            id=id+1
    	end
    end

    local text_size=self:getSystemFontSize()
    local str_value=""
    local now_str=""
    if param_type==0 then 
        for i=1,#table_text,1 do
            self:setString(now_str..table_text[i])
            if self:getContentSize().width > param_width then
                str_value=str_value..now_str
                str_value=str_value.."..."
                break ;	
            else
                now_str=now_str..table_text[i]
                if i==#table_text then
                    str_value=str_value..now_str
                end
            end
        end
        self:setString(str_value)
    elseif param_type==3 then 
        for i=1,#table_text,1 do
            self:setString(str_value..table_text[i])
            if self:getContentSize().width > param_width then
                str_value=str_value.."\n"
                str_value=str_value..table_text[i]
            else
                str_value=str_value..table_text[i]
            end
        end
        self:setString(str_value)
    end
end

return UILabelEx2
--endregion
