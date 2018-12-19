#pragma once
#include "cocos2d.h"
#include "extensions/cocos-ext.h"
USING_NS_CC;
////////////////////////////////////////////////////////////////

namespace cocos2d { namespace network {

class CC_DLL bpuploadertask
{
public:
	bpuploadertask()
	{
		url = "";
		filename = "";
		identifier = "";
		header = "";
		onTaskProgress = nullptr;
		onTaskResult = nullptr;
	};
	~bpuploadertask() {};
public:
	std::string url;
	std::string filename;
	std::string identifier;
	std::string header;
	std::function<void(const bpuploadertask& task, unsigned int total, unsigned int curr)> onTaskProgress;
	std::function<void(const bpuploadertask& task, unsigned int code)> onTaskResult;
};
////////////////////////////////////////////////////////////////
class CC_DLL bpuploader
{
public:
	bpuploader();
	~bpuploader();
public:
	static bpuploader* getInstance();
public:
	void upload(bpuploadertask &task);
	void update(float dt);
};

}}  // namespace cocos2d::network
