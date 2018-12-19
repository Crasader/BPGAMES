#pragma once
#include "GlobalDefine.h"
//////////////////////////////////////////////////////////////////////////

struct CMD_BASE_INFO
{
	int				int_client_type;
	int				int_area_id;
	int				int_channel_id;
	int				int_kind_id;
	int				int_version;
};

namespace V10 {


	typedef unsigned short WORD;
	typedef unsigned char BYTE;
	typedef unsigned int DWORD;
	typedef int LONG;
	typedef double DATE;
	typedef long long  LONGLONG;

	struct tagUserScore
	{
		LONGLONG		lGold;						//用户金币
		LONG			lScore;						//用户分数
		LONG			lWinCount;					//胜利盘数
		LONG			lLostCount;					//失败盘数
		LONG			lDrawCount;					//和局盘数
		LONG			lFleeCount;					//断线数目
		LONG			lExperience;				//用户经验
		WORD			reserve1;					//无效
		WORD			reserve2[30];				//无效
		DATE			reserve3;					//无效
		LONG			reserve4;					//无效
		DWORD			dwGameTime;					//游戏时间
		LONG			nCharm;						//魅力 
		LONG			nLogonCount;				//登陆次数
		LONG			nPraise;					//赞
#if		(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		BYTE                                cbReserved1;
		BYTE                                cbReserved2;
		BYTE                                cbReserved3;
		BYTE                                cbReserved4;
#endif
	};

	//用户基本信息结构
	struct tagUserInfoHead
	{
		//用户属性
		WORD								wFaceID;							//头像索引
		BYTE								cbGender;							//用户性别
		BYTE								cbMember;							//会员等级
		DWORD								dwUserID;							//用户 I D
		DWORD								dwGroupID;							//社团索引
		DWORD								dwUserRight;						//用户等级
		DWORD								dwMasterRight;						//管理权限

																				//用户状态
		WORD								wTableID;							//桌子号码
		WORD								wChairID;							//椅子位置
		WORD								wNetDelay;							//网络延时
		BYTE								cbUserStatus;						//用户状态
#if		(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		BYTE                                cbReserved1;
		BYTE                                cbReserved2;
		BYTE                                cbReserved3;
		BYTE                                cbReserved4;
#endif
		//用户积分
		tagUserScore						UserScoreInfo;						//积分信息

		DWORD								gametime;							//
#if		(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		BYTE                                cbReserved5;
		BYTE                                cbReserved6;
		BYTE                                cbReserved7;
		BYTE                                cbReserved8;
#endif
		DATE								szMemberOverTime;					//会员结束时间
		short int							byItemNum[30];

		BYTE								cbCameraStatus;						//摄象头状态
		BYTE								cbFaceEnable;						//对应wFaceID个人形象是不是可用
		LONG								lCharm;								//用户魅力
		LONG								lPraise;							//用户赞
	};


	//用户信息结构
	struct tagUserData
	{
		//用户属性
		WORD								wFaceID;							//头像索引
		BYTE								cbGender;							//用户性别
		BYTE								cbMember;							//会员等级
		DWORD								dwUserID;							//用户 I D
		DWORD								dwGroupID;							//社团索引
		DWORD								dwUserRight;						//用户等级
		DWORD								dwMasterRight;						//管理权限
		char								szName[NAME_LEN];					//用户名字
		char								szGroupName[32];					//社团名字

																				//用户积分
#if		(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
		BYTE                                cbReserved1;
		BYTE                                cbReserved2;
		BYTE                                cbReserved3;
		BYTE                                cbReserved4;
#endif
		long long							lGold;								//用户金币
		LONG								lScore;								//用户分数
		LONG								lWinCount;							//胜利盘数
		LONG								lLostCount;							//失败盘数
		LONG								lDrawCount;							//和局盘数
		LONG								lFleeCount;							//断线数目
		LONG								lExperience;						//用户经验

																				//用户状态
		WORD								wTableID;							//桌子号码
		WORD								wChairID;							//椅子位置
		WORD								wNetDelay;							//网络延时
		BYTE								cbUserStatus;						//用户状态
		BYTE								cbCameraStatus;						//摄象头状态

																				//其他信息
		BYTE								cbCompanion;						//用户关系
		BYTE								cbFaceEnable;						//对应wFaceID个人形象是不是可用

		DWORD								gametime;							//游戏时间
		LONG								lCharm;								//用户魅力
		LONG								lPraise;							//用户赞
	};




	const unsigned int MDM_GAME_LOGON			= 1;			//房间登录

	const unsigned int SUB_GAME_LOGON			= 2;			//I D 登录
	const unsigned int SUB_GAME_LOGON2			= 3;			//I D 登录
	const unsigned int SUB_GAME_LOGON3			= 4;			//I D 登录

	const unsigned int SUB_GAME_LOGON_SUCCESS	= 100;			//登陆成功
	const unsigned int SUB_GAME_LOGON_ERROR		= 101;			//登陆失败
	const unsigned int SUB_GAME_LOGON_FINISH	= 102;			//登陆完成

	struct CMD_GAME_LOGON
	{
		unsigned int	code;						//code
		unsigned int	gameversion;				//游戏版本
		unsigned int	userid;						//用户ID
		char			password[PASS_LEN];			//登录密码
	};

	struct CMD_GAME_LOGON2
	{
		unsigned int	code;						//code
		unsigned int	gameversion;				//游戏版本
		unsigned int	userid;						//用户ID
		char			password[PASS_LEN];			//登录密码
		CMD_BASE_INFO	base;
	};

	struct CMD_GAME_LOGON3
	{
		unsigned int	code;						//code
		unsigned int	gameversion;				//游戏版本
		unsigned int	userid;						//用户ID
		char			password[PASS_LEN];			//登录密码
		char			session[SESSION_LEN];		//密钥
		CMD_BASE_INFO	base;
	};

	struct CMD_GAME_LOGON_SUCCESS
	{
		unsigned int	userid;						//用户ID
	};

	struct CMD_GAME_LOGON_ERROR
	{
		int				flag;						//错误代码
		char			error[128];					//错误消息
	};


	//////////////////////////////////////////////////////////////////////////

	const unsigned int MDM_USER				= 2;			//用户信息

	const unsigned int SUB_USER_SIT			= 1;			//坐下请求
	const unsigned int SUB_USER_LOOKON		= 2;			//旁观请求
	const unsigned int SUB_USER_STANDUP		= 3;			//起立请求
	const unsigned int SUB_USER_LEFT		= 4;			//离开游戏

	const unsigned int SUB_USER_COME		= 100;			//用户进入
	const unsigned int SUB_USER_STATUS		= 101;			//用户状态
	const unsigned int SUB_USER_SCORE		= 102;			//用户分数
	const unsigned int SUB_USER_SITFAILED	= 103;			//坐下失败
	const unsigned int SUB_USER_PROP		= 105;			//用户道具
	const unsigned int SUB_USER_CHAT		= 200;			//聊天消息
	const unsigned int SUB_USER_MEMBER		= 203;			//用户会员

	const unsigned int SUB_USER_ACCESS_GOLD = 300;			//存取金币
	const unsigned int SUB_USER_ACCESS_GOLD_RET = 301;		//存取金币回复
	const unsigned int SUB_USER_ACCESS_GOLD_ERROR = 302;	//存取金币错误
	const unsigned int SUB_USER_QUERY_GOLD = 303;			//查询金币
	const unsigned int SUB_USER_QUERY_GOLD_RET = 304;		//查询金币回复
	const unsigned int SUB_USER_RECONNECT_TABLE = 305;		//重连到游戏桌子
	const unsigned int SUB_USER_REDPACKET_INFO = 310;		//红包场用户
	const unsigned int SUB_USER_REDPACK = 312;				//红包

	//用户基本信息结构
	struct CMD_USER_DATA
	{
		unsigned short	face;						//头像索引
		unsigned char	gender;						//用户性别
		unsigned char	member;						//会员等级
		unsigned int	userid;						//用户 I D
		unsigned int	reserve1;					//无效
		unsigned int	userright;					//用户等级
		unsigned int	masterright;				//管理权限
		unsigned short	tableid;					//桌子号码
		unsigned short	chairid;					//椅子位置
		unsigned short	delay;						//网络延时
		unsigned char	status;						//用户状态
		//tagUserScore	socre;						//积分信息
		unsigned int	gametime;					//游戏时间
		long long		reserve2;					//无效
		short int		reserve3[30];				//无效
		unsigned char	reserve4;					//无效
		unsigned char	reserve5;					//无效
		int				charm;						//用户魅力
		int				praise;						//用户赞
	};

	//用户状态
	struct CMD_USER_STATUS
	{
		unsigned int	userid;						//用户ID
		unsigned short	tableid;					//桌子位置
		unsigned short	chairid;					//椅子位置
		unsigned short	delay;						//网络延时
		unsigned char	status;						//用户状态
		unsigned char	reserve1;					//无效
	};


	//请求坐下
	struct CMD_USER_SIT
	{
		unsigned short	tableid;					//桌子位置
		unsigned short	chairid;					//椅子位置
		unsigned short	delay;						//网络延时
		unsigned char	len;						//密码长度
		char			password[PASS_LEN];			//桌子密码
	};

	//坐下失败
	struct CMD_USER_SIT_FAIL
	{
		char			error[256];					//错误描述
		unsigned short	errorid;					//错误号码
		bool			reserve1;					//无效
	};

	//聊天结构 
	struct CMD_USER_CHAT
	{
		unsigned short	len;						//信息长度
		unsigned int	color;						//信息颜色
		unsigned int	userid;						//发送用户
		unsigned int	touserid;					//目标用户
		char			chat[512];					//聊天信息
	};


	//更新会员资料信息
	struct CMD_USER_MEMBER
	{
		unsigned int	userid;						//用户ID
		unsigned int	member;						//会员
	};

	//存取金币
	struct CMD_ACCESS_GOLD
	{
		unsigned short	kindid;						//	
		unsigned short	tokindid;					//0：存，1：取
		long long		gold;						//金币数
	};

	//存取金币回复
	struct CMD_ACCESS_GOLD_RET
	{
		long long		gold1;						//银行金币
		long long		gold2;						//随身金币

		char			mes[128];					//消息
	};

	//存取金币错误
	struct CMD_ACCESS_GOLD_ERROR
	{
		int				flag;						//错误代码
		int				len;
		char			error[128];					//错误消息
	};

	//查询金币回复
	struct CMD_QUERY_GOLD_RET
	{
		long long		gold1;						//银行金币
		long long		gold2;						//随身金币
		int				limit;						//滑动限制
	};
	//红包场局数
	struct CMD_REDPACKET_INFO
	{
		unsigned int	userid;
		unsigned int	finish_count;
		unsigned int	totle_count;
		unsigned int	pass_time;
		unsigned int    interval;
		unsigned int	sendtime;
	};

	//发送红包
	struct CMD_FRAME_REDPACK
	{
		unsigned int	userid;
		unsigned int	redpack;
		unsigned int	reserve[4];
		char			message[1024];
	};

	//////////////////////////////////////////////////////////////////////////
	//配置信息数据包

	const unsigned int MDM_CONFIG			= 3;			//配置信息

	const unsigned int SUB_CONFIG_INFO		= 100;			//房间配置
	const unsigned int SUB_CONFIG_COLUMN	= 103;			//列表配置
	const unsigned int SUB_CONFIG_FINISH	= 104;			//配置完成
	const unsigned int SUB_CONFIG_LUA_RULE	= 105;			//lua配置字符串

	//lua规则发送
	struct CMD_CONFIG_LUA_RULE
	{
		int				flag;						//未知用途
		char			rule[1024];					//规则内容
	};

	//游戏房间信息
	struct CMD_CONFIG_INFO
	{
		unsigned short	gameid;						//类型ID
		unsigned short	type;						//游戏类型
		unsigned short	tablecount;					//桌子数目
		unsigned short	chaircount;					//椅子数目
	};

	//列表项描述结构
	struct CMD_COLUMNN_ITEM
	{
		unsigned short	width;						//列表宽度
		unsigned short	type;						//字段类型
		char			name[16];					//列表名字
	};

	//列表描述信息
	struct CMD_COLUMNN_INFO
	{
		unsigned short		count;					//列表数目
		CMD_COLUMNN_ITEM	item[32];				//列表描述
	};

	//////////////////////////////////////////////////////////////////////////
	//房间状态数据包

	const unsigned int MDM_TABLE			= 4;				//状态信息

	const unsigned int SUB_TABLE_INFO		= 100;				//桌子信息
	const unsigned int SUB_TABLE_STATUS		= 101;				//桌子状态

	//桌子状态结构
	struct CMD_TABLE_ITEM
	{
		unsigned char	lock;						//锁定状态
		unsigned char	start;						//是否正在游戏中
		unsigned int	reserve1;					//无效
	};

	//桌子状态数组
	struct CMD_TABLE_INFO
	{
		unsigned short	count;						//桌子数目
		CMD_TABLE_ITEM	status[512];				//状态数组
	};

	//桌子状态信息
	struct CMD_TABLE_STATUS
	{
		unsigned short	tableid;					//桌子号码
		unsigned char	start;						//是否正在游戏中
		unsigned char	lock;						//锁定状态
		unsigned int	reserve1;					//无效
	};


	//////////////////////////////////////////////////////////////////////////
	//系统数据包

	const unsigned int MDM_SYSTEM			= 10;			//系统信息
	const unsigned int SUB_SYSTEM_MESSAGE	= 100;			//系统消息

	//消息
	struct CMD_SYSTEM_MESSAGE
	{
		unsigned short	type;						//消息类型
		unsigned short	len;						//消息长度
		char			message[1024];				//消息内容
	};

	//////////////////////////////////////////////////////////////////////////

	//网络命令码

	const unsigned int MDM_GAME					= 100;			//游戏消息
	const unsigned int MDM_FRAME				= 101;			//框架消息

	const unsigned int SUB_FRAME_INFO			= 1;			//游戏信息
	const unsigned int SUB_FRAME_READY			= 2;			//用户同意
	const unsigned int SUB_FRAME_OPTION			= 100;			//游戏配置
	const unsigned int SUB_FRAME_SCENE			= 101;			//场景信息
	const unsigned int SUB_FRAME_CHAT			= 200;			//用户聊天
	const unsigned int SUB_FRAME_MESSAGE		= 300;			//系统消息
	const unsigned int SUB_FRAME_REPORT			= 600;			//举报
	const unsigned int SUB_FRAME_REPORT_RET		= 601;			//举报
	const unsigned int SUB_FRAME_KICKOUT		= 602;			//踢人
	const unsigned int SUB_FRAME_KICKOUT_RET	= 603;			//踢人
	const unsigned int SUB_FRAME_KICKOUT_NOTICE = 604;			//踢人
	const unsigned int SUB_FRAME_PRAISE			= 605;			//赞美
	const unsigned int SUB_FRAME_PRAISE_RET		= 606;			//赞美
	const unsigned int SUB_FRAME_PRAISE_NOTICE	= 607;			//赞美
	const unsigned int SUB_FRAME_GIFT			= 608;			//礼物
	const unsigned int SUB_FRAME_GIFT_RET		= 609;			//礼物
	const unsigned int SUB_FRAME_GIFT_NOTICE	= 610;			//礼物
	const unsigned int SUB_FRAME_READY_ERROR	= 611;			//准备错误
	const unsigned int SUB_FRAME_REDPACKET_GAMEC = 612;			//红包场游戏局数

	const unsigned int SUB_FRAME_OPEN_MINI_GAME = 613;			//打开小游戏
	const unsigned int SUB_FRAME_OPEN_MINI_GAME_RET = 614;			//打开小游戏回复
	const unsigned int SUB_FRAME_MINI_GAME_ERR = 615;			//小游戏失败
	const unsigned int SUB_FRAME_PLAY_MINI_GAME = 616;			//进行小游戏
	const unsigned int SUB_FRAME_MINI_GAME_RESULT = 617;			//小游戏结果

	//版本信息


	//游戏配置

	//聊天结构
	struct CMD_FRAME_CHAT
	{
		unsigned short	len;					//信息长度
		unsigned int	color;					//信息颜色
		unsigned int	userid;					//发送用户
		unsigned int	touserid;				//目标用户
		char			chat[512];				//聊天信息
	};

	//举报结构
	struct CMD_FRAME_REPORT
	{
		unsigned int	userid[8];				//举报对象
		unsigned short	count;					//举报对象数目
		unsigned int	kind;					//举报类型
	};

	//踢人
	struct CMD_FRAME_KICKOUT
	{
		unsigned int	userid;
		unsigned int	touserid;
	};

	//踢人 Flag 0:OK 1:游戏已经开始 2.权限不够 3.道具不足 4.玩家不存在 5.对方版本过低
	struct CMD_FRAME_KICKOUT_RET
	{
		unsigned int	flag;
		unsigned int	userid;
		unsigned int	touserid;
	};

	//踢人
	struct CMD_FRAME_KICKOUT_NOTICE
	{
		unsigned int	userid;
		unsigned int	touserid;
	};

	//赞
	struct CMD_FRAME_PRAISE
	{
		unsigned int	userid;
		unsigned int	touserid;
	};

	//赞
	struct CMD_FRAME_PRAISE_RET
	{
		unsigned int	flag;
		unsigned int	userid;
		unsigned int	touserid;
	};

	//赞
	struct CMD_FRAME_PRAISE_NOTICE
	{
		unsigned int	userid;
		unsigned int	touserid;
	};

	//礼物
	struct CMD_FRAME_GIFT
	{
		unsigned int	userid;
		unsigned int	touserid;
		unsigned int	giftid;
		unsigned int	count;
	};

	//礼物
	struct CMD_FRAME_GIFT_RET
	{
		unsigned int	flag;
		unsigned int	userid;
		unsigned int	touserid;
		unsigned int	giftid;
		unsigned int	count;
	};

	//礼物
	struct CMD_FRAME_GIFT_NOTICE
	{
		unsigned int	userid;
		unsigned int	touserid;
		unsigned int	giftid;
		unsigned int	count;
	};
	//准备错误
	struct CMD_FRAME_READY_ERROR
	{
		int				flag;						//错误代码
		char			error[128];					//错误消息
	};

	//消息数据包
	struct CMD_FRAME_MESSAGE
	{
		unsigned short	type;
		unsigned short	len;
		char			message[1024];
	};
	//红包场局数
	struct CMD_REDPACKET_GAMEC
	{
		unsigned int	userid;
		unsigned int	finish_count;
		unsigned int	totle_count;
	};
	struct CMD_MINI_GAME_OPEN
	{
		int				int_id;
	};

	struct CMD_MINI_GAME_INFO
	{
		unsigned int	userid;
		int				int_tax;
		int				int_count;
		int				int_time;
		long long		int_gold;
	};

	struct CMD_MINI_GAME_ERROR
	{
		int				flag;
		char			error[1024];
	};

	struct CMD_MINI_GAME_SELECT
	{
		int				int_id;
	};

	struct CMD_MINI_GAME_RESULT
	{
		int				int_turn;
		int				int_total_turn;
		long long		int_gold;
		bool			bool_success;
	};

};