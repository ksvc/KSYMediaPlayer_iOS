//
//  ViewController.m
//
//  Created by yiqian on 11/3/15.
//  Copyright (c) 2015 kingsoft. All rights reserved.
//

#import "ViewController.h"
#import "KSYPlayerVC.h"
#import "KSYProberVC.h"
#import "MonkeyTestViewController.h"

@interface ViewController ()

@property KSYPlayerVC * playerVC;
@property KSYProberVC * proberVC;
@property MonkeyTestViewController * monkeyTestVC;
@property NSURL * url;
@end

@implementation ViewController{
    UIButton *btnPlay;
    UIButton *btnProbe;
    UIButton *btnNote;
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
    
   _url = [NSURL URLWithString:@"http://maichang.kssws.ks-cdn.com/upload20150716161913.mp4"];
//   _url = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
  // _url = [NSURL URLWithString:@"http://test.live.ksyun.com/live/sxm.flv"];
   //_url = [NSURL URLWithString:@"http://120.132.75.127/vod/mov/shilei_hw_rotate_error.mov"];
    //_url = [NSURL URLWithString:@"http://cxy.kss.ksyun.com/h265_56c1f0717c63f102.mp4"];
   //_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%s", NSHomeDirectory(), "/Documents/shilei_hw_rotate_error.mov"]];
    
    _playerVC   = [[KSYPlayerVC alloc] initWithURL:_url];
    _proberVC  =  [[KSYProberVC alloc] initWithURL:_url];
    
    _monkeyTestVC = [[MonkeyTestViewController alloc] init];
    
    [self layoutUI];
    
}

- (void) layoutUI {
    CGFloat wdt = self.view.bounds.size.width;
    CGFloat hgt = self.view.bounds.size.height;
    
    CGFloat btnWdt = wdt * 0.6;
    CGFloat btnHgt = 40;
    
    CGFloat xPos = (wdt - btnWdt) / 2;
    CGFloat yPos = (hgt - btnHgt*3) / 2 - btnHgt;
    btnPlay.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);

    yPos = (hgt - btnHgt*3) / 2  + btnHgt;
    btnProbe.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
    
    yPos = (hgt - btnHgt*3) / 2  + btnHgt * 3;
    btnNote.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
}

- (IBAction)onPlayer:(id)sender {
    [self presentViewController:_playerVC animated:true completion:nil];
}

- (IBAction)onProber:(id)sender {
    [self presentViewController:_proberVC animated:true completion:nil];
}

- (IBAction)onNote:(id)sender {
    [self presentViewController:_monkeyTestVC
                       animated:YES
                     completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
