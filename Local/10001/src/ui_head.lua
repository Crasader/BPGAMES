local UIHead=class("UIHead",function() return ccui.ImageView:create() end);

function UIHead:ctor()
    print("hjjlog>>UIHead")
    self.m_user_id=0
    self:init();
end
function UIHead:destory()
end

function UIHead:init()
    -- local   l_lister= cc.EventListenerCustom:create("USER_CHAT", function (eventCustom)
    --     self:on_event_user_chat(eventCustom);
    -- end)
    -- cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(l_lister, 1)



end
function UIHead:set_head(param_width,param_height,param_user_data,parma_dir)
    param_user_data={}


end
function UIHead:set_head(param_width,param_height,param_user_id,param_face_id,param_sex_id)
    self:loadTexture("http://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png",0 )
    --self:loadTexture("http://cn-bookse-userresources.oss-cn-hangzhou.aliyuncs.com/head/10032360-3.png",0 )
    self:setScale9Enabled(true)
    local l_size=self:getContentSize();
    self:setScale(param_width/l_size.width);
end

function UIHead:on_event_user_chat(eventCustom)

    l_table.chat=eventCustom.chat;
    l_table.userid=eventCustom.userid;
    l_table.username=eventCustom.username;

    --[[chat：
        表情: [EM]XX  ,比如   [EM]09


    ]]--

    if self.m_user_id~=l_table.userid then
        return ;
    end


    local l_item_record=self:get_a_record_label()
    if #l_table.chat==6 then 
        local l_key=string.sub(l_table.chat,1,4)
        local l_value=string.sub(l_table.chat,5,6)
        print("hjjlog>>on_event",l_key,l_value);
        if l_key=="[EM]"   then 

            return ;
        end    
    end

end

return UIHead