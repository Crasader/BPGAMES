print("=====UIGrade=====")

sptr_grade_layer=nil
---------------------------------------------------------------------------------
-- 好友房战绩界面
---------------------------------------------------------------------------------
local UIControl = require("bpsrc/ui_control")
local UIGrade = class("UIGrade", UIControl)

local g_path = BPRESOURCE("bpres/ui_grade/")

---------------------------------------------------------------------------------
-- 常量
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- 函数
---------------------------------------------------------------------------------
function UIGrade:ctor()
    self.super:ctor(self)

    self.item_list = {}
    self.sleep_item_list = {}
	self:init()
end

function UIGrade:init()
	-- 背景框
    self:set_bg(g_path .. "gui.png")
    self:update_layout()

    self.info_bg = self:get_gui()
    self.view_size = self.info_bg:getContentSize()
    self:set_touch_bg(true)

    -- 名次 名字 战绩背景
    local title_bg = control_tools.newImg({path = g_path .. "title_bg.png"})
    self.info_bg:addChild(title_bg)
    title_bg:setPosition(cc.p(self.view_size.width/2, self.view_size.height - 84 - title_bg:getContentSize().height/2))

    -- 界面标题
    local title_img = control_tools.newImg({path = g_path .. "title.png"})
    self.info_bg:addChild(title_img)
    title_img:setPosition(cc.p(self.view_size.width/2, self.view_size.height - title_img:getContentSize().height*2/3))

    -- 名次图片
    local rank_img = control_tools.newImg({path = g_path .. "rank.png"})
    title_bg:addChild(rank_img)
    rank_img:setPosition(cc.p(100, title_bg:getContentSize().height/2))

    -- 名字图片
    local name_img = control_tools.newImg({path = g_path .. "name.png"})
    title_bg:addChild(name_img)
    name_img:setPosition(cc.p(title_bg:getContentSize().width/2, title_bg:getContentSize().height/2))

    -- 战绩图片
    local grade_img = control_tools.newImg({path = g_path .. "grade.png"})
    title_bg:addChild(grade_img)
    grade_img:setPosition(cc.p(title_bg:getContentSize().width - 100, title_bg:getContentSize().height/2))

    -- 拖动层
    self.drag_layout = control_tools.newScrollView({size = cc.size(740, 240)})
    self.info_bg:addChild(self.drag_layout)
    self.drag_layout:setScrollBarAutoHideEnabled(true)
    self.drag_layout:setPosition(cc.p(30, 95)) 

    self.table_id = control_tools.newLabel({str = "房间号：", font = 22, anchor = cc.p(0, 0.5), color = cc.c3b(255, 254, 232)})
    self.info_bg:addChild(self.table_id)
    self.table_id:setPosition(cc.p(30, 72))

    self.time_label = control_tools.newLabel({str = "游戏时间：", font = 22, anchor = cc.p(0, 0.5), color = cc.c3b(255, 254, 232)})
    self.info_bg:addChild(self.time_label)
    self.time_label:setPosition(cc.p(30, 42))

    self.btn_share = control_tools.newBtn({normal = g_path .. "btn_share.png"})
    self.info_bg:addChild(self.btn_share)
    self.btn_share:setPosition(cc.p(self.view_size.width/2, 55))
    self.btn_share:addTouchEventListener( function (sender, eventType) self:on_btn_share(sender, eventType) end )

    local tips_label = control_tools.newLabel({str = "好友房仅供娱乐，请勿他用！", font = 22, anchor = cc.p(1, 0.5), color = cc.c3b(255, 254, 232)})
    self.info_bg:addChild(tips_label)
    tips_label:setPosition(cc.p(self.view_size.width - 20, 58))
end
-- 分享点击事件
function UIGrade:on_btn_share(sender, eventType)
	if eventType ~= _G.TOUCH_EVENT_ENDED then
		return
	end
	-- 点击音效
	AudioEngine.playEffect(BPRESOURCE("bpres/sound/click.mp3"))
end
-- 创建名次item
function UIGrade:create_rank_item(rank, name, result)
    -- item bg
    local item_bg = nil
    if #self.sleep_item_list > 0 then
        item_bg = self.sleep_item_list[#self.sleep_item_list]
        table.remove(self.sleep_item_list, #self.sleep_item_list)

        item_bg.rank:setString(tostring(rank))
        item_bg.name:setString(tostring(name))
        item_bg.result:setString(tostring(result))
        item_bg:setVisible(true)
    else
        item_bg = control_tools.newImg({path = g_path .. "item_bg.png"})
        self.drag_layout:addChild(item_bg)

        item_bg.rank = control_tools.newLabel({str = rank, font = 26, color = cc.c3b(133, 79, 15)})
        item_bg:addChild(item_bg.rank)
        item_bg.rank:setPosition(cc.p(100, item_bg:getContentSize().height/2))

        item_bg.name = control_tools.newLabel({str = name, font = 26, color = cc.c3b(133, 79, 15)})
        item_bg:addChild(item_bg.name)
        item_bg.name:setPosition(cc.p(item_bg:getContentSize().width/2, item_bg:getContentSize().height/2))

        item_bg.result = control_tools.newLabel({str = result > 0 and "+" .. tostring(result) or tostring(result), font = 26, color = cc.c3b(133, 79, 15)})
        item_bg:addChild(item_bg.result)
        item_bg.result:setPosition(cc.p(item_bg:getContentSize().width - 100, item_bg:getContentSize().height/2))
    end

    return item_bg
end
-- 名词排序
function UIGrade:sort_by_grade(grade_list, count)
    for i = count, 2, -1 do
        for j = 1, i-1 do
            if grade_list[j].grade < grade_list[j+1].grade then
                local temp_value = grade_list[j]
                grade_list[j] = grade_list[j+1]
                grade_list[j+1] = temp_value
            end
        end
    end
end
-- 显示界面详情
function UIGrade:show_grade_layer(grade_data)
    -- 清除残留数据
    for i,v in ipairs(self.item_list) do
        table.insert(self.sleep_item_list, v)
        v:setVisible(false)
    end
    self.item_list = {}
    
    -- 显示房间号
    self.table_id:setString(tostring("房间号：" .. grade_data.room_code))

    -- 显示当前时间
    self.time_label:setString("游戏时间：" .. os.date("%Y/%m/%d %H:%M"))

    local count = #grade_data.grade_list
    -- 排序
    self:sort_by_grade(grade_data.grade_list, count)
    -- 设置滚动容器内部实际大小
    local total_height = count * 60 < 240 and 240 or count * 60
    self.drag_layout:setInnerContainerSize(cc.size(740, total_height))
    -- 显示名次列表
    for i=1, count do
        local item = self:create_rank_item(i, grade_data.grade_list[i].name, grade_data.grade_list[i].grade)
        item:setPosition(cc.p(self.drag_layout:getContentSize().width/2, total_height - (i-1)*60 - 30))
        table.insert(self.item_list, item)
    end
    self.drag_layout:jumpToTop()

	self:ShowGui(true)
end
-- 显示好友房战绩界面
function UIGrade.ShowGradeLayer(grade_data)
    if sptr_grade_layer == nil then 
        local main_layout = bp_get_main_layout()
        sptr_grade_layer = UIGrade:create()
        main_layout:addChild(sptr_grade_layer)
    end
  
    sptr_grade_layer:show_grade_layer(grade_data)
    return sptr_grade_layer
end

function UIGrade:destroy()
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(g_path .. "dh_kaishi.ExportJson")
end

return UIGrade
