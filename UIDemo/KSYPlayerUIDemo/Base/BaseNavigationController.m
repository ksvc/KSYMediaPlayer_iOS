//
//  BaseNavigationController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/22.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "BaseNavigationController.h"
#import "VideoListShowController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self swipToPopback];
}

- (void)swipToPopback {
    id target = self.interactivePopGestureRecognizer.delegate;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    self.panGesture.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self.view addGestureRecognizer:self.panGesture];
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)sender {
    [self popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    
    if (translation.x < 0) {
        return NO;
    }
    
    BOOL isPanUnEnabled = NO;
    
    isPanUnEnabled = ([self.topViewController isKindOfClass:[VideoListShowController class]]);
    
    if ([self.topViewController isKindOfClass:[VideoListShowController class]] && ((VideoListShowController *)self.topViewController).hasSuspendView) {
        isPanUnEnabled = NO;
    }
    
    if (!isPanUnEnabled) {
        return NO;
    }
    
    return fabs(translation.x) > fabs(translation.y);
}


@end
