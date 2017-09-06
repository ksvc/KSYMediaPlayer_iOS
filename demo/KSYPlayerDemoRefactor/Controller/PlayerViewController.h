//
//  PlayerViewController.h
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/22.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "BaseViewController.h"

@class PlayerViewModel, VideoContainerView;

@interface PlayerViewController : BaseViewController

@property (nonatomic, strong) VideoContainerView       *videoContainerView;

@property (nonatomic, copy) void(^willDisappearBlocked)(void);

- (instancetype)initWithPlayerViewModel:(PlayerViewModel *)playerViewModel;

- (void)stopSuspend;

- (void)pushFromSuspendHandler;

@end
