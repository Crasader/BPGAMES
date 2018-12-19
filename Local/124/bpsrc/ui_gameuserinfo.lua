--------------------------------------------------------------------------------
-- 游戏中用户信息界面
--------------------------------------------------------------------------------
local UIControl = require("bpsrc/ui_control")
local UIGameUserInfo = class("UIGameUserInfo", UIControl)

local UIHead = require("bpsrc/ui_head")
local UIReport = require("bpsrc/ui_report")

local g_path = BPRESOURCE("bpres/userinfo/")
local prop_path = BPRESOURCE("res/props/", 10001)
local req = "https://demoopen.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;PropUse&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;prop_id&quot;:{PROPID},&quot;reserve&quot;:&quot;{PARAM}&quot;,&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION},&quot;keyword&quot;:&quot;{KEYWORD}&quot;}}"

require "bptools/class_tools"

ptr_user_info = nil
--------------------------------------------------------------------------------
-- 函数
--------------------------------------------------------------------------------
-- 创建
function UIGameUserInfo:ctor()
    print("DY Log>>UIGameUserInfo")
    self.super:ctor(self)
    self.btn_gift = {}
    self.gift_num = {}
    self.gift_count_bg = {}
    self.gift_count = {}
    self.prop_item_tbl = {}
    self.praise_count_tbl = {}
    self.ptr_user_data = nil

    self:init()
end
-- 初始化
function UIGameUserInfo:init()
    local   l_lister= cc.EventListenerCustom:create("NOTICE_UPDATE_USER_DATA", function (eventCustom)
        print("----------------UIGameUserInfo-----------NOTICE_UPDATE_USER_DATA------------")
        if eventCustom==nil then return end
        self:on_update_user_data();
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    local l_lister= cc.EventListenerCustom:create("NOTICE_GMAE_START", function (eventCustom)
        if eventCustom==nil then return end
        self:on_game_start()
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)

    -- 背景框
    self:set_bg(g_path .. "gui.png")
    self:update_layout()

    self.info_bg = self:get_gui()
    self.the_size = self.info_bg:getContentSize()

    -- 头像
    self.user_head = UIHead:create({csize = cc.size(150, 150), path = g_path .. "head_back.png"})
    self.info_bg:addChild(self.user_head)
    self.user_head:setPosition(cc.p(self.user_head:getContentSize().width/2 + 40, self.the_size.height - self.user_head:getContentSize().height/2 - 35))

    local scale = 0.7
    self.other_praise_bg, self.other_praise_count = self:create_praise_part(self.user_head)
    self.other_praise_bg:setPosition(cc.p(self.user_head:getContentSize().width - self.other_praise_bg:getContentSize().width/2*scale, self.user_head:getContentSize().height - self.other_praise_bg:getContentSize().height/2*scale - 2))
    self.other_praise_bg:setScale(scale)

    -- vip标识
    self.vip_img = control_tools.newImg({})
    self.user_head:addChild(self.vip_img)
    self.vip_img:setPosition(cc.p(25, self:getContentSize().height - 15))
    self.vip_img:setVisible(false)

    -- 点赞按钮
    self.btn_praise = control_tools.newBtn({normal = g_path .. "praise_img.png"})
    self.user_head:addChild(self.btn_praise)
    self.btn_praise:setPosition(cc.p(self.user_head:getContentSize().width - 25 , 25))
    self.btn_praise:addTouchEventListener(function (sender, eventType) self:on_btn_praise(sender, eventType) end)

    -- 魅力
    local charm_bg = control_tools.newBtn({normal = g_path .. "charm_bg.png"})
    self.info_bg:addChild(charm_bg)
    charm_bg:setPosition(cc.p(self.user_head:getPositionX(), self.user_head:getPositionY() - self.user_head:getContentSize().height/2 - charm_bg:getContentSize().height/2 - 5))
    charm_bg:addTouchEventListener( function (sender, eventType) self:on_btn_charm(sender, eventType) end )
    charm_bg:setZoomScale(0)
    
    self.charm_label = control_tools.newLabel({str = "魅力:333", font = 20, color = cc.c3b(255, 227, 255)})
    charm_bg:addChild(self.charm_label)
    self.charm_label:setPosition(cc.p(charm_bg:getContentSize().width/2, charm_bg:getContentSize().height/2 + 1))

    -- 性别
    self.img_sex = control_tools.newImg({path = g_path .. "sex_0.png"})
    self.info_bg:addChild(self.img_sex)
    self.img_sex:setPosition(cc.p(self.info_bg:getContentSize().width/3 - 20, self.info_bg:getContentSize().height - 55))

    -- 名字
    self.user_name = control_tools.newLabel({str = "我就要五个字", font = 24, color = cc.c3b(175, 94, 22), anchor = cc.p(0, 0.5)})
    self.info_bg:addChild(self.user_name)
    self.user_name:setPosition(cc.p(self.img_sex:getPositionX() + 20, self.img_sex:getPositionY() - 1))

    -- 金币
    self.img_gold = control_tools.newImg({path = g_path .. "img_gold.png", scale = 0.8})
    self.info_bg:addChild(self.img_gold)
    self.img_gold:setPosition(cc.p(self.info_bg:getContentSize().width/3 - 20, self.info_bg:getContentSize().height - 85))

    -- 金币值
    self.gold_label = control_tools.newLabel({str = "1000000,235", fnt = g_path .. "gold_fnt/num_dt_wjxx_jb.fnt", anchor = cc.p(0, 0.5)})
    self.info_bg:addChild(self.gold_label)
    self.gold_label:setPosition(cc.p(self.img_gold:getPositionX() + 20, self.img_gold:getPositionY() - 5))

    self.praise_bg, self.praise_count = self:create_praise_part(self.info_bg)
    self.praise_bg:setPosition(cc.p(self.info_bg:getContentSize().width - self.praise_bg:getContentSize().width + 25, self.info_bg:getContentSize().height - 70))
    self.praise_bg:setVisible(false)

    -- 亲密度
    self.intimacy_bg = control_tools.newImg({path = g_path .. "praise_bg.png"})
    self.info_bg:addChild(self.intimacy_bg)
    self.intimacy_bg:setPosition(cc.p(self.info_bg:getContentSize().width - self.intimacy_bg:getContentSize().width + 25, self.info_bg:getContentSize().height - 70))
    self.intimacy_bg:setVisible(false)

    -- 心心
    local img_heart = control_tools.newImg({path = g_path .. "img_heart.png"})
    self.intimacy_bg:addChild(img_heart)
    img_heart:setPosition(cc.p(18, self.intimacy_bg:getContentSize().height/2))

    -- 亲密度文字
    local intimacy_label = control_tools.newLabel({color = cc.c3b(255, 131, 31), str = "亲密度", font = 18, anchor = cc.p(0, 0.5)})
    self.intimacy_bg:addChild(intimacy_label)
    intimacy_label:setPosition(cc.p( 28, img_heart:getPositionY() ))

    -- 亲密度值
    self.intimacy_count = control_tools.newLabel({color = cc.c3b(254, 234, 31), str = "2355", font = 24, anchor = cc.p(0, 0.5)})
    self.intimacy_bg:addChild(self.intimacy_count)
    self.intimacy_count:setPosition(cc.p( 85, img_heart:getPositionY() ))    

    -- 等级
    local level_img = control_tools.newImg({path = g_path .. "level.png", anchor = cc.p(0, 0.5)})
    self.info_bg:addChild(level_img)
    level_img:setPosition(cc.p(self.info_bg:getContentSize().width/3 - 30, self.info_bg:getContentSize().height - 130))

    self.level_label = control_tools.newLabel({font = 22, color = cc.c3b(175, 94, 22), anchor = cc.p(0, 0.5), str = "嚣张衙役"})
    self.info_bg:addChild(self.level_label)
    self.level_label:setPosition(cc.p(level_img:getPositionX() + level_img:getContentSize().width + 5, level_img:getPositionY()))

    -- 积分
    local score_img = control_tools.newImg({path = g_path .. "score.png", anchor = cc.p(0, 0.5)})
    self.info_bg:addChild(score_img)
    score_img:setPosition(cc.p(self.info_bg:getContentSize().width/3 - 30, self.info_bg:getContentSize().height - 162))

    self.score_label = control_tools.newLabel({font = 22, color = cc.c3b(175, 94, 22), anchor = cc.p(0, 0.5), str = "109"})
    self.info_bg:addChild(self.score_label)
    self.score_label:setPosition(cc.p(score_img:getPositionX() + score_img:getContentSize().width + 5, score_img:getPositionY()))

    -- 胜率
    local win_percent_img = control_tools.newImg({path = g_path .. "win_percent.png", anchor = cc.p(0, 0.5)})
    self.info_bg:addChild(win_percent_img)
    win_percent_img:setPosition(cc.p(self.info_bg:getContentSize().width/3 - 30, self.info_bg:getContentSize().height - 194))

    self.win_percent_label = control_tools.newLabel({font = 22, color = cc.c3b(175, 94, 22), anchor = cc.p(0, 0.5), str = "39%"})
    self.info_bg:addChild(self.win_percent_label)
    self.win_percent_label:setPosition(cc.p(win_percent_img:getPositionX() + win_percent_img:getContentSize().width + 5, win_percent_img:getPositionY()))

    -- 战绩
    local result_img = control_tools.newImg({path = g_path .. "result.png", anchor = cc.p(0, 0.5)})
    self.info_bg:addChild(result_img)
    result_img:setPosition(cc.p(self.info_bg:getContentSize().width/3 - 30, self.info_bg:getContentSize().height - 226))

    self.result_label = control_tools.newLabel({font = 22, color = cc.c3b(175, 94, 22), anchor = cc.p(0, 0.5), str = "187胜/189负/95平"})
    self.info_bg:addChild(self.result_label)
    self.result_label:setPosition(cc.p(result_img:getPositionX() + result_img:getContentSize().width + 5, result_img:getPositionY()))

    -- 举报
    self.btn_add = control_tools.newBtn({normal = g_path .. "btn_add1.png", pressed = g_path .. "btn_add2.png"})
    self.info_bg:addChild(self.btn_add)
    self.btn_add:setPosition(cc.p(self.info_bg:getContentSize().width - self.praise_bg:getContentSize().width + 25, self.info_bg:getContentSize().height - 69))
    self.btn_add:addTouchEventListener( function (sender, eventType) self:on_btn_add(sender, eventType) end )
    self.btn_add:setVisible(false)

    -- 踢人
    self.btn_kickout = control_tools.newBtn({normal = g_path .. "btn_kickout.png"})
    self.info_bg:addChild(self.btn_kickout)
    self.btn_kickout:setPosition(cc.p(self.btn_add:getPositionX(), self.btn_add:getPositionY() - 75))
    self.btn_kickout:addTouchEventListener(function (sender, eventType) self:on_btn_kickout(sender, eventType) end)
    self.btn_kickout:setVisible(false)

    -- 添加好友
    self.btn_report = control_tools.newBtn({normal = g_path .. "btn_report.png"})
    self.info_bg:addChild(self.btn_report)
    self.btn_report:setPosition(cc.p(self.btn_kickout:getPositionX(), self.btn_kickout:getPositionY() - 70))
    self.btn_report:addTouchEventListener( function (sender, eventType) self:on_btn_report(sender, eventType) end )
    self.btn_report:setVisible(false)

    -- 我的道具
    self.my_prop_img = control_tools.newImg({path = g_path .. "my_prop_img.png"})
    self.info_bg:addChild(self.my_prop_img)
    self.my_prop_img:setPosition(cc.p(self.info_bg:getContentSize().width/2, self.info_bg:getContentSize().height/2 - 25))
    self.my_prop_img:setVisible(false)

    self.prop_bg = control_tools.newImg({path = g_path .. "prop_bg.png"})
    self.my_prop_img:addChild(self.prop_bg)
    self.prop_bg:setPosition(cc.p(self.my_prop_img:getContentSize().width/2, -self.prop_bg:getContentSize().height/2 - 5 ))

    -- 拖动层
    self.drag_prop = control_tools.newScrollView({size = cc.size(630, 154), direction = SCROLLVIEW_DIR_HORIZONTAL})
    self.prop_bg:addChild(self.drag_prop)
    self.drag_prop:setScrollBarAutoHideEnabled(false)
    self.drag_prop:setPosition(cc.p(9, 4)) 

    self.btn_buy_prop = control_tools.newBtn({normal = g_path .. "prop_buy_other.png"})
    self.drag_prop:addChild(self.btn_buy_prop)
    self.btn_buy_prop:setPosition(cc.p(self.drag_prop:getContentSize().width/2, self.drag_prop:getContentSize().height/2))
    self.btn_buy_prop:addTouchEventListener( function (sender, eventType) self:on_btn_buy_prop(sender, eventType) end )

    -- 其他人的礼物面板
    self.other_gift_img  = control_tools.newImg({path = g_path .. "other_gift_img.png", anchor = cc.p(0, 0.5)})
    self.info_bg:addChild(self.other_gift_img)
    self.other_gift_img:setPosition(cc.p(self.info_bg:getContentSize().width/2 - self.other_gift_img:getContentSize().width/2, self.info_bg:getContentSize().height/2 - 25))
    self.other_gift_img:setVisible(false)

    for i=1, 5 do
        self.btn_gift[i] = control_tools.newImg({path = g_path .. "gift_item_bg.png"})
        self.other_gift_img:addChild(self.btn_gift[i])
        self.btn_gift[i]:setPosition(cc.p(self.btn_gift[i]:getContentSize().width/2-10 + (i - 1)*(self.btn_gift[i]:getContentSize().width-10), -self.btn_gift[i]:getContentSize().height/2))

        local img = control_tools.newBtn({normal = BPRESOURCE("bpres/gift/" .. i-1 .. "/icon.png")})
        self.btn_gift[i]:addChild(img)
        img:setPosition(cc.p(self.btn_gift[i]:getContentSize().width/2, self.btn_gift[i]:getContentSize().height/2 + 8))
        img:addTouchEventListener(function (sender, eventType) self:on_btn_gift(sender, eventType) end)
        img:setTag(i - 1)

        self.gift_num[i] = control_tools.newLabel({font = 22, color = cc.c3b(154, 84, 32)})
        self.btn_gift[i]:addChild(self.gift_num[i])
        self.gift_num[i]:setPosition(cc.p(self.btn_gift[i]:getContentSize().width/2, 28))

        self.gift_count_bg[i] = control_tools.newImg({path = g_path .. "gift_count_bg.png"})
        self.btn_gift[i]:addChild(self.gift_count_bg[i])
        self.gift_count_bg[i]:setPosition(cc.p(20, self.btn_gift[i]:getContentSize().height - 20))
        self.gift_count_bg[i]:setVisible(false)

        self.gift_count[i] = control_tools.newLabel({font = 22, color = cc.c3b(254, 234, 173), str = "99"})
        self.gift_count_bg[i]:addChild(self.gift_count[i])
        self.gift_count[i]:setPosition(cc.p(self.gift_count_bg[i]:getContentSize().width/2, self.gift_count_bg[i]:getContentSize().height/2+2))
    end

    self.btn_ten = control_tools.newBtn({normal = g_path .. "btn_ten.png"})
    self.other_gift_img:addChild(self.btn_ten)
    self.btn_ten:setPosition(cc.p(self.other_gift_img:getContentSize().width/2, -155))
    self.btn_ten:setZoomScale(0)
    self.btn_ten:addTouchEventListener(function (sender, eventType) self:on_btn_ten(sender, eventType) end)

    self.check_img = control_tools.newImg({path = g_path .. "gou.png"})
    self.btn_ten:addChild(self.check_img)
    self.check_img:setPosition(cc.p(self.check_img:getContentSize().width/2, self.btn_ten:getContentSize().height/2))
    self.check_img:setVisible(false)

    self:set_touch_bg(true)
end
-- 创建赞控件
function UIGameUserInfo:create_praise_part(father)
    -- 点赞
    local praise_bg = control_tools.newImg({path = g_path .. "praise_bg.png"})
    father:addChild(praise_bg)

    -- 赞手势
    local img_praise = control_tools.newImg({path = g_path .. "img_praise.png"})
    praise_bg:addChild(img_praise)
    img_praise:setPosition(cc.p(25, praise_bg:getContentSize().height/2))

    -- 赞文字
    local praise_label = control_tools.newLabel({color = cc.c3b(255, 212, 19), str = "赞", font = 22})
    praise_bg:addChild(praise_label)
    praise_label:setPosition(cc.p( 55, img_praise:getPositionY() ))

    -- 赞数量
    local praise_count = control_tools.newLabel({color = cc.c3b(255, 212, 19), str = "(999)", font = 22, anchor = cc.p(0, 0.5)})
    praise_bg:addChild(praise_count)
    praise_count:setPosition(cc.p( 75, img_praise:getPositionY() ))

    return praise_bg, praise_count
end

-- 点赞按钮点击事件
function UIGameUserInfo:on_btn_praise(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end

    --dd_wait:举报
    if self.ptr_user_data == nil then return end

    local self_userid = bind_function.get_self_user_data().dwUserID
    if self.ptr_user_data.dwUserID == self_userid then return end

    -- 点赞数更新 待添加
    self.praise_count_tbl[self.ptr_user_data.dwUserID] = 1

    self.btn_praise:setVisible(false)
    self.btn_praise:setTouchEnabled(false)

    bind_function.send_user_praise(self_userid, self.ptr_user_data.dwUserID)
end
-- 魅力按钮点击事件
function UIGameUserInfo:on_btn_charm(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end

    bp_show_hinting("使用互动表情，可增加减少TA的魅力值")
end
-- 举报按钮点击事件
function UIGameUserInfo:on_btn_report(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end
    --dd_wait:举报
    print("===============on_btn_report================")

    -- 点击音效 待添加
    self:ShowGui(false)

    if self.ptr_user_data == nil then return end

    local self_data = bind_function.get_self_user_data()
    if self_data == nil then return end

    if self_data.dwUserID == self.ptr_user_data.dwUserID then return end

    -- 举报
    UIReport.ShowReportLayer(self_data, self.ptr_user_data)
end
-- 添加好友按钮点击事件
function UIGameUserInfo:on_btn_add(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end
    print("===============on_btn_add================")

    -- 点击音效 待添加
    self:ShowGui(false)

    if self.ptr_user_data == nil then return end

    local self_data = bind_function.get_self_user_data()
    if self_data == nil then return end

    if self_data.dwUserID == self.ptr_user_data.dwUserID then return end

    --dd_wait:加好友
    -- struct_friend_apply the_apply;
    -- the_apply._int_user_id = ptr_user_data->dwUserID;
    -- the_apply._int_face_id = ptr_user_data->wFaceID;
    -- the_apply._int_sex_id = ptr_user_data->cbGender;
    -- the_apply._str_nick_name = GBK2UTF8(ptr_user_data->szName);
    -- UIFriendAdd::ShowAdd(the_apply,0);
end
-- 踢人按钮点击事件
function UIGameUserInfo:on_btn_kickout(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end
    print("===============on_btn_kickout================")
    -- 点击音效 待添加

    self:ShowGui(false)

    if self.ptr_user_data == nil then return end

    local self_data = bind_function.get_self_user_data()
    if self_data == nil then return end

    if self.kickout_mark == 1 then
        sender:setTouchEnabled(false)
    end
    self.kickout_mark = 1

    --dd_wait: 发送踢人消息
    bind_function.send_user_kick(self_data.dwUserID, self.ptr_user_data.dwUserID)
end
-- 礼物按钮点击事件
function UIGameUserInfo:on_btn_gift(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end

    -- 选中礼物索引
    if sender:getTag() < 0 or sender:getTag() > 4 then return end
    -- 外部礼物处理函数
    if self.callfunc == nil then return end

    self:ShowGui(false)

    self.callfunc(sender:getTag(), self.check_img:isVisible() == true and 10 or 1)

    self.ptr_user_data = nil
end
-- 是否十连发按钮点击事件
function UIGameUserInfo:on_btn_ten(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end

    if self.check_img:isVisible() == true then
        self.check_img:setVisible(false)
    else
        self.check_img:setVisible(true)
    end
end
-- 点击按钮回调（发送消息到服务端）
function UIGameUserInfo:request_use_prop(param_id)
    if self.ptr_user_data == nil then return end

    if id == PROP.ID_PROP_CHARMCLEAR then
        if self.ptr_user_data.lCharm < 0 then
            bp_show_hinting("魅力良好,不需要清零")
            return 
        end
    end

    if id == PROP.ID_PROP_SCORECLEAR then
        if self.ptr_user_data.lScore < 0 then
            bp_show_hinting("积分良好,不需要清零")
            return 
        end
    end

    req = bp_make_url(req)
    req = bp_string_replace_key(req,"&quot;","\"")
    req = bp_string_replace_key(req,"{PROPID}",param_id)
    req = bp_string_replace_key(req,"{PARAM}","")
    bp_http_get("" .. param_id, "", req, function(param_identifier, param_success, param_code, param_header, context) self:on_http_use_prop(param_identifier, param_success, param_code, param_header,context) end, 1)
end
-- 使用道具按钮响应事件（服务端返回消息处理结果）
function UIGameUserInfo:on_http_use_prop(param_identifier, param_success, param_code, param_header, context)  
    if param_success ~= true or param_code ~= 200 then 
        bp_show_hinting("道具失败("..param_identifier..")")
        return 
    end

    local l_data = json.decode(context)
    if l_data.rescode ~= 1 then 
        bp_show_hinting(l_data.resmsg)
        return 
    end

    bp_update_user_data(1)
    bp_show_hinting("道具已使用成功")
end
-- 使用道具按钮点击事件
function UIGameUserInfo:on_btn_prop(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end

    if sender.prop_info.mask == 0 then
        bp_show_hinting(sender.prop_info.caption)
        return 
    end

    bp_show_message_box("提示", sender.prop_info.caption, 1,
            "使用", "取消",
            function(prop_id) self:request_use_prop(sender.prop_info.id) end,
            function(param_1,param_2) end, 0, "")
end
-- 购买道具点击事件
function UIGameUserInfo:on_btn_buy_prop(sender, eventType)
    if eventType ~= _G.TOUCH_EVENT_ENDED then
        return 
    end

    --dd_wait:商城接口
    bind_function.send_command("open:2")
end
-- 创建道具图标
function UIGameUserInfo:create_prop_item(id, count, index)
    -- 道具底
    local prop_item = control_tools.newImg({path = g_path .. "prop_item_bg.png"})
    self.drag_prop:addChild(prop_item)
    prop_item:setPosition(cc.p((index-1/2)*prop_item:getContentSize().width, prop_item:getContentSize().height/2))

    -- 道具标识
    local item_img = control_tools.newImg({path = prop_path .. "prop_" .. id .. ".png"})
    prop_item:addChild(item_img)
    item_img:setPosition(cc.p(prop_item:getContentSize().width/2, prop_item:getContentSize().height/2 + 25))

    -- 道具详情
    prop_item.prop_info = json.decode(bp_get_prop_data(id))
    local prop_detail = control_tools.newLabel({color = cc.c3b(154,84,32), font = 18, str = prop_item.prop_info.name})
    prop_item:addChild(prop_detail)   
    prop_detail:setPosition(cc.p(prop_item:getContentSize().width/2, 45))

    -- 道具数量
    local prop_num = control_tools.newLabel({fnt = g_path .. "prop_count/num_dt_daoju.fnt", str = tostring(count) .. "个"})
    prop_item:addChild(prop_num)   
    prop_num:setPosition(cc.p(prop_item:getContentSize().width/2, 18))

    prop_item:addTouchEventListener(function (sender, eventType) self:on_btn_prop(sender, eventType) end)
    prop_item:setTouchEnabled(true)

    return prop_item
end
-- 更新用户信息
function UIGameUserInfo:on_update_user_data()
    if self.ptr_user_data == nil then return end

    local user_id = self.ptr_user_data.dwUserID
    self.ptr_user_data = bind_function.get_user_data_by_user_id(user_id)
    local self_userid = bind_function.get_self_user_data().dwUserID

    -- 显示头像
    self.user_head:set_head(142, 142, self.ptr_user_data)
    -- vip
    if self.ptr_user_data.cbMember > 0 and self.ptr_user_data.cbMember < 5 then
        self.vip_img:loadTexture(g_path .. "vip" .. self.ptr_user_data.cbMember .. ".png")
    end
    -- 魅力
    self.charm_label:setString(tostring(self.ptr_user_data.lCharm))
    -- 名字
    self.user_name:setString(tostring(self.ptr_user_data.szName))
    -- 性别
    self.img_sex:loadTexture(g_path .. "sex_" .. self.ptr_user_data.cbGender .. ".png")
    -- 金币
    self.gold_label:setString(tostring(self.ptr_user_data.lGold))
    -- 等级
    self.level_label:setString(class_tools.get_level_data(self.ptr_user_data.lGold)._str_level_name)
    -- 积分
    self.score_label:setString(tostring(self.ptr_user_data.lScore))
    -- 胜率
    local total_count = self.ptr_user_data.lWinCount + self.ptr_user_data.lLostCount + self.ptr_user_data.lDrawCount
    local percent = total_count == 0 and "0%" or tostring(math.floor(self.ptr_user_data.lWinCount * 100/total_count)) .. "%"
    self.win_percent_label:setString(percent)
    -- 战绩
    self.result_label:setString(tostring(self.ptr_user_data.lWinCount) .. "胜" .. tostring(self.ptr_user_data.lLostCount) .. "负" .. tostring(self.ptr_user_data.lDrawCount) .. "平" )
    -- 点赞数
    self.praise_bg:setVisible(user_id == self_userid)  
    self.praise_count:setString("(" .. tostring(self.ptr_user_data.lPraise) .. ")")
    self.other_praise_bg:setVisible(user_id ~= self_userid)
    self.other_praise_count:setString("(" .. tostring(self.ptr_user_data.lPraise) .. ")")
    
    -- 道具
    for i,v in ipairs(self.prop_item_tbl) do
        v:removeFromParent()
    end
    self.prop_item_tbl = {}

    local prop_data = json.decode(bp_get_self_prop_count())
    local index = 0
    for k,v in pairs(prop_data) do
        if v.cnt > 0 then
            index = index + 1
            local item_prop = self:create_prop_item(v.id, v.cnt, index)
            table.insert(self.prop_item_tbl, item_prop)
        end
    end
    self.drag_prop:jumpToLeft()

    local total_width = index*130
    if index == 0 then
        self.btn_buy_prop:loadTextureNormal(g_path .. "prop_buy_other.png")
        self.btn_buy_prop:setPosition(cc.p(self.drag_prop:getContentSize().width/2, self.drag_prop:getContentSize().height/2))
        self.drag_prop:setInnerContainerSize(cc.size(630, 154))
    else
        self.btn_buy_prop:loadTextureNormal(g_path .. "prop_buy_more.png")
        total_width = total_width + self.btn_buy_prop:getContentSize().width + 50
        self.btn_buy_prop:setPosition(cc.p(total_width - self.btn_buy_prop:getContentSize().width/2 - 25, self.drag_prop:getContentSize().height/2))
        self.drag_prop:setInnerContainerSize(cc.size(total_width, 154))
    end
end
-- 游戏开始相应事件
function UIGameUserInfo:on_game_start()
    self.praise_count_tbl = {}
    self.btn_praise:setVisible(true)
    self.btn_praise:setTouchEnabled(true)
end
-- 显示用户信息
function UIGameUserInfo:show_user_info(bool_report, user_data, callfunc, int_param)
    self.ptr_user_data = user_data
    self.callfunc = callfunc

    if user_data.dwUserID == bind_function.get_self_user_data().dwUserID then
        -- 点赞
        self.btn_praise:setVisible(false)
        self.btn_praise:setTouchEnabled(false)
        -- 按钮隐藏
        self.btn_report:setVisible(false)
        self.btn_report:setTouchEnabled(false)
        self.btn_kickout:setVisible(false)
        self.btn_kickout:setTouchEnabled(false)
        self.btn_add:setVisible(false)
        self.btn_add:setTouchEnabled(false)
        -- 显示点赞信息    
        self.praise_bg:setVisible(true)  
        self.praise_count:setString("(" .. tostring(self.ptr_user_data.lPraise) .. ")")
        self.other_praise_bg:setVisible(false)
        self.other_praise_count:setString("(" .. tostring(self.ptr_user_data.lPraise) .. ")")

        self.my_prop_img:setVisible(true)
        self.other_gift_img:setVisible(false)

        self:on_update_user_data()
    else
        -- 显示头像
        self.user_head:set_head(142, 142, user_data)
        -- vip
        if user_data.cbMember > 0 and user_data.cbMember < 5 then
            self.vip_img:loadTexture(g_path .. "vip" .. user_data.cbMember .. ".png")
        end
        -- 点赞
        self.btn_praise:setVisible(self.praise_count_tbl[self.ptr_user_data.dwUserID] ~= 1)
        self.btn_praise:setTouchEnabled(self.praise_count_tbl[self.ptr_user_data.dwUserID] ~= 1)
        -- 魅力 
        self.charm_label:setString(tostring(user_data.lCharm))
        -- 名字
        self.user_name:setString(tostring(user_data.szName))
        -- 性别
        self.img_sex:loadTexture(g_path .. "sex_" .. user_data.cbGender .. ".png")
        -- 金币
        self.gold_label:setString(tostring(user_data.lGold))
        -- 等级
        self.level_label:setString(class_tools.get_level_data(user_data.lGold)._str_level_name)
        -- 积分
        self.score_label:setString(tostring(user_data.lScore))
        -- 胜率
        local total_count = user_data.lWinCount + user_data.lLostCount + user_data.lDrawCount
        local percent = total_count == 0 and "0%" or tostring(math.floor(user_data.lWinCount * 100/total_count)) .. "%"
        self.win_percent_label:setString(percent)
        -- 战绩
        self.result_label:setString(tostring(user_data.lWinCount) .. "胜" .. tostring(user_data.lLostCount) .. "负" .. tostring(user_data.lDrawCount) .. "平" )

        -- 按钮隐藏
        self.btn_report:setVisible(true)
        self.btn_report:setTouchEnabled(true)
        self.btn_kickout:setVisible(true) 
        self.btn_kickout:setTouchEnabled(true)
        self.btn_add:setVisible(true)
        self.btn_add:setTouchEnabled(true)
        -- 显示点赞信息    
        self.praise_bg:setVisible(false)  
        self.praise_count:setString("(" .. tostring(self.ptr_user_data.lPraise) .. ")")
        self.other_praise_bg:setVisible(true)
        self.other_praise_count:setString("(" .. tostring(self.ptr_user_data.lPraise) .. ")")

        self.my_prop_img:setVisible(false)
        self.other_gift_img:setVisible(true)

        local room_json = bind_function.get_room_data()
        local pos1, pos2 = string.find(room_json.rule, "gift=")

        -- 礼物数
        for i = 1, 5 do 
            local count = bp_get_self_prop_count(1010 + i)

            self.gift_count_bg[i]:setVisible(count > 0)
            self.gift_count[i]:setString(tostring(count > 99 and "99+" or count))
            self.gift_num[i]:setString(string.sub(room_json.rule, pos2 + 2*i, pos2 + 2*i))
        end
    end

    self:ShowGui(true)
end
-- 显示用户详情界面
function UIGameUserInfo.ShowUserInfo(bool_report, user_data, callfunc, int_param)
    if ptr_user_info == nil  then 
        print("------------ShowUserInfo-----------1")
        local main_layout = bp_get_main_layout()
        ptr_user_info = UIGameUserInfo:create()
        main_layout:addChild(ptr_user_info)
    end
    print("-------------ShowUserInfo----------2")

    ptr_user_info:show_user_info(bool_report, user_data, callfunc, int_param)
    return ptr_user_info
end

function UIGameUserInfo.Instance()
    if ptr_user_info == nil then 
        local main_layout = bp_get_main_layout()
        ptr_user_info = UIGameUserInfo:create()
        main_layout:addChild(ptr_user_info)
    end
    return ptr_user_info
end

function UIGameUserInfo:destory()
    
end

return UIGameUserInfo
