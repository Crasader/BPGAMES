local UIRoomItem=class("UIRoomItem",function() return ccui.Button:create() end);
local g_path=BPRESOURCE("res/scene_room/roomitem/")
require "bptools/control_tools"
function UIRoomItem:ctor()
    --print("hjjlog>>UIRoomItem")
    self.the_site_data=nil
    self.the_img_bg=nil;
    self.ptr_label_limit_gold=nil
    self.ptr_label_desc=nil

    self:init();
end
function UIRoomItem:destory()

end

function UIRoomItem:init()
    self:loadTextures(g_path.."roomitem.png",g_path.."roomitem.png")
    self.the_img_bg=ccui.ImageView:create();
    self.the_img_bg:setPosition(cc.p(266/2,200/2))
    self:addChild(self.the_img_bg)

    local l_img_icon=control_tools.newImg({path=g_path.."room_item_gold.png"})
    self:addChild(l_img_icon);
    l_img_icon:setPosition(cc.p(55,58))

    self.ptr_label_limit_gold=control_tools.newLabel({fnt=g_path.."num_dt_fjbl.fnt"});
    self.ptr_label_limit_gold:setPosition(cc.p(130,53))
    self:addChild(self.ptr_label_limit_gold)

    self.ptr_label_desc=control_tools.newLabel({font=20,color=cc.c3b(249,254,194)})
    self:addChild(self.ptr_label_desc)
    self.ptr_label_desc:setPosition(cc.p(120,28))
end

function UIRoomItem:set_site_data(param_site_data,param_type)
    --[[
   {
      "address" : "demo.bookse.cn",
      "chaircount" : 5,
      "gameid" : 207,
      "id" : 20741,
      "kind" : 48,
      "limit" : [
         {
            "id" : 4,
            "value" : 100000
         }
      ],
      "mode" : 1,
      "name" : "大师场",
      "port" : 20741,
      "roomid" : 401,
      "rule" : "level=3;caption=\"防作弊场 10万以上\";caption_ex=\"大师对决场\";gift=\"1000,2000,5000,1000,2000\";",
      "tablecount" : 200
   },
    ]]--
    if param_type==nil then 
        param_type=1;
    end
    self.the_site_data=param_site_data;
    local l_type=(param_site_data.roomid-param_site_data.roomid%100)/100
    self.the_img_bg:loadTexture(g_path.."room_"..param_type.."_"..l_type..".png");
    self.ptr_label_desc:setVisible(false)
    self.ptr_label_limit_gold:setVisible(false)

    if l_type>4 then 
        return ;
    end
    local tt=assert(loadstring(param_site_data.rule)) 
    tt()
    print("hjjlog>>set_site_data:",param_site_data.rule,caption_ex)
    if caption_ex==nil then 
        caption_ex="";
    end
    self.ptr_label_desc:setString(caption_ex)
    self.ptr_label_desc:setVisible(true);


    --下限
    local l_limit_min_gold=0
    local l_limit_max_gold=0
    if param_site_data.limit==nil then 
        self.ptr_label_limit_gold:setVisible(false);
        return ;
    end
        self.ptr_label_limit_gold:setVisible(true);
    for k,v in pairs(param_site_data.limit) do 
        if v.id==4 then 
            l_limit_min_gold=v.value;
        elseif v.id==8 then 
            l_limit_max_gold=v.value;
        end
    end
    
    if l_limit_max_gold==0 then 
        if l_limit_min_gold>10000 then 
            self.ptr_label_limit_gold:setString((l_limit_min_gold/10000).."万以上")
        else
            self.ptr_label_limit_gold:setString(l_limit_min_gold.."以上")
        end
        return;
    end
    local l_str_min=l_limit_min_gold;
    local l_str_max=l_limit_max_gold
    if l_limit_min_gold>10000 then 
        l_str_min=(l_limit_min_gold/10000).."万"
     end 
    if l_limit_max_gold>10000 then 
        l_str_max=(l_limit_max_gold/10000).."万"
     end
    self.ptr_label_limit_gold:setString(l_str_min.."-"..l_str_max)
end




return UIRoomItem