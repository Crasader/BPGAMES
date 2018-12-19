#pragma once
//////////////////////////////////////////////////////////////////////////
//常量定义
#define NAME_LEN						32						//名字长度
#define PASS_LEN						33						//密码长度
#define IP_LEN							16						//IP长度
#define MAC_LEN							33						//MAC长度
#define SESSION_LEN						33						//SESSION长度
#define MD5_LEN							33						//MD5长度
#define MOBILE_LEN						16						//手机长度
#define MQ_LEN							64						//队列长度
#define CODE_LEN						12						//效验码长度

//常量定义
#define INVALID_TABLE					((unsigned short)(-1))	//无效桌子号
#define INVALID_CHAIR					((unsigned short)(-1))	//无效椅子号
#define MAX_CHAIR						8						//最大椅子数

//////////////////////////////////////////////////////////////////////////

// 客户端类型
#define KIND_CLIENT_PC					1			//PC
#define KIND_CLIENT_MOBILE				2			//移动

//平台类型
#define KIND_AREA_ANDROID				1			//安卓
#define KIND_AREA_IOS					2			//苹果
#define KIND_AREA_WECHAT				3			//微信小程序
#define KIND_AREA_WINDOWS				1000		//WINDOWS

//渠道类型
#define KIND_CHANNEL_APPSTORE			1			//APP Store
#define KIND_CHANNEL_TENCENT			1			//应用宝
#define KIND_CHANNEL_XIAOMI				3			//小米
#define KIND_CHANNEL_360SAFE			4			//360
#define KIND_CHANNEL_QIFAN				6			//起凡
#define KIND_CHANNEL_BAIDU				7			//百度
#define KIND_CHANNEL_HUAWEI				8			//华为
#define KIND_CHANNEL_LENOVO				9			//联想
#define KIND_CHANNEL_OPPO				10			//Oppo
#define KIND_CHANNEL_ANZHI				11			//安智
#define KIND_CHANNEL_WANDOUJIA			12			//豌豆荚
#define KIND_CHANNEL_MEIZU				13			//魅族
#define KIND_CHANNEL_MUMAYI				14			//木蚂蚁
#define KIND_CHANNEL_EGAME				15			//爱游戏
#define KIND_CHANNEL_BAIDU_NONET		16			//百度(单机)
#define KIND_CHANNEL_VIVO				17			//VIVO

//////////////////////////////////////////////////////////////////////////

// 充值方式
#define PAY_OPTION_APPLEPAY				0x00000001
#define PAY_OPTION_ALIPAY				0x00000002
#define PAY_OPTION_SMSPAY				0x00000004
#define PAY_OPTION_MANUALPAY			0x00000008
#define PAY_OPTION_MIPAY				0x00000010
#define PAY_OPTION_BAIDUPAY				0x00000020
#define PAY_OPTION_LENOVOPAY			0x00000040
#define PAY_OPTION_HUAWEIPAY			0x00000080 
#define PAY_OPTION_MEIZUPAY				0x00000100
#define PAY_OPTION_WEIXINPAY			0x00000200
#define	PAY_OPTION_EGAMEPAY				0x00000400
#define	PAY_OPTION_360SAFEPAY			0x00000800
#define PAY_OPTION_BAIDUPAY_NONET		0x00001000
#define PAY_OPTION_VIVOPAY				0x00002000
#define PAY_OPTION_OPPO					0x00004000
#define PAY_OPTION_HEEPAY				0x00008000
//////////////////////////////////////////////////////////////////////////

//游戏类型（非唯一）
#define ROOM_KIND_SCORE					0x0001		//积分场
#define ROOM_KIND_EDUCATE				0x0008		//训练场
#define ROOM_KIND_SCGOLD				0x0010		//双结算场
#define ROOM_KIND_NOCHEAT				0x0020		//防作弊场
#define ROOM_KIND_BETA					0x0040		//测试场
#define ROOM_KIND_LINEUP				0x0080		//排队机场
#define	ROOM_KIND_TABLE_LIST			0x0200		//选座场
#define	ROOM_KIND_MIN_BEANS				0x0400		//小金豆场
#define	ROOM_KIND_MAX_BEANS				0x0800		//大金豆场
#define ROOM_KIND_MINI_GAME				0x1000		//小游戏场


//游戏模式（唯一）
#define ROOM_MODE_NORMAL				0			//普通场
#define ROOM_MODE_MOBILE				1			//移动场
#define ROOM_MODE_FRIEND				4			//好友场
#define ROOM_MODE_REDPACKET				8			//红包场

//结束类型
#define RESULT_KIND_WIN					0			//胜
#define RESULT_KIND_LOST				1			//输
#define RESULT_KIND_DRAW				2			//和
#define RESULT_KIND_FLEE				3			//逃
#define RESULT_KIND_NULL				4			//无

//结算类型
#define TALLY_KIND_GOLD					1			//金币
#define TALLY_KIND_INGOT				2			//元宝
#define TALLY_KIND_CHARM				3			//魅力
#define TALLY_KIND_PRAISE				4			//赞
#define TALLY_KIND_SCORE				5			//积分

//开始方式
#define KIND_START_FULL					0			//满人开始
#define KIND_START_READY				1			//所有准备
#define KIND_START_CUSTOM				2			//自定义模式
#define KIND_START_FREEDOM				3			//自由模式

//好友场类型（唯一）
#define KIND_FRIEND_NULL				0			//无
#define KIND_FRIEND_COUNT				1			//完局数

//游戏状态
#define GS_FREE							0			//空闲状态
#define GS_PLAYING						100			//游戏状态

//用户状态
#define US_NULL							0x00		//没有状态
#define US_FREE							0x01		//站立状态
#define US_SIT							0x02		//坐下状态
#define US_READY						0x03		//同意状态
#define US_LOOKON						0x04		//旁观状态
#define US_PLAY							0x05		//游戏状态
#define US_OFFLINE						0x06		//断线状态

//登陆方式
#define KIND_LOGON_REGISTER				1			//游客登陆
#define KIND_LOGON_ACCOUNT				2			//帐号登陆
#define KIND_LOGON_PHONE				3			//手机登陆
#define KIND_LOGON_WECHAT				4			//微信登陆
#define KIND_LOGON_TENCENT				5			//QQ登陆
#define KIND_LOGON_CHANNEL				6			//渠道登陆

//////////////////////////////////////////////////////////////////////////

//房间限制类型
#define LIMIT_SCORE_MIN					0x00001		//积分下限
#define LIMIT_SCORE_MAX					0x00002		//积分上限
#define LIMIT_GOLD_MIN					0x00004		//金币下限
#define LIMIT_GOLD_MAX					0x00008		//金币上限
#define LIMIT_BEAUTY_MIN				0x00010		//魅力下限
#define LIMIT_BEAUTY_MAX				0x00020		//魅力上限
#define LIMIT_VERSION_MIN				0x00040		//版本下限
#define LIMIT_VERSION_MAX				0x00080		//版本上限
#define LIMIT_SAME_IP					0x00100		//同IP限制

//////////////////////////////////////////////////////////////////////////

//登陆错误类型
#define CODE_LOGON_SUCCESS				0			// 成功
#define CODE_LOGON_SOCKET_CLOSE			1			// 网络断开
#define CODE_LOGON_NEED_UPDATE			2			// 需要更新
#define CODE_LOGON_ACCOUNT_ERROR		3			// 帐号错误
#define CODE_LOGON_PASSWORD_ERROR		4			// 密码错误
#define CODE_LOGON_REJECT				5			// 拒绝登陆
#define CODE_LOGON_STOP					6			// 正在维护
#define CODE_LOGON_UNKONW				10			// 未知错误

//////////////////////////////////////////////////////////////////////////

// 举报类型
#define KIND_REPORT_NULL			0			//无
#define KIND_REPORT_NICKNAME		1			//昵称不文明
#define KIND_REPORT_ABUSE			2			//辱骂
#define KIND_REPORT_CHEAT			3			//合作作弊
#define KIND_REPORT_COUNT			4	

//////////////////////////////////////////////////////////////////////////

//消息类型
#define KIND_MESSAGE_INFO			0x0001		//信息消息
#define KIND_MESSAGE_BOX			0x0002		//弹出消息
#define KIND_MESSAGE_BARRAGE		0x0004		//弹幕消息
#define KIND_MESSAGE_CLOSE			0x1000		//关闭房间

//////////////////////////////////////////////////////////////////////////

//道具定义
#define ID_PROP_OXHEAD				1001	// 牛头
#define ID_PROP_LOTTER				1002	// 奖券
#define ID_PROP_RECARD				1003	// 记牌器
#define ID_PROP_SMALL_BUGLE			1004	// 小喇叭
#define ID_PROP_BIG_BUGLE			1005	// 大喇叭
#define ID_PROP_RECARD_ONE			1006	// 记牌器
#define ID_PROP_VIP_1				1007	// 会员1
#define ID_PROP_VIP_2				1008	// 会员2
#define ID_PROP_VIP_3				1009	// 会员3
#define ID_PROP_VIP_4				1010	// 会员4

#define ID_PROP_EMOTE_EGG			1011	// 表情(鸡蛋)
#define ID_PROP_EMOTE_SLIPPER		1012	// 表情(拖鞋)
#define ID_PROP_EMOTE_BOMB			1013	// 表情(炸弹)
#define ID_PROP_EMOTE_ROSE			1014	// 表情(玫瑰)
#define ID_PROP_EMOTE_PRAISE		1015	// 表情(赞)
#define ID_PROP_KICKOUT				1016	// 踢人卡
#define ID_PROP_SCOREDOUBLE			1017	// 双倍积分卡
#define ID_PROP_SCORESHIELD			1018	// 积分护身符
#define ID_PROP_CHARMCLEAR			1019	// 魅力清零卡
#define	ID_PROP_SCORECLEAR			1020	// 积分清零卡
#define	ID_PROP_PACKAGE				1021	// 互动道具包
#define ID_PROP_ROOM_CARD			1025    // 放卡

#define ID_PROP_IPAD				2001	// iPad
#define ID_PROP_POWER				2002	// 移动电源
#define ID_PROP_POLAROID			2003	// 拍立得
#define ID_PROP_DOLL				2004	// 纪念公仔
#define ID_PROP_BILL_50				2005	// 50话费
#define ID_PROP_BILL_100			2006	// 100话费
#define ID_PROP_GOLD_100W			2007	// 100万银子
#define ID_PROP_GOLD_30W			2008	// 30万银子
#define ID_PROP_GOLD_5W				2009	// 5万银子
#define ID_PROP_GOLD_20W			2010	// 20万银子
#define ID_PROP_GOLD_50W			2011	// 50万银子
#define ID_PROP_GOLD_200W			2012	// 200万银子
#define ID_PROP_GOLD_500W			2013	// 500万银子
#define ID_PROP_BILL_20				2014	// 20话费

// 道具状态ID
#define ID_PROP_STATUS_RECARD		1003	// 记牌器状态
#define ID_PROP_STATUS_VIP_1		1007	// VIP1状态
#define ID_PROP_STATUS_VIP_2		1008	// VIP2状态
#define ID_PROP_STATUS_VIP_3		1009	// VIP3状态
#define ID_PROP_STATUS_VIP_4		1010	// VIP4状态
#define ID_PROP_STATUS_SMALL_BUGLE	1011	// 无限小喇叭
#define ID_PROP_STATUS_BIG_BUGLE	1012	// 无限大喇叭
#define ID_PROP_STATUS_SCOREDOUBLE	1017	// 双倍积分卡
#define ID_PROP_STATUS_SCORESHIELD	1018	// 积分护身符

#define ID_PROP_STATUS_VIPAWARD_1	11007	// VIP1奖励状态
#define ID_PROP_STATUS_VIPAWARD_2	11008	// VIP2奖励状态
#define ID_PROP_STATUS_VIPAWARD_3	11009	// VIP3奖励状态
#define ID_PROP_STATUS_VIPAWARD_4	11010	// VIP4奖励状态

//////////////////////////////////////////////////////////////////////////

//数据包版本
#define SOCKET_VERSION				67
//////////////////////////////////////////////////////////////////////////
//数据包结构信息
struct CMD_INFO
{
	unsigned short	size;								//数据大小
	unsigned char	code;								//效验字段
	unsigned char	version;							//版本标识
};

//数据包命令信息
struct CMD_COMMAND
{
	unsigned short	main;								//主命令码
	unsigned short	sub;								//子命令码
};

//数据包传递包头
struct CMD_HEAD
{
	CMD_INFO		info;								//基础结构
	CMD_COMMAND		command;							//命令信息
};

//////////////////////////////////////////////////////////////////////////
//内核命令码
#define MDM_BASE_COMMAND	0							//内核命令
#define SUB_BASE_SOCKET		1							//检测命令

//检测结构信息
struct CMD_BASE_SOCKET
{
	unsigned int	send;
	unsigned int	recv;
};

struct CMD_BASE_INFO2
{
	int				clienttype;
	int				area;
	int				channel;
	int				app;
	int				version;
	int				package;
	char			keyword[32];
};
//////////////////////////////////////////////////////////////////////////