#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "network/HttpClient.h"
USING_NS_CC;

#define PAYMENT_KIND_ALIPAY			11
#define PAYMENT_KIND_WECHAT			12
#define PAYMENT_KIND_CHANNEL		13
////////////////////////////////////////////////////////////////
struct struct_payment
{
	std::string str_proudct_id;
	std::string str_proudct_name;
	std::string str_proudct_describe;
	int			int_proudct_price;
	int			int_pay_kind;
	std::string str_param1;
	std::string str_param2;
};

////////////////////////////////////////////////////////////////
class class_payment
{
public:
	class_payment();
	virtual ~class_payment();
public:
	static class_payment* getInstance();
	static void update(float dt);
public:
	void pay(struct_payment payment, std::function<void(const struct_payment payment, unsigned int code)> callback);
private:
	void work(std::string order);
public:
	static struct_payment	m_the_payment;
	static std::string		m_str_orderid;
	static std::function<void(const struct_payment payment, unsigned int code)> m_the_callback;
};

////////////////////////////////////////////////////////////////