//
//  AppDelegate.m
//  HookViewOnSpringBoard
//
//  Created by 十三哥 on 2026/1/20.
//

#import "AppDelegate.h"
#import "UIKitPrivate.h"
#import "Window.h"

@interface UIRootSceneWindow : UIWindow
@end

@implementation UIRootSceneWindow(hook)
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.backgroundColor = UIColor.clearColor.CGColor;
}
- (CGFloat)windowLevel {
    return 10000;
}
@end

@interface AppDelegate ()
// 强引用所有Scene的展示绑定器，每个标识对应一个，按需扩展
@property (nonatomic, strong) UIRootWindowScenePresentationBinder *binderForAAA; // 对应标识aaa
@property (nonatomic, strong) UIRootWindowScenePresentationBinder *binderForBBB; // 对应标识bbb
@end

extern void FBSystemShellInitialize(id block);

@implementation AppDelegate

#pragma mark - 通用方法：创建指定标识的悬浮Scene，返回其展示绑定器
- (UIRootWindowScenePresentationBinder *)createFloatingSceneWithIdentifier:(NSString *)sceneIdentifier {
    // 1. 获取全局Scene管理器
    FBSceneManager *sharedInstance = [FBSceneManager sharedInstance];
    
    // 2. 配置Scene定义（核心：设置唯一标识sceneIdentifier）
    FBSMutableSceneDefinition *definition = [FBSMutableSceneDefinition definition];
    definition.identity = [FBSSceneIdentity identityForIdentifier:sceneIdentifier]; // 每个Scene标识唯一
    definition.clientIdentity = [FBSSceneClientIdentity localIdentity];
    definition.specification = [UIApplicationSceneSpecification specification];
    
    // 3. 配置Scene基础参数（独立对象，不可复用）
    FBSMutableSceneParameters *parameters = [FBSMutableSceneParameters parametersForSpecification:definition.specification];
    UIMutableApplicationSceneSettings *settings = [UIMutableApplicationSceneSettings new];
    settings.displayConfiguration = UIScreen.mainScreen.displayConfiguration;
    settings.frame = [UIScreen.mainScreen _referenceBounds]; // 全屏展示，可按需修改
    settings.level = 1;
    settings.foreground = YES;
    settings.interfaceOrientation = UIInterfaceOrientationPortrait;
    settings.deviceOrientationEventsEnabled = YES;
    [settings.ignoreOcclusionReasons addObject:@"SystemApp"];
    parameters.settings = settings;
    
    // 4. 配置Scene客户端参数（独立对象，不可复用）
    UIMutableApplicationSceneClientSettings *clientSettings = [UIMutableApplicationSceneClientSettings new];
    clientSettings.interfaceOrientation = UIInterfaceOrientationPortrait;
    clientSettings.statusBarStyle = 0;
    parameters.clientSettings = clientSettings;
    
    // 5. 创建Scene实例
    FBScene *scene = [sharedInstance createSceneWithDefinition:definition initialParameters:parameters];
    
    // 6. 初始化该Scene的专属展示绑定器，绑定Scene
    UIRootWindowScenePresentationBinder *sceneBinder = [[UIRootWindowScenePresentationBinder alloc] initWithPriority:0 displayConfiguration:settings.displayConfiguration];
    [sceneBinder addScene:scene];
    
    return sceneBinder;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建根视图控制器
    UIViewController *rootVC1 = [[UIViewController alloc] init];
    UIViewController *rootVC2 = [[UIViewController alloc] init];
    
    // 手动创建第一个UIWindow（穿透触摸）
    self.overlayWindowIsTouch = [[Window alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.overlayWindowIsTouch.backgroundColor = UIColor.clearColor;
    self.overlayWindowIsTouch.windowLevel = 10000;
    self.overlayWindowIsTouch.rootViewController = rootVC1;
    self.overlayWindowIsTouch.hidden = NO;
    [self.overlayWindowIsTouch makeKeyAndVisible];
    
    // 手动创建第二个UIWindow（响应触摸）
    self.overlayWindowNoTouch = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.overlayWindowNoTouch.backgroundColor = UIColor.clearColor;
    self.overlayWindowNoTouch.windowLevel = 9999;
    self.overlayWindowNoTouch.rootViewController = rootVC2;
    self.overlayWindowNoTouch.hidden = NO;
    [self.overlayWindowNoTouch makeKeyAndVisible];
    
    
    FBSystemShellInitialize(^(id a){
        // 创建标识为aaa的Scene，绑定到专属binder
        self.binderForAAA = [self createFloatingSceneWithIdentifier:@"aaa"];
        // 创建标识为bbb的Scene，绑定到专属binder（直接调用通用方法，传入新标识即可）
        self.binderForBBB = [self createFloatingSceneWithIdentifier:@"bbb"];
        // 若需更多Scene，继续添加：self.binderForCCC = [self createFloatingSceneWithIdentifier:@"ccc"];
    });
    return YES;
}

#pragma mark - UISceneSession lifecycle
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
}

@end
