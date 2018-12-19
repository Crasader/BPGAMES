
--------------------------------------------------------------------------------
-- 卡牌
--------------------------------------------------------------------------------
local card_sprite = class("card_sprite", function () return ccui.ImageView:create() end)

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function card_sprite:ctor(pos, scale)
    self.is_selected = false
    self:setTouchEnabled(false)

    self:loadTexture("00.png", 1)
    self:setPosition(pos)
    self:setScale(scale)

    self:init()
end
-- 初始化
function card_sprite:init()
    -- 选中标识
    self.img = control_tools.newImg({path = "card_mask.png", ctype = 1})
    self.img:setPosition(cc.p(self:getContentSize().width/2, self:getContentSize().height/2))
    self:addChild(self.img)
    self.img:setVisible(false)
    
    -- 地主标识    
    self.landlord = control_tools.newImg({path = "landlord_flag.png", ctype = 1})
    self.landlord:setPosition(cc.p(self:getContentSize().width/2 + 48, self:getContentSize().height/2 + 77))
    self.landlord:setVisible(false)
    self:addChild(self.landlord)
end
-- 设置地主牌
function card_sprite:set_landlord(boolean)
    self.landlord:setVisible(boolean)
end

function card_sprite:load_cards_png(card)
    local card_color = game_logic.get_card_color(card)
    local card_size = game_logic.get_real_card_size(card)

    local ptr_str_filename = nil
    if card_size >= 0 and card_size < 10 then
        ptr_str_filename = tostring(card_color .. card_size .. ".png")
    elseif card_size == 10 then
        ptr_str_filename = tostring(card_color .. "a.png") 
    elseif card_size == 11 then
        ptr_str_filename = tostring(card_color .. "b.png") 
    elseif card_size == 12 then
        ptr_str_filename = tostring(card_color .. "c.png") 
    elseif card_size == 13 then
        ptr_str_filename = tostring(card_color .. "d.png") 
    elseif card_size == 14 then
        ptr_str_filename = tostring(card_color .. "e.png") 
    elseif card_size == 15 then
        ptr_str_filename = tostring(card_color .. "f.png") 
    end
    
    self:loadTexture(ptr_str_filename, 1)
    self.card = card
end

function card_sprite:set_check(boolean)
    self.is_selected = boolean
end

function card_sprite:is_check()
    return self.is_selected
end

function card_sprite:set_mask(boolean)
    self.img:setVisible(boolean)
end

function card_sprite:is_mask()
    return self.img:isVisible()
end

function card_sprite:get_card()
    return self.card
end

return card_sprite
