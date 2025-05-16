//
//  TMAConfigDefine.h
//  TMFMiniAppSDK
//
//  Created by 石磊 on 2023/4/11.
//

#import <Foundation/Foundation.h>

//当前小程序缓存文件（临时数据）的默认最大值 200M
//The default maximum value of the current mini program cache file (temporary data) 200M
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_FileManager_Store_MaxSize;

//当前小程序用户数据的默认最大值 200M
//The default maximum value of current mini program user data 200M
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_FileManager_Usr_MaxSize;

//chooseVideo视频长度默认值
//chooseVideo video length default value
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_ChooseVideoMaxDuration;

//chooseVideo视频文件大小限制默认值,单位是M
//chooseVideo video file size limit default value, unit is M
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_ChooseVideoMaxFileSize;


//背景音频是否与其他音频混播，默认是1，设置成0后，不与其它混播
//Whether the background audio is mixed with other audio, the default is 1, when set to 0, it will not be mixed with other audio
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_BackgroundAudioMixWithOther;

//背景音频（仅在 iOS 生效）是否遵循静音开关，默认是0，设置为1之后，在静音模式下，无法播放声音
//Whether background audio (effective only on iOS) follows the mute switch, the default is 0, after setting it to 1, the sound cannot be played in mute mode
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_BackgroundAudioMuteSwitch;

//是否在小程序loading页显示胶囊,默认是1显示
//Whether to display the capsule on the mini program loading page, the default is 1 display
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_LoadingPageRightView;


//关闭按钮icon地址
//Close button icon path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_CloseButton;
//关闭按钮icon深色主题地址
//Close button icon dark theme path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_CloseButtonDark;

//主页按钮icon地址
//Home button icon path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_HomeButton;
//主页按钮icon深色主题地址
//Home button icon dark theme path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_HomeButtonDark;

//返回按钮icon地址
//Back button icon path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_BackButton;
//返回按钮icon深色主题地址
//Back button icon dark theme path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_BackButtonDark;

//更多按钮icon地址
//More button icon path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_MoreButton;
//更多按钮icon深色主题地址
//More button icon dark theme path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_MoreButtonDark;

//录音按钮icon地址
//Recording button icon path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_RecordButton;
//录音按钮icon深色主题地址
//Recording button icon dark theme path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_RecordButtonDark;

//胶囊部分背景图片地址
//Capsule part background image path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_MoreBackground;
//胶囊部分背景图片深色主题地址
//Capsule part background picture dark theme path
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_MoreBackgroundDark;


//app 可配置使用的虚拟域名，用于小程序页面加载及 request 请求 refer 配置
//App can configure the virtual domain name used for mini program page loading and request request refer configuration
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_Virtualdomainname;


//app 可配置webview组件页面中可使用http资源,1/0
//App can configure webview component page to use http resources,1/0
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_ATS_Allow_Arbitrary_Loads;


//app 可配置qapm上报,1/0
//App can configure qapm report,1/0
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_QAPM_Report;


//app 可配置webview组件加载页面时是否显示进度条,1/0，默认为0显示
//You can configure whether to display the progress bar when the webview component loads the page, 1/0, the default is 0 display
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_WebView_Progress_Hide;

//app 可配置webview组件加载页面时进度条显示颜色,默认值为：#5BC8F6
//You can configure the progress bar display color when the webview component loads a page,The default value is:#5BC8F6
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_WebView_Progress_ProgressTintColor;

//app 可配置webview组件加载页面时进度条未完成部分背景显示颜色,默认值为：#E4E4E4
//The app can configure the background color of the unfinished part of the progress bar when the webview component loads the page. The default value is: #E4E4E4
OBJC_EXTERN NSString* const TMA_SK_MINIAPP_WebView_Progress_TrackTintColor;
