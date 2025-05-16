//
//  TMACustomVideoPlayerProtocol.h
//  TMFMiniAppSDK
//
//  Created by 许加文 on 2023/11/7.
//

#import <UIKit/UIKit.h>
#import <TCMPPSDK/TMAVideoViewDefine.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TMAVideoPlayerDelegate <NSObject>

@property(nonatomic, strong) NSString *tmaVideoPlayerCurrentURL; //播放地址
/*
 tmaVideoPlayerHostVC 用于记录videoPlayer所在的VC，通常是WebView，以在进入、退出全屏时进行相关操作，你只需要在你的customPlayer中加上 @synthesize tmaVideoPlayerHostVC;
 不需要进行其他操作.
 tmaVideoPlayerHostVC is used to record the VC where the videoPlayer is located, usually WebView, to perform related operations when entering and exiting full screen. You only need to add @synthesize tmaVideoPlayerHostVC to your customPlayer;
 No other operations are required.
 */
@property(nonatomic, weak)   UIViewController<TMAVideoViewFullScreenProtocol> *tmaVideoPlayerHostVC;
// 封面地址
// cover address
@property(nonatomic, strong) NSString *tmaVideoPlayerPosterUrl;
// 指定视频初始播放位置
// Specify the initial playback position of the video
@property(nonatomic, assign) CGFloat tmaVideoPlayerInitialTime;
// 是否显示控制按钮
// Whether to display control buttons
@property(nonatomic, assign) BOOL tmaVideoPlayerShowControls;
// 是否重复播放
// Whether to repeat playback
@property(nonatomic, assign) BOOL tmaVideoPlayerRepeat;
// 是否静音
// Whether to mute
@property(nonatomic, assign) BOOL tmaVideoPlayerIsMuted;
// 控制videoGravity、contentsGravity 和 poster 的 contentMode 有三种值：contain、fill、cover
// The contentMode that controls videoGravity, contentsGravity and poster has three values: contain, fill, cover
@property(nonatomic, strong) NSString *tmaVideoPlayerObjectFitMode;
// 全屏方向 有三种值：0 UIInterfaceOrientationPortrait, 90 UIInterfaceOrientationLandscapeRight, -90 UIInterfaceOrientationLandscapeLeft
// Full screen orientation has three values: 0 UIInterfaceOrientationPortrait, 90 UIInterfaceOrientationLandscapeRight, -90 UIInterfaceOrientationLandscapeLeft
@property(nonatomic, strong) NSNumber *tmaVideoPlayerFullscreenDirection;
// 是否支持双击暂停/播放
// Whether to support double-click to pause/play
@property(nonatomic, assign) BOOL tmaVideoPlayerEnablePlayGesture;
// 全屏时左上角的标题
// Title in the upper left corner of full screen
@property(nonatomic, strong) NSString *tmaVideoPlayerFullscreenTitle;
// 是否显示进度条
// Whether to display the progress bar
@property(nonatomic, assign) BOOL tmaVideoPlayerShowProgress;
// 是否显示全屏按钮
// Whether to display the full screen button
@property(nonatomic, assign) BOOL tmaVideoPlayerShowFullscreenBtn;
// 是否显示底部控制栏的播放按钮
// Whether to display the play button of the bottom control bar
@property(nonatomic, assign) BOOL tmaVideoPlayerShowPlayBtn;
// 是否显示中间播放按钮
// Whether to display the middle play button
@property(nonatomic, assign) BOOL tmaVideoPlayerShowCenterPlayButton;
// 播放按钮的位置bottom or center(默认bottom)
// The position of the play button: bottom or center (default: bottom)
@property(nonatomic, assign) NSString *tmaVideoPlayerPlayBtnPosition;
// 是否显示静音按钮
// Whether to display the mute button
@property(nonatomic, assign) BOOL tmaVideoPlayerShowMuteButton;
// 是否支持进度调整手势
// Whether progress adjustment gestures are supported
@property(nonatomic, assign) BOOL tmaVideoPlayerEnableProgressGesture;
// 非全屏是否开启音量、亮度调节手势
// Whether to enable volume and brightness adjustment gestures in non-full screen mode
@property(nonatomic, assign) BOOL tmaVideoPlayerPageGestureWhenNotFullscreen;
@property(nonatomic, strong) NSArray *tmaVideoPlayerDanmuList;
// 是否自动播放
// Whether to play automatically
@property(nonatomic, assign) BOOL tmaVideoPlayerAutoPlay;
// 是否允许后台播放
// Whether to allow background playback
@property(nonatomic, assign) BOOL tmaVideoPlayerBackgroundPlayback;
// 是否开启画中画
// Whether to enable picture-in-picture
@property(nonatomic, assign) BOOL tmaVideoPlayerIsPictureInPicture;
// 记录是否是全屏状态
// Record whether it is full screen state
@property(nonatomic, assign) BOOL tmaVideoPlayerIsFullScreen;
// 是否自动转屏进入全屏
// Whether to automatically turn the screen into full screen
@property(nonatomic, assign) BOOL tmaVideoPlayerEnableAutoRotation;
// 在非全屏模式下，是否开启亮度与音量调节手势（默认NO）
// In non-full screen mode, whether to enable brightness and volume adjustment gestures (default NO)
@property(nonatomic, assign) BOOL tmaVideoPlayerVslideGesture;
// 在全屏模式下，是否开启亮度与音量调节手势（默认YES）
// In full screen mode, whether to enable brightness and volume adjustment gestures (default YES)
@property(nonatomic, assign) BOOL tmaVideoPlayerVslideGestureInFullscreen;
// 当跳转到本小程序的其他页面时，是否自动暂停本页面的视频播放（默认YES）
// When jumping to other pages of this applet, whether to automatically pause the video playback of this page (default YES)
@property(nonatomic, assign) BOOL tmaVideoPlayerAutoPauseIfNavigate;
// 当跳转到其它App原生页面时，是否自动暂停本页面的视频（默认YES）
// When jumping to other App native pages, whether to automatically pause the video of this page (default YES)
@property(nonatomic, assign) BOOL tmaVideoPlayerAutoPauseIfOpenNative;
// 指定视频时长
// Specify video duration
@property(nonatomic, assign) CGFloat tmaVideoPlayerDuration;

/*
 用于向小程序端发送播放器事件
 Used to send player events to the applet
 */
@property(nonatomic, strong) void(^ _Nullable tmaVideoPlayerStatusBlock)(MAVideoPlayerStatus status, NSDictionary * _Nullable params);
// 播放
// play
- (void)tmaVideoPlayerPlay;
// 暂停
// pause
- (void)tmaVideoPlayerPause;
// 停止
// stop
- (void)tmaVideoPlayerStop;
// 调整播放进度
// Adjust playback progress
- (void)tmaVideoPlayerSeekDuration:(CGFloat)duration;
// 播放速率
// playback rate
- (void)tmaVideoPlayerPlayBackRate:(CGFloat)rate;
// 进入全屏
// Enter full screen
- (void)tmaVideoPlayerEnterFullScreen;
// 退出全屏
// Exit Full Screen
- (void)tmaVideoPlayerExitFullScreen;
// 全屏时是否显示系统状态栏
// Whether to display the system status bar when full screen
- (void)tmaVideoPlayerShowStatusBar:(BOOL)show;
// 插入弹幕
// Insert barrage
- (void)tmaVideoPlayerInsertDanmuText:(NSString *_Nonnull)content color:(NSString *_Nonnull)colorStr;
// 打断播放
// interrupt playback
- (void)tmaVideoPlayerInterruptPlay;
// 恢复播放
// Resume playback
- (void)tmaVideoPlayerResumePlay;
// 页面消失时的暂停
// Pause when the page disappears
- (void)tmaVideoPlayerPauseWhenDiappear;
// 页面恢复时的播放
// Playback when page is restored
- (void)tmaVideoPlayerPlayWhenAppear;
// 是否支持后台播放
// Whether to support background playback
- (void)tmaVideoPlayerRequestBackgroundPlayback:(BOOL)state;

@end

NS_ASSUME_NONNULL_END
