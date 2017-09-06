//
//  PlayerViewModel.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/23.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "PlayerViewModel.h"
#import "VideoContainerView.h"
#import "Masonry.h"

@interface PlayerViewModel ()

@end

@implementation PlayerViewModel

- (instancetype)initWithPlayingVideoModel:(VideoModel *)playingVideoModel
                       videoListViewModel:(VideoListViewModel *)videoListViewModel
                            selectedIndex:(NSInteger)selectedIndex {
    if (self = [super init]) {
        _playingVideoModel = playingVideoModel;
        _videoListViewModel = videoListViewModel;
        _currPlayingIndex = selectedIndex;
    }
    return self;
}

- (void)fullScreenHandlerForView:(VideoContainerView *)aView isFullScreen:(BOOL) isFullScreen {
    [aView removeFromSuperview];
    UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
    if (isFullScreen) {
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview:aView];
        [aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(keywindow);
        }];
        orientation = UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationLandscapeLeft;
    } else {
        [_owner.view addSubview:aView];
        [aView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(_owner.view);
            make.height.mas_equalTo(211);
        }];
        orientation = UIInterfaceOrientationPortrait;
    }
    [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
    aView.fullScreen = (orientation != UIInterfaceOrientationPortrait);
}

- (VideoModel *)nextVideoModel {
    VideoModel *next = nil;
    if (_currPlayingIndex + 1 < _videoListViewModel.listViewDataSource.count && _currPlayingIndex + 1 >= 0)
    {
        next = _videoListViewModel.listViewDataSource[_currPlayingIndex + 1];
    }
    return next;
}

@end
