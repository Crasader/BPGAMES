local UIControl=require("src/ui_control")
local UINotice=class("UINotice",UIControl)
local g_path=BPRESOURCE("res/notice/")
function UINotice:ctor(...)
    print("hjjlog>>UINotice")
    self.super:ctor(self)
    self.list_item_sleep={}
    self.list_item={}
    self:init();
end
function UINotice:destory()

end
function UINotice:init()
    self:set_bg(g_path.."gui.png")
    self:set_title(g_path.."title_notice.png")
    local l_bg=self:get_gui();
    local l_bg_size=l_bg:getContentSize();

    

end


return UINotice