#pragma once
#include <string>
#include <map>
//////////////////////////////////////////////////////////////////////////
#define BPSTATUS_APPLICATION_NULL		0		// 未启动
#define BPSTATUS_APPLICATION_RUNNED		1		// 运行中
#define BPSTATUS_APPLICATION_RUNNING	2		// 正在启动
#define BPSTATUS_APPLICATION_DESTORYING	3		// 正在销毁
//////////////////////////////////////////////////////////////////////////
#define BPSCENE_LOGON					0		// 登陆场景
#define BPSCENE_LOBBY					1		// 大厅场景
//////////////////////////////////////////////////////////////////////////
// 用户数据
struct struct_global_user_data
{
	int					int_user_id;			// 用户ID
	std::string			str_account;			// 登录帐号
	std::string			str_nickname;			// 登录帐号
	std::string			str_password;			// 登录密码
	unsigned int		int_user_right;			// 用户权限
	long long			int_gold;				// 用户金币
	long long			int_ingot;				// 用户元宝
	long long			int_charm;				// 用户魅力
	int					int_vip_id;				// 会员ID
	int					int_logon_count;		// 登陆次数
	int					int_pay_count;			// 充值额度
	int					int_experience;			// 用户经验
	int					int_face_id;			// 头像索引
	int					int_sex;				// 用户性别
	std::string			str_phone;				// 绑定手机
	int					int_praise;				// 用户赞的数据
	std::string			str_session;			// session
	unsigned int		int_master_right;		// 管理权限
	unsigned int		int_game_time;			// 游戏时间
	unsigned int		int_beans;				// 金豆
	unsigned int		int_redpacket;			// 红包
	unsigned int		int_relief_gold;		// 可用救济金次数
	unsigned int		int_relief_beans;		// 可用救济金豆次数
	long long			int_bank;				// 银行金币
	unsigned int		int_ingame;				// 位置信息
	struct_global_user_data()
	{
		int_user_id = 0;
		str_account = "";
		str_nickname = "";
		str_password = "";
		int_user_right = 0;
		int_gold = 0;
		int_ingot = 0;
		int_pay_count = 0;
		int_charm = 0;
		int_vip_id = 0;
		int_experience = 0;
		int_face_id = 0;
		int_sex = 0;
		str_phone = "";
		int_praise = 0;
		str_session = "";
		int_master_right = 0;
		int_game_time = 0;
		int_logon_count = 0;
		int_ingame = 0;
		int_redpacket = 0;
		int_beans = 0;
		int_relief_gold = 0;
		int_relief_beans = 0;
		int_bank = 0;
	}
};

// 游戏
struct struct_game_data
{
	int					int_game_id;
	std::string			str_name;
	std::string			str_describe;
	struct_game_data()
	{
		int_game_id = 0;
		str_name = "";
		str_describe = "";
	}
};

// 房间
struct struct_room_data
{
	int					int_id;
	int					int_game_id;			// 游戏ID
	int					int_room_id;			// 房间号码
	std::string			str_name;				// 房间名称
	std::string			str_address;			// 房间地址
	int					int_port;				// 房间端口
	int					int_room_mode;			// 房间模式 正常，比赛
	int					int_room_kind;			// 房间类型 分数，财富
	std::map<int, int>	map_limit;				// 进入条件
	std::string			str_rule;				// 房间规则
	int					int_table_count;		// 桌子数目
	int					int_chair_count;		// 椅子数目
	struct_room_data()
	{
		int_id = 0;
		int_room_id = 0;
		str_name = "";
		str_address = "";
		int_port = 0;
		int_game_id = 0;
		int_room_mode = 0;
		int_room_kind = 0;
		map_limit.clear();
		str_rule = "";
		int_table_count = 0;
		int_chair_count = 0;
	}
};

// 站点
struct struct_site_data
{
	int					int_id;
	std::string			str_name;				// 房间名称
	int					int_online_count;		// 在线人数
	int					int_game_id;			// 游戏ID
	int					int_room_mode;			// 房间模式 正常，比赛
	int					int_room_kind;			// 房间类型 分数，财富
	std::string			str_limit;				// 进入条件
	std::string			str_rule;				// 房间规则
	int					int_game_genre;			// 游戏类型
	int					int_game_version;		// 游戏版本
	struct_site_data()
	{
		int_id = 0;
		str_name = "";
		int_online_count = 0;
		int_game_id = 0;
		int_room_mode = 0;
		int_room_kind = 0;
		str_limit = "";
		str_rule = "";
		int_game_genre = 0;
		int_game_version = 0;
	}
};

// 商品
struct struct_product_data
{
	std::string			str_product_id;		// 商品id
	std::string			str_product_name;	// 商品名称
	std::string			str_product_caption;// 商品附标题
	std::string			str_product_describe;// 商品描述
	int					int_price;			// 商品价格(单位：元)
	int					int_icon;			// 图标索引
	int					int_type;			// 商品类型
	int					int_mask;			// 商品标示
	int					int_option;			// 支付类型（支持的支付方式）
	std::map<int, int>	map_param;			// 商品描述([{"id":1,"cnt":1000},{"id":2,"cnt":1000}])
	struct_product_data()
	{
		str_product_id = "";
		str_product_name = "";
		str_product_caption = "";
		str_product_describe = "";
		int_price = 0;
		int_icon = 0;
		int_type = 0;
		int_mask = 0;
		int_option = 0;
		map_param.clear();
	}
};

// 时效
struct struct_prop_data
{
	int					int_id;			// 道具ID
	std::string			str_name;		// 道具名称
	std::string			str_describe;	// 道具描述
	int					int_type;		// 道具类型
	int					int_mask;		// 道具标记

	struct_prop_data()
	{
		int_id = 0;
		str_name = "";
		str_describe = "";
		int_type = 0;
		int_mask = 0;
	}
};

// 地址信息
struct struct_address_data
{
	std::string			str_address;	// 地址
	int					int_port;		// 端口
	struct_address_data()
	{
		str_address = "";
		int_port = 0;
	}
};

// 地址信息
struct struct_list_data
{
	int					int_id;			// ID
	std::vector<int>	vector_list;	// 列表
	struct_list_data()
	{
		int_id = 0;
		vector_list.clear();
	}
};

#define MASK_MODULE_AUTO_INSTALL			0x00000001		// 自动安装
#define MASK_MODULE_AUTO_RUN				0x00000002		// 自动运行
#define MASK_MODULE_RETURN					0x00000004		// 返回事件
#define MASK_MODULE_CRASH_RESTART			0x00000008		// 崩溃后重启
#define MASK_MODULE_CRASH_EXIT				0x00000010		// 崩溃后退出
#define MASK_MODULE_CRASH_IGNORE			0x00000020		// 崩溃后忽略
// 模块信息
struct struct_module_data
{
	int					int_id;
	std::string			str_name;
	std::string			str_describe;
	int					int_version;
	unsigned int		int_mask;
	struct_module_data()
	{
		int_id = 0;
		str_name = "";
		int_version = 0;
		int_mask = 0;
		str_describe = "";
	}
};

struct struct_friend_create_item
{
	int			int_id;
	int			int_kind;
	int			int_kind_count;
	int			int_prop;
	int			int_prop_count;
	std::string str_describe;

	struct_friend_create_item()
	{
		int_id = 0;
		int_kind = 0;
		int_kind_count = 0;
		int_prop = 0;
		int_prop_count = 0;
		str_describe = "";
	}
};

struct struct_friend_site_item
{
	int				int_kind;
	std::string		str_name;
	std::string		str_describe;
	std::vector<struct_friend_create_item> vector_item;

	struct_friend_site_item()
	{
		int_kind = 0;
		str_name = "";
		str_describe = "";
		vector_item.clear();
	}
};

struct struct_friend_site_data
{
	int				int_game_id;
	int				int_expire;
	std::string		str_name;
	std::vector<struct_friend_site_item> vector_item;

	struct_friend_site_data()
	{
		int_game_id = 0;
		int_expire = 0;
		str_name = "";
		vector_item.clear();
	}
};

struct struct_wechat_data
{
	std::string		str_appid;

	struct_wechat_data()
	{
		str_appid = "";
	}
};

struct struct_umeng_data
{
	std::string		str_appid;

	struct_umeng_data()
	{
		str_appid = "";
	}
};

struct struct_channel_data
{
	std::string		str_appid;
	std::string		str_appkey;
	std::string		str_payid;
	std::string		str_paykey;
	struct_channel_data()
	{
		str_appid = "";
		str_appkey = "";
		str_payid = "";
		str_paykey = "";
	}
};

struct struct_update_data
{
	std::string		str_url;
	std::string		str_hints;
	struct_update_data()
	{
		str_url = "";
		str_hints = "";
	}
};