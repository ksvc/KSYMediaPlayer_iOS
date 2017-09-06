//
//  VersionSwitchHandler.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/22.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "VersionSwitchHandler.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "KSYLiveVC.h"
#import "ChoiceViewController.h"

@implementation VersionSwitchHandler

+ (void)switchToOldVersion {
    [self setRootViewControllerForClass:[KSYLiveVC class]];
}

+ (void)switchToNewVersion {
    [self setRootViewControllerForClass:[ChoiceViewController class]];
}

+ (void)setRootViewControllerForClass:(Class)class {
    AppDelegate *delegeate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegeate.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    delegeate.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[class alloc] init]];
    [delegeate.window makeKeyAndVisible];
}

@end
