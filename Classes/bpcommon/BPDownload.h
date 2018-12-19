#pragma once

#include "cocos2d.h"
#include "extensions/cocos-ext.h"
#include "ui/CocosGUI.h"

USING_NS_CC;
using namespace cocos2d::ui;

class BPDownload : public Layout
{
public:
	static void ShowDownload(
		std::string		identifier,
		std::string		url,
		std::string		filename,
		std::string		title,
		std::function<void(std::string identifier, std::string url, std::string filename, int code)> callback);
public:
	BPDownload();
	virtual ~BPDownload();
public:
	virtual bool init();
public:
	void show_download(
		std::string		identifier,
		std::string		url,
		std::string		filename,
		std::string		title,
		std::function<void(std::string identifier, std::string url, std::string filename, int code)> callback);
public:
	void on_action_open_finish();
	void on_action_close_finish();
public:
	ImageView *		m_ptr_gui_back;
	ImageView*		m_ptr_gui;
	Label*			m_ptr_label_text;
	LoadingBar*		m_ptr_loading;
public:
	std::string		m_str_identifier;
	std::string		m_str_url;
	std::string		m_str_filename;
	int				m_int_code;
	int				m_int_percent;
	std::function<void(std::string identifier, std::string url, std::string filename, int code)> m_fun_callback;
};
