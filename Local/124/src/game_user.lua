--------------------------------------------------------------------------------
-- 玩家头像
--------------------------------------------------------------------------------
local game_user = class("game_user", function() return ccui.Layout:create() end)

--------------------------------------------------------------------------------
-- 常量
--------------------------------------------------------------------------------
local tag = {self = 1, enemy = 2, needless = 3, base = 4}

local ccs = ccs or {}
ccs.MovementEventType = {
    START = 0,
    COMPLETE = 1,
    LOOP_COMPLETE = 2, 
}

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function game_user:ctor( visibleSize )
    self:setContentSize(visibleSize)
    self.player_background = {}
    self.player_heads = {}
    self.player_status = {}
    self.player_trust = {}
    self.player_identity = {}
    self.player_identity_logo = {}
    self.player_nickname = {}
    self.cards_count_bg = {}
    self.player_vip = {}
    self.gold_img = {}

    self:init(visibleSize)
end
-- 初始化
function game_user:init( visibleSize ) 
    for i=1, GAME_PLAYER do
        local head_back = self:game_user_info(i, visibleSize)
        head_back:setVisible(false)
    end
end
-- 设置父层级
function game_user:set_game_layer(game_layer)
    self.game_layer = game_layer
end
-- 玩家相关
function game_user:game_user_info( viewid, visibleSize )
    local player_pos = {cc.p(visibleSize.width-75, visibleSize.height -200*AUTO_HEIGHT), cc.p(75, 55*AUTO_HEIGHT), cc.p(75, visibleSize.height -200*AUTO_HEIGHT)}
    local time_pos = {cc.p(visibleSize.width-240, visibleSize.height - 200), cc.p(visibleSize.width/2, 280), cc.p(240, visibleSize.height -200)}

    local head_back = control_tools.newImg({})
    self:addChild(head_back)
    head_back:setPosition(player_pos[viewid])
    table.insert(self.player_background, head_back)

    local btn_head = require("bpsrc/ui_head"):create({path = "head_back.png", ctype = 1, size = cc.size(100*AUTO_HEIGHT, 100*AUTO_HEIGHT), csize = cc.size(99*AUTO_HEIGHT, 99*AUTO_HEIGHT)})
    head_back:addChild(btn_head)
    btn_head:setTouchEnabled(true)
    table.insert(self.player_heads, btn_head)

    local function touchfunc()
        local table_json = bind_function.get_user_data_by_chair_id(bind_function.switch_to_chair_id(viewid-1))
        if table_json == nil or table_json == {} or table_json == "" then return end

        if self.game_layer:bool_cheat() == true and self.game_layer.is_unkown_headimg[viewid] == true and viewid ~= LocalSelfChairId + 1 then return end
        
        self.game_layer.gift_show_user_id = table_json.dwUserID
        UserInfo.ShowUserInfo(1, 
            table_json,
            function (index, num) self.game_layer:on_btn_gift(index, num) end,
            1)
    end
    btn_head:setExtraFunc(touchfunc)

    --名字
    local back_name = control_tools.newLabel({font = 24, ex = true})
    head_back:addChild(back_name)
    back_name:setPosition(cc.p(0, -btn_head:getContentSize().height/2 - 15))
    table.insert(self.player_nickname, back_name)

    -- 金币
    local gold_img = control_tools.newImg({path = viewid == LocalSelfChairId + 1 and "img_gold_da.png" or "img_gold_xiao.png", ctype = 1})
    head_back:addChild(gold_img)
    if viewid == LocalSelfChairId + 1 then
        gold_img:setPosition(cc.p(btn_head:getPositionX() + btn_head:getContentSize().width/2 + gold_img:getContentSize().width/2 + 10, -btn_head:getContentSize().height/2 + gold_img:getContentSize().height/2 - 4))
    else    
        gold_img:setPosition(cc.p(0, back_name:getPositionY() - gold_img:getContentSize().height + 3))
    end
    table.insert(self.gold_img, gold_img)    

    local fnt_path = viewid == LocalSelfChairId + 1 and "text_font/number_doudizhu_jinbi1.fnt" or "text_font/number_doudizhu_jinbi2.fnt"
    gold_img.back_gold = control_tools.newLabel({fnt = g_path .. fnt_path})
    gold_img:addChild(gold_img.back_gold)
    gold_img.back_gold:setPosition(viewid == LocalSelfChairId + 1 and cc.p(20 + gold_img:getContentSize().width/2, 20) or cc.p(13 + gold_img:getContentSize().width/2, 10))

    -- vip
    local vip = control_tools.newImg({anchor = viewid >= LocalSelfChairId+1 and cc.p(0, 0) or cc.p(1, 0), ctype = 1})
    btn_head:addChild(vip)
    vip:setPosition(cc.p(viewid >= LocalSelfChairId+1 and 2 or btn_head:getContentSize().width-2, 1.5))
    table.insert(self.player_vip, vip)
    vip:setVisible(false)

    -- 状态(是否已准备)
    local status = control_tools.newImg({path = "ready.png", ctype = 1})
    self:addChild(status)
    status:setPosition(time_pos[viewid])
    status:setVisible(false)
    table.insert(self.player_status, status)

    -- 托管标志
    local trust_back = control_tools.newImg({path = "hint_bg.png", ctype = 1, size = cc.size(94*AUTO_HEIGHT, 94*AUTO_HEIGHT)})
    btn_head:addChild(trust_back)
    trust_back:setPosition(cc.p(btn_head:getContentSize().width/2, btn_head:getContentSize().height/2))
    trust_back:setVisible(false)
    table.insert(self.player_trust, trust_back)

    -- 身份
    local identity = control_tools.newImg({path = --[["img_landlord.png"--]]"img_farmer.png", ctype = 1})
    btn_head:addChild(identity)
    local identity_logo = control_tools.newImg({path = "banker_logo.png", ctype = 1})
    btn_head:addChild(identity_logo)
    if viewid < LocalSelfChairId+1 then
        identity:setPosition(cc.p(btn_head:getContentSize().width-18, btn_head:getContentSize().height-16))
        identity_logo:setPosition(cc.p(-40, btn_head:getContentSize().height- 13))
        identity:setScaleX(-1)
    else
        identity:setPosition(cc.p(18, btn_head:getContentSize().height-16))
        identity_logo:setPosition(cc.p(btn_head:getContentSize().width + 40, btn_head:getContentSize().height- 13))
    end
    table.insert(self.player_identity, identity)
    table.insert(self.player_identity_logo, identity_logo)
    identity:setVisible(false)
    identity_logo:setVisible(false)
    
    -- 卡牌数量
    local cards_count_bg = control_tools.newImg({path = "cards_count.png", ctype = 1})
    self:addChild(cards_count_bg)
    local mut = viewid > LocalSelfChairId and 1 or -1
    cards_count_bg:setPosition(cc.p(player_pos[viewid].x + mut*(btn_head:getContentSize().width - 10*AUTO_HEIGHT), player_pos[viewid].y - cards_count_bg:getContentSize().height/2))
    table.insert(self.cards_count_bg, cards_count_bg)
    cards_count_bg:setVisible(false)

    cards_count_bg.cards_count = control_tools.newLabel({fnt = g_path .. "/text_font/number_doudizhu_shoupaishuliang.fnt", str = "10"})
    cards_count_bg.cards_count:setPosition(cc.p(cards_count_bg:getContentSize().width/2, 15))
    cards_count_bg:addChild(cards_count_bg.cards_count)

    if viewid == LocalSelfChairId + 1 then 
        --  充值按钮
        local function touch_event(sender, touchType)
            if touchType == _G.TOUCH_EVENT_ENDED then
                -- if show_gift_shop then
                --     local tbl_json = bind_function.get_room_data()
                --     if tbl_json == nil then
                --         return
                --     end

                --     if bit._and(tbl_json.room_mode, GF.ROOM_MODE_REDPACKET) ~= 0 then
                --         show_gift_shop(5,6)
                --     else
                --         show_gift_shop(1,6)
                --     end
                -- else
                --     show_simple_shop("充值礼包", "获取礼包")
                -- end
            end
        end

        local btn_add = control_tools.newBtn({normal = "pay.png", ctype = 1, scale = AUTO_SCALE})
        btn_add:setPosition(cc.p(gold_img:getContentSize().width, gold_img:getContentSize().height/2))
        btn_add:addTouchEventListener(touch_event)
        gold_img:addChild(btn_add) 
    end
        
    return head_back
end

function game_user:update_head_img(viewid)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end
    print("---------------------zctgs vy se---------------------1")
    if UICustomImage.updata_head then
        print("---------------------zctgs vy se---------------------2")
        self.player_heads[viewid]:updata_head()    
    end
end

-- 设置vip
function game_user:setVip(viewid, vip_level)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end
    if vip_level < 1 or vip_level > 4 then
        self.player_vip[viewid+1]:setVisible(false)
        return 
    end
    self.player_vip[viewid+1]:setVisible(true)
    self.player_vip[viewid+1]:loadTexture("vip" .. vip_level .. ".png", 1)
end
-- 显示倍数提示
function game_user:show_gold_times()
    self.game_layer.times_img:setVisible(true)
    self.game_layer.times_img:setPosition(cc.p(self:getContentSize().width/2, self:getContentSize().height*3/5))

    local function callback()
        self.game_layer.times_img:setVisible(false)
        self.game_layer.top_bar:gold_times_action(self.game_layer.base_gold_times)
    end
    local pos = self.game_layer.top_bar.gold_times:convertToWorldSpace(cc.p(0, 0))
    local target_pos = self:convertToNodeSpace(pos)
    local moveto = action_tools.CCMoveTo(0.4, target_pos.x, target_pos.y)
    local callfunc = action_tools.CCCallFunc(callback)

    self.game_layer.times_img:runAction(action_tools.CCSequence(moveto, callfunc))
end
-- 显示出牌动画
function game_user:show_outcards_animation(outcards_type, viewid, cards_count)
    local position = {cc.p(self:getContentSize().width-230, self:getContentSize().height-205), 
                cc.p(self:getContentSize().width/2, self:getContentSize().height*2/5+20), 
                cc.p(230, self:getContentSize().height -205)}

    local count = cards_count > 10 and 10 or cards_count
    local width = ((count - 1) * 20) / 2 

    local posX, posY = 0, position[viewid+1].y-25
    if viewid > LocalSelfChairId then
        posX = position[viewid+1].x + width
    elseif viewid == LocalSelfChairId then
        posX = position[viewid+1].x
    elseif viewid < LocalSelfChairId then
        posX = position[viewid+1].x - width
    end

    if cards_count > 10 and viewid ~= LocalSelfChairId then
        posY = posY - 30
    end

    local armature = nil
    if outcards_type == KindCards.cards_3_1 or
        outcards_type == KindCards.cards_3_2 or
        outcards_type == KindCards.cards_4_2 or
        outcards_type == KindCards.cards_4_4 or 
        outcards_type == KindCards.cards_shunzi_1 or
        outcards_type == KindCards.cards_shunzi_2 or
        outcards_type == KindCards.cards_plane or 
        outcards_type == KindCards.cards_shunzi_3 then

        local pos_X = viewid <= LocalSelfChairId and posX+120 or posX-120
        armature = ccs.Armature:create("ddz_xiaopaixingdonghua")
        armature:setPosition(cc.p(posX, posY))
        self:addChild(armature, 101)  

        if outcards_type == KindCards.cards_3_1 then
            armature:getAnimation():play("ddz_sandaiyi")
        elseif outcards_type == KindCards.cards_3_2 then
            armature:getAnimation():play("ddz_sandaiyidui")
        elseif outcards_type == KindCards.cards_4_2 or 
            outcards_type == KindCards.cards_4_4 then
            armature:getAnimation():play("ddz_sidaier")
        elseif outcards_type == KindCards.cards_shunzi_1 then
            armature:getAnimation():play("ddz_shunzi")
        elseif outcards_type == KindCards.cards_shunzi_2 then
            armature:getAnimation():play("ddz_liandui")
        elseif outcards_type == KindCards.cards_plane or 
            outcards_type == KindCards.cards_shunzi_3  then
            armature:getAnimation():play("ddz_feiji")
        end

        local function animationEvent(armatureBack, movementType, movementID)
            if movementType ~= ccs.MovementEventType.START then
                armatureBack:removeFromParent()
            end
        end
        armature:getAnimation():setMovementEventCallFunc(animationEvent)

    elseif outcards_type == KindCards.cards_bomb or
        outcards_type == KindCards.cards_king then

        local derict = viewid >= LocalSelfChairId and -1 or 1
        if not self.boom then
            self.boom = control_tools.newImg({path = "boom.png", ctype = 1})
            self:addChild(self.boom)
        end

        local player_pos = {cc.p(self:getContentSize().width-75, self:getContentSize().height -220*AUTO_HEIGHT), cc.p(100, 60), cc.p(75, self:getContentSize().height -220*AUTO_HEIGHT)}
        self.boom:setPosition(player_pos[viewid+1])
        self.boom:setVisible(true)

        local controlPoint_1 = cc.p(self:getContentSize().width/2 + derict * 200, self:getContentSize().height/2+200)  
        local controlPoint_2 = cc.p(self:getContentSize().width/2 + derict * 100, self:getContentSize().height/2+100)  
        local endPosition = cc.p(self:getContentSize().width/2, self:getContentSize().height/2+50)  


        local rotate = action_tools.CCRotateTo(0.3, 720)
        local bezier = action_tools.CCBezierTo(0.3, {controlPoint_1, controlPoint_2, endPosition})

        local spawn = action_tools.CCSpawn(rotate, bezier)
        local callfunc = action_tools.CCCallFunc(function ()
            self.boom:setVisible(false)
            armature = ccs.Armature:create("ddz_zhadanbaozha")
            armature:setPosition(cc.p(self:getContentSize().width/2, self:getContentSize().height/2+50))
            if outcards_type == KindCards.cards_king then
                armature:getAnimation():play("ddz_wangzhaxiaoguo")
            else
                armature:getAnimation():play("ddz_zhadanxiaoguo")
            end                
            self:addChild(armature, 101)
            local function animationEvent(armatureBack, movementType, movementID)
                if movementType ~= ccs.MovementEventType.START then
                    armatureBack:removeFromParent()
                    self:show_gold_times()
                end
            end
            armature:getAnimation():setMovementEventCallFunc(animationEvent)
        end)   
        self.boom:stopAllActions()
        self.boom:runAction(CCSequence:create(spawn, callfunc))
    end
end
-- 显示剩余手牌
function game_user:set_cards_count(viewid, count)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end

    if viewid == LocalSelfChairId then
        return
    end

    if count == -1 then
        self.cards_count_bg[viewid+1]:setVisible(false)
        return 
    end

    self.cards_count_bg[viewid+1]:setVisible(true)
    self.cards_count_bg[viewid+1].cards_count:setString(tostring(count))
end
-- 显示玩家身份
function game_user:set_identity(viewid, identity)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end

    if self.player_background[viewid+1]:isVisible() == false then
        return
    end

    if identity == -1 then
        self.player_identity[viewid+1]:setVisible(false)
        self.player_identity_logo[viewid+1]:setVisible(false)
        return 
    end

    if identity == UserIdentity.landlord then
        self.player_identity[viewid+1]:loadTexture("img_landlord.png", 1)
        self.player_identity_logo[viewid+1]:setVisible(viewid ~= LocalSelfChairId)
    elseif identity == UserIdentity.farmer then
        self.player_identity[viewid+1]:loadTexture("img_farmer.png", 1)
        self.player_identity_logo[viewid+1]:setVisible(false)
    end
    self.player_identity[viewid+1]:setVisible(identity ~= UserIdentity.null)
end
-- 设置托管
function game_user:set_trust(viewid, isTrust)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end


    if isTrust then
        if self.player_trust[viewid+1].armature == nil then
            self.player_trust[viewid+1].armature = ccs.Armature:create("ddz_tuoguan")
            self.player_trust[viewid+1]:addChild(self.player_trust[viewid+1].armature)
            self.player_trust[viewid+1].armature:setPosition(self.player_trust[viewid+1]:getPosition())
        end
        self.player_trust[viewid+1].armature:getAnimation():play("Animation3")
    else 
        if self.player_trust[viewid+1].armature ~= nil then
            self.player_trust[viewid+1].armature:removeFromParent()
            self.player_trust[viewid+1].armature = nil
        end
    end
    self.player_trust[viewid+1]:setVisible(isTrust)
end
-- 显示玩家状态
function game_user:set_status(viewid, status)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end

    if status ~= UserStatus.ready and status ~= UserStatus.null then
        self.game_layer.player_clock:hide()
    end
    
    if status == UserStatus.is_landlord or status == UserStatus.null or status == UserStatus.outcards then
        self.player_status[viewid+1]:setVisible(false)
        return
    end

    self.player_status[viewid+1]:setVisible(true)
    if status == UserStatus.ready then
        if viewid == LocalSelfChairId then
            self.player_status[viewid+1]:setVisible(false)
        else
            self.player_status[viewid+1]:loadTexture("ready.png", 1)
        end
    elseif status == UserStatus.pass then
        self.player_status[viewid+1]:loadTexture("pass.png", 1)
        -- 播放pass音效
        if self.game_layer:get_sex_by_chairid(bind_function.switch_to_chair_id(viewid)) == PlayerSex.girl then
            AudioEngine.playEffect(MUSIC_PATH.girl[5][math.random(1, 4)])
        else
            AudioEngine.playEffect(MUSIC_PATH.boy[5][math.random(1, 4)])
        end
    else
        if status == UserStatus.landlord then
            self.player_status[viewid+1]:loadTexture("landlord.png", 1)
        elseif status == UserStatus.no_landlord then
            self.player_status[viewid+1]:loadTexture("no_landlord.png", 1)
        elseif status == UserStatus.rob then
            self.player_status[viewid+1]:loadTexture("rob.png", 1)
        elseif status == UserStatus.no_rob then
            self.player_status[viewid+1]:loadTexture("no_rob.png", 1)
        end
        for i=1, GAME_PLAYER do
            if self.game_layer.m_game_main:switch_to_view_id(i) ~= viewid then
                self.player_status[self.game_layer.m_game_main:switch_to_view_id(i)+1]:setVisible(false)
            end
        end
    end
end
-- 更新玩家头像（非自定义头像 根据性别）
function game_user:set_sex(viewid, user_data, bool_unknow)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end
    if self.player_heads[viewid + 1] == nil then
        return 
    end
    if self.player_heads[viewid + 1] == nil then
        return 
    end
    self.player_heads[viewid + 1]:set_head(94*AUTO_HEIGHT, 94*AUTO_HEIGHT, user_data, bool_unknow)
end
-- 设置用户名字
function game_user:set_nickname(viewid, name, vip_level)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end

    self:setVip(viewid, vip_level)
    
    if viewid == LocalSelfChairId then
        return    
    end

    self.player_nickname[viewid+1]:setColor(vip_level > 0 and cc.c3b(193, 4, 4) or cc.c3b(255, 255, 255))
    self.player_nickname[viewid+1]:setTextEx(name, 140)
    -- self.player_nickname[viewid+1]:setTextEx("我就要六个字我的天呐", 121)
    --[[if viewid == 0 then
        self.player_nickname[viewid+1]:setTextEx("就四个字", 81)
    else
        self.player_nickname[viewid+1]:setTextEx("任性五个字", 81)
    end]]
end
-- 获取按指定格式显示的金币or积分值
function game_user:get_gold_number(number)
    local gold = number
    if number < 10000 then
        gold = number
    elseif number < 1000000 then
        gold, dot =  math.modf(number/10000)
        dot =  math.modf(dot/ 0.01)
        if dot <10 then 
            dot = "0"..dot 
        end 
        gold = gold.."."..dot.."万"
    elseif number < 10000000 then
        gold, dot =  math.modf(number/10000)
        dot =  math.modf(dot/ 0.1)
        gold = gold.."."..dot.."万"
    else
        gold, dot =  math.modf(number/10000)
        gold = gold.."万"
    end
    return gold
end
-- 设置积分
function game_user:set_score(viewid, score)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end
    self.gold_img[viewid+1]:setVisible(true)
    self.gold_img[viewid+1].back_gold:setString(self:get_gold_number(score))
end
-- 设置金币
function game_user:set_gold(viewid, gold)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end
    if gold == -1 then
        return 
    end
    if gold == -2 then
        self.gold_img[viewid+1]:setVisible(false)
        return
    end
    self.gold_img[viewid+1]:setVisible(true)
    self.gold_img[viewid+1].back_gold:setString(self:get_gold_number(gold))
end
-- 显示玩家 
function game_user:show_user(viewid, isShow, isAction, isNocheat)
    print("-----isAction = ", isAction)
    isAction = isAction ~= nil and isAction or false
    isNocheat = isNocheat ~= nil and isNocheat or false
    print("-----isAction = ", isAction, isShow)
    if not viewid or viewid < 0 or viewid > GAME_PLAYER then
        return 
    end

    if isShow == true and view_id == LocalSelfChairId then
        btn_add:setVisible(self.game_layer:is_module_shop())
    end

    self.player_background[viewid + 1]:setVisible(isShow)
    self.player_nickname[viewid+1]:setVisible(isShow)
    self.gold_img[viewid+1]:setVisible(isShow)

    -- 离开动画
    if isShow == false and viewid ~= LocalSelfChairId and isAction == false then
        self:show_left_action(viewid)
    end
end
-- 显示离开动画
function game_user:show_left_action(viewid)
    local sprite = cc.Sprite:create()
    local pos = self.player_heads[viewid+1]:convertToWorldSpace(cc.p(self.player_heads[viewid+1]:getContentSize().width/2, self.player_heads[viewid+1]:getContentSize().height/2))
    sprite:setPosition(self:convertToNodeSpace(pos))
    self:addChild(sprite)
    local animation = cc.Animation:create()
    for i=1, 7 do
        local sprit_frame = cc.SpriteFrame:create((g_path .. "left/left000" .. i .. ".png"),
                                            cc.rect(0, 0, 64, 84))
        animation:addSpriteFrame(sprit_frame)
    end
    animation:setDelayPerUnit(0.7 / 7)
    animation:setRestoreOriginalFrame(true)
    local action = cc.Animate:create(animation)
    sprite:runAction(action)
end
-- 显示春天动画
function game_user:showSpringAnimation()
    local armature =  ccs.Armature:create("ddz_chuntian")
    armature:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2 ))
    self:addChild(armature, 1)
    armature:getAnimation():play("Animation1", 3, -1)
    local function animationEvent(armatureBack, movementType, movementID)
        if movementType ~= ccs.MovementEventType.START then
            armatureBack:removeFromParent()
        end
    end
    armature:getAnimation():setMovementEventCallFunc(animationEvent)
end 
-- 清除部分显示数据
function game_user:clear_ui()
    for i=1, GAME_PLAYER do
        self:set_identity(i-1, -1)
    end
end
-- 离开信息
function game_user:show_left_info(viewid, isAction)
    self:show_user(viewid, false, isAction)
    self:set_status(viewid, UserStatus.null)
    self:set_identity(viewid, UserIdentity.null)
    self:set_gold(viewid, -1)
    self:set_nickname(viewid, "", -1)
end

function game_user:destroy()

end

return game_user