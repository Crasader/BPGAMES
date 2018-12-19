local UIChatSend=class("UIChatSend",function() return ccui.Layout:create() end);
local g_path=BPRESOURCE("res/bugle/")
local UILabelEx=require("bptools/uilabelex2")
function UIChatSend:ctor()
    print("hjjlog>>UIChatSend")
    self.list_common={}
    self.list_common_sleep={}
    self.list_record={}
    self.list_record_sleep={}
    self:init();
end
function UIChatSend:destory()
end

function UIChatSend:init()

    self.the_size=cc.size(780,480);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);
    
    local l_bg_emoji=control_tools.newImg({path=g_path.."bg_emoji.png"})
    self:addChild(l_bg_emoji)
    l_bg_emoji:setPosition(cc.p(220,255))


    self.ptr_scrollview_emoji=ccui.ScrollView:create();
    l_bg_emoji:addChild(self.ptr_scrollview_emoji);
    self.ptr_scrollview_emoji:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview_emoji:setContentSize(cc.size(430,350))
    self.ptr_scrollview_emoji:setPosition(cc.p(6,10))
    self.ptr_scrollview_emoji:setScrollBarAutoHideEnabled(false)


    local int_line_count=math.ceil(26/4)
    local the_scrollview_size=cc.size(self.ptr_scrollview_emoji:getContentSize().width,90*int_line_count)

    if the_scrollview_size.height< self.ptr_scrollview_emoji:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview_emoji:getContentSize().height
    end
    self.ptr_scrollview_emoji:setInnerContainerSize(the_scrollview_size)

    local l_interval_x=(430-80*4)/4+80
    local l_x=l_interval_x/2;
    local l_y=the_scrollview_size.height-45;
    for i=0,26 do
        local l_btn_emoji=control_tools.newBtn({normal=g_path.."emoji/emoji_"..i..".png",pressed=g_path.."emoji/emoji_"..i..".png"})
        l_btn_emoji:setScale(0.5);
        self.ptr_scrollview_emoji:addChild(l_btn_emoji)
        l_btn_emoji:setPosition(cc.p(l_x,l_y))
        l_btn_emoji.id=i;        
        l_bg_emoji:addTouchEventListener(function(param_sender,param_touchType) self:on_btn_emoji(param_sender,param_touchType)  end)
        l_x=l_x+l_interval_x;
        if (i+1)%4==0 then 
            l_x=l_interval_x/2;
            l_y=l_y-90;
            local l_line=control_tools.newImg({path=g_path.."img_line.png"})
            self.ptr_scrollview_emoji:addChild(l_line)
            l_line:setPosition(cc.p(200,l_y+45))
        end
    end

    local l_bg_chat=control_tools.newImg({path=g_path.."bg_common.png"})
    self:addChild(l_bg_chat)
    l_bg_chat:setPosition(cc.p(610,255))



    self.ptr_scrollview_chat=ccui.ScrollView:create();
    l_bg_chat:addChild(self.ptr_scrollview_chat);
    self.ptr_scrollview_chat:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview_chat:setContentSize(cc.size(320,350))
    self.ptr_scrollview_chat:setPosition(cc.p(7,10))
    self.ptr_scrollview_chat:setScrollBarAutoHideEnabled(false)
    self.ptr_scrollview_chat:setVisible(true)

    self.ptr_scrollview_record=ccui.ScrollView:create();
    l_bg_chat:addChild(self.ptr_scrollview_record);
    self.ptr_scrollview_record:setDirection(SCROLLVIEW_DIR_VERTICAL)
    self.ptr_scrollview_record:setContentSize(cc.size(320,350))
    self.ptr_scrollview_record:setPosition(cc.p(7,10))
    self.ptr_scrollview_record:setScrollBarAutoHideEnabled(false)
    self.ptr_scrollview_record:setVisible(false)




    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(g_path.."dh_dt_ltbq/dh_dt_ltbq.ExportJson")
    -- --ccs.Armature:create("shuangkou_donghua_baozha")
    -- local armature = ccs.Armature:create("dh_dt_ltbq")
    -- armature:setPosition(0, 0)                    -- 设置位置
    -- l_bg_emoji:addChild(armature)                      -- 把动画对象加载到场景内
    -- armature:getAnimation():play("dh_dt_ltbq1",-1,1)            -- 设置动画对象执行的动画名称
    -- armature:setScale(0.5)

    local l_test_table={}
    table.insert( l_test_table,"快点吧，我等的花儿都谢了" )
    table.insert( l_test_table,"你的牌打得太好了" )
    table.insert( l_test_table,"你好，很高心认识你。" )
    table.insert( l_test_table,"怎么这么多炸弹，我都被炸晕了。" )
    table.insert( l_test_table,"你的牌打得太好了11111" )
    table.insert( l_test_table,"222222222222" )
    table.insert( l_test_table,"3333333333333" )
    table.insert( l_test_table,"你的牌打得太好了4444444" )
    table.insert( l_test_table,"你的牌打得太好了4444444" )
    table.insert( l_test_table,"你的牌打得太好了4444444" )
    table.insert( l_test_table,"你的牌打得太好了4444444" )
    table.insert( l_test_table,"你的牌打得太好了4444444" )
    table.insert( l_test_table,"你的牌打得太好了4444444" )
    self:init_common_chat(l_test_table)
end

function UIChatSend:clear_common_label()
    for k,v in pairs(self.list_common) do
        v.bg:setVisible(false)
        table.insert( self.list_common_sleep, v )
    end
    self.list_common={}
 end

 function UIChatSend:get_a_common_label()
    if #self.list_common_sleep >0 then 
        local l_item=self.list_common_sleep[#self.list_common_sleep]
        table.remove( self.list_common_sleep,#self.list_common_sleep )
        table.insert( self.list_common,l_item )
        return l_item;
    else 
        local l_item={}
        local l_label_message=control_tools.newLabel({ex=true,font=24,color=cc.c3b(132,70,20),anchor=cc.p(0,1)})
        self.ptr_scrollview_chat:addChild(l_label_message);
        l_item.label=l_label_message;

        local l_img_line=control_tools.newImg({path=g_path.."img_line.png"})
        l_label_message:addChild(l_img_line)
        l_item.line=l_img_line;
        table.insert( self.list_common, l_item )

        return l_item;
    end
 end

 function UIChatSend:clear_record_label()
    for k,v in pairs(self.list_record) do
        v.bg:setVisible(false)
        table.insert( self.list_record_sleep, v )
    end
    self.list_record={}
 end

 function UIChatSend:get_a_record_label()
    if #self.list_record_sleep >0 then 
        local l_item=self.list_record_sleep[#self.list_record_sleep]
        table.remove( self.list_record_sleep,#self.list_record_sleep )
        table.insert( self.list_record,l_item )
        return l_item;
    else 
        local l_item={}

        return l_item;
    end
 end

function UIChatSend:init_common_chat(param_table)
    self:clear_common_label();
    for k,v in pairs(param_table) do    
        local l_item=self:get_a_common_label();
        l_item.label:setTextEx(v,320,3)
    end

    local l_total_height=0;
    for k,v in pairs(self.list_common) do 
        local l_label_size=v.label:getContentSize()
        local l_height=l_label_size.height;
        l_total_height=l_total_height+l_height+10;
        print("hjjlog>>l_height11111:",l_height);

        v.line:setPosition(cc.p(424/2,0))
    end
    print("hjjlog>>111111111:",l_total_height);
    
    
    local the_scrollview_size=cc.size(self.ptr_scrollview_chat:getContentSize().width,l_total_height)

    if the_scrollview_size.height< self.ptr_scrollview_chat:getContentSize().height then
        the_scrollview_size.height=self.ptr_scrollview_chat:getContentSize().height
    end
    self.ptr_scrollview_chat:setInnerContainerSize(the_scrollview_size)

    local l_y=the_scrollview_size.height;
    for k,v in pairs(self.list_common) do
        local l_label_size=v.label:getContentSize()
        v.label:setPosition(cc.p(5,l_y))
        l_y=l_y-l_label_size.height-10;
    end

end

function UIChatSend:on_btn_emoji(param_sender,param_touchType)
    if param_touchType~=_G.TOUCH_EVENT_ENDED then
        return 
    end
end



return UIChatSend