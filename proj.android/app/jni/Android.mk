LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

$(call import-add-path,$(LOCAL_PATH)/../../../cocos2d)
$(call import-add-path,$(LOCAL_PATH)/../../../cocos2d/external)
$(call import-add-path,$(LOCAL_PATH)/../../../cocos2d/cocos)
$(call import-add-path,$(LOCAL_PATH)/../../../cocos2d/cocos/audio/include)

LOCAL_MODULE := MyGame_shared

LOCAL_MODULE_FILENAME := libMyGame

define walk
$(wildcard $(1)) $(foreach e, $(wildcard $(1)/*), $(call walk, $(e)))
endef

ALLFILES = $(call walk, $(LOCAL_PATH)/../../../Classes)
FILE_LIST := $(LOCAL_PATH)/hellocpp/main.cpp
FILE_LIST += $(filter %.cpp, $(ALLFILES))
 
LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%) \
                   $(LOCAL_PATH)/../../../Add-ons/jsoncpp/src/lib_json/json_internalarray.inl \
				   $(LOCAL_PATH)/../../../Add-ons/jsoncpp/src/lib_json/json_internalmap.inl \
				   $(LOCAL_PATH)/../../../Add-ons/jsoncpp/src/lib_json/json_reader.cpp \
				   $(LOCAL_PATH)/../../../Add-ons/jsoncpp/src/lib_json/json_value.cpp \
				   $(LOCAL_PATH)/../../../Add-ons/jsoncpp/src/lib_json/json_valueiterator.inl \
				   $(LOCAL_PATH)/../../../Add-ons/jsoncpp/src/lib_json/json_writer.cpp

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../Classes \
                    $(LOCAL_PATH)/../../../Add-ons/jsoncpp/include \
                    $(LOCAL_PATH)/../../../Add-ons \
                    $(LOCAL_PATH)/../../../cocos2d/external/lua/lua \
                    $(LOCAL_PATH)/../../../cocos2d/external/lua/tolua

# _COCOS_HEADER_ANDROID_BEGIN
# _COCOS_HEADER_ANDROID_END

LOCAL_STATIC_LIBRARIES := cocos2dx_static
LOCAL_STATIC_LIBRARIES += cocos2d_lua_android_static
LOCAL_STATIC_LIBRARIES += cocos2d_lua_static

# _COCOS_LIB_ANDROID_BEGIN
# _COCOS_LIB_ANDROID_END

include $(BUILD_SHARED_LIBRARY)

$(call import-add-path, $(LOCAL_PATH)/../../../cocos2d)
$(call import-module, cocos)

# _COCOS_LIB_IMPORT_ANDROID_BEGIN
# _COCOS_LIB_IMPORT_ANDROID_END
