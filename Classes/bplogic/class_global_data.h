#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"
USING_NS_CC;
using namespace cocos2d::ui;

#include "bpprotocol/GlobalDefine.h"
#include "bpprotocol/ClientDefine.h"
#include "bpprotocol/GlobalProp.h"
#include "bpprotocol/GlobalRight.h"

////////////////////////////////////////////////////////////////
#define NOTICE_UPDATE_USER_DATA		"NOTICE_UPDATE_USER_DATA"		// 刷新信息
////////////////////////////////////////////////////////////////

class class_global_data
{
public:
	class_global_data();
	virtual ~class_global_data();
public:
	void init();
	void update(float dt);
	void asyn();
public:
	/////////////////////////////////////////////////////////
	std::string		get_logon_address();
	std::string		get_auxi_address();
	std::string		get_push_address();
	std::string		get_route_address();
	/////////////////////////////////////////////////////////
	void			get_local_account(std::string &account, std::string &password);
	void			set_local_account(std::string account, std::string password);
	/////////////////////////////////////////////////////////
	void			init_static_text();
	std::string		get_static_text(int id);
	void			init_resource_text();
	std::string		get_resource_text(int id);
	/////////////////////////////////////////////////////////
	std::string		get_common_text(int id);
	bool			get_prop_data(int id, struct_prop_data &prop);
	bool			get_prop_status_data(int id, struct_prop_data &prop);
	std::string		get_url(int id);
	std::string		make_url(std::string url);
	std::string		make_url(int id);
	/////////////////////////////////////////////////////////
	std::string		get_local_text(int id);
	void			get_module_data(std::vector<struct_module_data> &module);
	bool			get_module_data(int id, struct_module_data &module);
	bool			have_module_data(int id);
	bool			get_product_data(std::string id, struct_product_data &product);
	/////////////////////////////////////////////////////////
	void			get_game_data(std::vector<struct_game_data> &game);
	bool			get_game_data(int id, struct_game_data &game);

	void			get_room_data(std::vector<struct_room_data> &room);
	bool			get_room_data(int id, struct_room_data &room);
	void			get_room_data(int id, std::vector<struct_room_data> &room);

	bool			get_friendsite_data(int id, struct_friend_site_data &site);
	/////////////////////////////////////////////////////////
	int				get_min_version();
	int				get_cur_version();
	int				get_max_version();
	int				get_module_version(int id);
	bool			is_newest_version();
	bool			is_check_version();
	/////////////////////////////////////////////////////////
	bool			have_mask_auth(unsigned int mask);
	bool			have_mask_module(unsigned int mask);
	bool			have_mask_pay(unsigned int mask);
	/////////////////////////////////////////////////////////
	const struct_wechat_data		get_wechat_data();
	void							set_wechat_data(struct_wechat_data data);
	const struct_umeng_data			get_umeng_data();
	void							set_umeng_data(struct_umeng_data data);
	const struct_channel_data		get_channel_data();
	void							set_channel_data(struct_channel_data data);
	const struct_update_data		get_update_data();
	void							set_update_data(struct_update_data data);
	const CMD_BASE_INFO2			get_base_info();
	void							set_base_info(CMD_BASE_INFO2 data);
	/////////////////////////////////////////////////////////
	const struct_global_user_data	get_self_user_data();
	void							set_self_user_data(struct_global_user_data userdata);
	unsigned int					get_self_prop_count(int id);
	unsigned int					get_self_prop_status(int id);
	unsigned int					get_self_right();
	bool							have_self_right(unsigned int right);

	void							set_self_prop_count(int id, unsigned int count);
	void							set_self_prop_status(int id, unsigned int count);
	void							set_self_gold(long long gold);
	void							set_self_ingot(int ingot);
	void							set_self_charm(int charm);
	void							set_self_bean(int bean);
	void							set_self_redpacket(int redpack);
	void							set_self_right(unsigned int right);
	/////////////////////////////////////////////////////////
	void							update_user_data(bool request = false);
	/////////////////////////////////////////////////////////
	void							application_run(int id, std::string param = "");
	void							application_run_fast(int id, std::string param = "");
	int								application_run_status(int id);
	int								application_run_handle(int id);
	void							application_signal(int id, int to, std::string param_1 = "", std::string param_2 = "");
	void							application_destory(int id);
	void							application_destory_fast(int id);
	bool							application_install(int id);
	void							application_remove();
	/////////////////////////////////////////////////////////
	void							set_auto_logon(bool logon);
	bool							get_auto_logon();
	/////////////////////////////////////////////////////////
	void							set_save_value(std::string key, std::string value, int expire);
	std::string						get_save_value(std::string key, std::string defult);
	void							set_temp_value(std::string key, std::string value);
	std::string						get_temp_value(std::string key, std::string defult);
	/////////////////////////////////////////////////////////
	Layout*							get_main_layout();
	void							set_main_layout(Layout* layout);
	int								get_curr_scene();
	void							set_curr_scene(int scene);
	/////////////////////////////////////////////////////////
	std::string						get_full_filename(int appid, std::string filename);
	std::string						get_temp_filename(std::string filename);
	/////////////////////////////////////////////////////////
	void							exit(bool logon);
	/////////////////////////////////////////////////////////
public:
	std::string									m_str_logon_address;
	std::string									m_str_push_address;
	std::string									m_str_route_address;

	std::map<int, std::string>					m_map_static_text;
	std::map<int, std::string>					m_map_resource_text;

	// 0.zip
	std::map<int, std::string>					m_map_common_text;
	std::map<int, struct_prop_data>				m_map_prop;
	std::map<int, struct_prop_data>				m_map_prop_status;
	std::map<int, std::string>					m_map_url;

	// 1.zip
	std::map<int, std::string>					m_map_local_text;
	std::map<int, struct_module_data>			m_map_module;
	std::map<std::string, struct_product_data>	m_map_product_gold;
	std::map<std::string, struct_product_data>	m_map_product_ingot;
	std::map<std::string, struct_product_data>	m_map_product_bean;
	std::map<std::string, struct_product_data>	m_map_product_first;
	std::vector<struct_list_data>				m_vector_game_list;

	// 2.zip
	std::map<int, struct_game_data>				m_map_game;
	std::map<int, struct_room_data>				m_map_room;
	std::map<int, struct_friend_site_data>		m_map_friend_site;

	// 更新
	int											m_int_min_version;
	int											m_int_cur_version;
	int											m_int_max_version;

	// 管控
	unsigned int								m_int_auth_mask;
	unsigned int								m_int_module_mask;
	unsigned int								m_int_pay_mask;

	std::map<int, unsigned int>					m_map_user_prop;
	std::map<int, unsigned int>					m_map_user_prop_status;
	// 当前主背景
	Layout*										m_ptr_main_layout;
	int											m_int_curr_scene;
	// 自动登录标记
	bool										m_bool_auto_logon;

	std::map<int, std::string>					m_map_application;
	std::list<int>								m_list_return_application;
	std::map<std::string, std::string>			m_map_temp_value;
private:
	struct_global_user_data						m_the_user_data;
	struct_wechat_data							m_the_wechat_data;
	struct_umeng_data							m_the_umeng_data;
	struct_channel_data							m_the_channel_data;
	struct_update_data							m_the_update_data;
	CMD_BASE_INFO2								m_the_base_info;
public:
	std::string									m_str_defult_logon_address;
	std::string									m_str_defult_account;
	std::string									m_str_defult_password;
	std::string									m_str_defult_packagename;
};

extern class_global_data* get_share_global_data();