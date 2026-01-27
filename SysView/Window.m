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
