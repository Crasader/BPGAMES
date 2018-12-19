ARCardLayer=class("ARCardLayer",function() return control_tools.newImg({}) end)
local ARCardView=require("src/ARCardView")
local MAX_WIDTH_SPEASE = 10 --据屏幕左右两侧最小间距
local m_game_layer = nil
function ARCardLayer:ctor(visible_size)
    self._hand_card_scale = 0.75
    self._out_card_scale = 0.42
    self._selected_height = 20
    self._out_card_posY = -40 + view_size.height / 2 
    self._hand_card_posY = 128


    --手牌牌堆
    self._hand_cards = {}
    self._hand_card_values = {}
    self._hand_cards_count = 0
    --顶起牌堆
    self._curr_select_cards = {}
    self._curr_select_card_values = {}

    --整理牌堆
    self._curr_zhengli_cards = {}
    self._curr_zhengli_card_values = {}
    self._zhengli_count = 0


    --排序方法
    self._sort_func =  game_logic.sort_cards_by_size

    --最大出牌牌堆
    self._curr_outted_card_values = {}
    --自己出牌牌堆
    self._outting_cards = {}

    self._curr_allow_out = false
    self._is_click_two = false
    self._pre_time = 0
    self._next_time = 0
    self._max_card_spease = 50
    self._min_card_spease = 10
    self._hand_card_width = nil
    self._outting_card_index = 0 
    self._bool_trust = false
    self:init()
    if visible_size then
        self:setScale9Enabled(true)
        self:setContentSize(visible_size)
    end
    
end

function ARCardLayer:setGameMain(gameMain)
    m_game_layer = gameMain
end

function ARCardLayer:init()
    
--ljx test
--    local l_values = {1, 1, 17, 17, 78, 78, 33, 33, 49, 49, 2, 2, 18, 18, 34, 34, 50, 50, 79, 79, 3, 4, 5, 6, 7, 19, 36}
--    self:setHandCardsByValue(l_values, 27, false)
--    self:ShowHintTips(HintTipsIndex.no_card)
--/test
    self:setTouchEnabled(true)
    self:addTouchEventListener(function (sender, eventType) self:touchEvent(sender, eventType) end)
end

function ARCardLayer:touchTest(sender, pos)
    local card_width = sender:getContentSize().width * sender:getScale()
    local card_height = sender:getContentSize().height * sender:getScale()
    local card_posx = sender:getPositionX()
    local card_posy = sender:getPositionY()
    local rect = cc.rect(card_posx - card_width/2, card_posy - card_height/2, card_width, card_height)
    return cc.rectContainsPoint(rect, pos)
end

function ARCardLayer:touchEvent(sender, eventType)
    if m_game_layer._bg_menu and m_game_layer._bg_menu:isVisible() then 
            m_game_layer._menu:closeMenu()         
    end
    if self._hand_cards_count == 0 then
        return
    end
    if self._hand_cards == nil or self._hand_cards == {} then
        return 
    end
    if eventType == _G.TOUCH_EVENT_BEGAN then
        local is_touch_card = false
        for i=#self._hand_cards, 1, -1 do
            --self._hand_cards[i]:hitTest(sender:getTouchBeganPosition()) == true
            if self:touchTest(self._hand_cards[i], sender:getTouchBeganPosition()) then
                --audio_engine.game_effect("hit_card")
--                audio_engine.playEffect(-1, get_self_chair_id())
                self._hand_cards[i]:showBlackMask()
                is_touch_card = true
                break  
            end        
        end
        --需要修改
        if not self._is_click_two and not is_touch_card then
            self._next_time = m_game_layer.ptr_time_clock._cur_time * 1000 
            local time = self._next_time - self._pre_time
            if time < 300 then
                self._is_click_two = true
            end
            self._pre_time = self._next_time
        end
    elseif eventType == _G.TOUCH_EVENT_MOVED then
        local start_pos = sender:getTouchBeganPosition()
        local move_pos = sender:getTouchMovePosition()

        for i=#self._hand_cards, 1, -1 do
            local pox_x = 0
            if i< #self._hand_cards then
                pos_x = self._hand_cards[i+1]:getPositionX() - self._hand_cards[i+1]:getContentSize().width/2 * self._hand_card_scale
            else
                pos_x = self._hand_cards[i]:getPositionX()
            end
            --local pos_x = self._hand_cards[i]:getPositionX() -- - self._hand_cards[i]:getContentSize().width/2 * self._hand_card_scale + view_size.width/2
            local a =self._hand_cards[i]:getSize()
            local pos_y = self._hand_cards[i]:getPositionY() + self._hand_cards[i]:getContentSize().height/2 * self._hand_card_scale --+ view_size.height/2
            local pos_y_bottom = self._hand_cards[i]:getPositionY() - self._hand_cards[i]:getContentSize().height/2 * self._hand_card_scale --+ view_size.height/2
            if ((pos_x >= start_pos.x and pos_x <= move_pos.x and start_pos.x < move_pos.x) or 
                (pos_x <= start_pos.x and pos_x >= move_pos.x and start_pos.x > move_pos.x)) and
                (start_pos.y <= pos_y and move_pos.y <= pos_y) and 
                (start_pos.y >= pos_y_bottom and move_pos.y >= pos_y_bottom) then 
                self._hand_cards[i]:showBlackMask()
            else
                self._hand_cards[i]:hideBlackMask()
            end
        end
        for i=#self._hand_cards, 1, -1 do
            if self:touchTest(self._hand_cards[i], sender:getTouchBeganPosition()) then
                self._hand_cards[i]:showBlackMask()
                break
            end        
        end
        for i=#self._hand_cards, 1, -1 do
            if self:touchTest(self._hand_cards[i], sender:getTouchBeganPosition()) then
                self._hand_cards[i]:showBlackMask()
                break
            end        
        end
    elseif eventType == _G.TOUCH_EVENT_ENDED or eventType == _G.TOUCH_EVENT_CANCELED then
        local l_select_cards = {}
        for i = 1, #self._hand_cards do
            if self._hand_cards[i]:isBlackMask() == true then
                table.insert(l_select_cards, self._hand_cards[i])
                self._hand_cards[i]:hideBlackMask()
            end
        end
        self:doSelectCards(l_select_cards, true)
        --选取顺子
        local curr_selected_card_values = self:getCurrSelectedCardValues()
        local stright_ret = game_logic.auto_get_stright(self._hand_card_values, self._hand_cards_count, curr_selected_card_values, #curr_selected_card_values)
        if #stright_ret > 0 then
            self:setHandCardSelect(stright_ret, true) 
        end

        if self._is_click_two then
            m_game_layer._hint_order = 0 --提示重置
            self._is_click_two = false
            self:clearSelectStatus()
        end
        -- ljx test 
--            m_game_layer._btn_out_card:setTouchEnabled(true)
--            m_game_layer._btn_out_card:setBright(true)
            -- /test
    end
end

--生成一组新的手牌
function ARCardLayer:setHandCardsByValue(card_values, card_count, is_ani)
    self:clearHandCards()
    if not card_count or card_count == 0 then
        return
    end
    self._hand_cards_count = card_count
    if not is_ani then
        local cards = self._sort_func(card_values, card_count)
        card_values = {}
        for k, v in pairs(cards) do
            table.insert(card_values, v)
        end
    end
    local card_index = 1
    -- 整理的牌放到最前面
    if #self._curr_zhengli_card_values > 0 then
        for i = #self._curr_zhengli_card_values, 1, -1 do
            for j = 1, #self._curr_zhengli_card_values[i] do
                self._hand_card_values[card_index] = self._curr_zhengli_card_values[i][j]
                self._hand_cards[card_index] = self:creatNewCardByValue(self._curr_zhengli_card_values[i][j], self._hand_card_scale)
                self._hand_cards[card_index]:setGroup(i)
                self:addChild(self._hand_cards[card_index])
                card_index = card_index + 1
            end
        end
    end
    local judge_table = {}
    for i = 1, card_count do 
        local bool_same = false
        for k = 1, #self._curr_zhengli_card_values do
            for j = 1, #self._curr_zhengli_card_values[k] do
                if card_values[i] == self._curr_zhengli_card_values[k][j] and not judge_table[k] then
                    bool_same = true
                    judge_table[k] = {}
                    judge_table[k][j] = true
                    break
                elseif card_values[i] == self._curr_zhengli_card_values[k][j] and not judge_table[k][j] then 
                    bool_same = true
                    judge_table[k][j] = true
                    break
                end
            end
            if bool_same then
                break
            end
        end
        if bool_same == false then                
            self._hand_card_values[card_index] = card_values[i]
            self._hand_cards[card_index] = self:creatNewCardByValue(card_values[i], self._hand_card_scale)
            self:addChild(self._hand_cards[card_index])
            card_index = card_index +1
        end
    end
    local max_cards_width = card_count * self._max_card_spease - self._max_card_spease + self._hand_card_width
    local min_cards_width = card_count * self._min_card_spease - self._min_card_spease + self._hand_card_width
    local temp_card_spease = self._max_card_spease
    local out_card_first_pos = 0
    if self._outting_card_index == UserIndex.down then
        out_card_first_pos = -max_cards_width/2 + self._hand_card_width/2
    elseif self._outting_card_index == UserIndex.right then
        if card_count >= 10 then
            max_cards_width = 10 * self._max_card_spease - self._max_card_spease + self._hand_card_width
        end
        out_card_first_pos = -max_cards_width + self._hand_card_width 
    end
    if max_cards_width > view_size.width - MAX_WIDTH_SPEASE then
        max_cards_width = view_size.width - MAX_WIDTH_SPEASE
        temp_card_spease = (max_cards_width - self._hand_card_width) / (card_count - 1)
    end
    for i = 1, card_count do
        local l_card_posX = -max_cards_width / 2 +  self._hand_card_width/2 + temp_card_spease * i - temp_card_spease + self:getContentSize().width/2
        if is_ani then
            if self._outting_card_index == 0 then
                if i == card_count then 
                    self._hand_cards[i]:runAction(action_tools.CCSequence(action_tools.CCDelayTime(0.075 * i), action_tools.CCMoveTo(0.075, l_card_posX, self._hand_card_posY), action_tools.CCCallFunc(function ()
                        self:updateHandCards()
                    end)))
                else                
                    self._hand_cards[i]:runAction(action_tools.CCSequence(action_tools.CCDelayTime(0.075 * i), action_tools.CCMoveTo(0.075, l_card_posX, self._hand_card_posY)))
                end
            elseif self._outting_card_index == UserIndex.down then
                local aaa = self._hand_cards[i]:convertToWorldSpaceAR(cc.p(out_card_first_pos + self._min_card_spease * (i-1), 0 ))
                self._hand_cards[i]:setPosition(cc.p(out_card_first_pos + self._min_card_spease * (i-1), 0 ))
                self._hand_cards[i]:stopAllActions()
                self._hand_cards[i]:runAction(action_tools.CCEaseExponentialOut(action_tools.CCMoveTo(0.5, out_card_first_pos + self._max_card_spease * (i-1), 0 )))
            elseif self._outting_card_index == UserIndex.up then
                self._hand_cards[i]:setPosition(cc.p(out_card_first_pos + self._min_card_spease * ((i-1)%10), math.floor((i-1)/10) * -31 ))
                self._hand_cards[i]:stopAllActions()
                self._hand_cards[i]:runAction(action_tools.CCEaseExponentialOut(action_tools.CCMoveTo(0.5, out_card_first_pos + self._max_card_spease * ((i-1)%10), math.floor((i-1)/10) * -31 )))
            else
                local shift_Y = 0
                if card_count > 20 then
                    shift_Y = 20
                end
                self._hand_cards[i]:setPosition(cc.p(out_card_first_pos + self._min_card_spease * ((i-1)%10), math.floor((i-1)/10) * -31 + shift_Y ))
                self._hand_cards[i]:stopAllActions()
                self._hand_cards[i]:runAction(action_tools.CCEaseExponentialOut(action_tools.CCMoveTo(0.5, out_card_first_pos + self._max_card_spease * ((i-1)%10), math.floor((i-1)/10) * -31 + shift_Y )))
            end
        else 
            self._hand_cards[i]:setPositionX(l_card_posX)
        end
    end
    if self:getCardsUserIndex() == 0 then
        local l_cards = self:getNeedCardValues()
       -- m_game_layer._tong_hua_shun_array = game_logic.get_all_tonghuashun_cards(l_cards, #l_cards)
       -- UIHelper.show_tonghuashun_btn(#m_game_layer._tong_hua_shun_array > 0);
    end
end
--设置手牌牌值
function ARCardLayer:setHandCardValues(card_values)
        self._hand_card_values = card_values
end
--获取手牌牌值
function ARCardLayer:getHandCardValues()
    
    return self._hand_card_values
end
--获取没整理的手牌
function ARCardLayer:getNeedCardValues()
    local l_values = {}
    for key, var in pairs(self._hand_cards) do
        if var:isZhengLi() == false then
            table.insert(l_values, var:getValue())
        end
    end
    return l_values
end
--获取整理的手牌牌组
function ARCardLayer:getZhengLiCardValues()
    return self._curr_zhengli_card_values
end
--添加一组整理的手牌
function ARCardLayer:addZhengLiCardValues()
    local l_cards = self:getCurrSelectedCards()
    if #l_cards == 0 then
        return
    end
    local zheng_li_values = {}
    for key, var in pairs(l_cards) do
        table.insert(zheng_li_values, var:getValue())
    end
    table.insert(self._curr_zhengli_card_values, zheng_li_values)
    self:clearSelectStatus()
    self:updateHandCards()
end

--移除一组整理的手牌
function ARCardLayer:removeZhengLiCards(bool_update)
    local l_cards = self:getCurrSelectedCards()
    local zheng_li_group = {}
    for key, var in pairs(l_cards) do
        local aaa = var:getGroup()
        if var:getGroup() ~= 0 and not zheng_li_group[var:getGroup()] then
            zheng_li_group[var:getGroup()] = true
        end
    end
    local l_new_group = {}
    for i = 1, #self._curr_zhengli_card_values do
        if not zheng_li_group[i] then
            table.insert(l_new_group, self._curr_zhengli_card_values[i])
        end
    end
    self._curr_zhengli_card_values = l_new_group
    self:clearSelectStatus()
    if bool_update then
        self:updateHandCards()
    end
end
function ARCardLayer:updateHandCards()
    self:setHandCardsByValue(self._hand_card_values, self._hand_cards_count, false)
end
function ARCardLayer:clearHandCards()
    if #self._hand_cards > 0  then
        for i = 1, #self._hand_cards do
            self._hand_cards[i]:removeFromParentAndCleanup(true)
        end
    end
    self._hand_cards = {}
    self._hand_card_values = {}
    self._hand_cards_count = 0
end
function ARCardLayer:updateCurrSelectedCards()
    local count = 0;
    self._curr_select_cards = {}
    self._curr_select_card_values = {}
    
    for key, var in pairs(self._hand_cards) do
        if var then
            if var:getSelect() == true then
                count = count + 1
                self._curr_select_cards[count] = var
                self._curr_select_card_values[count] = var:getValue()
            end
        end
    end
end
--通过牌值选取手牌(传入牌值数组 改变当前选中状态)
function ARCardLayer:setHandCardSelect(card_values, bool_ani) 
    self:clearSelectStatus();
    local l_select_cards = {};
    local temp_selected_cards = {} --这个table是用来判断改手牌是否使用过
    for  i = 1, #card_values do
        for key, var in pairs(self._hand_cards) do
            if var then
                if card_values[i] == var:getValue() and not temp_selected_cards[key] then
                    table.insert(l_select_cards, var)
                    temp_selected_cards[key] = true
                    break
                end
            end
        end
    end
    self:doSelectCards(l_select_cards, bool_ani);
end

--放下所有手牌
function ARCardLayer:clearSelectStatus()
    for key, var in pairs(self._hand_cards) do
        if var then
            if var:getSelect() == true then
                var:runAction(action_tools.CCMoveTo(0.1, var:getPositionX(), var:getPositionY() - self._selected_height));
                var:setSelect(false);
            end
        end
    end
    self:updateCurrSelectedCards()
    --UIHelper.show_reset_btn_enable(false)
    --UIHelper.show_out_btn_enable(false)
    if m_game_layer._cur_out_card_id ~= -1 and  m_game_layer:switch_to_view_id(m_game_layer._cur_out_card_id) == UserIndex.down and m_game_status ~= GameStatus.free  and not IsPause then
        m_game_layer.btn_out_card:setVisible(true)
        m_game_layer.btn_out_card:setTouchEnabled(false)
        m_game_layer.btn_out_card:setBright(false)
    else
        m_game_layer.btn_out_card:setVisible(false)
        m_game_layer.btn_out_card:setTouchEnabled(false)
        m_game_layer.btn_out_card:setBright(false)
    end
end

--通过牌对象选取手牌(传入牌值数组 改变当前选中状态)
function ARCardLayer:doSelectCards(param_cards, bool_ani) 
    local l_values = {}
    for key, var in pairs(param_cards) do
        if var then
            local l_move_y = self._selected_height
            if var:getSelect() == true then
                l_move_y = -l_move_y
            end
            if bool_ani then
                var:runAction(action_tools.CCMoveTo(0.1, var:getPositionX(), var:getPositionY() + l_move_y))
            else 
                var:setPositionY(var:getPositionY() + l_move_y)
            end
            var:setSelect(not var:getSelect());
            table.insert(l_values, var:getValue())
        end
    end
    --需要修改
    --出牌按钮
    local l_cards_type = self:getCurrSelectedCardsType()
    local curr_selected_card_values = self:getCurrSelectedCardValues()
    local bool_out = l_cards_type > 0

    if #m_game_layer._last_outing_cards_value > 0 then
        bool_out = game_logic.compare_two_cards(curr_selected_card_values, #curr_selected_card_values, m_game_layer._last_outing_cards_value, #m_game_layer._last_outing_cards_value)
    end
    --需要之后修改
    
    if m_game_layer._cur_out_card_id ~= -1 and m_game_layer:switch_to_view_id(m_game_layer._cur_out_card_id) == UserIndex.down and m_game_status ~= GameStatus.free and not IsPause then
        if bool_out then
            m_game_layer.btn_out_card:setVisible(true)
            m_game_layer.btn_out_card:setTouchEnabled(true)
            m_game_layer.btn_out_card:setBright(true)

            --m_game_layer:changeButtonStatus(m_game_layer._btn_out_card,1,1)
        else
            --m_game_layer:changeButtonStatus(m_game_layer._btn_out_card,1,0)
            m_game_layer.btn_out_card:setVisible(true)
            m_game_layer.btn_out_card:setTouchEnabled(false)
            m_game_layer.btn_out_card:setBright(false)
        end
    else
        m_game_layer.btn_out_card:setVisible(false)
        m_game_layer.btn_out_card:setTouchEnabled(false)
        m_game_layer.btn_out_card:setBright(false)
    end
--    UIHelper.show_out_btn_enable(bool_out)
--    --整理/恢复按钮
--    local curr_selected_cards = self:getCurrSelectedCards()
--    local bool_reset = false
--    for key, var in pairs(curr_selected_cards) do
--        if var:isZhengLi() == true then
--            bool_reset = true
--            break
--        end
--    end
--    UIHelper.show_reset_btn_enable(bool_reset)
end

function ARCardLayer:getCurrSelectedCardsType()
    local l_values = self:getCurrSelectedCardValues()
    return game_logic.get_cards_type(l_values, #l_values);
end
--获取当前弹起手牌牌值
function ARCardLayer:getCurrSelectedCardValues()
    self:updateCurrSelectedCards()
    return self._curr_select_card_values;
end
--获取当前弹起手牌
function ARCardLayer:getCurrSelectedCards()
    return self._curr_select_cards;
end


--出牌
function ARCardLayer:doOutCards()
    local param_card_values = self:getCurrSelectedCardValues()
    local l_type = self:getCurrSelectedCardsType()
    local l_out_values = {};
    self:clearOutCards();
    self:removeZhengLiCards()
    self:clearSelectStatus();
    for j = 1, #param_card_values do
        local temp_index = 0
        for i = 1, #self._hand_cards do
            if self._hand_cards[i]:getValue() == param_card_values[j] then
                table.insert(self._outting_cards, self._hand_cards[i])
                self._hand_cards[i]:hideColorMask()
                temp_index = i
                break;
            end
        end
        table.remove(self._hand_card_values, temp_index)
        table.remove(self._hand_cards, temp_index)
        self._hand_cards_count = self._hand_cards_count - 1
    end
    local aaa = #self._hand_card_values
    local l_pos_x = self:updateHandCardPos(#self._hand_card_values, self._hand_card_scale);
    self:moveHandCards(l_pos_x);
    l_pos_x = self:updateOutCardPos(#self._outting_cards, self._out_card_scale);
    self:moveOutCards(l_pos_x, param_card_values);
    if self:getCardsUserIndex() == 0 then
        local l_cards = self:getNeedCardValues()
       -- m_game_layer._tong_hua_shun_array = game_logic.get_all_tonghuashun_cards(l_cards, #l_cards)
       -- UIHelper.show_tonghuashun_btn(#m_game_layer._tong_hua_shun_array > 0);
    end
end
--更新手牌位置
function ARCardLayer:updateHandCardPos(param_count, param_scale)
    param_scale = param_scale/self._hand_card_scale
    local hand_cards_pos_X = {};
    local max_cards_width = self._max_card_spease * (param_count - 1)* param_scale + self._hand_card_width * param_scale
    local temp_card_spease = self._max_card_spease * param_scale
    
    if max_cards_width > view_size.width - MAX_WIDTH_SPEASE then
        max_cards_width = view_size.width - MAX_WIDTH_SPEASE
        temp_card_spease = (max_cards_width - self._hand_card_width*param_scale) / (param_count - 1)
    end
    local start_posx = -max_cards_width / 2 +  self._hand_card_width/2*param_scale - temp_card_spease
    for i = 1, param_count do
        hand_cards_pos_X[i] = (start_posx + temp_card_spease * i)+view_size.width/2;
    end
    return hand_cards_pos_X;
end

--更新出的牌的位置
function ARCardLayer:updateOutCardPos(param_count, param_scale)
    local hand_cards_pos_X = {};

    local max_cards_width = (param_count * self._max_card_spease - self._max_card_spease + self._hand_card_width)* param_scale
    local min_cards_width = (param_count * self._min_card_spease - self._min_card_spease + self._hand_card_width)* param_scale
    local temp_card_spease = self._max_card_spease * param_scale
    local out_card_first_pos = -max_cards_width/2+ self._hand_card_width/2* param_scale
    if max_cards_width > view_size.width - MAX_WIDTH_SPEASE then
        max_cards_width = view_size.width - MAX_WIDTH_SPEASE
        temp_card_spease = (max_cards_width - self._hand_card_width * param_scale) / (param_count - 1)
    end
    for i = 1, param_count do
        hand_cards_pos_X[i] = -max_cards_width / 2 +  self._hand_card_width/2 * param_scale + temp_card_spease * i - temp_card_spease + view_size.width/2
    end
    return hand_cards_pos_X
end

function ARCardLayer:moveHandCards(param_pos_x)
    for index = 1, #self._hand_cards  do
        self._hand_cards[index]:runAction(action_tools.CCSequence(action_tools.CCMoveTo(0.2, param_pos_x[index], self._hand_cards[index]:getPositionY()), action_tools.CCCallFunc(function () self:updateHandCards() end)));
    end
end

function ARCardLayer:moveOutCards(param_pos_x, param_values)
        local l_param_values = game_logic.sort_outing_cards(param_values, #param_values)
        local temp_move_index = {}
        for index = 1, #l_param_values do
            for key, var in pairs(self._outting_cards) do
                if var then
                    if var:getValue() == l_param_values[index] then
                        if not temp_move_index[key] then
                            temp_move_index[key] = index
                            var:stopAllActions()
                            var:runAction(action_tools.CCSpawn(action_tools.CCMoveTo(0.2, param_pos_x[index], self._out_card_posY), 
                                                                        action_tools.CCScaleTo(0.2, self._out_card_scale)));
                            var:setLocalZOrder(index)
                            break;        
                        end            
                    end
                end
            end
        end

end
function ARCardLayer:clearOutCards()
    if #self._outting_cards > 0 then
        for key, var in pairs(self._outting_cards) do
            if var then
                var:removeFromParentAndCleanup(true)
            end
        end
    end
    self._outting_cards = {};
end
--设置牌组类型 0手牌 1~4出牌牌组(UserIndex)
function ARCardLayer:setCardsUserIndex(param_index)
    param_index = param_index or 0
    if param_index == UserIndex.down then
        self:setAnchorPoint(cc.p(0.5, 0.5))
    elseif param_index == UserIndex.right then
        self:setAnchorPoint(cc.p(1, 0.5))
    else
        self:setAnchorPoint(cc.p(0, 0.5))
    end
    self._outting_card_index = param_index
end
function ARCardLayer:getCardsUserIndex()
    return self._outting_card_index
end
--设置牌最大间距 
function ARCardLayer:setCardMaxSpeace(param_speace)
    self._max_card_spease = param_speace
end
function ARCardLayer:getCardMaxSpeace()
    return self._max_card_spease
end
--设置牌最小间距 默认10
function ARCardLayer:setCardMinSpeace(param_speace)
    self._min_card_spease = param_speace
end
function ARCardLayer:getCardMinSpeace()
    return self._min_card_spease
end
--设置牌Scale 默认0.7
function ARCardLayer:setCardScale(param_scale)
    self._hand_card_scale = param_scale
end
function ARCardLayer:getCardScale()
    return self._hand_card_scale
end
-- 
function ARCardLayer:setSortFunc(sort_func)
    if type(sort_func) == "function" then
        self._sort_func = sort_func
    end
    self:clearSelectStatus()
    self:updateHandCards()
end


function ARCardLayer:clearData()
    self._curr_zhengli_cards = {}
    self._curr_zhengli_card_values = {}
    self._zhengli_count = 0
    self:clearHandCards()
    self:clearOutCards()
end
-- 单张牌工厂方法
function ARCardLayer:creatNewCardByValue(param_value, param_scale, param_pos)
    local temp_card = ARCardView.new(param_value)
    param_scale = param_scale or 1
    temp_card:setScale(param_scale)
    if param_pos then
        temp_card:setPosition(param_pos)
    else 
        temp_card:setPosition(cc.p(view_size.width + temp_card:getContentSize().width*param_scale, self._hand_card_posY))
    end
    if not self._hand_card_width then
        self._hand_card_width = temp_card:getContentSize().width * param_scale
    end
    return temp_card
end
return ARCardLayer