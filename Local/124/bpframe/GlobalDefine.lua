--GlobalFrame
GF={
    INVALID_TABLE        = 65535,--无效桌子号
    INVALID_CHAIR        = 65535,--无效椅子号
    MAX_CHAIR            = 8,--最大椅子数
    MAX_CONNECT_COUNT    = 2048,--最大连接数

    --IPC 网络事件
    IPC_MAIN_SOCKET = 1		,						--网络消息
    IPC_SUB_SOCKET_SEND = 1		,						--网络发送
    IPC_SUB_SOCKET_RECV = 2		,						--网络接收
    IPC_SUB_SOCKET_FRAME = 3    ,                        --网络接受框架消息

    --IPC 配置信息
    IPC_MAIN_CONFIG = 2	,							--配置信息
    IPC_SUB_SERVER_INFO = 1	,							--房间信息
    IPC_SUB_COLUMN_INFO = 2	,							--列表信息
    IPC_SUB_USER_MEMBER = 7	,							--会员状态
    --IPC 用户信息
    IPC_MAIN_USER = 3	,							--用户信息export const
    IPC_SUB_USER_COME = 1		,						--用户信息
    IPC_SUB_USER_STATUS = 2		,						--用户状态
    IPC_SUB_USER_SCORE = 3		,						--用户积分
    IPC_SUB_GAME_START = 4		,						--游戏开始
    IPC_SUB_GAME_FINISH = 5		,						--游戏结束
    IPC_SUB_REDPACKET_INFO = 6,
    IPC_SUB_USER_MEMBER=7,                              --会员状态

    --IPC 控制信息
    IPC_MAIN_CONCTROL = 4	,							--控制信息
    IPC_SUB_START_FINISH = 1,								--启动完成
    IPC_SUB_CLOSE_FRAME = 2	,							--关闭框架
    IPC_SUB_NOTICT_FRAME = 3,

    --游戏模式（唯一）
    ROOM_MODE_NORMAL = 0,--普通场
    ROOM_MODE_MOBILE = 1,--移动场
    ROOM_MODE_FRIEND = 4,--好友场
    ROOM_MODE_REDPACKET = 8,--红包场


    --游戏状态
   GS_FREE      = 0,--空闲状态
   GS_PLAYING   = 100,--游戏状态

    --用户状态
   US_NULL  = 0x00,--没有状态
   US_FREE  = 0x01,--站立状态
   US_SIT   = 0x02,--坐下状态
   US_READY = 0x03,--同意状态
   US_LOOKON= 0x04,--旁观状态
   US_PLAY  = 0x05,--游戏状态
   US_OFFLINE =0x06,--断线状态

 --举报类型
    KIND_REPORT_NULL			=0     ,--无
    KIND_REPORT_NICKNAME		=1     ,--昵称不文明
    KIND_REPORT_ABUSE			=2     ,--辱骂
    KIND_REPORT_CHEAT			=3     ,--合作作弊
    KIND_REPORT_COUNT			=4     ,--


   --消息类型
    KIND_MESSAGE_INFO    = 0x0001,--信息消息
    KIND_MESSAGE_BOX     = 0x0002,--弹出消息
    -- KIND_MESSAGE_BARRAGE = 0x0004,--弹幕消息
    KIND_MESSAGE_CLOSE   = 0x1000,--关闭房间


--游戏内通知事件。
    NOTICE_GAME_KICKOUT = "NOTICE_GAME_KICKOUT",
    NOTICE_GMAE_START   = "NOTICE_GMAE_START",
    NOTICE_USER_CHAT    = "NOTICE_USER_CHAT",
    NOTICE_MINIGUESS    = "NOTICE_MINIGUESS",
    NOTICE_MINIGUESS_RESULT    = "NOTICE_MINIGUESS_RESULT",

    -- -----------------
    -- DY ADD BEGIN
    -- -----------------
    ID_PROP_RECARD      =   1003,  -- 七天记牌器
    ID_PROP_RECARD_ONE  =   1006,  -- 记牌器

    ROOM_KIND_SCORE     =   0x0001,    -- 积分场
    ROOM_KIND_SCGOLD    =   0x0010,    -- 双结算场
    ROOM_KIND_NOCHEAT   =   0x0020,    -- 防作弊场
    ROOM_KIND_LINEUP    =   0x0080,    -- 排队机场
    ROOM_KIND_MINI_GAME =   0x1000,    -- 小游戏场

    MASK_MODULE_SHOP    =   0x00000400  -- 商城管控
    -- -----------------
    -- DY ADD END
    -- -----------------

}