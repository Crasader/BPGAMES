local UiMutilInfo=class("UiMutilInfo",function() return control_tools.newImg({}) end)
local m_game_main = nil

function UiMutilInfo:ctor()
    self._win_mutil = 1
    self._lose_mutil = 1
    self._contribution = 0

    self._bg_mutil = control_tools.newImg({path=BPRESOURCE("res/assist/bg_mutil.png")})
    self._bg_mutil:setPosition(cc.p(100-view_size.width*0.5, view_size.height*0.5-50))
    self:addChild(self._bg_mutil)

    self._img_win = control_tools.newImg({path=BPRESOURCE("res/assist/win.png")})
    self._img_win:setPosition(cc.p(35,63))
    self._bg_mutil:addChild(self._img_win)

    self._win_mutil_lable = control_tools.newLabel({fnt=BPRESOURCE("res/text_font/number_shuangkou_yingjiagongxian.fnt")})
    self._win_mutil_lable:setPosition(cc.p(55,57))
    self._win_mutil_lable:setAnchorPoint(cc.p(0,0.5))
    self._bg_mutil:addChild(self._win_mutil_lable)


    self._img_lose = control_tools.newImg({path=BPRESOURCE("res/assist/lose.png")})
    self._img_lose:setPosition(cc.p(35,27))
    self._bg_mutil:addChild(self._img_lose)

    self._lose_mutil_lable = control_tools.newLabel({fnt=BPRESOURCE("res/text_font/number_shuangkou_shu.fnt")})
    self._lose_mutil_lable:setPosition(cc.p(55,21))
    self._lose_mutil_lable:setAnchorPoint(cc.p(0,0.5))
    self._bg_mutil:addChild(self._lose_mutil_lable)


    self._img_contribution = control_tools.newImg({path=BPRESOURCE("res/assist/mutil.png")})
    self._img_contribution:setPosition(cc.p(130,63))
    self._bg_mutil:addChild(self._img_contribution)

    self._contribution_lable = control_tools.newLabel({fnt=BPRESOURCE("res/text_font/number_shuangkou_yingjiagongxian.fnt")})
    self._contribution_lable:setPosition(cc.p(130,27))
    self._bg_mutil:addChild(self._contribution_lable)

end

function UiMutilInfo:setGameMain(gameMain)
    m_game_main = gameMain
end

function UiMutilInfo:refresh_mutil_contribution()
    if self._contribution >= 0 then
        self._contribution_lable:setString("+"..self._contribution)
    else
        self._contribution_lable:setString(self._contribution)
    end
    self._win_mutil_lable:setString("x"..self._win_mutil)
    self._lose_mutil_lable:setString("x"..self._lose_mutil)
end

function UiMutilInfo:setData(param_data, is_refresh)
    local seat_id = m_game_main._map_seat[param_data.chair_id + 1]
    local self_seat_id =m_game_main._map_seat[m_game_main:switch_to_chair_id(UserIndex.down)+1]
    if not is_refresh then
        --未重连情况下
        if (seat_id - self_seat_id + 4)%4 == 0 then
            --加分的联盟
            if param_data.change_mul_value > self._win_mutil then
                self._win_mutil = param_data.change_mul_value
                --audio_engine.game_effect("Multiple_Up")
                if self._win_mutil >=16 then   
                    self._win_mutil = 16
                end
            end
        elseif (seat_id - self_seat_id + 4)%4 == 2 then
            --加分的联盟
            if param_data.change_mul_value > self._win_mutil then
                self._win_mutil = param_data.change_mul_value
                --audio_engine.game_effect("Multiple_Up")
                if self._win_mutil >=16 then   
                    self._win_mutil = 16
                end
            end
        else
            --扣分的联盟
            if param_data.change_mul_value > self._lose_mutil then
                self._lose_mutil = param_data.change_mul_value
                if self._lose_mutil >=16 then   
                    self._lose_mutil = 16
                end
            end
        end
    else
         --重连情况下
        self._win_mutil = 1
        self._lose_mutil = 1
        for i=1,GamePlayer do
            local tmp_seat_id = m_game_main._map_seat[i]
            if (tmp_seat_id - self_seat_id + 4)% 4 == 0 or (tmp_seat_id - self_seat_id + 4)% 4 == 2 then
                if self._win_mutil < param_data.mutil[i] then
                    self._win_mutil = param_data.mutil[i]
                end
                if self._win_mutil >=16 then   
                    self._win_mutil = 16
                end 
            else
                if self._lose_mutil < param_data.mutil[i] then
                    self._lose_mutil = param_data.mutil[i]
                end
                if self._lose_mutil >=16 then   
                    self._lose_mutil = 16
                end
            end
        end
    end
    self._contribution = param_data.contribution[m_game_main:switch_to_chair_id(UserIndex.down)+1]
    self:refresh_mutil_contribution()
end

return UiMutilInfo