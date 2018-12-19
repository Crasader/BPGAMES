#pragma once
#include "GlobalDefine.h"
#pragma pack(push)
#pragma pack(1)
//////////////////////////////////////////////////////////////////////
namespace V20 {
	
	const unsigned int MDM_LOGON			= 9000;				// 主命令

	const unsigned int SUB_LOGON_FILE		= MDM_LOGON + 1;	// 请求文件
	const unsigned int SUB_LOGON_VERSION	= MDM_LOGON + 2;	// 请求版本
	const unsigned int SUB_LOGON_AUTH_MASK	= MDM_LOGON + 3;	// 请求登陆标记
	const unsigned int SUB_LOGON_MODULE_MASK= MDM_LOGON + 4;	// 请求功能标记
	const unsigned int SUB_LOGON_PAY_MASK	= MDM_LOGON + 5;	// 请求支付标记
	const unsigned int SUB_LOGON_CONTROL	= MDM_LOGON + 6;	// 请求控制标记

	const unsigned int SUB_LOGON_REGISTER	= MDM_LOGON + 10;	// 游客登陆
	const unsigned int SUB_LOGON_ACCOUNT	= MDM_LOGON + 11;	// 帐号登陆
	const unsigned int SUB_LOGON_PHONE		= MDM_LOGON + 12;	// 手机登陆
	const unsigned int SUB_LOGON_WECHAT		= MDM_LOGON + 13;	// 微信登陆
	const unsigned int SUB_LOGON_CHANNEL	= MDM_LOGON + 14;	// 渠道登陆
	const unsigned int SUB_LOGON_MINIWECHAT	= MDM_LOGON + 15;	// 微信小游戏登陆

	const unsigned int SUB_LOGON_FILE_RET			= MDM_LOGON + 101;	// 配置文件返回
	const unsigned int SUB_LOGON_FILE_START			= MDM_LOGON + 102;	// 配置文件开始
	const unsigned int SUB_LOGON_FILE_END			= MDM_LOGON + 103;	// 配置文件结束
	const unsigned int SUB_LOGON_FILE_FINISH		= MDM_LOGON + 104;	// 配置文件结束
	const unsigned int SUB_LOGON_VERSION_RET		= MDM_LOGON + 201;	// 请求版本返回
	const unsigned int SUB_LOGON_AUTH_MASK_RET		= MDM_LOGON + 202;	// 登陆标记返回
	const unsigned int SUB_LOGON_MODULE_MASK_RET	= MDM_LOGON + 203;	// 功能标记返回
	const unsigned int SUB_LOGON_PAY_MASK_RET		= MDM_LOGON + 204;	// 支付标记返回
	const unsigned int SUB_LOGON_GAMELIST_RET		= MDM_LOGON + 205;	// 游戏列表返回
	const unsigned int SUB_LOGON_ROUTE_RET			= MDM_LOGON + 206;	// 路由列表返回
	const unsigned int SUB_LOGON_MODULE_RET			= MDM_LOGON + 207;	// 模块列表返回
	const unsigned int SUB_LOGON_CONTROL_RET		= MDM_LOGON + 208;	// 控制信息返回
	const unsigned int SUB_LOGON_SUCCESS			= MDM_LOGON + 301;	// 登陆成功
	const unsigned int SUB_LOGON_ERROR				= MDM_LOGON + 302;	// 登陆失败
	const unsigned int SUB_LOGON_FINISH				= MDM_LOGON + 303;	// 登陆结束

	//////////////////////////////////////////////////////////////////////
	//配置文件
	const unsigned int ID_LOGON_FILE_COMMON		= 0;	// 通用配置文件
	const unsigned int ID_LOGON_FILE_CHANNEL	= 1;	// 渠道配置文件
	const unsigned int ID_LOGON_FILE_GAMELIST	= 2;	// 列表配置文件

	//请求文件
	struct CMD_LOGON_FILE
	{
		CMD_BASE_INFO2	base;					// 基础信息
		char			md5[3][MD5_LEN];		// md5
	};

	//配置文件开始
	struct CMD_LOGON_FILE_START
	{
		unsigned int	file;
	};

	//配置文件结束
	struct CMD_LOGON_FILE_END
	{
		unsigned int	file;
	};

	struct CMD_LOGON_FILE_RET
	{
		unsigned int	file;
		unsigned int	len;
		unsigned char	data[1024];
	};

	//请求版本
	struct CMD_LOGON_VERSION
	{
		CMD_BASE_INFO2	base;					// 基础信息
	};

	//请求版本
	struct CMD_LOGON_VERSION_RET
	{
		int				min;					// 最小版本
		int				cur;					// 当前版本
		int				max;					// 最大版本
		char			ext[1024];				// 扩展信息{"hints":"有新的玩法，是否更新？","url":"https://www.baidu.com/demo.apk"}
	};

	const unsigned int MASK_VERSION_CHECK	= 0x00000001;		// 审核版本
	const unsigned int MASK_VERSION_NEW		= 0x00000002;		// 最新版本
	const unsigned int MASK_VERSION_OLD		= 0x00000004;		// 老旧版本

	const unsigned int MASK_VERSION_PLUGINS = 0x00000001;		// 插件版本
	const unsigned int MASK_VERSION_FULL	= 0x00000002;		// 完整版本

	//登陆标记位
	const unsigned int MASK_AUTH_REGISTER		= 0x00000001;	// 游客登陆
	const unsigned int MASK_AUTH_ACCOUNT		= 0x00000002;	// 帐号登陆
	const unsigned int MASK_AUTH_PHONE			= 0x00000004;	// 手机登陆
	const unsigned int MASK_AUTH_WECHAT			= 0x00000008;	// 微信登陆
	const unsigned int MASK_AUTH_CHANNEL		= 0x00000010;	// 渠道登陆

	//功能标记位
	const unsigned int MASK_MODULE_BIND_PHONE	= 0x00000001;	// 手机绑定功能
	const unsigned int MASK_MODULE_BIND_WECHAT	= 0x00000002;	// 微信绑定功能
	const unsigned int MASK_MODULE_SHARE_WECHAT = 0x00000004;	// 微信分享
	const unsigned int MASK_MODULE_AUCTION		= 0x00000008;	// 拍卖行功能
	const unsigned int MASK_MODULE_PUSH			= 0x00000010;	// 喇叭消息功能
	const unsigned int MASK_MODULE_GAMELIST		= 0x00000020;	// 游戏列表功能
	const unsigned int MASK_MODULE_MINIGAME		= 0x00000040;	// 小游戏功能
	const unsigned int MASK_MODULE_RANKING		= 0x00000080;	// 排行榜功能
	const unsigned int MASK_MODULE_EXCHANGE		= 0x00000100;	// 兑换功能
	const unsigned int MASK_MODULE_MOREGAME		= 0x00000200;	// 更多游戏功能
	const unsigned int MASK_MODULE_SHOP			= 0x00000400;	// 商城功能
	const unsigned int MASK_MODULE_NOTICE		= 0x00000800;	// 公告功能
	const unsigned int MASK_MODULE_SIGN			= 0x00001000;	// 签到功能
	const unsigned int MASK_MODULE_ACTIVITY		= 0x00002000;	// 活动功能
	const unsigned int MASK_MODULE_INTRODUCER	= 0x00004000;	// 推荐功能
	const unsigned int MASK_MODULE_CUSTOMER		= 0x00008000;	// 客服功能
	const unsigned int MASK_MODULE_TASKS		= 0x00010000;	// 任务功能
	const unsigned int MASK_MODULE_BANK			= 0x00020000;	// 银行功能
	const unsigned int MASK_MODULE_UPDATE_GUIDE	= 0x00040000;	// 更新引导
	const unsigned int MASK_MODULE_ASSESS_GUIDE	= 0x00080000;	// 评价引导
	const unsigned int MASK_MODULE_AUTHENTICATION=0x00100000;	// 实名认证
	const unsigned int MASK_MODULE_SYSTEM_PUSH	= 0x00200000;	// 系统消息
	const unsigned int MASK_MODULE_VIP			= 0x00400000;	// VIP
	const unsigned int MASK_MODULE_NEWPLAYER_PACK = 0x00800000;	// 新手礼包
	const unsigned int MASK_MODULE_BEANS		= 0x01000000;	// 金豆商城管控
	const unsigned int MASK_MODULE_REDPACKET	= 0x02000000;	// 红包管控
	const unsigned int MASK_MODULE_AUTO_LUCK	= 0x04000000;	// 自动弹出
	const unsigned int MASK_MODULE_GUIDE		= 0x08000000;	// 引导

	//支付标记位
	const unsigned int MASK_PAY_ALIPAY			= 0x00000002;	// 支付宝支付
	const unsigned int MASK_PAY_MANUALPAY		= 0x00000008;	// 人工充值
	const unsigned int MASK_PAY_WEIXINPAY		= 0x00000200;	// 微信支付
	const unsigned int MASK_PAY_CHANNELPAY		= 0x10000000;	// 渠道支付

	//请求标记
	struct CMD_LOGON_MASK
	{
		CMD_BASE_INFO2	base;					// 基础信息
		unsigned int	code;					// 版本标记
	};

	//请求标记返回
	struct CMD_LOGON_MASK_RET
	{
		unsigned int	mask;					// 标记位
	};

	//请求控制信息
	struct CMD_LOGON_CONTROL
	{
		CMD_BASE_INFO2	base;					// 基础信息
		unsigned int	code;					// 版本标记
		int				userid;					// 用户ID
		char			mac[MAC_LEN];			// mac
	};

	//控制信息返回
	struct CMD_LOGON_CONTROL_RET
	{
		char			data[1024];			// 信息
	};

	//游客登陆
	struct CMD_LOGON_REGISTER
	{
		CMD_BASE_INFO2	base;					// 基础信息
		char			mac[MAC_LEN];			// mac
	};

	//帐号登陆
	struct CMD_LOGON_ACCOUNT
	{
		CMD_BASE_INFO2	base;					// 基础信息
		char			account[NAME_LEN];		// 帐号
		char			password[PASS_LEN];		// 密码(md5)
		char			mac[MAC_LEN];			// mac
	};

	//手机登陆
	struct CMD_LOGON_PHONE
	{
		CMD_BASE_INFO2	base;					// 基础信息
		char			phone[MOBILE_LEN];		// 手机号码
		char			code[MOBILE_LEN];		// 效验码
		char			mac[MAC_LEN];			// mac
	};

	//微信登陆
	struct CMD_LOGON_WECHAT
	{
		CMD_BASE_INFO2	base;					// 基础信息
		char			appid[SESSION_LEN];		// 微信appid
		char			code[SESSION_LEN];		// 微信code
		char			mac[MAC_LEN];			// mac
	};

	//微信小程序登陆
	struct CMD_LOGON_MINIWECHAT
	{
		CMD_BASE_INFO2	base;					// 基础信息
		char			appid[SESSION_LEN];		// 微信appid
		char			mac[MAC_LEN];			// mac
		char			code[1024];				// 数据
	};

	//渠道登陆
	struct CMD_LOGON_CHANNEL
	{
		CMD_BASE_INFO2	base;					// 基础信息
		char			appid[SESSION_LEN];		// appid
		char			account[NAME_LEN];		// 用户帐号
		char			password[PASS_LEN];		// 用户密码
		char			mac[MAC_LEN];			// mac	
		char			code[1024];				// code
	};

	//登陆成功
	struct CMD_LOGON_SUCCESS
	{
		unsigned char	sex;						// 用户性别
		unsigned char	member;						// 会员等级
		unsigned short	face;						// 头像索引
		unsigned int	userid;						// 用户ID
		char			account[NAME_LEN];			// 用户帐号
		char			password[PASS_LEN];			// 用户密码
		char			nickname[NAME_LEN];			// 用户昵称
		char			session[SESSION_LEN];		// SESSION
		char			phone[MOBILE_LEN];			// 用户手机
		unsigned int	ingame;						// 位置信息
		unsigned int	experience;					// 用户经验
		unsigned int	userright;					// 用户等级
		unsigned int	masterright;				// 管理权限
		long long		gold;						// 金币
		unsigned int	ingot;						// 元宝数量
		unsigned int	charm;						// 魅力数量
		long long		praise;						// 赞数量
		unsigned short	pay;						// 总充值额
		unsigned int	servertime;					// 服务器时间
		unsigned int	logoncount;					// 登陆次数
		unsigned int	gametime;					// 游戏时间
		unsigned int    beans;						// 金豆
		unsigned int	redpacket;					// 红包
		unsigned int    awardTimes;					// 可用救济金次数
		unsigned int    beanTimes;					// 可用救济金豆次数
		long long		bank;						// 银行金币
		unsigned int	reserve[4];					// 预留字段
		char			ext[2048];					// 扩展信息(道具，状态)
	};

	//登陆失败
	struct CMD_LOGON_ERROR
	{
		int				flag;						// 错误代码
		char			error[128];					// 错误消息
	};

};

//////////////////////////////////////////////////////////////////////////
#pragma pack(pop)