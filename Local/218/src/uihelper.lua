local UIHelper = class("UIHelper")

local m_game_main = nil

function UIHelper.set_game_main(game_main)
    m_game_main = game_main
end

function UIHelper.on_btn_open_menu(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("gamelog>>on_btn_open_menu")
    m_game_main.ptr_menu_layer:setVisible(true)
end

function UIHelper.on_btn_close_menu(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("gamelog>>on_btn_open_menu")
    m_game_main.ptr_menu_layer:setVisible(false)
end

function UIHelper.on_btn_open_setting(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    --todo  cyn 设置界面
end

function UIHelper.on_btn_rule(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    m_game_main.ptr_rule_layer:showForm()
end

function UIHelper.on_btn_ready(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("gamelog>>on_btn_ready")
    m_game_main.ptr_game_frame:send_ready_data()
    m_game_main.ptr_game_end:setVisible(false)
    m_game_main.ptr_mutil_info:setData({mutil = {1,1,1,1}, contribution = {0,0,0,0}, chair_id = m_game_main:switch_to_chair_id(UserIndex.down)}, true)
    m_game_main:clear_game_info()
end

function UIHelper.on_btn_changetable(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("gamelog>>on_btn_changetable")
    m_game_main.ptr_game_frame:re_sit_down();
end

function UIHelper.on_btn_leave(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    print("gamelog>>on_btn_leave")
    m_game_main.ptr_game_frame:close_game();
end

function UIHelper.on_btn_sort_by_size(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    m_game_main.btn_sort_by_size:setVisible(false)
    m_game_main.btn_sort_by_count:setVisible(true)
    m_game_main.ptr_card_layer:setSortFunc(game_logic.sort_cards_by_count)
end

function UIHelper.on_btn_sort_by_count(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end

    m_game_main.btn_sort_by_size:setVisible(true)
    m_game_main.btn_sort_by_count:setVisible(false)
    m_game_main.ptr_card_layer:setSortFunc(game_logic.sort_cards_by_size)
end

function UIHelper.on_btn_out_card(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    m_game_main._cur_out_card_id = -1
    m_game_main.ptr_time_clock:hide()
    UIHelper.on_button_power(0, 0)
    local cards_value = m_game_main.ptr_card_layer:getCurrSelectedCardValues()
    cards_value = game_logic.sort_outing_cards(cards_value, #cards_value)
    local cards_type,cards_unit_length = game_logic.get_cards_type(cards_value, #cards_value)
    local min_card_size = game_logic.get_fact_min_size(cards_value, #cards_value, cards_type)
    local send_data = {cards_value = cards_value,cards_count =#cards_value ,cards_type = cards_type, min_card_size = min_card_size, unit_length = cards_unit_length}
    m_game_main.ptr_game_frame:send_game_data(C2SP.out_card,json.encode(send_data))
    --预出牌
    m_game_main.ptr_card_layer:doOutCards()
    m_game_main._hint_order = 0
    m_game_main._hint_ret = {}

    --托管相关 暂缓
    --若是数量排序 出牌之后要重新再排一下 暂缓
    
end

function UIHelper.on_btn_pass(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    m_game_main._cur_out_card_id = -1
    m_game_main.ptr_time_clock:hide()
    UIHelper.on_button_power(0, 0)
    m_game_main.ptr_card_layer:clearSelectStatus()
    m_game_main:refreshPassInfo(true, m_game_main:switch_to_chair_id(UserIndex.down))
    m_game_main.ptr_game_frame:send_game_data(C2SP.pass,"")
    m_game_main:refreshTipsInfo()
    m_game_main._hint_order = 0
    m_game_main._hint_ret = {}
end

function UIHelper.on_btn_hint(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    if isTrust then
        return
    end
    if #m_game_main._hint_ret == 0 then
        m_game_main._hint_ret = game_logic.hint(m_game_main.ptr_card_layer._hand_card_values, m_game_main.ptr_card_layer._hand_cards_count, m_game_main._last_outing_cards_value, #m_game_main._last_outing_cards_value)
    end
    local card_values = {}
    if #m_game_main._hint_ret > 0 then
        m_game_main._hint_order = m_game_main._hint_order% #m_game_main._hint_ret +1
        for k, v in pairs(m_game_main._hint_ret[m_game_main._hint_order]) do
            table.insert(card_values, v)
        end
        m_game_main.ptr_card_layer:setHandCardSelect(card_values, true) 
    elseif #m_game_main._hint_ret == 0 then
        --若没有大的牌，则直接发送过
        m_game_main:refreshTipsInfo()
        m_game_main:refreshPassInfo(true, m_game_main:switch_to_chair_id(UserIndex.down))
        m_game_main.ptr_game_frame:send_game_data(C2SP.pass,"")
        m_game_main.ptr_card_layer:clearSelectStatus()
    end
end

function UIHelper.on_btn_end_back(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    --好友房相关 暂缓
    m_game_main.ptr_time_clock:setPosition(m_game_main.time_clock_pos[0])
    m_game_main.ptr_time_clock:setTime(m_game_main.ptr_game_end.ptr_time_clock._time, true)
    m_game_main.ptr_time_clock:setVisible(true)
    m_game_main.ptr_game_end:setVisible(false)
    m_game_main.btn_details:setVisible(true)
    UIHelper.on_button_power(bit_tools._or(ButtonPower.Change_table, ButtonPower.Ready), bit_tools._or(ButtonPower.Change_table, ButtonPower.Ready))
end

function UIHelper.on_btn_no_trust(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end

    m_game_main.ptr_game_frame:send_game_data(C2SP.no_trust,"")
end

function UIHelper.on_btn_details(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    m_game_main.ptr_game_end:setVisible(true)
    m_game_main.ptr_time_clock:setVisible(false)
    m_game_main.ptr_game_end:setLeftTime(m_game_main.ptr_time_clock._time or 0)
end

function UIHelper.on_btn_recharge(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
    --todo 充值商城 show_simple_shop
end

function UIHelper.on_button_power(visible, enable)
    m_game_main.btn_changetable:setVisible(bit_tools._and(visible,ButtonPower.Change_table)>0)
    m_game_main.btn_changetable:setTouchEnabled(bit_tools._and(enable,ButtonPower.Change_table)>0)
    m_game_main.btn_changetable:setBright(bit_tools._and(enable,ButtonPower.Change_table)>0)

    m_game_main.btn_ready:setVisible(bit_tools._and(visible,ButtonPower.Ready)>0)
    m_game_main.btn_ready:setTouchEnabled(bit_tools._and(enable,ButtonPower.Ready)>0)
    m_game_main.btn_ready:setBright(bit_tools._and(enable,ButtonPower.Ready)>0)

    m_game_main.btn_out_card:setVisible(bit_tools._and(visible,ButtonPower.Out_Card)>0)
    m_game_main.btn_out_card:setTouchEnabled(bit_tools._and(enable,ButtonPower.Out_Card)>0)
    m_game_main.btn_out_card:setBright(bit_tools._and(enable,ButtonPower.Out_Card)>0)

    m_game_main.btn_pass:setVisible(bit_tools._and(visible,ButtonPower.Pass)>0)
    m_game_main.btn_pass:setTouchEnabled(bit_tools._and(enable,ButtonPower.Pass)>0)
    m_game_main.btn_pass:setBright(bit_tools._and(enable,ButtonPower.Pass)>0)

    m_game_main.btn_hint:setVisible(bit_tools._and(visible,ButtonPower.Hint)>0)
    m_game_main.btn_hint:setTouchEnabled(bit_tools._and(enable,ButtonPower.Hint)>0)
    m_game_main.btn_hint:setBright(bit_tools._and(enable,ButtonPower.Hint)>0)
    --准备等按钮变化
    if m_game_main.btn_ready:isVisible() and bit_tools._and(RoomType, GameRoomType.ROOM_KIND_LINEUP)>0 then
        m_game_main.btn_ready:setPositionX(view_size.width/2)
    else
        m_game_main.btn_ready:setPositionX(view_size.width/2+140)
    end
    --出牌等按钮变化
    if m_game_main.btn_out_card:isVisible() then
        --按钮位置改变
        if not m_game_main.btn_pass:isVisible() then
            m_game_main._cur_out_card_id = m_game_main:switch_to_chair_id(UserIndex.down)
            m_game_main.btn_out_card:setPositionX(view_size.width/2+5*AUTO_WIDTH)
        elseif not m_game_main.btn_ready:isVisible() then
            m_game_main.btn_out_card:setPositionX(view_size.width/2+215*AUTO_WIDTH)

            if m_game_main.ptr_card_layer then
                m_game_main._hint_ret = game_logic.hint(m_game_main.ptr_card_layer._hand_card_values, m_game_main.ptr_card_layer._hand_cards_count, m_game_main._last_outing_cards_value, #m_game_main._last_outing_cards_value)
                if #m_game_main._hint_ret == 0 then
                    if not isTrust then
                        m_game_main:refreshTipsInfo(1, false)
                    end
                end
            end
        end

        --轮到自己出牌时 该检查立起来的手牌是否符合出牌
        if m_game_main.ptr_card_layer then
            local l_cards_type = m_game_main.ptr_card_layer:getCurrSelectedCardsType()
            local curr_selected_card_values = m_game_main.ptr_card_layer:getCurrSelectedCardValues()
            local bool_out = l_cards_type > 0
            if #m_game_main._last_outing_cards_value > 0 then
                bool_out = game_logic.compare_two_cards(curr_selected_card_values, #curr_selected_card_values, m_game_main._last_outing_cards_value, #m_game_main._last_outing_cards_value)
            end
            if bool_out then
                m_game_main.btn_out_card:setVisible(true)
                m_game_main.btn_out_card:setBright(true)
                m_game_main.btn_out_card:setTouchEnabled(true)
            else
                m_game_main.btn_out_card:setVisible(true)
                m_game_main.btn_out_card:setBright(false)
                m_game_main.btn_out_card:setTouchEnabled(false)
            end
        end
    end

    

end

return UIHelper