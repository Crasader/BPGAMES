#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
USING_NS_CC;
////////////////////////////////////////////////////////////////

//连接事件
#define BP_SOCKET_EVENT_NULL			0	// 无事件
#define BP_SOCKET_EVENT_CONNECT_SUCCESS	10	// 连接事件
#define BP_SOCKET_EVENT_CONNECT_FAIL	11	// 连接事件
#define BP_SOCKET_EVENT_RECEIVE			20	// 数据事件
#define BP_SOCKET_EVENT_CLOSE			30	// 断开事件
////////////////////////////////////////////////////////////////

//连接状态
#define BP_SOCKET_STATUS_NULL		0		// 无连接
#define BP_SOCKET_STATUS_CONNECTING	1		// 正在连接
#define BP_SOCKET_STATUS_CONNECTED	2		// 连接中

////////////////////////////////////////////////////////////////
class bpsocket;
class bksocket_listener
{
public:
	virtual void on_socket_connect(bpsocket* ptr_socket, int code) = 0;
	virtual void on_socket_receive(bpsocket* ptr_socket, const unsigned char* data, unsigned int size) = 0;
	virtual void on_socket_close(bpsocket* ptr_socket, int code) = 0;
};
////////////////////////////////////////////////////////////////
class bpsocket_unit
{
public:
	bpsocket_unit();
	virtual ~bpsocket_unit();
public:
	void push_event(int event);
	int  pop_event();
public:
	void set_socket_status(int status);
	int  get_socket_status();
public:
	int	 write_socket_buffer(unsigned char* buffer, int size);
	void read_socket_buffer(std::vector<unsigned char> &buffer);
public:
	unsigned int				m_the_socket;
	std::mutex					m_the_mutex;
	std::list<int>				m_list_socket_event;
	int							m_int_socket_status;
	std::vector<unsigned char>	m_vector_socket_buffer;
	bool						m_bool_wait_exit;
};
////////////////////////////////////////////////////////////////
class bpsocket
{
public:
	bpsocket();
	virtual ~bpsocket();
public:
	bool connect(std::string address, unsigned int port);
	void close();
	int  send(unsigned char* bytes, int size);
	void update();
	int pause();
	int restore();
public:
	void set_socket_listener(bksocket_listener* ptr_listener);
private:
	std::shared_ptr<bpsocket_unit>	m_ptr_unit;
	std::vector<unsigned char>		m_vector_socket_buffer;
	bksocket_listener*				m_ptr_listener;
	unsigned int					m_int_index;
};

