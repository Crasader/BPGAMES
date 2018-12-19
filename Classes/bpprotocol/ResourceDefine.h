﻿#pragma once
//////////////////////////////////////////////////////////////////////////
// BPMessageBox
#define BPRESOURCES_MASK										10001
#define BPRESOURCES_TRANSPARENT									10002
#define BPRESOURCES_LOADING										10003
#define BPRESOURCES_HINTING										10004

//////////////////////////////////////////////////////////////////////////
// BPMessageBox
#define BPRESOURCES_MESSGAEBOX_BACK								10101
#define BPRESOURCES_MESSGAEBOX_BTN_CANCEL						10102
#define BPRESOURCES_MESSGAEBOX_BTN_OK							10103
#define BPRESOURCES_MESSGAEBOX_CHAR_OK							10104
#define BPRESOURCES_MESSGAEBOX_CHAR_OK_FNT						10105
#define BPRESOURCES_MESSGAEBOX_CHAR_CANCEL						10106
#define BPRESOURCES_MESSGAEBOX_CHAR_CANCEL_FNT					10107
//////////////////////////////////////////////////////////////////////////
// LOGON
#define BPRESOURCES_LOGON_BACK									10201
#define BPRESOURCES_LOGON_BTN_ACCOUNT							10202
#define BPRESOURCES_LOGON_BTN_PHONE								10203
#define BPRESOURCES_LOGON_BTN_TOURIST							10204
#define BPRESOURCES_LOGON_BTN_WECHAT							10205
#define BPRESOURCES_LOGON_BTN_CUSTOMER							10206
#define BPRESOURCES_LOGON_BTN_CHANNEL							10207
#define BPRESOURCES_LOGON_BTN_CHECK_1							10208
#define BPRESOURCES_LOGON_BTN_CHECK_2							10209
#define BPRESOURCES_LOGON_BTN_SERVER							10210
#define BPRESOURCES_LOGON_SERVER_BACK							10211
#define BPRESOURCES_LOGON_HINT									10212
#define BPRESOURCES_LOGON_LOGO									10213
#define BPRESOURCES_LOGON_PROGRESS_BACK							10214
#define BPRESOURCES_LOGON_PROGRESS_1							10215
#define BPRESOURCES_LOGON_PROGRESS_2							10216

#define BPRESOURCES_LOGON_LOGON_BACK							10221
#define BPRESOURCES_LOGON_LOGON_TITLE_BACK						10222
#define BPRESOURCES_LOGON_LOGON_EDITBOX_BACK					10223
#define BPRESOURCES_LOGON_LOGON_TITLE							10224
#define BPRESOURCES_LOGON_LOGON_BTN_CLOSE						10225
#define BPRESOURCES_LOGON_LOGON_BTN_FORGET						10226
#define BPRESOURCES_LOGON_LOGON_BTN_LOGON						10227
#define BPRESOURCES_LOGON_LOGON_ICON_ACCOUNT					10228
#define BPRESOURCES_LOGON_LOGON_ICON_PASSWORD					10229
#define BPRESOURCES_LOGON_LOGON_LABEL_ACCOUNT					10230
#define BPRESOURCES_LOGON_LOGON_LABEL_PASSWORD					10231

#define BPRESOURCES_LOGON_PHONE_BACK							10241
#define BPRESOURCES_LOGON_PHONE_TITLE_BACK						10242
#define BPRESOURCES_LOGON_PHONE_EDITBOX_BACK					10243
#define BPRESOURCES_LOGON_PHONE_TITLE							10244
#define BPRESOURCES_LOGON_PHONE_BTN_CLOSE						10245
#define BPRESOURCES_LOGON_PHONE_BTN_LOGON						10246
#define BPRESOURCES_LOGON_PHONE_BTN_CODE						10247
#define BPRESOURCES_LOGON_PHONE_ICON_PHONE						10248
#define BPRESOURCES_LOGON_PHONE_ICON_CODE						10249
#define BPRESOURCES_LOGON_PHONE_LABEL_PHONE						10250
#define BPRESOURCES_LOGON_PHONE_LABEL_CODE						10251

#define BPRESOURCES_DEVELOPER_BACK								10261
#define BPRESOURCES_DEVELOPER_TITLE_BACK						10262
#define BPRESOURCES_DEVELOPER_EDITBOX_BACK						10263
#define BPRESOURCES_DEVELOPER_TITLE								10264
#define BPRESOURCES_DEVELOPER_BTN_CLOSE							10265

#define BPRESOURCES_DOWNLOAD_BACK								10271
#define BPRESOURCES_DOWNLOAD_PROGRESS_1							10272
#define BPRESOURCES_DOWNLOAD_PROGRESS_2							10273

//////////////////////////////////////////////////////////////////////////

#define BPRESOURCE(id)	(get_share_global_data()->get_full_filename(10000, get_share_global_data()->get_resource_text(id)))