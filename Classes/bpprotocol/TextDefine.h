#pragma once
//////////////////////////////////////////////////////////////////////////
// TEXT
#define BPTEXT_COMMON_DEVELOPER_PASSWORD						1001	// 开发者模式密码
#define BPTEXT_COMMON_PLUGINS_NAME								1002	// 插件包名
#define BPTEXT_COMMON_HINT_EXIT									1003	// 退出提示
// TEXT
#define BPTEXT_LOGONINFO_DEVELOPERING							10001	// 正在等待进入开发者模式
#define BPTEXT_LOGONINFO_CONNECTING								10002	// 正在连接游戏服务
#define BPTEXT_LOGONINFO_VERSIONTING							10003	// 正在获取版本信息
#define BPTEXT_LOGONINFO_UPDATETING								10004	// 正在更新游戏资源
#define BPTEXT_LOGONINFO_AUTHTING								10005	// 正在验证登陆信息
#define BPTEXT_LOGONINFO_SUCCESS								10006	// 登录成功信息

// TEXT
#define BPTEXT_LOGONERROR_CONNECT_FAIL							10021	// 连接失败
#define BPTEXT_LOGONERROR_CONNECT_CLOSE							10022	// 连接断开
#define BPTEXT_LOGONERROR_FILE_UPDATE_FAIL						10023	// 更新失败
#define BPTEXT_LOGONERROR_FILE_WRITE_FAIL						10024	// 写入失败
#define BPTEXT_LOGONERROR_FILE_LOAD_FAIL						10025	// 加载失败
#define BPTEXT_LOGONERROR_EXCEPTION_FAIL						10026	// 处理异常

// TEXT
#define BPTEXT_BUTTONNAME_OK									10101	// 确定
#define BPTEXT_BUTTONNAME_CANCEL								10102	// 取消
#define BPTEXT_BUTTONNAME_RETRY									10103	// 重新尝试
#define BPTEXT_BUTTONNAME_CUSTOMER								10104	// 咨询客服
#define BPTEXT_BUTTONNAME_UPDATE								10105	// 马上下载
// TEXT
#define BPTEXT_EDITHINT_ACCOUNT_ERROR							10201	// 账号错误
#define BPTEXT_EDITHINT_PASSWORD_ERROR							10202	// 密码错误
#define BPTEXT_EDITHINT_PHONE_ERROR								10203	// 手机错误
#define BPTEXT_EDITHINT_PHONE_CODE_ERROR						10204	// 验证码错误

#define BPTEXT_HTTPINFO_ERROR									10301	// HTTP错误
//////////////////////////////////////////////////////////////////////////

#define BPTEXT(id)		(get_share_global_data()->get_static_text(id))