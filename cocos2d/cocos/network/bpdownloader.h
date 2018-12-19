#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
USING_NS_CC;
////////////////////////////////////////////////////////////////

namespace cocos2d { namespace network {

class CC_DLL bpdownloadertask
{
public:
	bpdownloadertask() 
	{
		url = "";
		filename = "";
		identifier = "";
		header = "";
		onTaskProgress = nullptr;
		onTaskResult = nullptr;
	};
	~bpdownloadertask() {};
public:
	std::string url;
	std::string filename;
	std::string identifier;
	std::string header;
	std::function<void(const bpdownloadertask& task, unsigned int total, unsigned int curr)> onTaskProgress;
	std::function<void(const bpdownloadertask& task, unsigned int code)> onTaskResult;
};
////////////////////////////////////////////////////////////////
class CC_DLL bpdownloader
{
public:
	bpdownloader();
	~bpdownloader();
public:
	static bpdownloader* getInstance();
public:
	void download(bpdownloadertask &task);
	void update(float dt);
};

}}  // namespace cocos2d::network
