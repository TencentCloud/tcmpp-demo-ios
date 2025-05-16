//
//  TMAVideoViewDefine.h
//  Pods
//
//  Created by miniapptmf on 2021/2/3.
//

#ifndef TMAVideoViewDefine_h
#define TMAVideoViewDefine_h

typedef NS_ENUM(NSInteger, TMAVideoFullScreenState) {
    // 不是视频全屏状态
    // Not the video full screen state
    TMAVideoFullScreenStateNone,
    // 视频全屏竖屏
    // Video full screen vertical screen
    TMAVideoFullScreenStatePortrait,
    // 视频全屏横屏，home键在左
    // The video is full screen and horizontal, with the home button on the left
    TMAVideoFullScreenStateLandscapeLeft,
    // 视频全屏横屏，home键在右
    // The video is full screen and horizontal, with the home button on the right
    TMAVideoFullScreenStateLandscapeRight,
};

typedef NS_ENUM(NSInteger, MAVideoPlayerStatus) {
    MAVideoPlayerStatusUnknown              = 0,
    MAVideoPlayerStatusWaiting              = 1,
    MAVideoPlayerStatusPlay                 = 2,
    MAVideoPlayerStatusPause                = 3,
    MAVideoPlayerStatusStop                 = 4,
    MAVideoPlayerStatusSeeking              = 5,
    MAVideoPlayerStatusSeeked               = 6,
    MAVideoPlayerStatusTimeUpdate           = 7,
    MAVideoPlayerStatusEnded                = 8,
    MAVideoPlayerStatusError                = 9,
    MAVideoPlayerStatusLoadStart            = 10,
    MAVideoPlayerStatusLoadProgress         = 11,
    MAVideoPlayerStatusLoaded               = 12,
    MAVideoPlayerStatusLoadedMetaData       = 13,

    MAVideoPlayerStatusClickFullScreenBtn   = 14,
    MAVideoPlayerStatusClickDanmuBtn        = 15,
    MAVideoPlayerStatusFullScreenChange     = 16,
};

@protocol TMAVideoViewFullScreenProtocol <NSObject>

@optional
// 小程序
// mini program
- (void)switchVideoFullscreenWithState:(TMAVideoFullScreenState)state;
@optional
// 小游戏
// mini game
- (void)prepareVideoFullScreen:(BOOL)isFullScreen view:(UIView *)view orientation:(UIDeviceOrientation)orientation;
@optional

// 添加view到renderView
// @param view 子组件
// @param underGameView 是否置于游戏页面底部
// Add view to renderView
// @param view subcomponent
// @param underGameView whether to place it at the bottom of the game page
- (void)addViewToRenderView:(UIView *)view underGameView:(BOOL)underGameView;

@end


#endif /* TMAVideoViewDefine_h */
