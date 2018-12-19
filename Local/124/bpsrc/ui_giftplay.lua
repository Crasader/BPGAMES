--------------------------------------------------------------------------------
-- 礼物发送
--------------------------------------------------------------------------------
local gift_play = class("gift_play", function () return ccui.Layout:create() end )
local g_path = BPRESOURCE("bpres/gift/")

--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
function gift_play:ctor()

end

function gift_play:play_gift(from_pos, to_pos, gift_id, sprite_id, delay)
    sprite_id = sprite_id or 0
    delay = delay or 0

    if gift_id < 0 or gift_id > 4 then
        return
    end

    local file_info = cc.FileUtils:getInstance():getStringFromFile(g_path .. gift_id .. "/config.json")
    if file_info == nil then return end
    
    local table_json = json.decode(file_info)
    if table_json == nil then return end

    -- 开始
    local start_width = table_json.start_width
    local start_height = table_json.start_height
    local start_count = table_json.start_count
    local start_time = table_json.start_time
    local animation1 = cc.Animation:create()
    for i=1, start_count do
        local sprit_frame = cc.SpriteFrame:create(g_path .. gift_id .. "/start" .. i .. ".png",
                                            cc.rect(0, 0, start_width, start_height))
        animation1:addSpriteFrame(sprit_frame)
    end
    animation1:setDelayPerUnit(start_time / start_count)
    animation1:setRestoreOriginalFrame(true)
    local start_action = cc.Animate:create(animation1)

    -- 移动
    local move_width = table_json.move_width
    local move_height = table_json.move_height
    local move_time = table_json.move_time
    local move_rotation = table_json.move_rotation
    local move_turn = table_json.move_turn
    local animation2 = cc.Animation:create()
    local sprit_frame = cc.SpriteFrame:create(g_path .. gift_id .. "/duration.png",
                                        cc.rect(0, 0, move_width, move_height))
    animation2:addSpriteFrame(sprit_frame)
    animation2:setDelayPerUnit(move_time / 1)
    animation2:setRestoreOriginalFrame(true)
    local move_action = cc.Animate:create(animation2)

    -- 结束
    local end_width = table_json.end_width
    local end_height = table_json.end_height
    local end_count = table_json.end_count
    local end_time = table_json.end_time
    local animation3 = cc.Animation:create()
    for i=1, end_count do
        local sprit_frame = cc.SpriteFrame:create(g_path .. gift_id .. "/end" .. i .. ".png",
                                            cc.rect(0, 0, end_width, end_height))
        animation3:addSpriteFrame(sprit_frame)
    end
    animation3:setDelayPerUnit(end_time / end_count)
    animation3:setRestoreOriginalFrame(true)

    local end_action = cc.Animate:create(animation3)

    local sprite_gift = {}
    sprite_gift[sprite_id] = cc.Sprite:create()
    sprite_gift[sprite_id]:setPosition(from_pos)
    self:addChild(sprite_gift[sprite_id])

    local function action_sound()
        AudioEngine.playEffect(g_path .. "sound/sound_index" .. gift_id .. ".mp3")
    end

    local function callBack()
        sprite_gift[sprite_id]:removeFromParent()
    end

    local delaytime = action_tools.CCDelayTime(delay)
    local callback = action_tools.CCCallFunc(action_sound)
    local callback2 = action_tools.CCCallFunc(callBack)
    local sequence1 = action_tools.CCSequence(delaytime, callback, move_action, end_action, callback2)

    local delay1 = action_tools.CCDelayTime(delay)
    local move1 = action_tools.CCMoveTo(move_time, to_pos.x, to_pos.y)
    local sequence2 = action_tools.CCSequence(delay1, move1)
    
    if move_rotation == 1 then 
        local delay_time = action_tools.CCDelayTime(delay)
        local rotate = CCRotateBy:create(move_time,360*move_turn)
        local sequence3 = action_tools.CCSequence(delay_time, rotate)
        sprite_gift[sprite_id]:runAction(action_tools.CCSpawn(sequence1, sequence2, sequence3))
    else
        sprite_gift[sprite_id]:runAction(action_tools.CCSpawn(sequence1, sequence2))
    end
end

function gift_play:play_gift_times(form_pos, to_pos, gift_id, gift_num)
    print("----------gift_id = ", gift_id, " gift_num = ", gift_num)
    gift_num = gift_num or 1
    for i=1, gift_num do
        self:play_gift(form_pos, to_pos, gift_id, i, 0.2*(i-1))
    end
end

return gift_play
