#pragma once

//////////////////////////////////////////////////////////////////////////

//玩家权限定义
#define UR_CANNOT_PLAY					0x00000001L				//不能进行游戏
#define UR_CANNOT_LOOKON				0x00000002L				//不能旁观游戏
#define UR_CANNOT_WISPER				0x00000004L				//不能发送私聊
#define UR_MASK_ABNORMAL 				0x00000008L				//异常的用户
#define UR_MASK_FILL_PHONE				0x00000010L				//填写过手机

#define UR_RIGHT_PAY					0x00000020L				//完整的支付权限
#define UR_MASK_VIP						0x00000040L				//会员标记
#define UR_MASK_PAY						0x00000080L				//充值用户标记
#define UR_MASK_ALIPAY					0x00000100L				//阿里充值用户标记
#define UR_MASK_APPLEPAY				0x00000200L				//苹果充值用户标记
#define UR_MASK_SMSPAY					0x00000400L				//短信充值用户标记
#define UR_MASK_WXPAY					0x00000800L				//微信充值用户标记
#define UR_MASK_TASK					0x00001000L				//任务参与标记
#define UR_MASK_ACTIVE					0x00002000L				//活动参与标记
#define UR_MASK_SLIGHT_PAY				0x00004000L				//浅度付费用户 <= 30
#define UR_MASK_MODERATE_PAY			0x00008000L				//中度付费用户
#define UR_MASK_SEVERE_PAY				0x00010000L				//重度付费用户 > 300
#define UR_RIGHT_FULLGAME				0x00020000L				//完整的游戏权限
#define UR_MASK_BETA					0x00040000L				//内测权限
#define UR_MASK_CERTIFICATION			0x00080000L				//实名认证权限
#define UR_MASK_ADULT					0x00100000L				//成年人权限
#define UR_MASK_INTRODUCER				0x00200000L				//是否有介绍人
#define UR_MASK_CHECK_PHONE				0x00400000L				//是否已手机验证
#define UR_MASK_CHECK_WECHAT			0x00800000L				//是否已微信验证

#define UR_MASK_FORMAL_USER				0x10000000L				//正式帐号
#define UR_MASK_CHECK					0x20000000L				//审核人员帐号（审核版本登陆过游戏的帐号）
#define UR_MASK_ROBOT					0x40000000L				//机器人

//////////////////////////////////////////////////////////////////////////
#define UMR_EVER_PLUGINS				0x00000001L				//曾经安装插件