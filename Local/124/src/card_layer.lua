--------------------------------------------------------------------------------
-- 卡牌界面
--------------------------------------------------------------------------------
local card_layer = class("card_layer", function() return ccui.Layout:create() end)
local card_sprite = require("src/card_sprite")

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function card_layer:ctor( visibleSize )
    self.card_scale = 0.7
    self.out_scale = 0.4
    self.game_layer = {}
    self.hand_cards = {}
    self:setContentSize(visibleSize)
    self:init(visibleSize)
end
-- 初始化
function card_layer:init( visibleSize )
    self:addTouchEventListener(function (sender, eventType) self:touch_event(sender, eventType) end)
end
-- 设置父层级
function card_layer:set_game_layer( game_layer )
    self.game_layer = game_layer
end
-- 显示地主角标
function card_layer:show_landlord_tag(viewid, card, index, count)
    count = count or #self.game_layer.struct_hand_cards
    if self.game_layer.user_identity == nil or self.game_layer.user_identity == {} then
        card:set_landlord(false)
    else
        card:set_landlord(self.game_layer.user_identity[viewid] == UserIdentity.landlord and index == count)
    end
end
-- 创建一个卡牌
function card_layer:get_one_card()
    local temp_card = nil
    if self.sleep_cards == nil or #self.sleep_cards == 0 then
        temp_card = card_sprite:create(cc.p(self:getContentSize().width/2, self:getContentSize().height*2/5 + 20), self.card_scale)
        self:addChild(temp_card)
    else
        temp_card = self.sleep_cards[1]
        temp_card:setScale(self.card_scale)
        table.remove(self.sleep_cards, 1)
    end
    return temp_card
end
-- 回收一个卡牌
function card_layer:recycle_one_card(card)
    self.sleep_cards = self.sleep_cards or {}
    if card then
        card:setVisible(false)
        card:setScale(self.card_scale)
        table.insert(self.sleep_cards, card)
        card:set_landlord(false)
    end
end
-- 是否和手牌值一样
function card_layer:is_same_cards(hand_cards)
    if self.hand_cards == nil then
        return false
    end
    local count = 0
    local is_same = true
    for k,v in pairs(self.hand_cards) do
        if v then
            count = count + 1
            if v:get_card() ~= hand_cards[count] then
                is_same = false
                break
            end
        end
    end
    return is_same
end
-- 获取手牌数量
function card_layer:get_cards_count()
    local count = 0
    if self.hand_cards == nil then
        return count
    end
    for k, v in pairs(self.hand_cards) do
        if v then
            count = count + 1
        end
    end

    return count
end
-- 获取出牌数量
function card_layer:get_outcards_count(viewid)
    local count = 0
    local cards_tbl = {}
    if self.out_cards == nil then
        return count, cards_tbl
    end

    if self.out_cards[viewid+1] == nil then
        return count, cards_tbl
    end
    
    for k, v in pairs(self.out_cards[viewid+1]) do
        if v then
            count = count + 1
            table.insert(cards_tbl, v:get_card())
        end
    end

    return count, cards_tbl
end
-- 显示手牌数量
function card_layer:show_cards_count()
    local temp_time = 0
    local count = 0
    local function update_cards(dt)
        temp_time = temp_time + dt
        if temp_time > SEND_CARD_SPEED then
            temp_time = 0
            count = count + 1
        else
            return 
        end
        for j=1, GAME_PLAYER do
            if j ~= LocalSelfChairId + 1 then
                self.game_layer.game_user:set_cards_count(j-1, count)
            end
        end
        if count == 17 then
            self:unscheduleUpdate()
        end
    end
    self:scheduleUpdateWithPriorityLua(update_cards, 0)
end
-- 移动到目标位置
function card_layer:move_to_target_pos(pos, cards_count)
    self:show_cards_count()
    local time, count = 0, 0
    for k,v in pairs(self.hand_cards) do
        count = count + 1
        v:stopAllActions()
        local pos_x = math.floor(self:getContentSize().width/2 - (pos * (cards_count - 1))/2  + pos*(k - 1))  
        local pox_y = self:get_posY()
        local delay = action_tools.CCDelayTime(SEND_CARD_SPEED*(count-1))
        local moveto = action_tools.CCMoveTo(SEND_CARD_SPEED, pos_x, pox_y)
        
        if count == cards_count then
            local function callback()
                local value = bind_function.restore_message()
                print("=============== 恢复消息 value = ", value)
                AudioEngine.stopEffect(self.game_layer.send_cards_effectid)    
            end
            local call_back = action_tools.CCCallFunc(callback)
            v:runAction(action_tools.CCSequence(delay, moveto, call_back))
        else
            v:runAction(action_tools.CCSequence(delay, moveto))    
        end        
    end
end
-- 显示手牌
function card_layer:show_hand_cards(isAni, cards_count, cards_data)
    self:clear_hand_cards()

    self.move_pos = (self:getContentSize().width - 220*0.7) / 16
    local pos = cards_count > 17 and (self:getContentSize().width -  220*0.7) / (cards_count - 1) or self.move_pos
    local start_posX = self:getContentSize().width/2 - (cards_count - 1) * pos/2
    
    local num, posX, posY = 0, 0, self:get_posY() 
    for i,v in ipairs(cards_data) do
        if v and v ~= 0 then
            local card = self:get_one_card()
            card:load_cards_png(v)
            card:setLocalZOrder(i)
            card:set_mask(false)
            card:set_check(false)
            card:setVisible(true)
            self:show_landlord_tag(LocalSelfChairId, card, i, cards_count)

            if isAni then
                posX = self:getContentSize().width+card:getContentSize().width/2
            else
                posX, posY = math.floor(start_posX + pos*(i - 1)), self:get_posY()
                if cards_count == MAX_HAND_CARDS then
                    for j=1, BASE_CARDS_COUNT do
                        if v == self.game_layer.struct_base_cards[j] then
                            posY = posY + 20
                            break
                        end
                    end
                end
            end
            card:setPosition(cc.p(posX, posY))
            table.insert(self.hand_cards, card)

            if posY == self:get_posY()+ 20 then
                num = num + 1
                local delay = action_tools.CCDelayTime(1.5)
                local moveto = action_tools.CCMoveTo(0.1, posX, self:get_posY())
                if num == BASE_CARDS_COUNT then
                    local function callback()
                        print("================可以点击啦==================")
                        self:setTouchEnabled(true)
                    end
                    local call_back = CCCallFunc:create(callback)
                    card:runAction(action_tools.CCSequence(delay, moveto, call_back))
                else
                    card:runAction(action_tools.CCSequence(delay, moveto))    
                end            
            end
        end
    end
    if isAni then
        self:move_to_target_pos(pos, cards_count)
    else
        print("================能不能点击啊==================", self.game_layer.user_identity[LocalSelfChairId+1] ~= UserIdentity.null)
        self:setTouchEnabled(self.game_layer.user_identity[LocalSelfChairId+1] ~= UserIdentity.null)
    end
end
-- 清除手牌
function card_layer:clear_hand_cards()
    if self.hand_cards == nil then
        self.hand_cards = {}
        return 
    end
    
    for k,v in pairs(self.hand_cards) do
        if v then
            v:stopAllActions()
            self:recycle_one_card(v)
        end
    end
    self.hand_cards = {}
end
-- 清除出牌
function card_layer:clear_out_cards(viewid)
    if viewid < 0 or viewid > 2 then
        return 
    end

    if self.out_cards == nil then
        self.out_cards = {}
    end

    if self.out_cards[viewid+1] == nil then
        self.out_cards[viewid+1] = {}
        return 
    end

    for k,v in pairs(self.out_cards[viewid+1]) do
        if v then
            v:stopAllActions()
            v:setVisible(false)
            self:recycle_one_card(v)
        end
    end
    self.out_cards[viewid+1] = {}
end
-- 初始化出牌
function card_layer:init_out_cards(viewid, out_cards, count, is_sort)
    if is_sort == nil then
        is_sort = true
    end

    if viewid < 0 or viewid > 2 then
        return 
    end

    self:clear_out_cards(viewid)

    if count <= 0 then
        return
    end
    
    if count > 3 then
        game_logic.sort_cards_by_size(out_cards, count)
    end

    local cards_tbl = nil
    if is_sort == true and count > 3 then
        cards_tbl = game_logic.sort_cards_by_count(out_cards, count) 
    else
        cards_tbl = out_cards
    end

    local width, card_width = 0, 0
    for i=1, count do
        local card = self:get_one_card()
        card:load_cards_png(cards_tbl[i])
        card:setLocalZOrder(i)
        card:setScale(self.out_scale)
        card:setVisible(true)
        card:set_mask(false)
        table.insert(self.out_cards[viewid+1], card)
        self:show_landlord_tag(viewid, card, i, count)

        if i == count then
            width = width + card:getContentSize().width
        else
            width = width + 20
        end

        card_width = card:getContentSize().width
    end
    local pos = {cc.p(self:getContentSize().width-230, self:getContentSize().height-205), 
                    cc.p(self:getContentSize().width/2, self:getContentSize().height*2/5+20), 
                    cc.p(230, self:getContentSize().height -205)}
    if viewid == 0 then
        if width > (card_width + 20*9) then
            width = card_width + 20*9            
        end
        local index = 0
        local posX = pos[viewid+1].x - width + card_width
        local posY = pos[viewid+1].y
        for i,v in ipairs(self.out_cards[viewid+1]) do
            index = index + 1
            if index == 11 then
                posX = pos[viewid+1].x - width + card_width
                posY = pos[viewid+1].y-29
            end
            v:setPosition(cc.p(posX, posY))
            posX = posX + 20
        end
    elseif viewid == 1 then
        local posX = self:getContentSize().width/2 - (count-1)*20/2 - 20
        local posY = pos[viewid+1].y
        for i,v in ipairs(self.out_cards[viewid+1]) do
            posX = posX + 20
            v:setPosition(cc.p(posX, posY))
        end
    elseif viewid == 2 then
        if width > (card_width + 20*9) then
            width = card_width + 20*9            
        end
        local index = 0
        local posX = pos[viewid+1].x
        local posY = pos[viewid+1].y
        for i,v in ipairs(self.out_cards[viewid+1]) do
            index = index + 1
            if index == 11 then
                posX = pos[viewid+1].x 
                posY = pos[viewid+1].y-29
            end
            v:setPosition(cc.p(posX, posY))
            posX = posX + 20
        end
    end
end
-- 显示出牌
function card_layer:show_out_cards()
    self:clear_out_cards(LocalSelfChairId)
    
    local cards_tbl, count = {}, 0
    for k,v in pairs(self.hand_cards) do
        if v:is_check() == true then
            table.insert(self.out_cards[LocalSelfChairId+1], v)
            table.insert(cards_tbl, v:get_card())
            count = count + 1
        end
    end

    cards_tbl = game_logic.sort_cards_by_count(cards_tbl, count)

    for i,value in ipairs(cards_tbl) do
        for k,v in pairs(self.hand_cards) do
            if v:is_check() == true and v:get_card() == value then
                v:set_check(false)
                v:setLocalZOrder(i)
                self:show_landlord_tag(LocalSelfChairId, v, i, count)
                local start_x = self:getContentSize().width/2 - (self.temp_outcards_count-1)*25/2 + 25*(i-1)
                local action_move = action_tools.CCMoveTo(0.2, start_x, self:getContentSize().height*2/5+30)
                local action_scale = action_tools.CCScaleTo(0.2, self.out_scale)
                v:stopAllActions()
                v:runAction(action_tools.CCSpawn(action_move, action_scale))
            end
        end
    end

    for i = #self.hand_cards, 1, -1 do
        for m,n in pairs(self.temp_out_cards) do
            if n == self.hand_cards[i] then
                table.remove(self.hand_cards, i)
                table.remove(self.game_layer.struct_hand_cards, i)
                break
            end
        end
    end
    self:update_hand_cards(#self.hand_cards)
end
-- 更新手牌
function card_layer:update_hand_cards(count)
    local posX = 0
    local cards_num = 0
    local pos = count >= 17 and ((self:getContentSize().width - 120) / count) or self.move_pos
    for k,v in pairs(self.hand_cards) do
        if v:is_check() then
            v:set_check(false)
            v:stopAllActions()
            v:runAction(action_tools.CCMoveTo(0, v:getPositionX(), self:get_posY()))
        end
        if v and v ~= nil then
            cards_num = cards_num + 1
            local posX = self:getContentSize().width/2 - (pos * (count - 1))/2 + pos*(cards_num - 1)        
            v:runAction(action_tools.CCMoveTo(0.2, posX, self:get_posY()))
        end
        self:show_landlord_tag(LocalSelfChairId, v, k)
    end
end
-- 显示选中牌
function card_layer:show_choose_card(tbl)
    self.temp_out_cards = {}
    self.temp_outcards_count = 0
    for i,v in ipairs(self.hand_cards) do
        if v:is_check() == true then
            local is_have = false
            for key, value in ipairs(tbl) do
                if value == v:get_card() then
                    table.insert(self.temp_out_cards, v)
                    self.temp_outcards_count = self.temp_outcards_count + 1
                    is_have = true
                    break
                end
            end
            if is_have == false then
                v:runAction(action_tools.CCMoveTo(0.1, v:getPositionX(), self:get_posY()))
                v:set_check(false)
            end
        else
            for key, value in ipairs(tbl) do
                if value == v:get_card() then
                    v:runAction(action_tools.CCMoveTo(0.1, v:getPositionX(), self:get_posY() + 20))
                    table.insert(self.temp_out_cards, v)
                    self.temp_outcards_count = self.temp_outcards_count + 1
                    v:set_check(true)
                    break
                end
            end
        end
    end
    self.game_layer.btn_outcards:setBright(self.temp_outcards_count ~= 0)
    self.game_layer.btn_outcards:setTouchEnabled(self.temp_outcards_count ~= 0)
end
-- 寻找手牌中是否有此牌
function card_layer:search_cards(card)
    local is_have = true
    for i,v in ipairs(self.game_layer.struct_hand_cards) do
        if v == card then
            is_have = false
            break
        end
    end
    return is_have
end
-- 获取出牌牌值
function card_layer:get_out_cards()
    if self.temp_out_cards == nil then
        return 
    end
    local cards_tbl = {}
    for i,v in ipairs(self.temp_out_cards) do
        if v and self:search_cards(v) then
            print("card_value = ", v:get_card())
            table.insert(cards_tbl, v:get_card())
        end
    end

    return cards_tbl
end
-- 从手牌中寻找选中牌
function card_layer:check_temp_outcards()
    self.temp_outcards_count = 0
    self.temp_out_cards = {}
    for i,v in ipairs(self.hand_cards) do
        if v:is_check() == true then
            self.temp_outcards_count = self.temp_outcards_count + 1
            table.insert(self.temp_out_cards, v)
        end
    end
end
-- 是否能出牌
function card_layer:whether_choose_outcards()
    local isShow = false

    if self.temp_outcards_count ~= 0 and self.temp_outcards_count ~= nil then
        local cards1 = self.game_layer.struct_max_outcards
        local count1 = self.game_layer.max_outcards_count
        local cards2 = self:get_out_cards()
        local count2 = self.temp_outcards_count
        game_logic.sort_cards_by_size(cards2, count2)
        self.temp_outcards_type = game_logic.get_outcards_type(cards2, count2)
        self.is_follow = count1 ~= 0 and true or false
        print("self.is_follow = ", self.is_follow)
        if (count1 == 0 and self.temp_outcards_type ~= KindCards.cards_error) or 
            (count1 ~= 0 and game_logic.cards_compare(cards1, count1, cards2, count2) == true) then
            isShow = true
        end
    end

    print("self.temp_outcards_count = ", self.temp_outcards_count)
    self.game_layer.btn_outcards:setBright(isShow)
    self.game_layer.btn_outcards:setTouchEnabled(isShow)
end
-- 顺子两边选中 中间自动选中
function card_layer:is_auto_supplement()
    if self.temp_outcards_count < 2 then
        return
    end

    for i,v in ipairs(self.temp_out_cards) do
        if i ~= self.temp_outcards_count then
            if game_logic.get_card_size(v:get_card()) == game_logic.get_card_size(self.temp_out_cards[i+1]:get_card()) then
                return 
            end
        end
    end

    local temp_pos = {}
    for i,v in ipairs(self.hand_cards) do
        if v:is_check() == true then 
            table.insert(temp_pos, i)
        end
    end

    if game_logic.get_card_size(self.game_layer.struct_hand_cards[temp_pos[1]]) >= 15 then
        return 
    end

    if game_logic.get_card_size(self.game_layer.struct_hand_cards[temp_pos[1]]) <= game_logic.get_card_size(self.game_layer.struct_hand_cards[temp_pos[#temp_pos]]) + 3 then
        return 
    end

    local need_pos = {}
    for i=temp_pos[1], temp_pos[#temp_pos]-1 do
        local card = game_logic.get_card_size(self.game_layer.struct_hand_cards[i])
        local next_card = game_logic.get_card_size(self.game_layer.struct_hand_cards[i+1])

        if card == next_card or card == next_card + 1 then
            if card == next_card + 1 and card ~= game_logic.get_card_size(self.game_layer.struct_hand_cards[temp_pos[1]]) then
                local is_same = false
                for j,v in ipairs(self.temp_out_cards) do
                    if card == game_logic.get_card_size(v:get_card()) then
                        is_same = true
                        break
                    end
                end
                if not is_same then
                    table.insert(need_pos, i)
                end
            end
        else
            return
        end
    end

    table.insert(need_pos, temp_pos[#temp_pos])
    for i,v in ipairs(need_pos) do
        local card = self.hand_cards[v]
        if card:is_check() == false then
            card:set_check(true)
            card:runAction(action_tools.CCMoveTo(0.1, card:getPositionX(), self:get_posY() + 20))
            self.temp_outcards_count = self.temp_outcards_count + 1
            table.insert(self.temp_out_cards, card)
        end
    end
end
-- 选中牌向下移动
function card_layer:choose_cards_move_down()
    if self.hand_cards == nil then
        return
    end
    for i,v in ipairs(self.hand_cards) do
        if v:is_check() == true then
            v:set_check(false)
            v:runAction(action_tools.CCMoveTo(0.1, v:getPositionX(), self:get_posY()))
        end
    end
end
-- 双击
function card_layer:click_two()
    self.is_click_two = false
    self:choose_cards_move_down()
    self.temp_out_cards = {}
    self.temp_outcards_count = 0
    self.game_layer.hint_index = self.game_layer.hint_index - 1
    if self.game_layer.hint_index == 0 then
        if self.game_layer.hint_cards_data ~= nil and #self.game_layer.hint_cards_data ~= 0 then
            self.game_layer.hint_index = #self.game_layer.hint_cards_data 
        else
            self.game_layer.hint_index = 1
        end
    end
end
-- 点击区域
function card_layer:touchTest(sender, pos)
    local width = sender:getContentSize().width * sender:getScale()
    local height = sender:getContentSize().height * sender:getScale()

    local posx = sender:getPositionX()
    local posy = sender:getPositionY()
    
    local rect = cc.rect(posx - width/2, posy - height/2, width, height)
    
    return cc.rectContainsPoint(rect, pos)
end
-- 点击事件
function card_layer:touch_event(sender, eventType)
    if self.game_layer.bg_menu and self.game_layer.bg_menu:isVisible() then 
        self.game_layer.game_menu:open_menu(false)         
    end

    if self.hand_cards == nil or self.hand_cards == {} then
        print("==============不能点击=================")
        return 
    end

    if eventType == _G.TOUCH_EVENT_BEGAN then
        local is_touch_card = false
        for i = #self.hand_cards, 1, -1 do
            if ui_tools.hitTest(self.hand_cards[i], sender:getTouchBeganPosition()) == true then
                AudioEngine.playEffect(MUSIC_PATH.normal[0])
                self.hand_cards[i]:set_mask(true)
                is_touch_card = true
                break  
            else
                is_touch_card = false
            end        
        end

        if not is_touch_card then
            self:stopAllActions()
            self.click_count = self.click_count or 0
            self.click_count = self.click_count + 1
            if self.click_count == 2 then
                self.click_count = 0
                self.is_click_two = true 
            end
            if not self.is_click_two then 
                local function callback()
                    self.click_count = 0
                end
                self:runAction(action_tools.CCSequence(action_tools.CCDelayTime(0.2), action_tools.CCCallFunc(callback)))
            end
        end

    elseif eventType == _G.TOUCH_EVENT_MOVED then
        local start_pos = sender:getTouchBeganPosition()
        local move_pos = sender:getTouchMovePosition()

        for i=#self.hand_cards, 1, -1 do
            local pos_x = self.hand_cards[i]:getPositionX() - self.hand_cards[i]:getContentSize().width/2 * 0.7
            local pos_y = self.hand_cards[i]:getPositionY() + self.hand_cards[i]:getContentSize().height/2 * 0.7
            if ((pos_x >= start_pos.x and pos_x <= move_pos.x and start_pos.x < move_pos.x) or 
                (pos_x <= start_pos.x and pos_x >= move_pos.x and start_pos.x > move_pos.x)) and
                (start_pos.y <= pos_y and move_pos.y <= pos_y) then 
                self.hand_cards[i]:set_mask(true)
            else
                self.hand_cards[i]:set_mask(false)
            end
        end

        for i=#self.hand_cards, 1, -1 do
            if ui_tools.hitTest(self.hand_cards[i], sender:getTouchBeganPosition()) == true then
                self.hand_cards[i]:set_mask(true)
                break
            end        
        end

        for i=#self.hand_cards, 1, -1 do
            if ui_tools.hitTest(self.hand_cards[i], sender:getTouchMovePosition()) == true then
                self.hand_cards[i]:set_mask(true)
                break
            end
        end

    elseif eventType == _G.TOUCH_EVENT_ENDED or eventType == _G.TOUCH_EVENT_CANCELED then
        local is_down = false
        for i,v in ipairs(self.hand_cards) do
            if v:is_mask() == true then
                if v:is_check() == true then 
                    --下降
                    v:set_check(false)
                    v:stopAllActions()
                    v:runAction(action_tools.CCMoveTo(0.1, v:getPositionX(), self:get_posY()))
                    is_down = true
                else
                    --上升
                    v:set_check(true)
                    v:stopAllActions()
                    v:runAction(action_tools.CCMoveTo(0.1, v:getPositionX(), self:get_posY() + 20))
                end
                v:set_mask(false)
            end
        end

        self:check_temp_outcards()
        if not is_down then
            -- 自动补充顺子中间卡牌
            self:is_auto_supplement(is_down)
        end

        if self.is_click_two then
            self:click_two()
        end

        self:whether_choose_outcards()

    end
end
-- 获取卡牌基础y坐标
function card_layer:get_posY()
    return math.floor(self:getContentSize().height/5 - 2)
end

function card_layer:destory()
    self:unscheduleUpdate()
end

function card_layer:clear_data()

end

function card_layer:clear_ui()
    for i=1, GAME_PLAYER do
        self:clear_out_cards(i-1)
    end
    self:clear_hand_cards()
    self:unscheduleUpdate()
end

function card_layer:DY_test()
    self:show_hand_cards(false, 20)
end

return card_layer
