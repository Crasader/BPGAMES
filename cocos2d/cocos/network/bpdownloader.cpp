#include "bpdownloader.h"
#include <thread>
#include <chrono>
#include <curl/curl.h>
////////////////////////////////////////////////////////////////////////////////////////////////
namespace cocos2d { namespace network {
class bpdownloaderunit
{
public:
	bpdownloaderunit() 
	{
		file = 0;
		filename = "";
		received = 0;
		total = 0;
		code = 0;
	};
	~bpdownloaderunit() {};
public:
	bpdownloadertask	task;
	FILE*				file;
	std::string			filename;
	unsigned int		received;
	unsigned int		total;
	int					code;
};

////////////////////////////////////////////////////////////////////////////////////////////////
static std::list<bpdownloaderunit*>	swaits;
static std::list<bpdownloaderunit*>	sworks;
static std::list<bpdownloaderunit*>	sfinishs;
static std::mutex					smutex;

static size_t fun_write(void *ptr, size_t size, size_t nmemb, void* userdata)
{
	std::unique_lock<std::mutex> lock(smutex);
	bpdownloaderunit *unit = (bpdownloaderunit*)userdata;
	if (unit->file != 0)
	{
		if (fwrite(ptr, 1, size * nmemb, unit->file) != size * nmemb)
            return 0;
		unit->received += size * nmemb;
		return size * nmemb;
	}
    return 0;
}

static int fun_progress(void *clientp, curl_off_t dltotal, curl_off_t dlnow, curl_off_t ultotal, curl_off_t ulnow)
{
	std::unique_lock<std::mutex> lock(smutex);
	bpdownloaderunit *unit = (bpdownloaderunit*)clientp;
	unit->total = (int)dltotal;
	return 0;
}

static void fun_thread()
{
	while (true)
	{
		bpdownloaderunit* unit = nullptr;
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
				unit->file = fopen(unit->filename.c_str(), "wb");
				if (unit->file == 0)
				{
					code = 2003;
					break;
				}
				handle = curl_easy_init();
				if (handle == 0)
				{
					code = 2004;
					break;
				}
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
				curl_easy_setopt(handle, CURLOPT_WRITEFUNCTION, fun_write);
				curl_easy_setopt(handle, CURLOPT_WRITEDATA, unit);
				curl_easy_setopt(handle, CURLOPT_FAILONERROR, true);
				curl_easy_setopt(handle, CURLOPT_CONNECTTIMEOUT, 10);
				curl_easy_setopt(handle, CURLOPT_NOSIGNAL, 1L);
				curl_easy_setopt(handle, CURLOPT_LOW_SPEED_LIMIT, 1);
				curl_easy_setopt(handle, CURLOPT_LOW_SPEED_TIME, 30);
				curl_easy_setopt(handle, CURLOPT_SSL_VERIFYPEER, 0L);
				curl_easy_setopt(handle, CURLOPT_SSL_VERIFYHOST, 0L);
				curl_easy_setopt(handle, CURLOPT_FOLLOWLOCATION, true);
				curl_easy_setopt(handle, CURLOPT_XFERINFOFUNCTION, fun_progress);
				curl_easy_setopt(handle, CURLOPT_XFERINFODATA, unit);
				curl_easy_setopt(handle, CURLOPT_NOPROGRESS, 0L);

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
					code = 2005;
					break;
				}
				if (fflush(unit->file))
				{
					code = 2006;
					break;
				}
				if (fclose(unit->file))
				{
					code = 2007;
					break;
				}
				if (unit->received == 0)
				{
					code = 2008;
					break;
				}
				curl_easy_cleanup(handle);
				handle = 0;
				if (headers)
				{
					curl_slist_free_all(headers);
					headers = 0;
				}
				unit->file = 0;
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
		for (std::list<bpdownloaderunit*>::iterator iter = sworks.begin(); iter != sworks.end(); iter++)
		{
			bpdownloaderunit* temp = *iter;
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

bpdownloader::bpdownloader()
{
	for (size_t i = 0; i < 8; i++)
	{
		std::thread th1(fun_thread);
		th1.detach();
	}
	cocos2d::Director::getInstance()->getScheduler()->scheduleUpdate(this, 0, false);
}
bpdownloader::~bpdownloader()
{
	cocos2d::Director::getInstance()->getScheduler()->unscheduleUpdate(this);
}

void bpdownloader::download(bpdownloadertask &task)
{
	static unsigned int sindex = 0;
	sindex++;
	std::string str_directory = FileUtils::getInstance()->getFileDirectory(task.filename);
	if (str_directory.empty() == false)
		FileUtils::getInstance()->createDirectory(str_directory);

	std::string str_filename = "";
	str_filename += task.filename;
	str_filename += ".temp";
	str_filename += std::to_string(sindex);
	if (FileUtils::getInstance()->isFileExist(str_filename) == true)
		FileUtils::getInstance()->removeFile(str_filename);

	bpdownloaderunit* unit = new bpdownloaderunit();
	unit->task = task;
	unit->filename = str_filename;
	smutex.lock();
	swaits.push_back(unit);
	smutex.unlock();
	return;
}

void bpdownloader::update(float dt)
{
	smutex.lock();
	std::list<bpdownloaderunit*> works = sworks;
	smutex.unlock();
	for (std::list<bpdownloaderunit*>::iterator iter = works.begin(); iter != works.end(); iter++)
	{
		bpdownloaderunit* unit = *iter;
		if (unit == nullptr)
			continue;
		if (unit->task.onTaskProgress && unit->total != 0)
			unit->task.onTaskProgress(unit->task, unit->total, unit->received);
	}

	while (true)
	{
		bpdownloaderunit* unit = nullptr;
		smutex.lock();
		if (sfinishs.size() != 0)
		{
			unit = sfinishs.front();
			sfinishs.pop_front();
		}
		smutex.unlock();
		if (unit == nullptr)
			break;

		if (unit->code == 0)
		{
			if (FileUtils::getInstance()->isFileExist(unit->task.filename))
			{
				if (FileUtils::getInstance()->removeFile(unit->task.filename) == false)
					unit->code = 2009;
			}
			if (FileUtils::getInstance()->renameFile(unit->filename, unit->task.filename) == false)
				unit->code = 2010;
			Director::getInstance()->getTextureCache()->removeTextureForKey(unit->task.filename);
		}

		if (unit->task.onTaskProgress && unit->total != 0)
			unit->task.onTaskProgress(unit->task, unit->total, unit->received);
		if (unit->task.onTaskResult)
			unit->task.onTaskResult(unit->task, unit->code);
		delete unit;
	}
}

bpdownloader* bpdownloader::getInstance()
{
	static bpdownloader* downloader = 0;
	if (downloader == 0)
		downloader = new bpdownloader;
	return downloader;
}
}}  // namespace cocos2d::network