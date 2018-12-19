-----------------------------------------------------------------
-- 单款游戏入口
-----------------------------------------------------------------
local gameMain = class("gameMain")
g_path = BPRESOURCE("res/")

function gameMain:ctor()
    print("DY Log>>gameMain:ctor")
    self.ptr_game_frame = nil
    self:init()
end

function gameMain:init()
    print("DY Log>>gameMain:init")
    -- 初始化场景
    local main_layout = bp_get_main_layout();
    local visibleSize = CCDirector:getInstance():getVisibleSize()

    -- 加载资源
    self.frame_cache = CCSpriteFrameCache:getInstance()
    self.frame_cache:addSpriteFrames(g_path .. "TextureResources.plist")
    self.frame_cache:addSpriteFrames(g_path .. "cards/cards_1.plist")
    self.frame_cache:addSpriteFrames(g_path .. "cards/cards_2.plist")
    self.frame_cache:addSpriteFrames(g_path .. "cards/cards_3.plist")
    self.frame_cache:addSpriteFrames(g_path .. "res_result.plist")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "action/ddz_pipei.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "action/ddz_tuoguan.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "action/ddz_chuntian.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "action/ddz_zhadanbaozha.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "action/ddz_xiaopaixingdonghua.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "action/ddz_shengli.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "action/ddz_shibai.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "action/ddz_shengli_chuntian.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path .. "action/dh_fanfanle.ExportJson")

    require "src/game_logic"
    -- 初始化游戏界面
    self.ddz_layer = require("src/game_layer"):create(visibleSize)
    main_layout:addChild(self.ddz_layer)
    self.ddz_layer:setTouchEnabled(true)
end

function gameMain:destory()
    print("DY Log>>gameMain:destory")
    self.ddz_layer:destory()
    -- 移除资源
    self.frame_cache:removeSpriteFramesFromFile(g_path .. "TextureResources.plist")
    self.frame_cache:removeSpriteFramesFromFile(g_path .. "cards/cards_1.plist")
    self.frame_cache:removeSpriteFramesFromFile(g_path .. "cards/cards_2.plist")
    self.frame_cache:removeSpriteFramesFromFile(g_path .. "cards/cards_3.plist")
    self.frame_cache:removeSpriteFramesFromFile(g_path .. "res_result.plist")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "action/ddz_pipei.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "action/ddz_tuoguan.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "action/ddz_chuntian.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "action/ddz_zhadanbaozha.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "action/ddz_xiaopaixingdonghua.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "action/ddz_shengli.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "action/ddz_shibai.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "action/ddz_shengli_chuntian.ExportJson")
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "action/dh_fanfanle.ExportJson")
end

function gameMain:set_game_frame(param_game_frame)
    print("DY Log>>gameMain:set_game_frame")
    self.ptr_game_frame = param_game_frame
    if self.ddz_layer ~= nil then
        self.ddz_layer:set_game_main(param_game_frame)
    end
end

--------------------------------------------------------------------------------
-- 游戏交互
--------------------------------------------------------------------------------
function gameMain:on_game_message(int_main_id, data)
    print("DY Log>>gameMain:on_game_message",int_main_id,data)
    if data == nil then
        return 
    end
    self.ddz_layer:on_game_message(int_main_id, data)
end

function gameMain:on_game_user_left(ptr_user_data,bool_look)
    print("DY Log>>gameMain:on_game_user_left",json.encode(ptr_user_data))
    if not look then
        if ptr_user_data == nil then
            return 
        end
        self.ddz_layer:on_game_user_left(ptr_user_data)
    end
end

--用户状态改变
function gameMain:on_game_user_status(ptr_user_data,bool_look)
    print("DY Log>>gameMain:on_game_user_status",json.encode(ptr_user_data))
    if not look then
        if ptr_user_data == nil then
            return 
        end
        self.ddz_layer:on_game_user_status(ptr_user_data)
    end
end 

function gameMain:on_game_user_enter(ptr_user_data,bool_look)
    print("DY Log>>gameMain:on_game_user_enter",json.encode(ptr_user_data))
    if not bool_look then
        if ptr_user_data == nil then
            return 
        end
        self.ddz_layer:on_game_user_enter(ptr_user_data)
    end
end

function gameMain:on_game_user_data(ptr_user_data,bool_look)
    print("DY Log>>on_game_user_data",json.encode(ptr_user_data))
    if not look then
        if ptr_user_data == nil then
            return 
        end
        self.ddz_layer:on_game_user_data(ptr_user_data)
    end
end

function gameMain:on_game_user_score(ptr_user_data,boo_look)
    print("DY Log>>on_game_user_score",json.encode(ptr_user_data))
    if not look then
        if ptr_user_data == nil then
            return 
        end
        self.ddz_layer:on_game_user_score(ptr_user_data)
    end
end

function gameMain:on_game_user_chat(ptr_user_data, string_chat)
    print("DY Log>>on_game_user_chat",json.encode(ptr_user_data))
    print("string_chat = ", string_chat)
    if ptr_user_data == nil or string_chat == nil then
        return 
    end
    self.ddz_layer:on_game_user_chat(ptr_user_data, string_chat)
end

return gameMain