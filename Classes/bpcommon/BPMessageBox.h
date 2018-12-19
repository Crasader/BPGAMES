#pragma once

#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"

USING_NS_CC;
using namespace cocos2d::ui;

#ifndef MB_OK
#define MB_OK		0x00000000L
#endif

#ifndef MB_OKCANCEL
#define MB_OKCANCEL	0x00000001L
#endif

#define BP_MESSAGEBOX_LISTENER(__selector__,__target__, ...) std::bind(&__selector__,__target__, std::placeholders::_1, std::placeholders::_2)

class BPMessageBox : public Layout
{
public:
	static void ShowMessageBox(
		std::string		title,
		std::string		text,
		int				type,
		std::string		ok = "",
		std::string		cancel = "",
		std::function<void(int param1, void* param2)> callback_ok = nullptr,
		std::function<void(int param1, void* param2)> callback_cancel = nullptr,
		int				param1 = 0,
		void*			param2 = 0);
public:
	BPMessageBox();
	virtual ~BPMessageBox();
public:
	virtual bool init();
public:
	void show_message_box(
		std::string		title,
		std::string		text,
		int				type,
		std::string		ok,
		std::string		cancel,
		std::function<void(int param1, void* param2)> callback_ok,
		std::function<void(int param1, void* param2)> callback_cancel,
		int				param1,
		void*			param2);
public:
	void on_btn_ok(Ref* sender, Widget::TouchEventType type);
	void on_btn_cancel(Ref* sender, Widget::TouchEventType type);
	void on_action_open_finish();
	void on_action_close_finish();
public:
	ImageView *		m_ptr_gui_back;
	ImageView*		m_ptr_gui;
	Label*			m_ptr_label_text;
	Button*			m_ptr_btn_ok;
	Button*			m_ptr_btn_cancel;
	int				m_int_index;
public:
	std::function<void(int param1, void* param2)> m_fun_callback_ok;
	std::function<void(int param1, void* param2)> m_fun_callback_cancel;
public:
	int				m_int_param;
	void*			m_ptr_param;
};
