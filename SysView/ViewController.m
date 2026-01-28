//
//  ViewController.m
//  HookViewOnSpringBoard
//
//  Created by 十三哥 on 2026/1/20.
//  QQ:350722326 WX:shisange2026 git:http://github.com/nongshifu
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 300, 30)];
    titleLabel.text = @"覆盖控制器测试";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    // 创建添加到穿透触摸窗口的按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.backgroundColor = [UIColor blueColor];
    button1.frame = CGRectMake(50, 100, 300, 50);
    [button1 setTitle:@"添加视图到触摸窗口" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(addViewToOverlayWindow1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    // 创建添加到响应触摸窗口的按钮
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.backgroundColor = [UIColor greenColor];
    button2.frame = CGRectMake(50, 170, 300, 50);
    [button2 setTitle:@"添加视图到穿透触摸窗口" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(addViewToOverlayWindow2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

- (void)addViewToOverlayWindow1 {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 150, 150)];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [appDelegate.overlayWindowIsTouch addSubview:view];
    

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.text = @"响应触摸";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
}

- (void)addViewToOverlayWindow2 {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 150, 150)];
    view.backgroundColor = [UIColor orangeColor];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [appDelegate.overlayWindowNoTouch addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    label.text = @"穿透触摸";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
}

@end
