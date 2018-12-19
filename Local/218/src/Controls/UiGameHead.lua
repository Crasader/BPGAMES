local UIGameHead=class("UIGameHead",function() return ccui.Layout:create() end);
local ZOrder = {
    bg = 11,
    face = 12,
    border = 13,
    name = 14,
    gold = 15,
    gold_bg = 16,
    sign = 17,
    other = 18,
    rank = 19,
}
function UIGameHead:ctor()
    print("hjjlog>>uigamehead")
    self._img_head=nil
    self._img_border=nil
    self._label_name=nil
    self._label_gold=nil
    self._img_bg=nil
    self._img_robot=nil
    self._img_rank=nil
    self._is_left=nil
end

function UIGameHead:set_head(ptr_user_data, view_id)
    --头像
    self._img_head=nil
    if ptr_user_data.wFaceID==0 then 
        self._img_head=control_tools.newImg({path=BPRESOURCE("gameres/head_id_1.png"),ctype=0})
    else 
        -- local url="https://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png?x-oss-process=style/simplify";
        self._img_head=control_tools.newImg({anchor={x=0.5,y=0.5},size={width=100,height=100},path="http://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png",ctype=0})
    end
    self:addChild(self._img_head)

    --头像框
    self._img_border=control_tools.newImg({path=BPRESOURCE("res/head/border.png"),ctype=0})
    self:addChild(self._img_border)
    self._img_border:setPosition(cc.p(0,0))

    --昵称
    self._label_name=control_tools.newLabel({font=24})
    self:addChild(self._label_name)
    self._label_name:setPosition(cc.p(0,-60));
    game_logic.setNameText(self._label_name, ptr_user_data.szName, 140)

    --金币
    self._label_gold=control_tools.newLabel({str=game_logic.getGoldText(ptr_user_data.lGold ),font=24})
    self:addChild(self._label_gold)
    self._label_gold:setPosition(cc.p(0,-80))

    --机器人（托管）
    self._img_robot = control_tools.newImg({path=BPRESOURCE("res/head/robot.png")})
    self:addChild(self._img_robot)
    self._img_robot:setLocalZOrder(ZOrder.other)
    self._img_robot:setPosition(cc.p(0,0))
    self._img_robot:setScale(0.8)
    self._img_robot:setVisible(false)

    --名次
    self._img_rank=control_tools.newImg({path=BPRESOURCE("res/head/escape_4.png")})
    self:addChild(self._img_rank)
    self._img_rank:setLocalZOrder(ZOrder.rank)
    self._img_rank:setVisible(false)

    --背景与位置调整
    if view_id and view_id== UserIndex.down then
        self._img_bg=control_tools.newImg({path=BPRESOURCE("res/head/bg_self.png"), size=cc.size(100,60),ctype=0})
        self._img_bg:setPosition(cc.p(0, 24))
        self._label_name:setPosition(cc.p(100,-33))
        self._label_gold:setPosition(cc.p(250,-33))
    else
        self._img_bg=control_tools.newImg({path=BPRESOURCE("res/head/bg_other.png"),ctype=0})
        self._img_bg:setPosition(cc.p(0, -18))
    end
    self:addChild(self._img_bg)
    
    if ptr_user_data.cbMember and ptr_user_data.cbMember > 0 and ptr_user_data.cbMember <5 then
        self._label_name:setTextColor(cc.c3b(255, 0, 0))
    else
        self._label_name:setTextColor(cc.c3b(255, 255, 255))
    end
    self:showVipLogo(ptr_user_data.cbMember, view_id)
    --层级调整
    self._img_head:setLocalZOrder(ZOrder.face)
    self._img_bg:setLocalZOrder(ZOrder.bg)
    self._img_border:setLocalZOrder(ZOrder.border)
    self._label_name:setLocalZOrder(ZOrder.name)
    self._label_gold:setLocalZOrder(ZOrder.gold)
end
function UIGameHead:update_head(ptr_user_data)
    if ptr_user_data.wFaceID==0 then 
        self._img_head:loadTexture(BPRESOURCE("gameres/head_id_1.png"),0)
    else 
        self._img_head:loadTexture("http://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png",0 )
    end
    --self._label_name:setString(ptr_user_data.szName)
    game_logic.setNameText(self._label_name, ptr_user_data.szName, 140)

    self._label_gold:setString(game_logic.getGoldText(ptr_user_data.lGold))
end

function UIGameHead:showVipLogo(level, view_id)
    if not self._vip_logo then
        self._vip_logo = control_tools.newImg({path =BPRESOURCE("res/head/vip1.png")})
        self:addChild(self._vip_logo)
        self._vip_logo:setLocalZOrder(ZOrder.sign)
    end

    self._vip_logo:setPosition(cc.p(-20, 26))
    if view_id == UserIndex.right then
        self._vip_logo:setPosition(cc.p(20, 26))
    end

    if level and level<5 and level >0 then
        self._vip_logo:loadTexture(BPRESOURCE("res/head/vip")..level..".png")
        self._vip_logo:setVisible(true)
    else
        self._vip_logo:setVisible(false)
    end
end

function UIGameHead:showRank(rank_order)
    if not self._img_rank then
        return 
    end

    if rank_order and rank_order > 0 and rank_order < 4 then
        self._img_rank :loadTexture(BPRESOURCE("res/head/escape_")..rank_order..".png")
        self._img_rank:setVisible(true)
    elseif rank_order and rank_order == 0 then
        self._img_rank:loadTexture(BPRESOURCE("res/head/escape_4.png"))
        self._img_rank:setVisible(true)
    else
        self._img_rank:setVisible(false)
    end
end

function UIGameHead:refreshRankPos(view_id)
    if not self._img_rank then
        return 
    end
    self._img_rank:setPosition(cc.p(30,20))
    if view_id == UserIndex.right then
        self._img_rank:setPosition(cc.p(-30,20))
    end
end

function UIGameHead:showRobot()
    self._img_robot:setVisible(true)
    self._is_left = true
end

function UIGameHead:hideRobot()
    self._img_robot:setVisible(false)
    self._is_left = false
end

return UIGameHead