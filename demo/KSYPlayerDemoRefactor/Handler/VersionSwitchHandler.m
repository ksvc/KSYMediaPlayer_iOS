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
    AppDelegate *delegeate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegeate.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    delegeate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[KSYLiveVC alloc] init]];
    [delegeate.window makeKeyAndVisible];
}

+ (void)switchToNewVersion {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseNavigationController *baseNav = storyboard.instantiateInitialViewController;
    
    AppDelegate *delegeate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegeate.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    delegeate.window.rootViewController = baseNav;
    [delegeate.window makeKeyAndVisible];
}

@end
