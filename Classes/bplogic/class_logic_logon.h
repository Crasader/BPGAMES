#pragma once
#include "bpbase/bpsocketex.h"
////////////////////////////////////////////////////////////////
typedef std::function<bool(int, int, std::string)> BPLogonListener;
#define BP_LOGON_LISTENER(__selector__,__target__, ...) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3)
////////////////////////////////////////////////////////////////
#define LOGON_ACTION_NULL					0	// 无
#define LOGON_ACTION_CONFIG					10	// 收到配置信息	param1:成功[0] 失败[非0]		param2:失败原因
#define LOGON_ACTION_VERSION				20	// 收到版本信息 param1:成功[0] 失败[非0]		param2:失败原因
#define LOGON_ACTION_CONTROL_AUTH			30	// 收到认证管控 param1:成功[0] 失败[非0]		param2:失败原因
#define LOGON_ACTION_AUTH					40	// 收到认证结果 param1:成功[0] 失败[非0]		param2:失败原因
#define LOGON_ACTION_CONTROL				50	// 收到模块管控 param1:成功[0] 失败[非0]		param2:失败原因
#define LOGON_ACTION_UPDATE					60	// 收到更新信息 param1:进度[百分比]				param2:失败原因（无需goon）
#define LOGON_ACTION_FINISH					70	// 收到登陆结束 param1:成功[0] 失败[非0]		param2:失败原因
////////////////////////////////////////////////////////////////

#define AUTH_ACTION_REGISTER				1	// 游客登录
#define AUTH_ACTION_ACCOUNT					2	// 账号登陆
#define AUTH_ACTION_WECHAT					3	// 微信登陆
#define AUTH_ACTION_PHONE					4	// 手机登陆
#define AUTH_ACTION_CHANNEL					5	// 渠道登陆
////////////////////////////////////////////////////////////////
class class_logic_logon : public bksocketex_listener
{
public:
	class_logic_logon();
	virtual ~class_logic_logon();
public:
	bool start();
	bool goon();
	bool reset();
	void listener(const BPLogonListener& listener);
public:
	void param(int nparam1, int nparam2, std::string sparam1, std::string sparam2);
public:
	virtual void on_socket_connect(bpsocketex* ptr_socket, int code);
	virtual void on_socket_receive(bpsocketex* ptr_socket, unsigned int main, unsigned int sub, const unsigned char* data, unsigned int size);
	virtual void on_socket_close(bpsocketex* ptr_socket, int code);
public:
	bool on_socket_file_start(const unsigned char* data, unsigned int size);
	bool on_socket_file_end(const unsigned char* data, unsigned int size);
	bool on_socket_file_ret(const unsigned char* data, unsigned int size);
	bool on_socket_file_finish(const unsigned char* data, unsigned int size);
	bool on_socket_version_ret(const unsigned char* data, unsigned int size);
	bool on_socket_mask_auth(const unsigned char* data, unsigned int size);
	bool on_socket_mask_control(const unsigned char* data, unsigned int size);
	bool on_socket_auth_success(const unsigned char* data, unsigned int size);
	bool on_socket_auth_fail(const unsigned char* data, unsigned int size);
private:
	void step(int action);
	void success();
	void fail();
private:
	std::map<int, FILE*>	m_map_files;
	bpsocketex				m_the_socket;
	BPLogonListener			m_the_listener;
private:
	int						m_int_param1;
	int						m_int_param2;
	std::string				m_str_param1;
	std::string				m_str_param2;
private:
	unsigned int			m_int_step;
	int						m_int_code;
	std::string				m_str_message;
	bool					m_bool_working;
	bool					m_bool_update_success;
	std::map<int, int>		m_map_updateing;
};