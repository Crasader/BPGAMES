#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"

USING_NS_CC;
using namespace cocos2d::ui;

class BPLoading : public Layout
{
public:
	static void ShowLoading(bool show, std::string hint = "");
public:
	BPLoading();
	virtual ~BPLoading();
public:
	virtual bool init();
public:
	void show_loading(bool show, std::string hint);
	void on_action_open_finish();
	void on_action_close_finish();
public:
	ImageView*		m_ptr_gui_back;
	ImageView*		m_ptr_gui;
	Label*			m_ptr_label_text;
};
