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
@property (weak, nonatomic) IBOutlet UISwitch *showDebugLogSwitch;
@property (weak, nonatomic) IBOutlet UIButton *confirmConfigeButton;
@property (weak, nonatomic) IBOutlet UIButton *hardDecodeButton;
@property (weak, nonatomic) IBOutlet UIButton *softDecodeButton;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *aView = [[UIView alloc] init];
    self.tableView.tableFooterView = aView;
    [self defaultSettingHandler];
}

- (void)defaultSettingHandler {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SettingModel *model = delegate.settingModel;
    
    self.bufferTimeTextField.text = [NSString stringWithFormat:@"%zd", model.bufferTimeMax];
    self.bufferSizeTextField.text = [NSString stringWithFormat:@"%zd", model.bufferSizeMax];
    self.prepareTimeoutTextField.text = [NSString stringWithFormat:@"%zd", model.preparetimeOut];
    self.readTimeoutTextField.text = [NSString stringWithFormat:@"%zd", model.readtimeOut];
    self.loopPlaySwitch.on = model.shouldLoop;
    self.showDebugLogSwitch.on = model.showDebugLog;
    self.hardDecodeButton.selected = (model.videoDecoderMode == MPMovieVideoDecoderMode_Hardware);
    self.softDecodeButton.selected = (model.videoDecoderMode == MPMovieVideoDecoderMode_Software);
}

- (IBAction)popBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmAction:(id)sender {
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SettingModel *model = delegate.settingModel;
    model.videoDecoderMode = self.hardDecodeButton.selected ? MPMovieVideoDecoderMode_Hardware : MPMovieVideoDecoderMode_Software;
    model.bufferTimeMax = [[self.bufferTimeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    model.bufferSizeMax = [[self.bufferSizeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] doubleValue];
    model.preparetimeOut = [[self.prepareTimeoutTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
    model.readtimeOut = [[self.readTimeoutTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] integerValue];
    model.shouldLoop = self.loopPlaySwitch.on;
    model.showDebugLog = self.showDebugLogSwitch.on;
    
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
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
