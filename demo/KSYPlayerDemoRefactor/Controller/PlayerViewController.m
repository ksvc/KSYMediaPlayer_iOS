//
//  PlayerViewController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/22.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "PlayerViewController.h"
#import <KSYMediaPlayer/KSYMoviePlayerController.h>
#import <AVKit/AVKit.h>
#import "PlayerViewModel.h"
#import "VideoModel.h"
#import "VideoContainerView.h"
#import "SettingDataHandler.h"
#import "SettingModel.h"
#import "Masonry.h"
#import "PlayerTableViewCell.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "KSYUIVC.h"
#import "UpdateVolumeAndBrightView.h"
#import "RecordeViewController.h"

@interface PlayerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) PlayerViewModel          *playerViewModel;
@property (nonatomic, strong) KSYMoviePlayerController *player;
@property (nonatomic, strong) UITableView              *videoTableView;
@property (nonatomic, assign) int64_t   prepared_time;
@property (nonatomic, assign) int       fvr_costtime;
@property (nonatomic, assign) int       far_costtime;
@property (nonatomic, assign) NSTimeInterval playedTime;
@property (nonatomic, assign) BOOL  switchingDefination;
@property (nonatomic, strong) UpdateVolumeAndBrightView *volumeBrightControlView;
@property (nonatomic, strong) RecordeViewController     *recordeController;
@end

@implementation PlayerViewController

- (instancetype)initWithPlayerViewModel:(PlayerViewModel *)playerViewModel {
    if (self = [super init]) {
        _playerViewModel = playerViewModel;
        _playerViewModel.owner = self;
        _playedTime = 0;
    }
    return self;
}

- (void)dealloc {
    [self.player stop];
    [self.player removeObserver:self forKeyPath:@"currentPlaybackTime"];
    [self removeObserver:self forKeyPath:@"player"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [self addObserver:self forKeyPath:@"player" options:NSKeyValueObservingOptionNew context:nil];
    [self setupUI];
    [self setupPlayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = NO;
    if (self.willDisappearBlocked) {
        self.willDisappearBlocked();
    }
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL fullScreen = (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft);
    [self.playerViewModel fullScreenHandlerForView:self.videoContainerView isFullScreen:fullScreen];
}

- (VideoContainerView *)videoContainerView {
    if (!_videoContainerView) {
        __weak typeof(self) weakSelf = self;
        _videoContainerView = [[VideoContainerView alloc] initWithFullScreenBlock:^(BOOL isFullScreen){
            typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.playerViewModel fullScreenHandlerForView:strongSelf.videoContainerView isFullScreen:isFullScreen];
        }];
        _videoContainerView.backgroundColor = [UIColor brownColor];
    }
    return _videoContainerView;
}

- (UpdateVolumeAndBrightView *)volumeBrightControlView {
    if (!_volumeBrightControlView) {
        _volumeBrightControlView = [[UpdateVolumeAndBrightView alloc] init];
    }
    return _volumeBrightControlView;
}

- (UITableView *)videoTableView {
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _videoTableView.dataSource = self;
        _videoTableView.delegate = self;
        _videoTableView.rowHeight = 88;
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _videoTableView.backgroundColor = [UIColor blackColor];
        [_videoTableView registerNib:[UINib nibWithNibName:@"PlayerTableViewCell" bundle:nil] forCellReuseIdentifier:kPlayerTableViewCellId];
    }
    return _videoTableView;
}

- (void)setupUI {
    [self.view addSubview:self.videoTableView];
    [self.view addSubview:self.videoContainerView];
    
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.mas_equalTo(211);
    }];
    [self.videoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(212);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

- (void)pushFromSuspendHandler {
    [self.view addSubview:self.videoContainerView];
    [self.videoContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.mas_equalTo(211);
    }];
}

- (void)setupPlayer {
    //初始化播放器并设置播放地址
    self.player = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:_playerViewModel.playingVideoModel.PlayURL.firstObject] fileList:nil sharegroup:nil];
    [self setupObservers:_player];
    _player.controlStyle = MPMovieControlStyleNone;
    [self.videoContainerView addSubview: _player.view];
    [self.videoContainerView sendSubviewToBack:_player.view];
    [self.videoContainerView insertSubview:self.volumeBrightControlView aboveSubview:_player.view];
    
    __weak typeof(self) weakSelf = self;
    
    self.recordeController = [[RecordeViewController alloc] initWithPlayer:_player screenRecordeFinishedBlock:^{
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.videoContainerView sendSubviewToBack:strongSelf.volumeBrightControlView];
        [strongSelf.videoContainerView sendSubviewToBack:strongSelf.player.view];
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationPortrait) {
            [strongSelf.playerViewModel fullScreenHandlerForView:strongSelf.videoContainerView isFullScreen:NO];
        }
    }];
    
    self.videoContainerView.playStateBlock = ^(VCPlayHandlerState state) {
        typeof(weakSelf) strongSelf = weakSelf;
        if (state == VCPlayHandlerStatePause) {
            [strongSelf.player pause];
        } else if (state == VCPlayHandlerStatePlay) {
            [strongSelf.player play];
        }
    };
    self.videoContainerView.dragSliderBlock = ^(float progress){
        typeof(weakSelf) strongSelf = weakSelf;
        double seekPos = progress * strongSelf.player.duration;
        [strongSelf.player seekTo:seekPos accurate:YES];
    };
    self.videoContainerView.nextButtonBLock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        VideoModel *nextVideo = [strongSelf.playerViewModel nextVideoModel];
        if (nextVideo) {
            [strongSelf.player reload:[NSURL URLWithString:nextVideo.PlayURL.lastObject]];
            strongSelf.playerViewModel.playingVideoModel = nextVideo;
            [strongSelf.videoContainerView configeVideoModel:nextVideo];
            if (self.playerViewModel.currPlayingIndex < self.playerViewModel.videoListViewModel.listViewDataSource.count) {
                strongSelf.playerViewModel.currPlayingIndex += 1;
            } else {
                strongSelf.playerViewModel.currPlayingIndex = 0;
            }
        }
    };
    self.videoContainerView.definitionChoiceBlock = ^(VideoDefinitionType definition) {
        typeof(weakSelf) strongSelf = weakSelf;
        NSInteger definitionIndex = (NSInteger)definition;
        if (definitionIndex < strongSelf.playerViewModel.playingVideoModel.PlayURL.count && definitionIndex != strongSelf.playerViewModel.playingVideoModel.definitation.integerValue) {
            strongSelf.switchingDefination = YES;
            NSString *definitionUrl = strongSelf.playerViewModel.playingVideoModel.PlayURL[definitionIndex];
            [strongSelf.player reload:[NSURL URLWithString:definitionUrl]];
            strongSelf.playerViewModel.playingVideoModel.definitation = @(definition);
        }
    };
    self.videoContainerView.speedChoiceBlock = ^(float speed) {
        typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.player.playbackSpeed = speed;
    };
    self.videoContainerView.screenShotBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        UIImage *thumbnailImage = strongSelf.player.thumbnailImageAtCurrentTime;
        [KSYUIVC saveImageToPhotosAlbum:thumbnailImage];
    };
    self.videoContainerView.screenRecordeBlock = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.videoContainerView bringSubviewToFront:strongSelf.player.view];
        [strongSelf.videoContainerView bringSubviewToFront:strongSelf.volumeBrightControlView];
        [strongSelf.videoContainerView addSubview:strongSelf.recordeController.view];
        [strongSelf addChildViewController:strongSelf.recordeController];
        [strongSelf.recordeController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(strongSelf.videoContainerView);
        }];
        [strongSelf.recordeController startRecorde];
    };
    
    [self.videoContainerView configeVideoModel:self.playerViewModel.playingVideoModel];
    
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoContainerView);
    }];
    [_volumeBrightControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoContainerView);
    }];
    self.videoContainerView.autoresizesSubviews = TRUE;
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SettingModel *settingModel = delegate.settingModel;
    if (!settingModel) {
        settingModel = [[SettingModel alloc] init];
        delegate.settingModel = settingModel;
    }
    
    if(settingModel)
    {
        //设置播放参数
        _player.videoDecoderMode = settingModel.videoDecoderMode;
        _player.shouldLoop = settingModel.shouldLoop;
        _player.bufferTimeMax = settingModel.bufferTimeMax;
        _player.bufferSizeMax = settingModel.bufferSizeMax;
        [_player setTimeout:(int)settingModel.preparetimeOut readTimeout:(int)settingModel.readtimeOut];
    }
    NSKeyValueObservingOptions opts = NSKeyValueObservingOptionNew;
    [_player addObserver:self forKeyPath:@"currentPlaybackTime" options:opts context:nil];
    self.prepared_time = (long long int)([[NSDate date] timeIntervalSince1970] * 1000);
    [_player prepareToPlay];
}

- (void)registerObserver:(NSString *)notification player:(KSYMoviePlayerController*)player {
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(notification)
                                              object:player];
}

- (void)setupObservers:(KSYMoviePlayerController*)player
{
    [self registerObserver:MPMediaPlaybackIsPreparedToPlayDidChangeNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackStateDidChangeNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackDidFinishNotification player:player];
    [self registerObserver:MPMoviePlayerLoadStateDidChangeNotification player:player];
    [self registerObserver:MPMovieNaturalSizeAvailableNotification player:player];
    [self registerObserver:MPMoviePlayerFirstVideoFrameRenderedNotification player:player];
    [self registerObserver:MPMoviePlayerFirstAudioFrameRenderedNotification player:player];
    [self registerObserver:MPMoviePlayerSuggestReloadNotification player:player];
    [self registerObserver:MPMoviePlayerPlaybackStatusNotification player:player];
    [self registerObserver:MPMoviePlayerNetworkStatusChangeNotification player:player];
    [self registerObserver:MPMoviePlayerSeekCompleteNotification player:player];
}

#pragma mark -- public method

- (void)stopSuspend {
    [self.player stop];
}

#pragma mark --
#pragma mark - table dataSource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _playerViewModel.videoListViewModel.listViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlayerTableViewCellId];
    if (indexPath.row < _playerViewModel.videoListViewModel.listViewDataSource.count) {
        [cell configeWithVideoModel:_playerViewModel.videoListViewModel.listViewDataSource[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.playerViewModel.currPlayingIndex == indexPath.row) {
        return;
    }
    if (indexPath.row < _playerViewModel.videoListViewModel.listViewDataSource.count) {
        VideoModel *videoModel = _playerViewModel.videoListViewModel.listViewDataSource[indexPath.row];
        [self.player reload:[NSURL URLWithString:videoModel.PlayURL.firstObject]];
        self.playerViewModel.playingVideoModel = videoModel;
        self.playerViewModel.currPlayingIndex = indexPath.row;
        [self.videoContainerView configeVideoModel:self.playerViewModel.playingVideoModel];
    }
}

#pragma mark --
#pragma mark - notification handler

-(void)handlePlayerNotify:(NSNotification*)notify
{
    if (!_player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        if (self.switchingDefination) {
            [self.player seekTo:_playedTime accurate:YES];
            self.switchingDefination = NO;
        }
        [self.videoContainerView updateTotalPlayTime:_player.duration];
        if(_player.shouldAutoplay == NO)
            [_player play];
    }
    /*
    if (MPMoviePlayerPlaybackStateDidChangeNotification ==  notify.name) {
        NSLog(@"------------------------");
        NSLog(@"player playback state: %ld", (long)_player.playbackState);
        NSLog(@"------------------------");
    }
    if (MPMoviePlayerLoadStateDidChangeNotification ==  notify.name) {
        NSLog(@"player load state: %ld", (long)_player.loadState);
        if (MPMovieLoadStateStalled & _player.loadState) {
            NSLog(@"player start caching");
        }
        if (_player.bufferEmptyCount &&
            (MPMovieLoadStatePlayable & _player.loadState ||
             MPMovieLoadStatePlaythroughOK & _player.loadState)){
                NSLog(@"player finish caching");
                NSString *message = [[NSString alloc]initWithFormat:@"loading occurs, %d - %0.3fs",
                                     (int)_player.bufferEmptyCount,
                                     _player.bufferEmptyDuration];
                [self toast:message];
            }
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
        NSLog(@"player finish state: %ld", (long)_player.playbackState);
        NSLog(@"player download flow size: %f MB", _player.readSize);
        NSLog(@"buffer monitor  result: \n   empty count: %d, lasting: %f seconds",
              (int)_player.bufferEmptyCount,
              _player.bufferEmptyDuration);
    }
    if (MPMovieNaturalSizeAvailableNotification ==  notify.name) {
        NSLog(@"video size %.0f-%.0f, rotate:%ld\n", _player.naturalSize.width, _player.naturalSize.height, (long)_player.naturalRotate);
        if(((_player.naturalRotate / 90) % 2  == 0 && _player.naturalSize.width > _player.naturalSize.height) ||
           ((_player.naturalRotate / 90) % 2 != 0 && _player.naturalSize.width < _player.naturalSize.height))
        {
            //如果想要在宽大于高的时候横屏播放，你可以在这里旋转
        }
    }
    if (MPMoviePlayerFirstVideoFrameRenderedNotification == notify.name)
    {
        fvr_costtime = (int)((long long int)([self getCurrentTime] * 1000) - prepared_time);
        NSLog(@"first video frame show, cost time : %dms!\n", fvr_costtime);
    }
    if (MPMoviePlayerFirstAudioFrameRenderedNotification == notify.name)
    {
        far_costtime = (int)((long long int)([self getCurrentTime] * 1000) - prepared_time);
        NSLog(@"first audio frame render, cost time : %dms!\n", far_costtime);
    }
    if (MPMoviePlayerSuggestReloadNotification == notify.name)
    {
        NSLog(@"suggest using reload function!\n");
        if(!reloading)
        {
            reloading = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
                if (_player) {
                    NSLog(@"reload stream");
                    [_player reload:_reloadUrl flush:YES mode:MPMovieReloadMode_Accurate];
                }
            });
        }
    }
    if(MPMoviePlayerPlaybackStatusNotification == notify.name)
    {
        int status = [[[notify userInfo] valueForKey:MPMoviePlayerPlaybackStatusUserInfoKey] intValue];
        if(MPMovieStatusVideoDecodeWrong == status)
            NSLog(@"Video Decode Wrong!\n");
        else if(MPMovieStatusAudioDecodeWrong == status)
            NSLog(@"Audio Decode Wrong!\n");
        else if (MPMovieStatusHWCodecUsed == status )
            NSLog(@"Hardware Codec used\n");
        else if (MPMovieStatusSWCodecUsed == status )
            NSLog(@"Software Codec used\n");
        else if(MPMovieStatusDLCodecUsed == status)
            NSLog(@"AVSampleBufferDisplayLayer  Codec used");
    }
    if(MPMoviePlayerNetworkStatusChangeNotification == notify.name)
    {
        int currStatus = [[[notify userInfo] valueForKey:MPMoviePlayerCurrNetworkStatusUserInfoKey] intValue];
        int lastStatus = [[[notify userInfo] valueForKey:MPMoviePlayerLastNetworkStatusUserInfoKey] intValue];
        NSLog(@"network reachable change from %@ to %@\n", [self netStatus2Str:lastStatus], [self netStatus2Str:currStatus]);
    }
    if(MPMoviePlayerSeekCompleteNotification == notify.name)
    {
        NSLog(@"Seek complete");
    }
     */
}

#pragma mark --
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if([keyPath isEqual:@"currentPlaybackTime"]) {
        if (!self.switchingDefination) {
            self.playedTime = _player.currentPlaybackTime;
            [_videoContainerView updatePlayedTime:_player.currentPlaybackTime];
        }
    }
//    else if([keyPath isEqual:@"clientIP"])
//    {
//        NSLog(@"client IP is %@\n", [change objectForKey:NSKeyValueChangeNewKey]);
//    }
//    else if([keyPath isEqual:@"localDNSIP"])
//    {
//        NSLog(@"local DNS IP is %@\n", [change objectForKey:NSKeyValueChangeNewKey]);
//    }
    else if ([keyPath isEqualToString:@"player"]) {
        if (_player) {
            
        } else {
            
        }
    }
}

@end
