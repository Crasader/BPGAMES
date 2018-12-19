#pragma once

#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"
#include "network/bpuploader.h"
#include "bpbase/bptools.h"
#include "bplogic/class_global_data.h"
#include "bplogic/class_logic_logon.h"
#include "bplogic/class_downloader.h"

USING_NS_CC;
using namespace cocos2d::ui;

#define BPSTATUS_LOGON_DEVELOPER_WAIT					10		// 等待进入开发者模式
#define BPSTATUS_LOGON_DEVELOPER_ENTER					20		// 开发者模式密钥输入
#define BPSTATUS_LOGON_DEVELOPER_EDIT					30		// 开发者模式
#define BPSTATUS_LOGON_AUTH								40		// 认证

class layout_logon : public Layout
{
public:
	static layout_logon* create();
public:
	layout_logon();
	virtual ~layout_logon();
public:
    virtual bool init();
public:
	void show_progress(std::string hint, int progress);
	void show_server();
public:
	void delay_init(float delay);
	void on_delay_init();
	void delay_logon(float delay);
	void on_delay_logon();
public:
	bool on_logon_listener(int step, int param1, std::string param2);
	void on_btn_logon(Ref* sender, Widget::TouchEventType type);
public:
	void on_key_return(EventKeyboard::KeyCode code, Event* event);
public:
	ImageView*	m_ptr_gui_server;
	CheckBox*	m_ptr_checkbox_server;
	Button*		m_ptr_btn_server;
	Label*		m_ptr_label_hints;

	Button*		m_ptr_btn_wechat;
	Button*		m_ptr_btn_phone;
	Button*		m_ptr_btn_account;
	Button*		m_ptr_btn_channel;
	Button*		m_ptr_btn_tourist;

	ImageView*	m_ptr_gui_loading;
	LoadingBar* m_ptr_loading;

	Button*		m_ptr_btn_customer;

	int			m_handle;
public:
	class_logic_logon	m_the_logic_logon;
	int					m_int_logon_status;
};
