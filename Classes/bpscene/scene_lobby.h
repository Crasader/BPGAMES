#pragma once

#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"
USING_NS_CC;

class scene_lobby : public cocos2d::Scene
{
public:
	static scene_lobby* create();
public:
	scene_lobby();
	virtual ~scene_lobby();
public:
    virtual bool init();
public:
	ui::Layout* m_ptr_layout;
};
