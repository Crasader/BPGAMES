#pragma once

#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "scripting/lua-bindings/manual/lua_module_register.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

////////////////////////////////////////////////////////////////
// bptools
extern void register_bptools_module(lua_State* L);
extern int bind_to_tools_md5(lua_State *L);
extern int bind_to_tools_md5_file(lua_State *L);
extern int bind_to_tools_mac(lua_State *L);
extern int bind_to_tools_guid(lua_State *L);
extern int bind_to_tools_identifier(lua_State *L);
extern int bind_to_tools_base64_encode(lua_State *L);
extern int bind_to_tools_base64_decode(lua_State *L);
extern int bind_to_tools_url_encode(lua_State *L);
extern int bind_to_tools_url_decode(lua_State *L);
extern int bind_to_tools_utf2gbk(lua_State *L);
extern int bind_to_tools_gbk2utf(lua_State *L);
extern int bind_to_tools_string_split_key(lua_State *L);
extern int bind_to_tools_string_replace_key(lua_State *L);
extern int bind_to_tools_starts_with(lua_State *L);
extern int bind_to_tools_ends_with(lua_State *L);
extern int bind_to_tools_open_url(lua_State *L);
extern int bind_to_tools_show_url(lua_State *L);
extern int bind_to_tools_set_clipboard_data(lua_State *L);
extern int bind_to_tools_get_clipboard_data(lua_State *L);
extern int bind_to_tools_get_command_line(lua_State *L);
extern int bind_to_tools_create_image_data(lua_State *L);
extern int bind_to_tools_request_permission(lua_State *L);
extern int bind_to_tools_record_sound_start(lua_State *L);
extern int bind_to_tools_record_sound_finish(lua_State *L);
extern int bind_to_tools_get_wifi_status(lua_State *L);
extern int bind_to_tools_get_battery_status(lua_State *L);
extern int bind_to_tools_get_package_name(lua_State *L);
extern int bind_to_tools_get_install_status(lua_State *L);
extern int bind_to_tools_wechat_share_text(lua_State *L);
extern int bind_to_tools_wechat_share_image(lua_State *L);
extern int bind_to_tools_wechat_share_program(lua_State *L);
extern int bind_to_tools_wechat_auth(lua_State *L);
extern int bind_to_tools_channel_init(lua_State *L);
extern int bind_to_tools_channel_logon(lua_State *L);
extern int bind_to_tools_channel_logout(lua_State *L);
extern int bind_to_tools_channel_exit(lua_State *L);
extern int bind_to_tools_location(lua_State *L);
extern int bind_to_tools_play_music(lua_State *L);
extern int bind_to_tools_stop_music(lua_State *L);
extern int bind_to_tools_play_effect(lua_State *L);
extern int bind_to_tools_stop_effect(lua_State *L);
extern int bind_to_tools_writelogs(lua_State *L);
extern int bind_to_tools_get_rule_int(lua_State *L);
extern int bind_to_tools_get_rule_longlong(lua_State *L);
extern int bind_to_tools_get_rule_boolean(lua_State *L);
extern int bind_to_tools_get_rule_string(lua_State *L);


////////////////////////////////////////////////////////////////
// class_global_data
extern void register_bpglobal_module(lua_State* L);
extern int bind_to_global_get_wechat_data(lua_State *L);
extern int bind_to_global_get_umeng_data(lua_State *L);
extern int bind_to_global_get_channel_data(lua_State *L);
extern int bind_to_global_get_update_data(lua_State *L);
extern int bind_to_global_get_logon_address(lua_State *L);
extern int bind_to_global_get_auxi_address(lua_State *L);
extern int bind_to_global_get_push_address(lua_State *L);
extern int bind_to_global_get_route_address(lua_State *L);
extern int bind_to_global_get_areaid(lua_State *L);
extern int bind_to_global_get_channelid(lua_State *L);
extern int bind_to_global_get_appid(lua_State *L);
extern int bind_to_global_get_version(lua_State *L);
extern int bind_to_global_get_packageid(lua_State *L);
extern int bind_to_global_get_keyword(lua_State *L);
extern int bind_to_global_get_static_text(lua_State *L);
extern int bind_to_global_get_resource_text(lua_State *L);
extern int bind_to_global_get_common_text(lua_State *L);
extern int bind_to_global_get_prop_data(lua_State *L);
extern int bind_to_global_get_prop_status_data(lua_State *L);
extern int bind_to_global_get_url(lua_State *L);
extern int bind_to_global_make_url(lua_State *L);
extern int bind_to_global_get_local_text(lua_State *L);
extern int bind_to_global_get_module_mask(lua_State *L);
extern int bind_to_global_get_module_data(lua_State *L);
extern int bind_to_global_get_modules_data(lua_State *L);
extern int bind_to_global_have_module_data(lua_State *L);
extern int bind_to_global_get_product_data(lua_State *L);
extern int bind_to_global_get_min_version(lua_State *L);
extern int bind_to_global_get_cur_version(lua_State *L);
extern int bind_to_global_get_max_version(lua_State *L);
extern int bind_to_global_get_module_version(lua_State *L);
extern int bind_to_global_have_mask_auth(lua_State *L);
extern int bind_to_global_have_mask_module(lua_State *L);
extern int bind_to_global_have_mask_pay(lua_State *L);
extern int bind_to_golbal_get_mask_module(lua_State* L);
extern int bind_to_global_have_self_right(lua_State *L);
extern int bind_to_global_get_self_user_data(lua_State *L);
extern int bind_to_global_set_self_user_data(lua_State *L);
extern int bind_to_global_get_self_prop_count(lua_State *L);
extern int bind_to_global_get_self_prop_status(lua_State *L);
extern int bind_to_global_get_self_right(lua_State *L);
extern int bind_to_global_set_self_prop_count(lua_State *L);
extern int bind_to_global_set_self_prop_status(lua_State *L);
extern int bind_to_global_set_self_gold(lua_State *L);
extern int bind_to_global_set_self_ingot(lua_State *L);
extern int bind_to_global_set_self_charm(lua_State *L);
extern int bind_to_global_set_self_bean(lua_State *L);
extern int bind_to_global_set_self_redpacket(lua_State *L);
extern int bind_to_global_set_self_right(lua_State *L);
extern int bind_to_global_update_user_data(lua_State *L);
extern int bind_to_global_application_data(lua_State *L);
extern int bind_to_global_application_run(lua_State *L);
extern int bind_to_global_application_run_fast(lua_State *L);
extern int bind_to_global_application_run_handle(lua_State *L);
extern int bind_to_global_application_signal(lua_State *L);
extern int bind_to_global_application_destory(lua_State *L);
extern int bind_to_global_application_destory_fast(lua_State *L);
extern int bind_to_global_application_run_status(lua_State *L);
extern int bind_to_global_get_main_layout(lua_State *L);
extern int bind_to_global_get_full_filename(lua_State *L);
extern int bind_to_global_get_game_data(lua_State *L);
extern int bind_to_global_get_room_data(lua_State *L);
extern int bind_to_global_get_room_data_by_gameid(lua_State *L);
extern int bind_to_global_get_friendsite_data(lua_State *L);
extern int bind_to_global_get_local_value(lua_State *L);
extern int bind_to_global_set_local_value(lua_State *L);
extern int bind_to_global_get_save_value(lua_State *L);
extern int bind_to_global_set_save_value(lua_State *L);
extern int bind_to_global_get_temp_value(lua_State *L);
extern int bind_to_global_set_temp_value(lua_State *L);
extern int bind_to_global_get_game_list(lua_State *L);
extern int bind_to_global_exit(lua_State *L);
extern int bind_to_global_get_temp_filename(lua_State *L);

////////////////////////////////////////////////////////////////
// ui
extern void register_bpui_module(lua_State* L);
extern int bind_to_ui_show_loading(lua_State *L);
extern int bind_to_ui_show_hinting(lua_State *L);
extern int bind_to_ui_show_message_box(lua_State *L);
////////////////////////////////////////////////////////////////
// base
extern void register_bpbase_module(lua_State* L);
extern int bind_to_base_download_file(lua_State *L);
extern int bind_to_base_upload_file(lua_State *L);
extern int bind_to_base_download_application(lua_State *L);

extern int bind_to_base_socket_create(lua_State *L);
extern int bind_to_base_socket_release(lua_State *L);
extern int bind_to_base_socket_connect(lua_State *L);
extern int bind_to_base_socket_close(lua_State *L);
extern int bind_to_base_socket_send_data(lua_State *L);
extern int bind_to_base_socket_connecting(lua_State *L);
extern int bind_to_base_socket_pause(lua_State *L);
extern int bind_to_base_socket_restore(lua_State *L);

extern int bind_to_base_pack_start(lua_State *L);
extern int bind_to_base_pack(lua_State *L);
extern int bind_to_base_pack_end(lua_State *L);
extern int bind_to_base_pack_check(lua_State *L);


extern int bind_to_base_unpack_start(lua_State *L);
extern int bind_to_base_unpack(lua_State *L);
extern int bind_to_base_unpack_end(lua_State *L);

extern int bind_to_base_http_get(lua_State *L);
extern int bind_to_base_http_post(lua_State *L);

extern int bind_to_base_payment_custom(lua_State *L);
extern int bind_to_base_payment_proudct(lua_State *L);
////////////////////////////////////////////////////////////////
extern void unregister_module(lua_State* L);

