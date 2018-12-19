
ui_tools = ui_tools or {}

function ui_tools.hitTest(sender, pos)
    local width = sender:getContentSize().width * sender:getScale()
    local height = sender:getContentSize().height * sender:getScale()

    local posx = sender:getPositionX()
    local posy = sender:getPositionY()
    
    local rect = cc.rect(posx - width/2, posy - height/2, width, height)
    
    return cc.rectContainsPoint(rect, pos)
end