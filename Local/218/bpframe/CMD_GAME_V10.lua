V10={
    MDM_GAME_LOGON=1,
    SUB_GAME_LOGON = 2,			--I D 登录
    SUB_GAME_LOGON2 = 3,			--I D 登录
    SUB_GAME_LOGON3 = 4,			--I D 登录
    SUB_GAME_LOGON_SUCCESS = 100,			--登陆成功
    SUB_GAME_LOGON_ERROR = 101,			--登陆失败
    SUB_GAME_LOGON_FINISH = 102,			--登陆完成


    MDM_USER = 2,			--用户信息
    SUB_USER_SIT = 1,			--坐下请求
    SUB_USER_LOOKON = 2,			--旁观请求
    SUB_USER_STANDUP = 3,			--起立请求
    SUB_USER_LEFT = 4,			--离开游戏
    SUB_USER_COME = 100,			--用户进入
    SUB_USER_STATUS = 101,			--用户状态
    SUB_USER_SCORE = 102,			--用户分数
    SUB_USER_SITFAILED = 103,			--坐下失败
    SUB_USER_PROP = 105,			--用户道具
    SUB_USER_CHAT = 200,			--聊天消息
    SUB_USER_MEMBER = 203,			--用户会员
    SUB_USER_ACCESS_GOLD = 300,			--存取金币
    SUB_USER_ACCESS_GOLD_RET = 301,		--存取金币回复
    SUB_USER_ACCESS_GOLD_ERROR = 302,	--存取金币错误
    SUB_USER_QUERY_GOLD = 303,			--查询金币
    SUB_USER_QUERY_GOLD_RET = 304,		--查询金币回复
    SUB_USER_RECONNECT_TABLE = 305,		--重连到游戏桌子
    SUB_USER_REDPACKET_INFO = 310,		--红包场用户
    SUB_USER_REDPACK = 312,				--红包

    MDM_CONFIG = 3,			--配置信息

    SUB_CONFIG_INFO = 100,			--房间配置
    SUB_CONFIG_COLUMN = 103,			--列表配置
    SUB_CONFIG_FINISH = 104,			--配置完成
    SUB_CONFIG_LUA_RULE = 105,			--lua配置字符串

    MDM_TABLE			= 4,				--状态信息
	SUB_TABLE_INFO		= 100,				--桌子信息
    SUB_TABLE_STATUS	= 101,				--桌子状态

    MDM_SYSTEM			= 10,			--系统信息
    SUB_SYSTEM_MESSAGE	= 100,			--系统消息

    MDM_GAME					= 100,			--游戏消息
    MDM_FRAME				= 101,			--框架消息
    SUB_FRAME_INFO			= 1,			--游戏信息
    SUB_FRAME_READY			= 2,			--用户同意
    SUB_FRAME_OPTION			= 100,			--游戏配置
    SUB_FRAME_SCENE			= 101,			--场景信息
    SUB_FRAME_CHAT			= 200,			--用户聊天
    SUB_FRAME_MESSAGE		= 300,			--系统消息
    SUB_FRAME_REPORT			= 600,			--举报
    SUB_FRAME_REPORT_RET		= 601,			--举报
    SUB_FRAME_KICKOUT		= 602,			--踢人
    SUB_FRAME_KICKOUT_RET	= 603,			--踢人
    SUB_FRAME_KICKOUT_NOTICE = 604,			--踢人
    SUB_FRAME_PRAISE			= 605,			--赞美
    SUB_FRAME_PRAISE_RET		= 606,			--赞美
    SUB_FRAME_PRAISE_NOTICE	= 607,			--赞美
    SUB_FRAME_GIFT			= 608,			--礼物
    SUB_FRAME_GIFT_RET		= 609,			--礼物
    SUB_FRAME_GIFT_NOTICE	= 610,			--礼物
    SUB_FRAME_READY_ERROR	= 611,			--准备错误
    SUB_FRAME_REDPACKET_GAMEC = 612,			--红包场游戏局数
    SUB_FRAME_OPEN_MINI_GAME = 613,			--打开小游戏
    SUB_FRAME_OPEN_MINI_GAME_RET = 614,			--打开小游戏回复
    SUB_FRAME_MINI_GAME_ERR = 615,			--小游戏失败
    SUB_FRAME_PLAY_MINI_GAME = 616,			--进行小游戏
    SUB_FRAME_MINI_GAME_RESULT = 617,			--小游戏结果

}
