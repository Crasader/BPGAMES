#pragma once

#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"
#include "network/HttpClient.h"

USING_NS_CC;
using namespace cocos2d::ui;
using namespace cocos2d::network;

class BPLogonPhone : public Layout
{
public:
	static void ShowLogonPhone(
		std::string phone, 
		std::function<void(std::string phone, std::string code)> callback);
public:
	BPLogonPhone();
	virtual ~BPLogonPhone();
public:
	virtual bool init();
public:
	void show_logon_phone(
		std::string phone,
		std::function<void(std::string phone, std::string code)> callback);
public:
	void on_btn_logon(Ref* sender, Widget::TouchEventType type);
	void on_btn_close(Ref* sender, Widget::TouchEventType type);
	void on_btn_code(Ref* sender, Widget::TouchEventType type);
	void on_action_open_finish();
	void on_action_close_finish();
	void on_http_code(HttpClient *sender, HttpResponse *response);
private:
	std::string		m_str_phone;
	std::string		m_str_code;
private:
	ImageView *		m_ptr_gui_back;
	ImageView*		m_ptr_gui;

	Button*			m_ptr_btn_close;
	Button*			m_ptr_btn_logon;
	Button*			m_ptr_btn_code;

	EditBox*		m_ptr_edit_phone;
	EditBox*		m_ptr_edit_code;

	bool			m_bool_logon;
private:
	std::function<void(std::string phone, std::string code)> m_fun_callback;
};
