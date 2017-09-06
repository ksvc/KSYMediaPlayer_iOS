//
//  SettingViewController.m
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/24.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingModel.h"
#import "AppDelegate.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bufferTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *bufferSizeTextField;
@property (weak, nonatomic) IBOutlet UITextField *prepareTimeoutTextField;
@property (weak, nonatomic) IBOutlet UITextField *readTimeoutTextField;
@property (weak, nonatomic) IBOutlet UISwitch *loopPlaySwitch;
@property (weak, nonatomic) IBOutlet UIButton *confirmConfigeButton;
@property (weak, nonatomic) IBOutlet UIButton *hardDecodeButton;
@property (weak, nonatomic) IBOutlet UIButton *softDecodeButton;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *aView = [[UIView alloc] init];
    self.tableView.tableFooterView = aView;
}
- (IBAction)popBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 @property (nonatomic, assign) MPMovieVideoDecoderMode videoDecoderMode;
 
 @property (nonatomic, assign) NSTimeInterval bufferTimeMax;
 
 @property (nonatomic, assign) NSTimeInterval bufferSizeMax;
 
 @property (nonatomic, assign) NSInteger preparetimeOut;
 
 @property (nonatomic, assign) NSInteger readtimeOut;
 
 @property (nonatomic, assign) BOOL  shouldLoop;
 */
- (IBAction)confirmAction:(id)sender {
    SettingModel *model = [[SettingModel alloc] init];
    model.videoDecoderMode = self.hardDecodeButton.selected ? MPMovieVideoDecoderMode_Hardware : MPMovieVideoDecoderMode_Software;
    model.bufferTimeMax = [[self.bufferTimeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    model.bufferSizeMax = [[self.bufferSizeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    model.preparetimeOut = [[self.prepareTimeoutTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
    model.readtimeOut = [[self.readTimeoutTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
    model.shouldLoop = self.loopPlaySwitch.on;

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.settingModel = model;
    [self hideKeyboard];
}
- (IBAction)hardDecodeAction:(id)sender {
    self.hardDecodeButton.selected = YES;
    self.softDecodeButton.selected = NO;
}
- (IBAction)softDecodeAction:(id)sender {
    self.hardDecodeButton.selected = NO;
    self.softDecodeButton.selected = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [self.bufferTimeTextField endEditing:YES];
    [self.bufferSizeTextField endEditing:YES];
    [self.prepareTimeoutTextField endEditing:YES];
    [self.readTimeoutTextField endEditing:YES];
}

@end
