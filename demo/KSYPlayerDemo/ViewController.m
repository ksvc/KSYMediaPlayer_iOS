//
//  ViewController.m
//
//  Created by yiqian on 11/3/15.
//  Copyright (c) 2015 kingsoft. All rights reserved.
//

#import "ViewController.h"
#import "KSYPlayerVC.h"
#import "KSYProberVC.h"
#import "KSYNetTrackerVC.h"
#import "KSYMonkeyTestVC.h"

#import "KSYPlayerCfgVC.h"

@interface ViewController ()

//配置控制器
@property KSYPlayerCfgVC *playerCfgVC;
@property KSYPlayerVC * playerVC;
@property KSYProberVC * proberVC;//格式探测
@property KSYMonkeyTestVC * monkeyTestVC;
@property KSYNetTrackerVC * netTrackerVC;//跟踪器
@property NSURL * url;
@end

@implementation ViewController{
    UIButton *btnPlay;//播放
    UIButton *btnProbe;//探测格式
    UIButton *btnNote;
    UIButton *btnNet;//网络探测
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
}

- (BOOL)shouldAutorotate {
    [self layoutUI];
    return YES;
}

- (void)initUI{
    btnPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPlay setTitle:@"播放demo" forState: UIControlStateNormal];
    btnPlay.backgroundColor = [UIColor lightGrayColor];
    [btnPlay addTarget:self action:@selector(onPlayer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPlay];
    
    btnProbe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnProbe setTitle:@"格式探测demo" forState: UIControlStateNormal];
    btnProbe.backgroundColor = [UIColor lightGrayColor];
    [btnProbe addTarget:self action:@selector(onProber:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnProbe];
    
    btnNote = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnNote setTitle:@"Monkey Test" forState: UIControlStateNormal];
    btnNote.backgroundColor = [UIColor lightGrayColor];
    [btnNote addTarget:self action:@selector(onNote:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNote];
    
    btnNet = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnNet setTitle:@"网络探测" forState: UIControlStateNormal];
    btnNet.backgroundColor = [UIColor lightGrayColor];
    [btnNet addTarget:self action:@selector(onNet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNet];
    
   _url = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
   //_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%s", NSHomeDirectory(), "/Documents/IMG_0676.MOV"]];

    [self layoutUI];
}

- (void) layoutUI {
    CGFloat wdt = self.view.bounds.size.width;
    CGFloat hgt = self.view.bounds.size.height;
    
    CGFloat btnWdt = wdt * 0.6;
    CGFloat btnHgt = 40;
    CGFloat yGap = 40;
    
    CGFloat xPos = (wdt - btnWdt) / 2;
    CGFloat yPos = hgt / 4;
    btnPlay.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);

    yPos += (btnHgt + yGap);
    btnProbe.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
    
    yPos += (btnHgt + yGap);
    btnNote.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
    
    yPos += (btnHgt + yGap);
    btnNet.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
}

- (IBAction)onPlayer:(id)sender {//先弹出配置控制器
    _playerCfgVC = [[KSYPlayerCfgVC alloc] initWithURL:_url fileList:nil];
    [self presentViewController:_playerCfgVC animated:true completion:nil];
}

- (IBAction)onProber:(id)sender {
    _proberVC  =  [[KSYProberVC alloc] initWithURL:_url];
    [self presentViewController:_proberVC animated:true completion:nil];
}

- (IBAction)onNote:(id)sender {
    _monkeyTestVC = [[KSYMonkeyTestVC alloc] init];
    [self presentViewController:_monkeyTestVC animated:YES completion:nil];
}

- (IBAction)onNet:(id)sender {
    _netTrackerVC = [[KSYNetTrackerVC alloc] init];
    [self presentViewController:_netTrackerVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
