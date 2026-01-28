//  Created by 十三哥 on 2026/1/27.
//  QQ:350722326 WX:shisange2026 git:http://github.com/nongshifu
//
#import "Window.h"
#import "objc/runtime.h"
@implementation Window

- (instancetype)initWithWindowScene:(UIWindowScene *)windowScene {
    self = [super initWithWindowScene:windowScene];
    if (self) {
    }
    return self;
}

- (BOOL)_ignoresHitTest {
    
    return YES;
}

@end
