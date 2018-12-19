《Lua游戏框架说明》
 1.class_game_frame 文件里有游戏内允许使用的接口
 
----------------------------------
 version：v1.5
 1.添加show_bugle_send		（用于显示喇叭发送面板）
 1.添加show_gold_rain		（用于显示金币雨动画）
 1.添加show_game_chat		（用于显示游戏内聊天面板）
 1.添加init_game_chat		（用于初始化游戏内聊天面板）
 1.添加init_game_chat_style	（用于初始化游戏内聊天面板风格）
 1.添加show_game_report		（用于显示举报面板）
 1.添加init_game_report_style	（用于初始化举报面板风格）
 1.添加show_game_user_info	（用于显示用户信息面板）
 1.添加init_game_user_info_style（用于初始化用户信息面板风格）
----------------------------------
 version：v1.4
 1.get_current_time添加毫秒字段：millisecond
----------------------------------
 version：v1.3
 1.添加show_sysmessage_box（用于弹出系统对话框）
----------------------------------
 version：v1.2
 1.show_message_box支持直接传递回调函数
 2.http_request_get支持直接传递回调函数
 3.http_request_post支持直接传递回调函数
----------------------------------
 
==================================
函数名称:  bp_application_run
函数描述:  用于运行单款游戏
参数说明:  int型	单款ID
参数说明:  string型	协议具体内容 默认“”
返回说明:  无
-----------------
函数名称:  bp_string_replace_key
函数描述:  用于字符串的键值替换
参数说明:  string型 替换前的字符串
参数说明:  string型 需替换的键名
参数说明:  string型 需替换的键值
返回说明:  string型 替换后的字符串
-----------------
函数名称:  bp_get_wifi_status
函数描述:  用于获取wifi状态
参数说明:  无
返回说明:  int型 0:非wifi下 1:wifi下
-----------------
函数名称:  bp_get_battery_status
函数描述:  用于获取电量状态
参数说明:  无
返回说明:  int型 电量值（0~100）
-----------------
函数名称:  bp_update_user_data
函数描述:  用于更新用户信息
参数说明:  无
返回说明:  无
-----------------
函数名称:  send_game_data
函数描述:  用于发送数据到服务端
参数说明:  int型	协议ID
参数说明:  string型	协议具体内容
返回说明:  无
-----------------
函数名称:  send_ready_data
函数描述:  用于发送准备消息到服务端
参数说明:  无
返回说明:  无
-----------------
函数名称:  send_user_chat
函数描述:  用于发送聊天消息到服务端
参数说明:  string型	聊天内容
返回说明:  无
-----------------
函数名称:  send_user_report
函数描述:  用于发送举报消息到服务端
参数说明:  string型	{"report_kind":1,"user_count":3,"user_id":[1001,1002,1003]}
返回说明:  无
-----------------
函数名称:  stand_up
函数描述:  用于完成站起操作
参数说明:  无
返回说明:  无
-----------------
函数名称:  sit_down
函数描述:  用于完成坐下操作
参数说明:  无
返回说明:  无
-----------------
函数名称:  re_sit_down
函数描述:  用于完成重新坐下操作
参数说明:  无
返回说明:  无
-----------------
函数名称:  re_enter_game
函数描述:  用于完成重新进入房间操作
参数说明:  无
返回说明:  无
-----------------
函数名称:  leave_game
函数描述:  用于完成离开游戏操作，按逃跑处理
参数说明:  无
返回说明:  无
-----------------
函数名称:  close_game
函数描述:  用于完成离开游戏操作，按断线处理
参数说明:  无
返回说明:  无
-----------------
函数名称:  is_look_mode
函数描述:  用于判断当前是否为旁观模式
参数说明:  无
返回说明:  bool型
-----------------
函数名称:  is_allow_look
函数描述:  用于判断是否允许旁观
参数说明:  无
返回说明:  bool型
-----------------
函数名称:  switch_to_chair_id
函数描述:  用于将视图位置转化为逻辑位置
参数说明:  int型 视图位置
返回说明:  int型 逻辑位置
-----------------
函数名称:  switch_to_view_id
函数描述:  用于将逻辑位置转化为视图位置
参数说明:  int型 逻辑位置
返回说明:  int型 视图位置
-----------------
函数名称:  pause_message
函数描述:  用于暂停消息循环
参数说明:  无
返回说明:  无
-----------------
函数名称:  restore_message
函数描述:  用于恢复已暂停的消息循环
参数说明:  无
返回说明:  无
-----------------
函数名称:  get_self_chair_id
函数描述:  用于获取自己的逻辑位置
参数说明:  无
返回说明:  int型 逻辑位置
-----------------
函数名称:  bp_get_self_user_data
函数描述:  用于获取自己的玩家信息
参数说明:  无
返回说明:  string型 {"face_id":0,"sex":0,"member":0,"user_id":0,"group_id":0,"user_right":0,"master_right":0,"nickname":"lilei","gold":0,"socre":0,"win_count":0,"lose_count":0,"draw_count":0,"flee_count":0,"exp":0,"table_id":0,"chair_id":0,"delay":0,"user_status":0,"game_time":0}
-----------------
函数名称:  get_user_data
函数描述:  用于通过逻辑位置获取玩家信息
参数说明:  int型 逻辑位置
返回说明:  string型 {"face_id":0,"sex":0,"member":0,"user_id":0,"group_id":0,"user_right":0,"master_right":0,"nickname":"lilei","gold":0,"socre":0,"win_count":0,"lose_count":0,"draw_count":0,"flee_count":0,"exp":0,"table_id":0,"chair_id":0,"delay":0,"user_status":0,"game_time":0}
-----------------
函数名称:  get_user_data_by_user_id
函数描述:  用于通过用户ID获取玩家信息
参数说明:  int型 用户ID
返回说明:  string型 {"face_id":0,"sex":0,"member":0,"user_id":0,"group_id":0,"user_right":0,"master_right":0,"nickname":"lilei","gold":0,"socre":0,"win_count":0,"lose_count":0,"draw_count":0,"flee_count":0,"exp":0,"table_id":0,"chair_id":0,"delay":0,"user_status":0,"game_time":0}
-----------------
函数名称:  get_game_data
函数描述:  用于获取当前游戏信息
参数说明:  无
返回说明:  string型 {"game_id":0,"game_name":0,"online_count":0,"min_version":0,"max_version":0}
-----------------
函数名称:  get_room_data
函数描述:  用于获取当前房间信息
参数说明:  无
返回说明:  string型 {"room_id":0,"room_name":0,"online_count":0,"address":"127.0.0.1","port":1002,"game_id":0,"room_mode":0,"room_kind":0,"limit_mask":0,"min_score":0,"max_score":0,"min_gold":0,"max_gold":0,"min_charm":0,"max_charm":0,"rule":"a=1;b=2;","game_genre":0,"table_count":0,"chair_count":0,"game_version":0}
-----------------
函数名称:  get_game_status
函数描述:  用于当前游戏状态
参数说明:  无
返回说明:  int型 游戏状态
-----------------
函数名称:  set_game_status
函数描述:  用于当前游戏状态
参数说明:  int型 游戏状态
返回说明:  无
-----------------

函数名称:  show_hinting
函数描述:  用于显示提示信息
参数说明:  string型 信息内容
返回说明:  无
-----------------
函数名称:  show_loading
函数描述:  用于显示加载框
参数说明:  int型 0:不显示 1:显示
返回说明:  无
-----------------
函数名称:  show_message_box
函数描述:  用于显示对话框
参数说明:  string型	对话框正文内容
参数说明:  string型 对话框标题内容
参数说明:  int型	0:确定框 1:确定/取消类型
参数说明:  string型 确定按钮文本内容
参数说明:  string型 取消按钮文本内容
参数说明:  function型 确定按钮回调函数,格式如下:callback(param1, param2)
参数说明:  function型 取消按钮回调函数,格式如下:callback(param1, param2)
参数说明:  int型	回调函数参数1
参数说明:  string型 回调函数参数2
返回说明:  无
-----------------
函数名称:  show_setting
函数描述:  用于显示设置面板
返回说明:  无
-----------------
函数名称:  show_shop
函数描述:  用于显示大商城面板
返回说明:  无
-----------------
函数名称:  show_simple_shop
函数描述:  用于显示小商城面板
参数说明:  string型 标题正文内容
参数说明:  string型 按钮正文内容
返回说明:  无
-----------------
函数名称:  show_bugle_send
函数描述:  用于显示喇叭发送面板
返回说明:  无
-----------------
函数名称:  show_gold_rain
函数描述:  用于显示金币雨动画
返回说明:  无
-----------------
函数名称:  show_game_chat
函数描述:  用于显示游戏内聊天面板
返回说明:  无
-----------------
函数名称:  init_game_chat
函数描述:  用于初始化游戏内聊天面板常用语
参数说明:  string型 常用语内容 格式:{["你好"],["他好"]}
返回说明:  无
-----------------
函数名称:  init_game_chat_style
函数描述:  用于初始化游戏内聊天面板界面风格
参数说明:  string型 风格描述(暂未定义)
返回说明:  无
-----------------
函数名称:  show_game_report
函数描述:  用于举报面板
参数说明:  int型 用户ID
返回说明:  无int
-----------------
函数名称:  init_game_report_style
函数描述:  用于初始化举报面板界面风格
参数说明:  string型 风格描述(暂未定义)
返回说明:  无
-----------------
函数名称:  show_game_user_info
函数描述:  用于显示用户信息面板
参数说明:  int型 是否有举报功能
参数说明:  int型 用户ID
参数说明:  function型 取消按钮回调函数,格式如下:callback(index, param) index:礼物索引，param:回调参数
参数说明:  int型 回调参数
返回说明:  无
-----------------
函数名称:  init_game_user_info_style
函数描述:  用于初始化用户信息面板界面风格
参数说明:  string型 风格描述(暂未定义)
返回说明:  无
-----------------
函数名称:  string_md5
函数描述:  用于字符串md5加密
参数说明:  string型 需加密的文本串
返回说明:  string型 加密后的文本串
-----------------
函数名称:  file_md5
函数描述:  用于文件md5加密
参数说明:  string型 需加密的文件路径
返回说明:  string型 加密后的文本串
-----------------
函数名称:  bp_gbk2utf
函数描述:  用于将gbk编码字符串转化为utf8编码字符串
参数说明:  string型 gbk编码字符串
返回说明:  string型 utf8编码字符串
-----------------
函数名称:  utf8_to_gbk
函数描述:  用于将utf8编码字符串转化为gbk编码字符串
参数说明:  string型 utf8编码字符串
返回说明:  string型 gbk编码字符串
-----------------
函数名称:  get_current_time
函数描述:  用于回去当前的系统时间
参数说明:  无
返回说明:  string型 {"year":1999,"month":12,"day":25,"week":2,"hour":23,"minute":59,"second":59,"millisecond":232132122}
-----------------
函数名称:  get_udid
函数描述:  用于获取唯一标识符
参数说明:  无
返回说明:  string型 唯一标识符
-----------------
函数名称:  get_cache_path
函数描述:  用于获取系统缓存路径
参数说明:  无
返回说明:  string型 缓存路径
-----------------
函数名称:  get_document_path
函数描述:  用于获取系统文档路径
参数说明:  无
返回说明:  string型 文档路径

-----------------
函数名称:  string_replace_key_with_integer
函数描述:  用于字符串的键值替换
参数说明:  string型 替换前的字符串
参数说明:  string型 需替换的键名
参数说明:  int型 	需替换的键值
返回说明:  string型 替换后的字符串
-----------------
函数名称:  get_device_name
函数描述:  用于获取设备名称
参数说明:  无
返回说明:  string型 设备名称
-----------------
函数名称:  get_phone_number
函数描述:  用于获取电话号码
参数说明:  无
返回说明:  string型 电话号码

-----------------
函数名称:  get_install_status
函数描述:  用于判断指定包名应用是否有安装在手机中
参数说明:  string型 包名
返回说明:  int型 	0:没有 1:有
-----------------
函数名称:  open_url
函数描述:  用于打开指定网页
参数说明:  string型 网页地址
返回说明:  int型 	0:失败 1:成功
-----------------
函数名称:  share_wechat
函数描述:  用于微信分享
参数说明:  string型 分享标题
参数说明:  string型 分享内容
参数说明:  string型 分享图标的路径
参数说明:  string型 分享连接的地址
参数说明:  int型 	分享类型 0:好友 1:朋友圈
返回说明:  int型 	0:失败 1:成功
-----------------
函数名称:  get_kind_id
函数描述:  用于获取当前应用的ID
参数说明:  无
返回说明:  int型 	应用ID
-----------------
函数名称:  get_area_id
函数描述:  用于获取当前的平台ID
参数说明:  无
返回说明:  int型 	平台ID 1:安卓 2:IOS
-----------------
函数名称:  get_channel_id
函数描述:  用于获取渠道ID
参数说明:  无
返回说明:  int型
-----------------
函数名称:  get_package_id
函数描述:  用于获取渠道子ID
参数说明:  无
返回说明:  int型
-----------------
函数名称:  get_version
函数描述:  用于获取当前应用版本
参数说明:  无
返回说明:  int型 版本号
-----------------
函数名称:  is_checking_version
函数描述:  用于判断是否为审核状态
参数说明:  无
返回说明:  bol型 false:非审核状态 true:审核状态
-----------------
函数名称:  is_newest_version
函数描述:  用于判断是否为最新版本
参数说明:  无
返回说明:  bol型 false:非最新版本 true:最新版本
-----------------
函数名称:  is_visitor_account
函数描述:  用于判断是否为访客帐号
参数说明:  无
返回说明:  bol型 false:非访客帐号 true:访客帐号
-----------------
函数名称:  get_keyword
函数描述:  用于获取应用关键字
参数说明:  无
返回说明:  string型 应用关键字
-----------------
函数名称:  get_update_address
函数描述:  用于获取更新地址
参数说明:  无
返回说明:  string型 更新地址
-----------------
函数名称:  get_assess_address
函数描述:  用于获取评价地址
参数说明:  无
返回说明:  string型 评价地址
-----------------
函数名称:  get_share_address
函数描述:  用于获取分享地址
参数说明:  无
返回说明:  string型 分享地址
-----------------
函数名称:  get_webpay_address
函数描述:  用于获取网页充值页面地址
参数说明:  无
返回说明:  string型 网页充值页面地址
-----------------
函数名称:  get_manualpay_address
函数描述:  用于获取人工充值的跳转地址
参数说明:  无
返回说明:  string型 人工充值的跳转地址
-----------------
函数名称:  get_feedback_address
函数描述:  用于获取客服反馈地址
参数说明:  无
返回说明:  string型 客服反馈地址
-----------------
函数名称:  get_level_data
函数描述:  用于获取等级信息
参数说明:  int型 	金币数目
返回说明:  string型 金币数目对应的等级信息 {"level":18,"level_name":"玉皇大帝","next_level_gold":80000000}
-----------------
函数名称:  get_music_volume
函数描述:  用于获取背景音乐的音量
参数说明:  无
返回说明:  number型 音量(0.0 - 1.0)
-----------------
函数名称:  set_music_volume
函数描述:  用于设置背景音乐的音量
参数说明:  number型 音量(0.0 - 1.0)
返回说明:  无
-----------------
函数名称:  get_effects_volume
函数描述:  用于获取背景音效的音量
参数说明:  无
返回说明:  number型 音量(0.0 - 1.0)
-----------------
函数名称:  set_effects_volume
函数描述:  用于设置背景音效的音量
参数说明:  number型 音量(0.0 - 1.0)
返回说明:  无
-----------------
函数名称:  get_config_value
函数描述:  用于获取持久化键/值
参数说明:  string型 键名
参数说明:  string型 值默认值(无此键名时的返回值)
返回说明:  string型 值
-----------------
函数名称:  set_config_value
函数描述:  用于设置持久化键/值
参数说明:  string型 键名
参数说明:  string型 值
返回说明:  无
-----------------
函数名称:  bp_set_self_gold
函数描述:  用于调整自己的金币数(用于通知其他界面模块)
参数说明:  int型 自己的金币数量
返回说明:  无
-----------------
函数名称:  bp_set_self_bean
函数描述:  用于调整自己的金豆数(用于通知其他界面模块)
参数说明:  int型 自己的金豆数量
返回说明:  无
-----------------
函数名称:  get_self_gold
函数描述:  用于获取自己的金币数
参数说明:  无
返回说明:  int型 自己的金币数量
-----------------
函数名称:  set_self_ingot
函数描述:  用于调整自己的元宝数(用于通知其他界面模块)
参数说明:  int型 自己的元宝数量
返回说明:  无
-----------------
函数名称:  get_self_ingot
函数描述:  用于获取自己的元宝数
参数说明:  无
返回说明:  int型 自己的元宝数量
-----------------
函数名称:  bp_set_self_charm
函数描述:  用于调整自己的魅力数(用于通知其他界面模块)
参数说明:  int型 自己的魅力数量
返回说明:  无
-----------------
函数名称:  get_self_charm
函数描述:  用于获取自己的魅力数
参数说明:  无
返回说明:  int型 自己的魅力数量
-----------------
函数名称:  get_prop_data_by_id
函数描述:  用于获取指定道具的信息
参数说明:  int型 道具ID
返回说明:  string型 道具信息 {"id":1002,"type":2,"name":"奖券","caption":"可用于兑换话费或实物奖励","can_sale":0,"can_use":0}
-----------------
函数名称:  get_prop_count_by_id
函数描述:  用于获取指定道具的数量
参数说明:  int型 道具ID
返回说明:  int型 道具数目
-----------------
函数名称:  set_prop_count_by_id
函数描述:  用于设置指定道具的数量
参数说明:  int型 道具ID
参数说明:  int型 道具数目
返回说明:  无
-----------------
函数名称:  get_status_time_by_id
函数描述:  用于获取指定道具状态的失效时间
参数说明:  int型 状态ID
返回说明:  int型 时效时间
-----------------
函数名称:  set_status_time_by_id
函数描述:  用于设置指定道具状态的失效时间
参数说明:  int型 状态ID
参数说明:  int型 时效时间
-----------------
函数名称:  get_prop_status
函数描述:  用于判断指定的道具是否在有效期内
参数说明:  int型 状态ID
返回说明:  bol型 false:否 true:是
-----------------
函数名称:  bp_make_url
函数描述:  用于格式化字符串(会替换指定关键字为具体的内容，{KINDID}等会替换为真实的数值，如107)
参数说明:  string型 需格式化的字符串
返回说明:  string型 格式化后的字符串
-----------------
函数名称:  execute_sql
函数描述:  在本地的数据库中执行指定的SQL脚本
参数说明:  string型 SQL脚本
返回说明:  无
-----------------
函数名称:  bp_http_get
函数描述:  用于通过GET的方式访问http接口
参数说明:  string型 请求标识符,即tag
参数说明:  string型 请求地址
参数说明:  function型 回调函数，格式如下:callback(tag, code, data)
返回说明:  无
-----------------
函数名称:  bp_http_post
函数描述:  用于通过POST的方式访问http接口
参数说明:  string型 请求标识符,即tag
参数说明:  string型 请求地址
参数说明:  string型 POST数据
参数说明:  function型 回调函数，格式如下:callback(tag, code, data)
返回说明:  无
-----------------
函数名称:  show_sysmessage_box
函数描述:  用于显示对话框
参数说明:  string型	对话框正文内容
参数说明:  string型 对话框标题内容
参数说明:  int型	0:确定框 1:确定/取消类型
参数说明:  string型 确定按钮文本内容
参数说明:  string型 取消按钮文本内容
参数说明:  function型 确定按钮回调函数,格式如下:callback(param1, param2)
参数说明:  function型 取消按钮回调函数,格式如下:callback(param1, param2)
参数说明:  int型	回调函数参数1
参数说明:  string型 回调函数参数2
返回说明:  无
-----------------


































