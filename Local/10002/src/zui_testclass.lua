local UITestClass=class("UITestClass",function() return ccui.Layout:create() end);

function UITestClass:ctor()
    print("hjjlog>>UITestClass")
    self:init();
end
function UITestClass:destory()
end

function UITestClass:init()
    self.the_size=cc.size(770,420);
    self:setContentSize(self.the_size)

    local test_bg=control_tools.newImg({path=TESTCOLOR.r,size=self.the_size})
    test_bg:setPosition(cc.p(self.the_size.width/2,self.the_size.height/2))
    self:addChild(test_bg);

end




return UITestClass