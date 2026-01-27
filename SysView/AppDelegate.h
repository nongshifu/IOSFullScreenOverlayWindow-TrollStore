//
//  AppDelegate.h
//  SysView
//
//  Created by 十三哥 on 2026/1/27.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
/// 响应触摸的窗口
@property (nonatomic, strong) UIWindow *overlayWindowIsTouch;
/// 穿透触摸的窗口
@property (nonatomic, strong) UIWindow *overlayWindowNoTouch;

@end

