//
//  AppDelegate.h
//  MediaPlayerUIDemo
//
//  Created by 王旭 on 2018/1/31.
//  Copyright © 2018年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL allowRotation;

@property (nonatomic, strong) SettingModel *settingModel;

@end

