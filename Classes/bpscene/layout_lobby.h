#pragma once

#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"

USING_NS_CC;
using namespace cocos2d::ui;


class layout_lobby : public Layout
{
public:
	static layout_lobby* create();
public:
	layout_lobby();
	virtual ~layout_lobby();
public:
    virtual bool init();
public:
	void on_key_return(EventKeyboard::KeyCode code, Event* event);
};
