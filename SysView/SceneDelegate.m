//
//  SceneDelegate.m
//  HookViewOnSpringBoard
//
//  Created by 十三哥 on 2026/1/20.
//

#import "SceneDelegate.h"
#import "UIKitPrivate.h"
#import "ViewController.h"
#import "Window.h"
#import "AppDelegate.h"
@implementation UINavigationBar(forceFullHeightInLandscape)

- (BOOL)forceFullHeightInLandscape {
  return YES;
}

@end

@interface SceneDelegate (){
    FBSOrientationObserver *_orientationObserver;
}

@end

@implementation SceneDelegate



//  1. 通过UISceneDelegate来管理window
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    NSString * aaa = @"aaa";
    NSString * bbb = @"bbb";
    // 创建根视图控制器
    UIViewController *rootVC1 = [[UIViewController alloc] init];
    rootVC1.view.backgroundColor = [UIColor clearColor];
    UIViewController *rootVC2 = [[UIViewController alloc] init];
    rootVC2.view.backgroundColor = [UIColor clearColor];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([session.persistentIdentifier isEqual: NSBundle.mainBundle.bundleIdentifier]) {//手动启动
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        UIViewController *initialVC = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
        if (initialVC) {
            self.window.rootViewController = initialVC;
        } else {
            self.window.rootViewController = [[ViewController alloc] init];
        }
        
    }
    //使用带触摸的系统窗口UIWindow
    if ([session.persistentIdentifier isEqual: aaa]){
        
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        self.window.rootViewController = rootVC1;
        appDelegate.overlayWindowIsTouch = self.window;
    }
    //使用带穿透的自定义UIWindow
    if ([session.persistentIdentifier isEqual: bbb]){
        
        self.window = [[Window alloc] initWithWindowScene:windowScene];
        self.window.rootViewController = rootVC2;
        appDelegate.overlayWindowNoTouch = self.window;
        
    }
    self.window.frame = windowScene.coordinateSpace.bounds;
    
    [self.window makeKeyAndVisible];
    
    
    if ([session.persistentIdentifier isEqual: NSBundle.mainBundle.bundleIdentifier] || [session.persistentIdentifier isEqual: aaa] || [session.persistentIdentifier isEqual: bbb]) {
        _orientationObserver = [[FBSOrientationObserver alloc] init];
        __weak SceneDelegate *weakSelf = self;
        [_orientationObserver setHandler:^(FBSOrientationUpdate *orientationUpdate) {
            SceneDelegate *strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIInterfaceOrientation orientation = orientationUpdate.orientation;
                double duration = orientationUpdate.duration;
                [strongSelf.window _rotateWindowToOrientation:orientation updateStatusBar:true duration:duration skipCallbacks:false];
            });
        }];
    }
}



// SceneDelegate.m
- (void)sceneDidDisconnect:(UIScene *)scene {
    
}



- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
