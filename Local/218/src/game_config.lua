--层级
LZOrder={
    hand_card   =10,
    assist      =11,
    user_head   =12,
	phone_info  =13,
    left_count  =14,
    table_timer =15,
    dice        =16,
    chat        =17,
    bg_menu     =18,
    menu        =19,
    game_end    =20,
}

--游戏协议
--客户端to服务端
C2SP={
    user_gift       = 1001, --发送礼物
    out_card        = 1002, --发送出牌信息
    pass            = 1003, --发送不出牌信息
    no_trust		= 1005, --取消托管
}
--服务端to客户端
S2CP={
    game_start          = 101,
    game_config         = 102,
    light_card			= 103,
    opposite_hand_cards = 106,
    hand_cards          = 107,
    hand_card_count		= 108,
    pass                = 109,
    out_card		    = 110,
    outing_card		    = 111,
    mutil_change        = 113,
    rank_info			= 114,
    user_seat			= 115,
    button_power        = 116,
    trust               = 118;
    rest_cards_count    = 119;
    rest_hand_cards	    = 120;
    time_data           = 125,
    friend_record       = 128,
    finish_info		    = 129,
    gift				= 130,
    tip_msg			    = 135,
}

--牌色
CardColor = {
    fang	= 0x00,
    mei		= 0x01,
    hong	= 0x02,
    hei		= 0x03,
    joker	= 0x04,
}
--牌值
CardSize = {
    a		= 0x01,
    [2]		= 0x02,
    [3]		= 0x03,
    [4]		= 0x04,
    [5]		= 0x05,
    [6]		= 0x06,
    [7]		= 0x07,
    [8]		= 0x08,
    [9]		= 0x09,
    [10]	= 0x0a,
    j		= 0x0b,
    q		= 0x0c,
    k		= 0x0d,
    bjoker	= 0x0e,
    rjoker	= 0x0f,
}

--牌型
CardsType={
    null        = 0,
    single      = 1,
    double      = 2,
    three       = 3,
    stright_s   = 4,
    stright_d   = 5,
    stright_t   = 6,
    bomb_4      = 20,
    bomb_5      = 25,
    bomb_joker_3= 26,
    bomb_6      = 30,
    bomb_7      = 35,
    bomb_joker_4= 36,
    bomb_8      = 40,
    bomb_9      = 45,
    bomb_10     = 50,
    bomb_11     = 55,
}

--游戏状态
GameStatus={
    free        = 0,
	send_card   = 1,
	out_card    = 2,
}

--玩家状态
UserStatus={
    us_null     = 0x00, --没有状态
    us_free     = 0x01, --站立状态
    us_sit      = 0x02, --坐下状态
    us_ready    = 0x03, --同意状态
    us_lookon   = 0x04, --旁观状态
    us_play     = 0x05, --游戏状态
    us_offline  = 0x06, --断线状态
}

--玩家性别
Sex={
    nv  =0, --女
    nan =1, --男
}

--出完牌标志显示位置
EscapeDirc={
    left    = 1, 
    right   = 2,
}

--按钮权限
ButtonPower={
    Ready			=0x0001,
    Change_table	=0x0002,
    Out_Card        =0x0008,
    Hint			=0x0010,
    Pass			=0x0020,
    Sort			=0x0040,
    Friend			=0x0080,
}

--管控配置表
MaskModule={
    Message=0x00000001,
    Shop=0x00000002,
    ShareWechat=0x00000020,
}

--游戏类型（非唯一）
GameRoomType = {
        SCORE               = 0x0001,   --积分场
        EDUCATE             = 0x0008,   --训练场
        SCGOLD              = 0x0010,   --双结算场
        NOCHEAT             = 0x0020,   --防作弊场
        BETA                = 0x0040,   --测试场
        ROOM_KIND_LINEUP    = 0x0080,   --排队机场
        ROOM_KIND_WEIGHT    = 0x0100,   --权重配牌
        ROOM_KIND_RECORD    = 0x0200,   --记录盘局
        ROOM_KIND_REDPACK   = 0x0400    --红包场
}

--游戏模式（唯一）
GameRoomMode = {
    ROOM_MODE_NORMAL			=	0,			
    ROOM_MODE_MOBILE			=	1,			
    ROOM_MODE_FRIEND			=	4,			
    ROOM_MODE_REDPACKET			=	8	
}

--系统消息
SMessageType = {
    info = 0x0001, eject = 0x0002, global = 0x0004, close_game = 0x1000
}

GameStatue = {
    null        = 0,
    ready       = 1,
    game        = 2,
    all_end     = 3,
}


ROOM_MODE_FRIEND=4
ROOM_KIND_NOCHEAT = 0x0020
ROOM_KIND_LINEUP = 0x0080
ROOM_KIND_SCGOLD = 0x0010
ROOM_KIND_SCORE = 0x0001
MASK_MODULE_SHOP = 0x00000400
ROOM_KIND_MINI_GAME = 0x1000
ShowWechatBtn = true
CanContinue = true
ROOM_MODE_REDPACKET = 8