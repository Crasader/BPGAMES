#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "network/bpdownloader.h"
USING_NS_CC;
using namespace cocos2d::network;

////////////////////////////////////////////////////////////////
class bpappdownloadertask
{
public:
	bpappdownloadertask() { appid = 0; };
	~bpappdownloadertask() {};
public:
	int appid;
	std::string identifier;
	std::function<void(const bpappdownloadertask& task, unsigned int code)> onTaskResult;
	std::function<void(const bpappdownloadertask& task, unsigned int currcount, unsigned int totalcount)> onTaskProgress;
};
////////////////////////////////////////////////////////////////
class class_downloader
{
public:
	class_downloader();
	virtual ~class_downloader();
public:
	static class_downloader* getInstance();
public:
	void download(bpappdownloadertask &task);
	void update(float dt);
private:
	void work(bpappdownloadertask &task);
private:
	bpappdownloadertask currtask;
};