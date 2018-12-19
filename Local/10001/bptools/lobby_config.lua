AC={
 	--登陆标记位
	MASK_AUTH_REGISTER		= 0x00000001,    --游客登陆
	MASK_AUTH_ACCOUNT		= 0x00000002,    --帐号登陆
	MASK_AUTH_PHONE			= 0x00000004,    --手机登陆
	MASK_AUTH_WECHAT			= 0x00000008,    --微信登陆
	MASK_AUTH_CHANNEL		= 0x00000010,    --渠道登陆
}

LC={
    --功能标记位
	MASK_MODULE_BIND_PHONE	    = 0x00000001,-- 手机绑定功能
	MASK_MODULE_BIND_WECHAT	    = 0x00000002,-- 微信绑定功能
	MASK_MODULE_SHARE_WECHAT    = 0x00000004,-- 微信分享
	MASK_MODULE_AUCTION		    = 0x00000008,-- 拍卖行功能
	MASK_MODULE_PUSH			= 0x00000010,-- 喇叭消息功能
	MASK_MODULE_GAMELIST		= 0x00000020,-- 游戏列表功能
	MASK_MODULE_FRIENDSYSTEM = 0x00000040,-- 好友系统
	MASK_MODULE_RANKING		= 0x00000080,-- 排行榜功能
	MASK_MODULE_EXCHANGE		= 0x00000100,-- 兑换功能
	MASK_MODULE_MOREGAME		= 0x00000200,-- 更多游戏功能
	MASK_MODULE_SHOP			= 0x00000400,-- 商城功能
	MASK_MODULE_NOTICE		= 0x00000800,-- 公告功能
	MASK_MODULE_SIGN			= 0x00001000,-- 签到功能
	MASK_MODULE_ACTIVITY		= 0x00002000,-- 活动功能
	MASK_MODULE_INTRODUCER	= 0x00004000,-- 推荐功能
	MASK_MODULE_CUSTOMER		= 0x00008000,-- 客服功能
	MASK_MODULE_TASKS		= 0x00010000,-- 任务功能
	MASK_MODULE_BANK			= 0x00020000,-- 银行功能
	MASK_MODULE_UPDATE_GUIDE	= 0x00040000,-- 更新引导
	MASK_MODULE_ASSESS_GUIDE	= 0x00080000,-- 评价引导
	MASK_MODULE_AUTHENTICATION=0x00100000,-- 实名认证
	MASK_MODULE_SYSTEM_PUSH	= 0x00200000,-- 系统消息
	MASK_MODULE_VIP			= 0x00400000,-- VIP
	MASK_MODULE_NEWPLAYER_PACK=0x00800000,-- 新手礼包
	MASK_MODULE_BEANS		= 0x01000000,-- 金豆商城管控
	MASK_MODULE_REDPACKET	= 0x02000000,-- 红包管控
	MASK_MODULE_ABANDONED	= 0x04000000,-- 废弃
	MASK_MODULE_GUIDE		= 0x08000000,-- 事件引导
	MASK_MODULE_AUTO_ACTIVITY= 0x10000000,-- 自动弹出活动
	MASK_MODULE_AUTO_LUCK	= 0x20000000,-- 自动弹出签到
	MASK_MODULE_PROPSHOP		= 0x40000000,-- 道具商城
}
UC = {
    --玩家权限定义
          UR_CANNOT_PLAY				=	0x00000001,--不能进行游戏
          UR_CANNOT_LOOKON				=   0x00000002,--不能旁观游戏
          UR_CANNOT_WISPER				=   0x00000004,--不能发送私聊
          UR_CANNOT_ROOM_CHAT			=	0x00000008,--不能大厅聊天
          UR_CANNOT_GAME_CHAT			=	0x00000010,--不能游戏聊天
          UR_RIGHT_PAY					=   0x00000020,--完整的支付权限
          UR_MASK_VIP					=	0x00000040,--会员标记
          UR_MASK_PAY					=	0x00000080,--充值用户标记
          UR_MASK_ALIPAY				=	0x00000100,--阿里充值用户标记
          UR_MASK_APPLEPAY				=   0x00000200,--苹果充值用户标记
          UR_MASK_SMSPAY				=	0x00000400,--短信充值用户标记
          UR_MASK_WXPAY					=   0x00000800,--微信充值用户标记
          UR_MASK_TASK					=   0x00001000,--任务参与标记
          UR_MASK_ACTIVE				=	0x00002000,--活动参与标记
          UR_MASK_SLIGHT_PAY			=	0x00004000,--浅度付费用户 <= 30
          UR_MASK_MODERATE_PAY			=   0x00008000,--中度付费用户
          UR_MASK_SEVERE_PAY			=	0x00010000,--重度付费用户 > 300
          UR_RIGHT_FULLGAME				=   0x00020000,--完整的游戏权限
          UR_MASK_BETA					=   0x00040000,--内测权限
          UR_MASK_CERTIFICATION			=   0x00080000,--实名认证权限
          UR_MASK_ADULT					=   0x00100000,--成年人权限
          UR_MASK_INTRODUCER			=	0x00200000,--是否有介绍人
          UR_MASK_CHECK_PHONE			=	0x00400000,--是否已手机验证
          UR_MASK_CHECK_WECHAT			=   0x00800000,--是否已微信验证
          UR_MASK_CHANGE_NAME			=	0x01000000,--是否已经修改过名字
          UR_MASK_FORMAL_USER			=	0x10000000,--正式帐号
          UR_MASK_CHECK					=   0x20000000,--审核人员帐号（审核版本登陆过游戏的帐号）
          UR_MASK_ROBOT					=   0x40000000--机器人
}

PUSH_NOTIE_MESSAGE		="PUSH_NOTIE_MESSAGE"	      --推送消息
PUSH_NOTIE_BUGLE		="PUSH_NOTIE_BUGLE"		      --喇叭消息
PUSH_NOTIE_ACTION		="PUSH_NOTIE_ACTION"		      --命令消息
PUSH={
        MDM_PUSH					=8000				,      --推送消息

        SUB_PUSH_REGISTER			=1					,      --注册
        SUB_PUSH_REGISTER_RET		=100					,      --注册回馈
        SUB_PUSH_ENTER_ROOM			=3					,      --注册
        SUN_PUSH_ACTION_RET			=4					,      --推送反馈
        SUN_PUSH_ACTION				=5					,      --用户行为
        SUB_PUSH_ENTER_ROOM_RET		=103					,      --注册回馈
        SUB_PUSH_MESSAGE			=102					,      --消息推送
        SUB_PUSH_BUGLE				=104					,      --喇叭消息
        SUN_USER_ACTION				=105					,      --用户行为

        SUB_FRIEND_APPLY			=201					,      --好友申请
        SUB_FRIEND_APPLY_RET		=202					,      --好友申请返回
        SUB_FRIEND_CHAT				=211					,      --好友聊天
        SUB_FRIEND_CHAT_RET			=212					,      --好友聊天返回
        SUB_FRIEND_UPDATE			=221					,      --好友消息通知
        SUB_FRIEND_AGREE			=222					,      --好友申请同意
        SUB_FRIEND_AGREE_RET		=223					,      --好友申请同意返回
        SUB_FRIEND_DELETE			=234					,      --删除好友
        SUB_FRIEND_DELETE_RET		=235					,      --删除好友返回
        SUB_FRIEND_STATUS			=231					,      --好友状态
        SUB_FRIEND_STATUS_START		=232					,      --好友状态下发开始
        SUB_FRIEND_STATUS_RET		=233					,      --好友状态
        SUB_FRIEND_STATUS_FINISH	=234					,      --好友状态下发结束
}


TESTCOLOR={
    r=BPRESOURCE("res/test_red.png"),
    g=BPRESOURCE("res/test_green.png"),

}
PROPS=
{
	{id=1005,fund_desc="",prop_name="大喇叭X10",logo=1005,price=500,prop_count=10,fund_price="500元宝",pay_type=2},
	{id=1004,fund_desc="",prop_name="小喇叭X20",logo=1004,price=100,prop_count=20,fund_price="100元宝",pay_type=2},
	{id=1016,fund_desc="",prop_name="踢人卡X5",logo=1016,price=50,prop_count=5,fund_price="50元宝",pay_type=2},
	{id=1003,fund_desc="",prop_name="7天记牌器",logo=1003,price=60,prop_count=1,fund_price="60元宝",pay_type=2},
	{id=1021,fund_desc="",prop_name="互动道具包X2",logo=1021,price=50,prop_count=2,fund_price="50元宝",pay_type=2},
	{id=1025,fund_desc="",prop_name="房卡X5",logo=1025,price=100,prop_count=5,fund_price="100元宝",pay_type=2},
	{id=1020,fund_desc="",prop_name="积分清零卡",logo=1020,price=100,prop_count=1,fund_price="100元宝",pay_type=2},
	{id=1017,fund_desc="",prop_name="双倍积分卡",logo=1017,price=50,prop_count=1,fund_price="50元宝",pay_type=2},
	{id=1018,fund_desc="",prop_name="积分护身符",logo=1018,price=50,prop_count=1,fund_price="50元宝",pay_type=2},
	{id=1006,fund_desc="",prop_name="1天记牌器X5",logo=1006,price=50,prop_count=5,fund_price="50元宝",pay_type=2},
	{id=2010,fund_desc="10元宝=1万",prop_name="20万金币",logo=2010,price=180,prop_count=1,fund_price="180元宝",pay_type=2},
	{id=2007,fund_desc="10元宝=1万",prop_name="100万金币",logo=2007,price=800,prop_count=1,fund_price="800元宝",pay_type=2}
}
VIPDATA=
{
	{id=1007,name="白银会员",gold=210000,award=7000,sign=1,head=1,prop={{id=1006,count=1},{id=1021,count=1},{id=1017,count=1}},day=30,price=280},
	{id=1008,name="黄金会员",gold=530000,award=15000,sign=1,head=1,prop={{id=1003,count=1},{id=1021,count=2},{id=1017,count=2},{id=1018,count=1}},day=30,price=650},
	{id=1009,name="白金会员",gold=1050000,award=35000,sign=1,head=1,prop={{id=1003,count=2},{id=1021,count=4},{id=1017,count=3},{id=1018,count=2}},day=30,price=1400},
	{id=1010,name="钻石会员",gold=3000000,award=100000,sign=1,head=1,prop={{id=1003,count=3},{id=1021,count=8},{id=1017,count=4},{id=1018,count=3}},day=30,price=4000}
}

URL={
    HTTP_USE_PROP="https://open.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;PropUse&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;prop_id&quot;:{PROPID},&quot;reserve&quot;:&quot;{PARAM}&quot;,&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION},&quot;keyword&quot;:&quot;{KEYWORD}&quot;}}",
    HTTP_CHANGE_NICKNAME_NEW="https://demoopen.bookse.cn/api.svc/Api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;ModifyAccount&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;newaccounts&quot;:&quot;{NEWNICKNAME}&quot;,&quot;newgender&quot;:{NEWSEX},&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION}}}",
    HTTP_BUY_PROP="https://demoopen.bookse.cn/api.svc/Api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;PropBuy&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;fund_id&quot;:{PROPID},&quot;fund_count&quot;:{PROPCOUNT},&quot;use_type&quot;:{USETYPE},&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION},&quot;keyword&quot;:&quot;{KEYWORD}&quot;}}",
    HTTP_CLIENT_AWARD="http://webdemo.tongquegame.com/mobile/client_award.php?userid={USERID}&session={SESSION}&type={TYPEID}&kindid={KINDID}&areaid={AREAID}&channelid={CHANNELID}&version={VERSION}&keyword={KEYWORD}",
    HTTP_GET_NOTICE="http://webdemo.tongquegame.com/mobile/notice_query.php?areaid={AREAID}&kindid={KINDID}&channel={CHANNELID}&userid={USERID}&session={SESSION}&version={VERSION}",
    HTTP_EXCHANGE_REDPACKET_LIST="http://webdemo.tongquegame.com/mobile/redpackfield_show.php?userid={USERID}&session={SESSION}",
    HTTP_QUERY_GOLD="https://demoopen.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;QueryUserGold&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID}}}",
    HTTP_EXCHANGE_RECORD="https://demoopen.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;QueryFundExchangeLog&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;pageno&quot;:{PAGENO},&quot;pagesize&quot;:{PAGESIZE},&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION},&quot;keyword&quot;:&quot;{KEYWORD}&quot;}}",
    HTTP_EXCHANGE_OPERATION="https://demoopen.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;FundExchange&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;exchange_id&quot;:{EXCHANGEID},&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION},&quot;keyword&quot;:&quot;{KEYWORD}&quot;}}",
    HTTP_EXCHANGE_LIST="https://demoopen.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;QueryFundExchange&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;kind&quot;:1,&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION},&quot;keyword&quot;:&quot;{KEYWORD}&quot;}}",
    HTTP_ACCESS_GOLD="https://demoopen.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;UserGoldAccess&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;op_gold&quot;:{OPGOLD},&quot;op_type&quot;:{OPTYPE},&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION}}}",
    HTTP_USE_PROP="https://demoopen.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;PropUse&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;prop_id&quot;:{PROPID},&quot;reserve&quot;:&quot;{PARAM}&quot;,&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION},&quot;keyword&quot;:&quot;{KEYWORD}&quot;}}",
    HTTP_TASK_REWARD="http://webdemo.tongquegame.com/mobile/user_daytask_receive.php?userid={USERID}&task_id={TASKID}&session={SESSION}",
    HTTP_TASK_DATA="http://webdemo.tongquegame.com/mobile/user_daytask_query.php?userid={USERID}&kindid={KINDID}&session={SESSION}",
    HTTP_GET_PHONE_CODE="http://demoopen.bookse.cn/api.svc/Api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;GetSmsCode&quot;},&quot;reqdata&quot;:{&quot;phonenum&quot;:&quot;{PHONE}&quot;,&quot;type&quot;:{PHONE_TYPE}}}",
    HTTP_REG_REAL_NAME="https://demoopen.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;UpdateIdCard&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;idcard&quot;:&quot;{NEWIDCARD}&quot;,&quot;realname&quot;:&quot;{REALNAME}&quot;,&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION},&quot;keyword&quot;:&quot;{KEYWORD}&quot;}}",
    HTTP_CHANGE_PASSWORD="https://demoopen.bookse.cn/api.svc/api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;UpdatePwd&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;pwd&quot;:&quot;{PASSWORDMD5}&quot;,&quot;newpwd&quot;:&quot;{NEWPASSWORD}&quot;,&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION},&quot;keyword&quot;:&quot;{KEYWORD}&quot;}}",
    HTTP_CHANGE_ACCOUNT="https://demoopen.bookse.cn/api.svc/Api?{&quot;head&quot;:{&quot;FunctionCode&quot;:&quot;ModifyRegAccount&quot;,&quot;session&quot;:&quot;{SESSION}&quot;},&quot;reqdata&quot;:{&quot;userid&quot;:{USERID},&quot;password&quot;:&quot;{PASSWORDMD5}&quot;,&quot;newregaccounts&quot;:&quot;{NEWACCOUNTS}&quot;,&quot;newpassword&quot;:&quot;{NEWPASSWORD}&quot;,&quot;areaid&quot;:{AREAID},&quot;kindid&quot;:{KINDID},&quot;channel&quot;:{CHANNELID},&quot;version&quot;:{VERSION}}}"   
}

PROP={
        ID_PROP_OXHEAD		=1001, 	-- 牛头
        ID_PROP_LOTTER		=1002, 	-- 奖券
        ID_PROP_RECARD		=1003, 	-- 记牌器
        ID_PROP_SMALL_BUGLE	=1004, 	-- 小喇叭
        ID_PROP_BIG_BUGLE	=1005, 	-- 大喇叭
        ID_PROP_RECARD_ONE	=1006, 	-- 记牌器
        ID_PROP_VIP_1		=1007, 	-- 会员1
        ID_PROP_VIP_2		=1008, 	-- 会员2
        ID_PROP_VIP_3		=1009, 	-- 会员3
        ID_PROP_VIP_4		=1010, 	-- 会员4

        ID_PROP_EMOTE_EGG		=1011, 	-- 表情(鸡蛋)
        ID_PROP_EMOTE_SLIPPER	=1012, 	-- 表情(拖鞋)
        ID_PROP_EMOTE_BOMB		=1013, 	-- 表情(炸弹)
        ID_PROP_EMOTE_ROSE		=1014, 	-- 表情(玫瑰)
        ID_PROP_EMOTE_PRAISE	=1015, 	-- 表情(赞)
        ID_PROP_KICKOUT			=1016, 	-- 踢人卡
        ID_PROP_SCOREDOUBLE		=1017, 	-- 双倍积分卡
        ID_PROP_SCORESHIELD		=1018, 	-- 积分护身符
        ID_PROP_CHARMCLEAR		=1019, 	-- 魅力清零卡
        ID_PROP_SCORECLEAR		=1020, 	-- 积分清零卡
        ID_PROP_PACKAGE			=1021, 	-- 互动道具包
        ID_PROP_ROOM_CARD		=1025, 	-- 放卡

        ID_PROP_IPAD			=2001, 	-- iPad
        ID_PROP_POWER			=2002, 	-- 移动电源
        ID_PROP_POLAROID		=2003, 	-- 拍立得
        ID_PROP_DOLL			=2004, 	-- 纪念公仔
        ID_PROP_BILL_50			=2005, 	-- 50话费
        ID_PROP_BILL_100		=2006, 	-- 100话费
        ID_PROP_GOLD_100W		=2007, 	-- 100万银子
        ID_PROP_GOLD_30W		=2008, 	-- 30万银子
        ID_PROP_GOLD_5W			=2009, 	-- 5万银子
        ID_PROP_GOLD_20W		=2010, 	-- 20万银子
        ID_PROP_GOLD_50W		=2011, 	-- 50万银子
        ID_PROP_GOLD_200W		=2012, 	-- 200万银子
        ID_PROP_GOLD_500W		=2013, 	-- 500万银子
        ID_PROP_BILL_20			=2014, 	-- 20话费

}


 