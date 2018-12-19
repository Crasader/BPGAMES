#include "bpuploader.h"
#include <thread>
#include <chrono>
#include <curl/curl.h>
////////////////////////////////////////////////////////////////////////////////////////////////
namespace cocos2d { namespace network {
class bpuploaderunit
{
public:
	bpuploaderunit()
	{
		sended = 0;
		total = 0;
		code = 0;
		file = 0;
	};
	~bpuploaderunit() {};
public:
	bpuploadertask		task;
	FILE*				file;
	unsigned int		sended;
	unsigned int		total;
	int					code;
};

////////////////////////////////////////////////////////////////////////////////////////////////
static std::list<bpuploaderunit*>	swaits;
static std::list<bpuploaderunit*>	sworks;
static std::list<bpuploaderunit*>	sfinishs;
static std::mutex					smutex;

static size_t fun_read(void *ptr, size_t size, size_t nmemb, void *stream)
{
	std::unique_lock<std::mutex> lock(smutex);
	bpuploaderunit *unit = (bpuploaderunit*)stream;
	if (unit->file != 0)
	{
		size_t int_read_size = fread(ptr, 1, size * nmemb, unit->file);
		unit->sended += int_read_size;
		return int_read_size;
	}
    return 0;
}

static void fun_thread()
{
	while (true)
	{
		bpuploaderunit* unit = nullptr;
		smutex.lock();
		if (swaits.size() != 0)
		{
			unit = swaits.front();
			swaits.pop_front();
			sworks.push_back(unit);
		}
		smutex.unlock();
		if (unit == nullptr)
		{
			std::this_thread::sleep_for(std::chrono::milliseconds(10));
			continue;
		}

		curl_slist* headers = 0;
		CURL*		handle = 0;
		int			code = 0;
		try
		{
			do
			{
				unit->file = fopen(unit->task.filename.c_str(), "rb");
				if (unit->file == 0)
				{
					code = 2001;
					break;
				}

				fseek(unit->file, 0, SEEK_END);
				unit->total = ftell(unit->file);
				rewind(unit->file);

				handle = curl_easy_init();
				if (unit->task.header.empty() == false)
				{
					std::string str_header = unit->task.header;
					while (true)
					{
						size_t index = str_header.find("\n");
						if (index != std::string::npos)
						{
							std::string item = str_header.substr(0, index);
							if (item.empty() == false)
								headers = curl_slist_append(headers, item.c_str());
							str_header = str_header.substr(index + 1);
							continue;
						}
						else
						{
							if (str_header.empty() == false)
								headers = curl_slist_append(headers, str_header.c_str());
							break;
						}
					}
				}
				if (headers != 0)
					curl_easy_setopt(handle, CURLOPT_HTTPHEADER, headers);
				curl_easy_setopt(handle, CURLOPT_URL, unit->task.url.c_str());
				curl_easy_setopt(handle, CURLOPT_READFUNCTION, fun_read);
				curl_easy_setopt(handle, CURLOPT_READDATA, unit);
				curl_easy_setopt(handle, CURLOPT_FAILONERROR, true);
				curl_easy_setopt(handle, CURLOPT_CONNECTTIMEOUT, 10);
				curl_easy_setopt(handle, CURLOPT_NOSIGNAL, 1L);
				curl_easy_setopt(handle, CURLOPT_LOW_SPEED_LIMIT, 1);
				curl_easy_setopt(handle, CURLOPT_LOW_SPEED_TIME, 30);
				curl_easy_setopt(handle, CURLOPT_SSL_VERIFYPEER, 0L);
				curl_easy_setopt(handle, CURLOPT_SSL_VERIFYHOST, 0L);
				curl_easy_setopt(handle, CURLOPT_FOLLOWLOCATION, true);
				curl_easy_setopt(handle, CURLOPT_UPLOAD, 1L);
				curl_easy_setopt(handle, CURLOPT_NOPROGRESS, 1L);

				CURLcode ccode = curl_easy_perform(handle);
				if (ccode != CURLE_OK)
				{
					code = ccode;
					break;
				}
				int status = 0;
				ccode = curl_easy_getinfo(handle, CURLINFO_RESPONSE_CODE, &status);
				if (code != CURLE_OK)
				{
					code = ccode + 1000;
					break;
				}
				if (status != 200)
				{
					code = 2002;
					break;
				}
				if (unit->sended == 0)
				{
					code = 2003;
					break;
				}
				curl_easy_cleanup(handle);
				handle = 0;
				if (headers)
				{
					curl_slist_free_all(headers);
					headers = 0;
				}
				code = 0;
			} while (false);
		}
		catch (...)
		{}

		if (handle)
		{
			curl_easy_cleanup(handle);
			handle = 0;
		}
		if (headers)
		{
			curl_slist_free_all(headers);
			headers = 0;
		}
		if (unit->file)
		{
			fclose(unit->file);
			unit->file = 0;
		}
		unit->code = code;

		smutex.lock();
		for (std::list<bpuploaderunit*>::iterator iter = sworks.begin(); iter != sworks.end(); iter++)
		{
			bpuploaderunit* temp = *iter;
			if (temp == unit)
			{
				sworks.erase(iter);
				break;
			}
		}
		sfinishs.push_back(unit);
		smutex.unlock();
	}
	return;
}

bpuploader::bpuploader()
{
	for (size_t i = 0; i < 4; i++)
	{
		std::thread th1(fun_thread);
		th1.detach();
	}
	cocos2d::Director::getInstance()->getScheduler()->scheduleUpdate(this, 0, false);
}
bpuploader::~bpuploader()
{
	cocos2d::Director::getInstance()->getScheduler()->unscheduleUpdate(this);
}

void bpuploader::upload(bpuploadertask &task)
{
	bpuploaderunit* unit = new bpuploaderunit();
	unit->task = task;
	smutex.lock();
	swaits.push_back(unit);
	smutex.unlock();
	return;
}

void bpuploader::update(float dt)
{
	smutex.lock();
	std::list<bpuploaderunit*> works = sworks;
	smutex.unlock();
	for (std::list<bpuploaderunit*>::iterator iter = works.begin(); iter != works.end(); iter++)
	{
		bpuploaderunit* unit = *iter;
		if (unit == nullptr)
			continue;
		if (unit->task.onTaskProgress && unit->total != 0)
			unit->task.onTaskProgress(unit->task, unit->total, unit->sended);
	}

	while (true)
	{
		bpuploaderunit* unit = nullptr;
		smutex.lock();
		if (sfinishs.size() != 0)
		{
			unit = sfinishs.front();
			sfinishs.pop_front();
		}
		smutex.unlock();
		if (unit == nullptr)
			break;

		if (unit->task.onTaskProgress && unit->total != 0)
			unit->task.onTaskProgress(unit->task, unit->total, unit->sended);
		if (unit->task.onTaskResult)
			unit->task.onTaskResult(unit->task, unit->code);
		delete unit;
	}
}

bpuploader* bpuploader::getInstance()
{
	static bpuploader* uploader = 0;
	if (uploader == 0)
		uploader = new bpuploader;
	return uploader;
}
}}  // namespace cocos2d::network