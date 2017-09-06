//
//  AppDelegate.h
//  KSYPlayerDemo
//
//  Created by zengfanping on 12/7/15.
//  Copyright © 2015 kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingModel.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL allowRotation;

@property (nonatomic, strong) SettingModel *settingModel;

@end

