#pragma once

#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"
USING_NS_CC;

class scene_logon : public cocos2d::Scene
{
public:
	static scene_logon* create();
public:
	scene_logon();
	virtual ~scene_logon();
public:
    virtual bool init();
public:
	ui::Layout* m_ptr_layout;
};
