#pragma once

#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"

USING_NS_CC;
using namespace cocos2d::ui;

class BPLogonAccount : public Layout
{
public:
	static void ShowLogonAccount(
		std::string account, 
		std::string password,
		std::function<void(std::string account, std::string password)> callback);
public:
	BPLogonAccount();
	virtual ~BPLogonAccount();
public:
	virtual bool init();
public:
	void show_logon_account(
		std::string account, 
		std::string password,
		std::function<void(std::string account, std::string password)> callback);
public:
	void on_btn_logon(Ref* sender, Widget::TouchEventType type);
	void on_btn_close(Ref* sender, Widget::TouchEventType type);
	void on_btn_forget(Ref* sender, Widget::TouchEventType type);
	void on_action_open_finish();
	void on_action_close_finish();
private:
	std::string		m_str_account;
	std::string		m_str_password;
private:
	ImageView *		m_ptr_gui_back;
	ImageView*		m_ptr_gui;

	Button*			m_ptr_btn_close;
	Button*			m_ptr_btn_logon;
	Button*			m_ptr_btn_forget;

	EditBox*		m_ptr_edit_account;
	EditBox*		m_ptr_edit_password;

	bool			m_bool_logon;
private:
	std::function<void(std::string account, std::string password)> m_fun_callback;
};
