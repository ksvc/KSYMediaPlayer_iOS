//
//  ViewController.m
//
//  Created by yiqian on 11/3/15.
//  Copyright (c) 2015 kingsoft. All rights reserved.
//

#import "ViewController.h"
#import "KSYPlayerVC.h"

@interface ViewController ()

@property KSYPlayerVC * playerVC;
@property NSURL * url;
@end

@implementation ViewController{
    UIButton *btnPlay;
    
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
    
    _url = [NSURL URLWithString:@"http://kssws.ks-cdn.com/zjtestbuket1/%E9%98%85%E8%AF%BB%E6%95%B0%E5%8A%9F%E8%83%BD%E9%94%99%E8%AF%AF.mp4"];
    
    _url = [NSURL URLWithString:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
    //_url = [NSURL URLWithString:@"http://eflakee.kss.ksyun.com/Catch%20Me%20If%20You%20Can.m4v"];
    //_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%s", NSHomeDirectory(), "/Documents/2.mp4"]];
    _playerVC   = [[KSYPlayerVC alloc] initWithURL:_url];

    [self layoutUI];
    
}

- (void) layoutUI {
    CGFloat wdt = self.view.bounds.size.width;
    CGFloat hgt = self.view.bounds.size.height;
    
    CGFloat btnWdt = wdt * 0.6;
    CGFloat btnHgt = 40;
    CGFloat xPos = (wdt - btnWdt) / 2;
    CGFloat yPos = (hgt - btnHgt*3) / 2;
    btnPlay.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);;    
}

- (IBAction)onPlayer:(id)sender {
    [self presentViewController:_playerVC animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
