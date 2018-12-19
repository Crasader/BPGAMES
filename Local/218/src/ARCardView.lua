ARCardView=class("ARCardView",function() return control_tools.newImg({}) end)
local the_path = BPRESOURCE("res/card/")
--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
function ARCardView:ctor(param_data)
    self._card_value = 0
    self._card_size = 0
    self._card_color = 0
    self._black_mask = nil
    self._color_mask = nil
    self._bool_select = false
    self._bool_mask = false
    self._bool_zl = false
    self._cai_logo = nil
    self._group = 0
    self:init(param_data)
end 

function ARCardView:init(param_data)
    if param_data then
        self:loadCardTexture(param_data)
    end
end 


function ARCardView:loadCardTexture(card)
    local card_color = game_logic.get_card_color(card)
    local card_size = game_logic.get_card_size(card)
    local ptr_str_filename = string.format("%02x",card)..".png"
    
    self:loadTexture(the_path..ptr_str_filename, 0)
    self._card_value = card
    self._card_color = card_color
    self._card_size = card_size

end

--整理牌的遮罩
function ARCardView:showColorMask(param_group)
    local l_group = param_group%2+1
    if not self._color_mask then
        self._color_mask = control_tools.newImg({path = the_path.."arr_mask_.."..l_group..".png", ctype = 0})
        self._color_mask:setPositionX(-2)
        self:addChild(self._color_mask,2)
    end
    self._color_mask:loadTexture(the_path.."arr_mask_"..l_group..".png", 0)
    self._color_mask:setVisible(true)
    self._bool_zl = true
end
function ARCardView:hideColorMask()
    if not self._color_mask then
        return
    end
    self._color_mask:setVisible(false)
    self._bool_zl = false
end
function ARCardView:isZhengLi()
    return self._bool_zl
end
function ARCardView:setGroup(param_group)
    if param_group == 0 then
        self:hideColorMask()
        self._group = 0
    else
        self:showColorMask(param_group)
        self._group = param_group
    end
end
function ARCardView:getGroup(param_group)
    return self._group 

end
--选牌时的黑色遮罩
function ARCardView:showBlackMask()
    if not self._black_mask then
        self._black_mask = control_tools.newImg({path = the_path.."img_mask.png", ctype = 0})
        --cocos 3.x 子节点默认位置为父节点的左下角 所以位置进行调整
        self._black_mask:setPosition(self._black_mask:getContentSize().width/2, self._black_mask:getContentSize().height/2)
        self:addChild(self._black_mask,3)
    end
    self._black_mask:setVisible(true)
    self._bool_mask = true
end
function ARCardView:hideBlackMask()
    if not self._black_mask then
        return
    end
    self._black_mask:setVisible(false)
    self._bool_mask = false
end
function ARCardView:isBlackMask()
    return self._bool_mask
end
--选中状态
function ARCardView:setSelect(bool_selector)
    self._bool_select = bool_selector
end
function ARCardView:getSelect()
    return self._bool_select
end
-- 牌值信息
function ARCardView:getValue()
    return self._card_value
end
function ARCardView:getSize()
    return self._card_size
end
function ARCardView:getColor()
    return self._card_color
end


return ARCardView
