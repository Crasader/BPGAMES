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

   --消息类型
    KIND_MESSAGE_INFO    = 0x0001,--信息消息
    KIND_MESSAGE_BOX     = 0x0002,--弹出消息
    -- KIND_MESSAGE_BARRAGE = 0x0004,--弹幕消息
    KIND_MESSAGE_CLOSE   = 0x1000,--关闭房间



}