#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "bpsocket.h"
USING_NS_CC;

////////////////////////////////////////////////////////////////
class bpsocketex;
class bksocketex_listener
{
public:
	virtual void on_socket_connect(bpsocketex* ptr_socket, int code) = 0;
	virtual void on_socket_receive(bpsocketex* ptr_socket, unsigned int main, unsigned int sub, const unsigned char* data, unsigned int size) = 0;
	virtual void on_socket_close(bpsocketex* ptr_socket, int code) = 0;
};
////////////////////////////////////////////////////////////////
class bpsocketex : public bksocket_listener
{
public:
	bpsocketex();
	virtual ~bpsocketex();
public:
	bool connect(std::string address, unsigned int port);
	bool isconnect();
	void close();
	int send(int main, int sub, unsigned char* bytes, int size);
	int pause();
	int restore();

	void update(float dt);
public:
	virtual void on_socket_connect(bpsocket* ptr_socket, int code);
	virtual void on_socket_receive(bpsocket* ptr_socket, const unsigned char* data, unsigned int size);
	virtual void on_socket_close(bpsocket* ptr_socket, int code);
public:
	void set_socket_listener(bksocketex_listener* ptr_listener);
private:
	bool encode(unsigned char data[], int size);
	bool decode(unsigned char data[], int size);
private:
	std::shared_ptr<bpsocket>					m_ptr_socket;
	std::vector<std::shared_ptr<bpsocket> >		m_vector_socket;
	bksocketex_listener*						m_ptr_listener;
	std::vector<unsigned char>					m_vector_receive_buffer;
	bool										m_bool_connect;
	unsigned int								m_int_send_count;
	unsigned int								m_int_recv_count;
};

