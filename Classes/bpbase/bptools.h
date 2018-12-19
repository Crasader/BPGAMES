#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "network/HttpClient.h"
#include "network/bpdownloader.h"
USING_NS_CC;
////////////////////////////////////////////////////////////////
#define PERMISSION_PHOTO                        1   // 相册权限
#define PERMISSION_MICROPHONE                   2   // 麦克风权限
#define PERMISSION_LOCATION                     3   // 定位权限
////////////////////////////////////////////////////////////////
#define HANDLE_TOOLS_GET_URL                    10    // 获取URL配置(安卓)
#define HANDLE_TOOLS_GET_USERDATA               11    // 获取用户数据(安卓)

#define HANDLE_TOOLS_CALLBACK_WXSHARE           21    // 微信分享回调(安卓/苹果/微软)
#define HANDLE_TOOLS_CALLBACK_WXAUTH            22    // 微信认证回调(安卓/苹果/微软)
#define HANDLE_TOOLS_CALLBACK_CREATE_IMAGE      23    // 创建图片回调(安卓/苹果/微软)
#define HANDLE_TOOLS_CALLBACK_LOGON				24    // 渠道登陆(安卓)
#define HANDLE_TOOLS_CALLBACK_LOGOUT			25    // 渠道登出(安卓)
#define HANDLE_TOOLS_CALLBACK_EXIT				26    // 渠道退出(安卓)

#define HANDLE_TOOLS_CALLBACK_GET_CLIPBOARD     31    // 获取粘贴板的回调(安卓)
////////////////////////////////////////////////////////////////
struct struct_tools_handle
{
    int            askid;
    int            id;
    int            param1;
    std::string param2;
};
////////////////////////////////////////////////////////////////

class bptools
{
public:
	static std::string	md5(std::vector<unsigned char> data);
	static std::string	md5_string(std::string data);
	static std::string	md5_file(std::string filename);
	static std::string	mac();
	static std::string	guid();
	static int			identifier();

	static std::string					base64_encode(std::vector<unsigned char> data);
	static std::vector<unsigned char>	base64_decode(std::string data);

	static std::string	url_encode(const std::string data);
	static std::string	url_decode(const std::string data);

	static std::string	utf2gbk(std::string data);
	static std::string	gbk2utf(std::string data, bool gbk = true);

	static std::vector<std::string>	string_split_key(std::string source, std::string key);
	static std::string				string_replace_key(std::string source, std::string key, std::string value);
	static bool			starts_with(std::string data, std::string start);
	static bool			ends_with(std::string data, std::string end);

	static bool			open_url(std::string url);
	static bool			show_url(std::string url);

	static void			set_clipboard_data(std::string data);
	static std::string	get_clipboard_data();

	static std::string	get_command_line();
    
    static bool         request_permission(int permission);

	static bool			create_image_data(int width, int height, std::function<void(unsigned int code, std::string filename)> callback);
	static void			record_sound_start(std::string filename, int handle);
	static std::string	record_sound_finish(int handle);

	static bool			get_wifi_status();
	static int			get_battery_status();
	static std::string	get_package_name();
	static bool			get_install_status(std::string package);

	static std::string	location();

	static void			play_music(std::string filename, bool loop);
	static void			stop_music();
	static int			play_effect(std::string filename, bool loop);
	static void			stop_effect(int handle);

	static bool         wechat_share_text(std::string unit, std::function<void(unsigned int code)> callback);
	static bool			wechat_share_image(std::string unit, std::function<void(unsigned int code)> callback);
	static bool			wechat_share_program(std::string unit, std::function<void(unsigned int code)> callback);
	static bool			wechat_auth(std::function<void(unsigned int code, std::string data)> callback);

	static bool			channel_init();
	static bool			channel_logon(std::string unit, std::function<void(unsigned int code, std::string data)> callback);
	static bool			channel_logout(std::string unit, std::function<void(unsigned int code, std::string data)> callback);
	static bool			channel_exit(std::string unit, std::function<void(unsigned int code, std::string data)> callback);

	static void			writelogs(int id, std::string format, ...);

	static int			get_rule_int(std::string rule, std::string params, std::string result);
	static long long	get_rule_longlong(std::string rule, std::string params, std::string result);
	static bool			get_rule_boolean(std::string rule, std::string params, std::string result);
	static std::string	get_rule_string(std::string rule, std::string params, std::string result);

	static void			update(float dt);
    static void         asyn_event(int askid, int id, int param1, std::string param2);
public:
    static std::mutex                       m_the_mutex;
    static std::list<struct_tools_handle>   m_list_asyn_event;
    static unsigned int                     m_int_record_time;
    static int                              m_int_record_handle;
    static std::string                      m_str_user_context;
    static std::map<int, std::string>       m_map_url;
    static std::function<void(unsigned int code, std::string filename)>     m_the_create_image_callback;
    static std::function<void(unsigned int code)>                           m_the_wxshare_callback;
    static std::function<void(unsigned int code, std::string data)>         m_the_wxauth_callback;
	static std::function<void(unsigned int code, std::string data)>			m_the_logout_callback;
	static std::function<void(unsigned int code, std::string data)>         m_the_logon_callback;
	static std::function<void(unsigned int code, std::string data)>         m_the_exit_callback;
};
////////////////////////////////////////////////////////////////
#define UTF8(data)				(bptools::gbk2utf(data, CC_TARGET_PLATFORM == CC_PLATFORM_WIN32).c_str())
#define GBK2UTF8(data)			(bptools::gbk2utf(data, true).c_str())
#define UTF82GBK(data)			(bptools::utf2gbk(data).c_str())
#define BPLOG(id, format, ...)	(bptools::writelogs(id, format, ##__VA_ARGS__))
////////////////////////////////////////////////////////////////
