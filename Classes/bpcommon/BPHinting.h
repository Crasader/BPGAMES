#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"

USING_NS_CC;
using namespace cocos2d::ui;

class BPHinting : public Layout
{
public:
	static void ShowHinting(std::string hint);
public:
	BPHinting();
	virtual ~BPHinting();
public:
	virtual bool init();
public:
	void show_hinting(std::string hint);
	void on_action_open_finish();
	void on_action_close_finish();
public:
	ImageView *		m_ptr_gui_back;
	Layout*			m_ptr_layout_text;
	Label*			m_ptr_label_text;
};
