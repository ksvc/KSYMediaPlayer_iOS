//
//  VodViewController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/22.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "VodViewController.h"
#import "VideoListViewModel.h"
#import "PlayerViewController.h"
#import "FlowLayout.h"
#import "Masonry.h"
#import "VideoCollectionViewCell.h"
#import "PlayerViewController.h"
#import "PlayerViewModel.h"
#import "Constant.h"
#import "VideoCollectionHeaderView.h"
#import "SuspendPlayView.h"
#import "VideoContainerView.h"
#import "QRViewController.h"
#import "VideoModel.h"
#import "UIView+Toast.h"

@interface VodViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, FlowLayoutDelegate>
@property (nonatomic, strong) VideoListViewModel        *videoListViewModel;
@property (nonatomic, strong) UICollectionView          *videoCollectionView;
@property (nonatomic, strong) VideoCollectionHeaderView *headerView;
@property (nonatomic, strong) PlayerViewController      *pvc;
@property (nonatomic, strong) SuspendPlayView           *suspendView;
@property (nonatomic, strong) UIView                    *clearView;
@property (nonatomic, assign) BOOL willAppearFromPlayerView;
@property (nonatomic, assign) BOOL isMoving;
@end


@implementation VodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self fetchDatasource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (_willAppearFromPlayerView) {
        [self.view addSubview:self.clearView];
        [self.view addSubview:self.suspendView];
        [self.clearView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        self.suspendView.frame = CGRectMake(0, 0, 200, 113);
        self.suspendView.center = self.view.center;
        
        [self.pvc.videoContainerView removeFromSuperview];
        [self.suspendView addSubview:self.pvc.videoContainerView];
        [self.suspendView sendSubviewToBack:self.pvc.videoContainerView];
        [self.pvc.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.suspendView);
        }];
        [self addChildViewController:self.pvc];
        [self.pvc.videoContainerView suspendHandler];
        self.willAppearFromPlayerView = NO;
        self.hasSuspendView = YES;
    }
}
- (IBAction)scanQRCodeAction:(id)sender {
    QRViewController *qrVC = [[QRViewController alloc] init];
    __weak typeof(qrVC) weakQRVC = qrVC;
    __weak typeof(self) weakSelf = self;
    qrVC.getQrCode = ^(NSString *stringQR) {
        typeof(weakQRVC) strongQRVC = weakQRVC;
        typeof(weakSelf) strongSelf = weakSelf;
        [strongQRVC dismissViewControllerAnimated:YES completion:nil];
        VideoModel *model = [[VideoModel alloc] init];
#warning 检测stringQR是否是合法的点播地址
        model.PlayURL = @[stringQR];
        [strongSelf didSelectedVideoHandler:model selectedIndex:-1];
    };
    [self presentViewController:qrVC animated:YES completion:nil];
}

- (void)fetchDatasource {
    NSURL *url = [NSURL URLWithString:@"https://appdemo.download.ks-cdn.com:8682/api/GetLiveUrl/2017-01-01?Option=2"];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    [self.view makeToastActivity:CSToastPositionCenter];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.view hideToastActivity];
        strongSelf.videoListViewModel = [[VideoListViewModel alloc] initWithJsonResponseData:data];
        [strongSelf.videoCollectionView reloadData];
        [strongSelf.headerView configeVideoModel:self.videoListViewModel.listViewDataSource.firstObject];
    }];
    [task resume];
}

- (void)setupUI {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.videoCollectionView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.height.mas_equalTo(197);
    }];
    [self.videoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(5);
        make.leading.trailing.bottom.equalTo(self.view);
    }];
}

- (UICollectionView *)videoCollectionView
{
    if (!_videoCollectionView)
    {
        _videoCollectionView = ({
            FlowLayout *flowLayout = [[FlowLayout alloc]init];
            flowLayout.delegate = self;
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            collectionView.scrollsToTop = NO;
            collectionView.alwaysBounceVertical = YES;
            [collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kVideoCollectionViewCellId];
            collectionView;
        });
    }
    return _videoCollectionView;
}

- (VideoCollectionHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"VideoCollectionHeaderView" owner:self options:nil].firstObject;
        __weak typeof(self) weakSelf = self;
        _headerView.tapBlock = ^{
            typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf didSelectedVideoHandler:strongSelf.videoListViewModel.listViewDataSource.firstObject selectedIndex:0];
        };
    }
    return _headerView;
}

- (SuspendPlayView *)suspendView  {
    if (!_suspendView) {
        _suspendView = [[NSBundle mainBundle] loadNibNamed:@"SuspendPlayView" owner:self options:nil].firstObject;
        [_suspendView.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSuspendHandler)];
        [_suspendView addGestureRecognizer:tap];
    }
    return _suspendView;
}

- (void)tapSuspendHandler {
    self.willAppearFromPlayerView = YES;
    self.hasSuspendView = NO;
    [self.pvc.videoContainerView removeFromSuperview];
    [self.pvc removeFromParentViewController];
    [self.suspendView removeFromSuperview];
    [self.clearView removeFromSuperview];
    [self.pvc pushFromSuspendHandler];
    [self.pvc.videoContainerView recoveryHandler];
    [self.navigationController pushViewController:self.pvc animated:YES];
}

- (UIView *)clearView {
    if (!_clearView) {
        _clearView = [[UIView alloc] init];
        _clearView.backgroundColor = [UIColor clearColor];
    }
    return _clearView;
}

- (void)closeButtonAction {
    [self.pvc.videoContainerView removeFromSuperview];
    [self.pvc removeFromParentViewController];
    [self.suspendView removeFromSuperview];
    [self.clearView removeFromSuperview];
    [self.pvc stopSuspend];
    self.pvc = nil;
    self.hasSuspendView = NO;
}

- (void)didSelectedVideoHandler:(VideoModel *)videoModel selectedIndex:(NSInteger)selectedIndex {
    if (!videoModel) {
        return;
    }
    PlayerViewModel *playerViewModel = [[PlayerViewModel alloc] initWithPlayingVideoModel:videoModel videoListViewModel:_videoListViewModel selectedIndex:selectedIndex];
    PlayerViewController *pvc = [[PlayerViewController alloc] initWithPlayerViewModel:playerViewModel];
    self.pvc = pvc;
    __weak typeof(self) weakSelf = self;
    pvc.willDisappearBlocked = ^{
        typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.willAppearFromPlayerView = YES;
    };
    [self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark - CollectionView Datasource and Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _videoListViewModel.listViewDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVideoCollectionViewCellId forIndexPath:indexPath];
    if (indexPath.row < self.videoListViewModel.listViewDataSource.count) {
        [cell configeWithVideoModel:self.videoListViewModel.listViewDataSource[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoModel *videoModel = nil;
    if (indexPath.row < self.videoListViewModel.listViewDataSource.count) {
        videoModel = self.videoListViewModel.listViewDataSource[indexPath.row];
    }
    if (videoModel) {
        [self didSelectedVideoHandler:videoModel selectedIndex:indexPath.row];
    }
}

#pragma mark --
#pragma mark - FlowLayoutDelegate

- (CGFloat)flowLayout:(FlowLayout *)flowLayout heightForRowAtIndexPath:(NSInteger )index itemWidth:(CGFloat)itemWidth {
    return kVideoCollectionViewCellHeight;
}

#pragma mark --
#pragma mark -- touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGPoint convertPoint = [self.view convertPoint:point toView:self.suspendView];
    if (convertPoint.x > 0 && convertPoint.y > 0) {
        self.isMoving = YES;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    if(!_isMoving){
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint current = [touch locationInView:self.view];
    CGPoint previous = [touch previousLocationInView:self.view];
    
    CGPoint center = self.suspendView.center;
    
    CGPoint offset = CGPointMake(current.x - previous.x, current.y - previous.y);
    
    if (center.x + offset.x >= 0 && center.x + offset.x <= self.view.frame.size.width &&
        center.y + offset.y >= 0 && center.y + offset.y <= self.view.frame.size.height - 64
        ) {
        self.suspendView.center = CGPointMake(center.x + offset.x, center.y + offset.y);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.isMoving = NO;
}

@end
