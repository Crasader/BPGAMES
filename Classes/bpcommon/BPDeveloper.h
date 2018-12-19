#pragma once

#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"
#include "network/bpdownloader.h"

USING_NS_CC;
using namespace cocos2d::ui;

class BPDeveloper : public Layout
{
public:
	static void ShowDeveloper(std::function<void()> callback);
public:
	BPDeveloper();
	virtual ~BPDeveloper();
public:
	virtual bool init();
public:
	void show_developer(std::function<void()> callback);
public:
	void on_btn_cancel(Ref* sender, Widget::TouchEventType type);
	void on_btn_ok(Ref* sender, Widget::TouchEventType type);
	void on_action_open_finish();
	void on_action_close_finish();
private:
	ImageView *		m_ptr_gui_back;
	ImageView*		m_ptr_gui;

	Button*			m_ptr_btn_close;
	Button*			m_ptr_btn_cancel;
	Button*			m_ptr_btn_ok;

	Label*			m_ptr_label_appid;
	Label*			m_ptr_label_channcel;
	Label*			m_ptr_label_packageid;
	Label*			m_ptr_label_keyword;
	Label*			m_ptr_label_packagename;
	Label*			m_ptr_label_mac;

	EditBox*		m_ptr_edit_version;
	EditBox*		m_ptr_edit_address;
	EditBox*		m_ptr_edit_account;
	EditBox*		m_ptr_edit_password;

private:
	std::function<void()> m_fun_callback;
};
