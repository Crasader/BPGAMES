#include "bptools.h"
#include <string>
#include <list>
#include <vector>
#include <map>
#include "jsoncpp/json.h"
#include "bpmacros.h"
#include "bplogic/class_global_data.h"

#import <AVFoundation/AVFoundation.h>

#import "WeChatSDK/WXApiObject.h"
#import "WeChatSDK/WechatAuthSDK.h"
#import "WeChatSDK/WXApi.h"

#include "platform/CCGLView.h"
#include "platform/ios/CCEAGLView-ios.h"

////////////////////////////////////////////////////////////////
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
std::string	bptools::utf2gbk(std::string data)
{
    NSStringEncoding utf8_encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    NSStringEncoding gbk_encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* str_utf8 = [[NSString alloc]initWithBytes:data.c_str() length:data.length() encoding:utf8_encode ];
    NSString* str_gbk = [str_utf8 stringByAddingPercentEscapesUsingEncoding:gbk_encode];
    return url_decode([str_gbk UTF8String]);
}

std::string	bptools::gbk2utf(std::string data, bool gbk)
{
	if (gbk == false)
		return data;
    NSStringEncoding gbk_encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* str_utf8 = [[NSString alloc]initWithBytes:data.c_str() length:data.length() encoding:gbk_encode ];
	return [str_utf8 UTF8String];
}

////////////////////////////////////////////////////////////////
@interface BPUILoading : NSObject
- (id) initWithParentView:(UIView*)parentView;
- (void) startAlert;
- (void) stopAlert;
@end

@interface BPUILoading()

@property (nonatomic) UIActivityIndicatorView* indicatorWaiting;
@property (nonatomic) UIView* viewAlert;
@property (nonatomic) UIView* viewParent;
@property (nonatomic) UILabel* labWaiting;
@property (copy, nonatomic) NSString* strWaiting;
@property (nonatomic) BOOL isStart;

@end

@implementation BPUILoading

- (id) initWithParentView:(UIView*)parentView {
    if(self = [super init]) {
        self.viewParent = parentView;
        self.isStart = NO;
    }
    return self;
}

- (void) startAlert {
    if (self.isStart == YES) {
        return;
    }
    
    self.viewAlert = [[UIView alloc] init];
    [self.viewAlert setBackgroundColor:[UIColor blackColor]];
    [self.viewAlert setAlpha:0.6];
    self.viewAlert.layer.cornerRadius = 10;
    self.viewAlert.layer.masksToBounds = YES;
    self.viewAlert.layer.borderWidth = 0;
    self.viewAlert.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.viewAlert setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.viewParent addSubview:self.viewAlert];
    [self.viewAlert addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlert
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeHeight
                                                              multiplier:1
                                                                constant:80]];
    [self.viewAlert addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlert
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1
                                                                constant:200]];
    [self.viewParent addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlert
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                   toItem:self.viewParent
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1
                                                                 constant:0]];
    [self.viewParent addConstraint:[NSLayoutConstraint constraintWithItem:self.viewAlert
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationLessThanOrEqual
                                                                   toItem:self.viewParent
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1
                                                                 constant:0]];
    
    self.indicatorWaiting =  [[UIActivityIndicatorView alloc] init];
    [self.indicatorWaiting setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.indicatorWaiting setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.viewAlert addSubview:self.indicatorWaiting];
    [self.viewAlert addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorWaiting
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                                                  toItem:self.viewAlert
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:40]];
    [self.viewAlert addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorWaiting
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                                                  toItem:self.viewAlert
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0]];
    
    self.strWaiting = @"正在加载中...";
    self.labWaiting = [[UILabel alloc] init];
    self.labWaiting.text = self.strWaiting;
    self.labWaiting.textAlignment = NSTextAlignmentCenter;
    self.labWaiting.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.labWaiting setTextColor:[UIColor whiteColor]];
    [self.labWaiting setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.viewAlert addSubview:self.labWaiting];
    [self.viewAlert addConstraint:[NSLayoutConstraint constraintWithItem:self.labWaiting
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                                                  toItem:self.viewAlert
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:20]];
    [self.viewAlert addConstraint:[NSLayoutConstraint constraintWithItem:self.labWaiting
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationLessThanOrEqual
                                                                  toItem:self.viewAlert
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0]];
    [self.indicatorWaiting startAnimating];
    self.isStart = YES;
}

- (void) stopAlert {
    if (self.isStart == NO) {
        return;
    }
    [self.indicatorWaiting stopAnimating];
    [self.viewAlert removeFromSuperview];
    self.isStart = NO;
}

@end
////////////////////////////////////////////////////////////////
static cocos2d::experimental::ui::WebView*  sptr_webview = 0;
static BPUILoading*                         sptr_loading = 0;
////////////////////////////////////////////////////////////////
@interface BPUIButton : UIButton
- (void)on_btn_action:(UIButton*)button;
@end

@implementation BPUIButton
- (void)on_btn_action:(UIButton*)button {
    [button removeFromSuperview];
    if (sptr_webview) {
        get_share_global_data()->get_main_layout()->removeChild(sptr_webview);
        sptr_webview = 0;
    }
    if (sptr_loading) {
        [sptr_loading stopAlert];
        [sptr_loading release];
        sptr_loading = 0;
    }
}
@end
////////////////////////////////////////////////////////////////
bool bptools::show_url(std::string url)
{
    sptr_loading = [[BPUILoading alloc] initWithParentView:(CCEAGLView*)cocos2d::Director::getInstance()->getOpenGLView()->getEAGLView()];

    sptr_webview = cocos2d::experimental::ui::WebView::create();
    sptr_webview->setContentSize(Director::getInstance()->getVisibleSize());
    sptr_webview->setPosition(Vec2(Director::getInstance()->getVisibleSize().width / 2, Director::getInstance()->getVisibleSize().height / 2));
    sptr_webview->setScalesPageToFit(true);
    sptr_webview->setOnDidFinishLoading([=](cocos2d::experimental::ui::WebView *sender, const std::string &url)
    {
        if (sptr_loading) {
            [sptr_loading stopAlert];
            [sptr_loading release];
            sptr_loading = 0;
        }
    });
    sptr_webview->setOnDidFailLoading([=](cocos2d::experimental::ui::WebView *sender, const std::string &url)
    {
        if (sptr_loading) {
            [sptr_loading stopAlert];
            [sptr_loading release];
            sptr_loading = 0;
        }
    });
    sptr_webview->loadURL(url);
    get_share_global_data()->get_main_layout()->addChild(sptr_webview);
    [sptr_loading startAlert];

    CCEAGLView* view = (CCEAGLView*)cocos2d::Director::getInstance()->getOpenGLView()->getEAGLView();
    std::string str_filename = FileUtils::getInstance()->fullPathForFilename("close.png");
    BPUIButton* ptr_close = [BPUIButton buttonWithType:UIButtonTypeCustom];
    ptr_close.frame = CGRectMake([view getWidth] / 2 - 60, 0, 60, 60);
    [ptr_close setImage:[UIImage imageNamed:[NSString stringWithUTF8String : str_filename.c_str()]] forState:0];
    [view addSubview:ptr_close];
    [ptr_close addTarget:ptr_close action:@selector(on_btn_action:) forControlEvents:UIControlEventTouchUpInside];
    return true;
}

bool bptools::open_url(std::string url)
{
    NSString* data = [NSString stringWithUTF8String:url.c_str()];
    return [[UIApplication sharedApplication]openURL:[NSURL URLWithString:data]];
}

void bptools::set_clipboard_data(std::string data)
{
    [[UIPasteboard generalPasteboard] setString:[NSString stringWithUTF8String:data.c_str()]];
}

std::string bptools::get_clipboard_data()
{
    NSString* data = [UIPasteboard generalPasteboard].string;
    
    std::string ret = "";
    if(data != nil)
        ret = [data UTF8String];
    else
        ret = "";
    
    return ret;
}

std::string bptools::get_command_line()
{
    return "";
}

////////////////////////////////////////////////////////////////
static int sint_image_width = 0;
static int sint_image_height = 0;
@interface BPUIImagePickerControllerDelegate : NSObject<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
@end

@implementation BPUIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIGraphicsBeginImageContext(CGSizeMake(sint_image_width, sint_image_height));
    [image drawInRect:CGRectMake(0, 0, sint_image_width, sint_image_height)];
    UIImage* temp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* data = UIImagePNGRepresentation(temp);
    std::string str_filename = get_share_global_data()->get_temp_filename(bptools::guid() + ".png");
    [data writeToFile:[NSString stringWithUTF8String : str_filename.c_str()] atomically:YES];
    [self release];
    if (FileUtils::getInstance()->isFileExist(str_filename))
        bptools::asyn_event(0, HANDLE_TOOLS_CALLBACK_CREATE_IMAGE, S_OK, str_filename);
    else
        bptools::asyn_event(0, HANDLE_TOOLS_CALLBACK_CREATE_IMAGE, S_FALSE, "");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self release];
    bptools::asyn_event(0, HANDLE_TOOLS_CALLBACK_CREATE_IMAGE, S_FALSE, "");
}

@end

bool bptools::create_image_data(int width, int height, std::function<void(unsigned int code, std::string filename)> callback)
{
    bptools::m_the_create_image_callback = callback;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_CREATE_IMAGE, S_FALSE, "");
        return true;
    }
    
    sint_image_width = width;
    sint_image_height = height;
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = [[BPUIImagePickerControllerDelegate alloc] init];
    picker.allowsEditing = YES;
    
    id controller = (CCEAGLView*)cocos2d::Director::getInstance()->getOpenGLView()->getEAGLView();
    while (controller) {
        controller = ((UIResponder*)controller).nextResponder;
        if ([controller isKindOfClass:[UIViewController class]])
            break;
    }
    
    UIViewController *viewController = controller;
    [viewController presentViewController:picker animated:YES completion:nil];
    return true;
}

bool bptools::request_permission(int permission)
{
    if (permission == PERMISSION_PHOTO)
    {
        return true;
    }
    else if (permission == PERMISSION_MICROPHONE)
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (status == AVAuthorizationStatusAuthorized)
            return true;
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied)
            return false;
        if (status == AVAuthorizationStatusNotDetermined)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted){}];
            return false;
        }
        return true;
    }
    else{}
    return false;
}

static AVAudioRecorder* sthe_audio_recorder = nil;
static std::string      sstr_record_filename = "";
void bptools::record_sound_start(std::string filename, int handle)
{
    sstr_record_filename = filename;
    m_int_record_handle = handle;
    m_int_record_time = (unsigned int)time(0);
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSString* ptr_str_filename = [NSString stringWithUTF8String : filename.c_str()];
    NSURL *url = [NSURL fileURLWithPath:ptr_str_filename];
    
    NSMutableDictionary *setting=[NSMutableDictionary dictionary];
    [setting setObject:@(kAudioFormatAMR) forKey:AVFormatIDKey];
    [setting setObject:@(8000) forKey:AVSampleRateKey];
    [setting setObject:@(2) forKey:AVNumberOfChannelsKey];
    [setting setValue:[NSNumber numberWithInt:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    NSError *error = nil;
    sthe_audio_recorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
    [sthe_audio_recorder record];
    return;
}

std::string bptools::record_sound_finish(int handle)
{
    if (sthe_audio_recorder == 0)
        return "";
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [sthe_audio_recorder stop];
    [sthe_audio_recorder release];
    sthe_audio_recorder = 0;
    return sstr_record_filename;
}

bool bptools::get_wifi_status()
{
    return true;
}

int bptools::get_battery_status()
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double deviceLevel = [UIDevice currentDevice].batteryLevel;
    int battery = deviceLevel * 100;
    if (battery < 0)
        battery = 100;
    return battery;
}

std::string bptools::get_package_name()
{
    NSString* package = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return [package UTF8String];
}

bool bptools::get_install_status(std::string package)
{
    if (package.empty())
        return false;
    package += "://";
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithUTF8String:package.c_str()]]];
}

///////////////////////////////////////////////////////
// 文本分享
// title	string		分享标题(URLENCODE)
// message	string		分享内容(URLENCODE)
// icon		string		icon路径(可为url)
// url		string		分享连接
// type		int			分享类型（0:聊天 1:朋友圈）
///////////////////////////////////////////////////////
bool bptools::wechat_share_text(std::string unit, std::function<void(unsigned int code)> callback)
{
	m_the_wxshare_callback = callback;
	if (unit.empty())
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    if ([WXApi isWXAppInstalled] == NO)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
	Json::Reader the_reader;
	Json::Value the_value;
	if (the_reader.parse(unit.c_str(), the_value, true) == false)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    
    std::string str_title = url_decode(the_value["title"].asString());
    std::string str_message = url_decode(the_value["message"].asString());
    std::string str_icon = the_value["icon"].asString();
    std::string str_url = the_value["url"].asString();
    int int_type = the_value["type"].asInt();
    
	if (bptools::starts_with(str_icon, "http://") || bptools::starts_with(str_icon, "https://"))
	{
		std::string str_filename = "";
		str_filename += bptools::guid();
		str_filename += FileUtils::getInstance()->getFileExtension(str_icon);
		str_filename = get_share_global_data()->get_temp_filename(str_filename);
        the_value["icon"] = str_filename;
        unit = the_value.toStyledString();
        
		network::bpdownloadertask task;
		task.url = str_icon;
		task.filename = str_filename;
        task.identifier = bptools::guid();
		task.onTaskResult = [=](const network::bpdownloadertask& task, unsigned int code)
		{
            if (code == 0)
                wechat_share_text(unit, callback);
            else
                asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
		};
		network::bpdownloader::getInstance()->download(task);
        return true;
	}
        
    Data data = FileUtils::getInstance()->getDataFromFile(str_icon);
    if (data.isNull() == true)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }

    std::string str_filename = "";
    str_filename += bptools::guid();
    str_filename += FileUtils::getInstance()->getFileExtension(str_icon);
    str_filename = get_share_global_data()->get_temp_filename(str_filename);

    if (FileUtils::getInstance()->writeDataToFile(data, str_filename) == false)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    
    str_icon = str_filename;

    // 获取缩略图
    UIImage* image = [UIImage imageNamed:[NSString stringWithUTF8String : str_icon.c_str()]];
    unsigned int maxsize = 32 * 1024;
    int width = (int)image.size.width;
    int height = (int)image.size.height;
    UIImage* thumb = nil;
    while (true)
    {
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [image drawInRect:CGRectMake(0, 0, width, height)];
        UIImage* temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
            
        NSData* thumbdata = UIImagePNGRepresentation(temp);
        if (thumbdata == nil)
            break;
        if ([thumbdata length] * 1 < maxsize)
        {
            thumb = temp;
            break;
        }
        
        width = width / 2;
        height = height / 2;
        continue;
    }
    if (thumb == nil)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    WXWebpageObject *object = [WXWebpageObject object];
    object.webpageUrl = [NSString stringWithUTF8String : str_url.c_str()];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [NSString stringWithUTF8String : str_title.c_str()];
    message.description = [NSString stringWithUTF8String : str_message.c_str()];
    message.mediaObject = object;
    [message setThumbImage:thumb];
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = int_type;
    
    [WXApi sendReq:req];
    return true;
}

///////////////////////////////////////////////////////
// 图片分享
// image	string		图片地址，可为URL
// type		int			分享类型（0:聊天 1:朋友圈）
///////////////////////////////////////////////////////
bool bptools::wechat_share_image(std::string unit, std::function<void(unsigned int code)> callback)
{
    m_the_wxshare_callback = callback;
    if (unit.empty())
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    if ([WXApi isWXAppInstalled] == NO)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    Json::Reader the_reader;
    Json::Value the_value;
    if (the_reader.parse(unit.c_str(), the_value, true) == false)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    
    std::string str_image = url_decode(the_value["image"].asString());
    int int_type = the_value["type"].asInt();
    
    if (bptools::starts_with(str_image, "http://") || bptools::starts_with(str_image, "https://"))
    {
        std::string str_filename = "";
        str_filename += bptools::guid();
        str_filename += FileUtils::getInstance()->getFileExtension(str_image);
        str_filename = get_share_global_data()->get_temp_filename(str_filename);
        the_value["image"] = str_filename;
        unit = the_value.toStyledString();
        
        network::bpdownloadertask task;
        task.url = str_image;
        task.filename = str_filename;
        task.identifier = bptools::guid();
        task.onTaskResult = [=](const network::bpdownloadertask& task, unsigned int code)
        {
            if (code == 0)
                wechat_share_image(unit, callback);
            else
                asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        };
        network::bpdownloader::getInstance()->download(task);
        return true;
    }
    
    Data data = FileUtils::getInstance()->getDataFromFile(str_image);
    if (data.isNull() == true)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    
    std::string str_filename = "";
    str_filename += bptools::guid();
    str_filename += FileUtils::getInstance()->getFileExtension(str_image);
    str_filename = get_share_global_data()->get_temp_filename(str_filename);
    
    if (FileUtils::getInstance()->writeDataToFile(data, str_filename) == false)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    
    str_image = str_filename;
    
    // 获取缩略图
    UIImage* image = [UIImage imageNamed:[NSString stringWithUTF8String : str_image.c_str()]];
    unsigned int maxsize = 32 * 1024;
    int width = (int)image.size.width;
    int height = (int)image.size.height;
    UIImage* thumb = nil;
    while (true)
    {
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [image drawInRect:CGRectMake(0, 0, width, height)];
        UIImage* temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData* thumbdata = UIImagePNGRepresentation(temp);
        if (thumbdata == nil)
            break;
        if ([thumbdata length] * 1 < maxsize)
        {
            thumb = temp;
            break;
        }
        
        width = width / 2;
        height = height / 2;
        continue;
    }
    if (thumb == nil)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }

    WXImageObject* object = [WXImageObject object];
    [object setImageData:[NSData dataWithContentsOfFile:[NSString stringWithUTF8String : str_image.c_str()]]];
    
    WXMediaMessage* message = [WXMediaMessage message];
    message.title = nil;
    message.description = nil;
    message.mediaObject = object;
    [message setThumbImage:thumb];
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = int_type;
    
    [WXApi sendReq:req];
    return true;
}

///////////////////////////////////////////////////////
// 小程序分享
// title	string		标题
// message	string		正文
// url		string		
// username	string		
// image	string		图片(可以为URL)
// path		string		
// type		int			分享类型（0:聊天 1:朋友圈）
///////////////////////////////////////////////////////
bool bptools::wechat_share_program(std::string unit, std::function<void(unsigned int code)> callback)
{
    m_the_wxshare_callback = callback;
    if (unit.empty())
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    if ([WXApi isWXAppInstalled] == NO)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    Json::Reader the_reader;
    Json::Value the_value;
    if (the_reader.parse(unit.c_str(), the_value, true) == false)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    
    std::string str_title = url_decode(the_value["title"].asString());
    std::string str_message = url_decode(the_value["message"].asString());
    std::string str_url = the_value["url"].asString();
    std::string str_username = the_value["username"].asString();
    std::string str_image = the_value["image"].asString();
    std::string str_path = the_value["path"].asString();
    int int_type = the_value["image"].asInt();
    
    if (bptools::starts_with(str_image, "http://") || bptools::starts_with(str_image, "https://"))
    {
        std::string str_filename = "";
        str_filename += bptools::guid();
        str_filename += FileUtils::getInstance()->getFileExtension(str_image);
        str_filename = get_share_global_data()->get_temp_filename(str_filename);
        the_value["image"] = str_filename;
        unit = the_value.toStyledString();
        
        network::bpdownloadertask task;
        task.url = str_image;
        task.filename = str_filename;
        task.identifier = bptools::guid();
        task.onTaskResult = [=](const network::bpdownloadertask& task, unsigned int code)
        {
            if (code == 0)
                wechat_share_program(unit, callback);
            else
                asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        };
        network::bpdownloader::getInstance()->download(task);
        return true;
    }
    
    Data data = FileUtils::getInstance()->getDataFromFile(str_image);
    if (data.isNull() == true)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    
    std::string str_filename = "";
    str_filename += bptools::guid();
    str_filename += FileUtils::getInstance()->getFileExtension(str_image);
    str_filename = get_share_global_data()->get_temp_filename(str_filename);
    
    if (FileUtils::getInstance()->writeDataToFile(data, str_filename) == false)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    
    str_image = str_filename;
    
    // 获取缩略图
    UIImage* image = [UIImage imageNamed:[NSString stringWithUTF8String : str_image.c_str()]];
    unsigned int maxsize = 128 * 1024;
    int width = (int)image.size.width;
    int height = (int)image.size.height;
    UIImage* thumb = nil;
    while (true)
    {
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        [image drawInRect:CGRectMake(0, 0, width, height)];
        UIImage* temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData* thumbdata = UIImagePNGRepresentation(temp);
        if (thumbdata == nil)
            break;
        if ([thumbdata length] * 1 < maxsize)
        {
            thumb = temp;
            break;
        }
        
        width = width / 2;
        height = height / 2;
        continue;
    }
    if (thumb == nil)
    {
        asyn_event(0, HANDLE_TOOLS_CALLBACK_WXSHARE, S_FALSE, "");
        return true;
    }
    
    WXMiniProgramObject* object = [WXMiniProgramObject object];
    object.webpageUrl = [NSString stringWithUTF8String : str_url.c_str()];
    object.userName = [NSString stringWithUTF8String : str_username.c_str()];
    object.path = [NSString stringWithUTF8String : str_path.c_str()];
    object.hdImageData = UIImagePNGRepresentation(thumb);
    
    WXMediaMessage* message = [WXMediaMessage message];
    message.title = [NSString stringWithUTF8String : str_title.c_str()];
    message.description = [NSString stringWithUTF8String : str_message.c_str()];
    message.mediaObject = object;
    message.thumbData = nil;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = int_type;
    
    [WXApi sendReq:req];
    return true;
}

bool bptools::wechat_auth(std::function<void(unsigned int code, std::string data)> callback)
{
	m_the_wxauth_callback = callback;
    if ([WXApi isWXAppInstalled] == NO)
	{
	    asyn_event(0, HANDLE_TOOLS_CALLBACK_WXAUTH, S_FALSE, "");
		return true;
	}
    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"bookse";
    [WXApi sendReq:req];
    return true;
}

bool bptools::channel_logon(std::string unit, std::function<void(unsigned int code, std::string data)> callback)
{
	m_the_logon_callback = callback;
	asyn_event(0, HANDLE_TOOLS_CALLBACK_LOGON, S_FALSE, "");
	return true;
}

bool bptools::channel_logout(std::string unit, std::function<void(unsigned int code, std::string data)> callback)
{
	m_the_logout_callback = callback;
	asyn_event(0, HANDLE_TOOLS_CALLBACK_LOGOUT, S_OK, "");
	return true;
}

bool bptools::channel_exit(std::string unit, std::function<void(unsigned int code, std::string data)> callback)
{
	m_the_exit_callback = callback;
	asyn_event(0, HANDLE_TOOLS_CALLBACK_EXIT, S_OK, "");
	return true;
}

std::string bptools::location()
{
	return "";
}
#endif
