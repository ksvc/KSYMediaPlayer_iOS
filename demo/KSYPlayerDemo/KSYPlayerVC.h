//
//  FirstViewController.h
//  QYLive
//
//  Created by yiqian on 11/3/15.
//  Copyright (c) 2015 qyvideo. All rights reserved.
//
#import <UIKit/UIKit.h>
#if USING_DYNAMIC_FRAMEWORK
#import <KSYMediaPlayerDy/KSYMediaPlayerDy.h>
#else
#import <KSYMediaPlayer/KSYMediaPlayer.h>
#endif
@interface KSYPlayerVC : UIViewController
- (instancetype)initWithURL:(NSURL *)url;
@end

