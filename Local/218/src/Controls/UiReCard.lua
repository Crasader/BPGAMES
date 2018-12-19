local UiReCard=class("UiReCard",function() return control_tools.newImg({}) end)

function UiReCard:ctor()
    self._note_lable = {}

    local l_bg = control_tools.newImg({path=BPRESOURCE("res/assist/bg_note.png")})
    self:addChild(l_bg)
    --l_bg:setVisible(false)

    local note_posX = 318
    local note_posY = 30
    self.note_lable_pos={
        cc.p(-122+note_posX,note_posY),cc.p(-159+note_posX,note_posY),cc.p(282+note_posX,note_posY),
        cc.p(245+note_posX,note_posY),cc.p(207+note_posX,note_posY),cc.p(170+note_posX,note_posY),
        cc.p(135+note_posX,note_posY),cc.p(96+note_posX,note_posY),cc.p(60+note_posX,note_posY),
        cc.p(24+note_posX,note_posY),cc.p(-12+note_posX,note_posY),cc.p(-52+note_posX,note_posY),
        cc.p(-86+note_posX,note_posY),cc.p(-210+note_posX,note_posY),cc.p(-270+note_posX,note_posY),
    }
    for i=1, 15 do
        self._note_lable[i] = control_tools.newLabel({fnt=BPRESOURCE("res/text_font/number_shuangkou_jpq.fnt")})
        self._note_lable[i]:setPosition(self.note_lable_pos[i])
        l_bg:addChild(self._note_lable[i])
    end
end

function UiReCard:setData(param_data)
    for i=1,15 do
        self._note_lable[i]:setString(param_data[i])
    end
end


return UiReCard