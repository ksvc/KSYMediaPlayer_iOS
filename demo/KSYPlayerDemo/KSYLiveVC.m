//
//  FirstViewController.m
//  QYLive
//
//  Created by yiqian on 11/3/15.
//  Copyright (c) 2015 kingsoft. All rights reserved.
//

#import "KSYLiveVC.h"
#import "QRViewController.h"
#import "KSYPlayerVC.h"
#import "KSYProberVC.h"
#import "KSYMonkeyTestVC.h"
#import "KSYNetTrackerVC.h"
#import "KSYSQLite.h"
#import "KSYDBCreater.h"
#import "Masonry.h"
#import "VersionSwitchHandler.h"

@interface KSYLiveVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITextField     *_textFiled;
    UIButton        *_buttonQR;
    UITableView     *_ctrTableView;
    UITableView     *_addressTable;
    NSArray         *_controllers;
    CGFloat         _width;
    CGFloat         _height;
    NSMutableArray  *_addressMulArray;
}

@end

@implementation KSYLiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KSYDEMO";
    self.view.backgroundColor = [UIColor whiteColor];
    _addressMulArray = [[NSMutableArray alloc] init];
    //要播放的地址请通过addObject添加在这里
    [_addressMulArray addObject:@"rtmp://live.hkstv.hk.lxdns.com/live/hks"];
    [_addressMulArray addObject:@"PlayerRec.mp4"];
    [self initVariable];
    [self initLiveVCUI];
    [KSYDBCreater initDatabase];
    
    [self addNewVerButton];
}

- (void)addNewVerButton {
    UIButton *newVerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [newVerBtn setTitle:@"切换至新版" forState:UIControlStateNormal];
    [newVerBtn addTarget:self action:@selector(newVerBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newVerBtn];
    [newVerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 50));
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-20);
    }];
}

- (void)newVerBtnClicked {
    [VersionSwitchHandler switchToNewVersion];
}

- (UITextField *)addTextField{
    UITextField *text = [[UITextField alloc]init];
    text.delegate     = self;
    [self.view addSubview:text];
    text.layer.masksToBounds = YES;
    text.layer.borderWidth   = 1;
    text.layer.borderColor   = [UIColor blackColor].CGColor;
    text.layer.cornerRadius  = 2;
    return text;
}
- (UITableView *)addAddressTable{
    UITableView *table      = [self addTableView];
    return table;
}
- (UIBarButtonItem *)addBarButtonItemWithTitle:(NSString *)title action:(SEL)action{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.masksToBounds = YES;
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.borderColor   = [UIColor blackColor].CGColor;
    button.layer.borderWidth   = 1;
    button.layer.cornerRadius  = 5;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    return barButton;
}
- (void)addLeftNavigationBarButton{
    self.navigationItem.leftBarButtonItem = [self addBarButtonItemWithTitle:@"扫描二维码" action:@selector(scanQR)];
}

- (void)addRightNavigationBarButton{
    self.navigationItem.rightBarButtonItem = [self addBarButtonItemWithTitle:@"关闭键盘" action:@selector(closeKeyBoard)];
}

- (UITableView *)addTableView{
    UITableView *teble = [[UITableView alloc]init];
    teble.layer.masksToBounds = YES;
    teble.layer.borderColor   = [UIColor blackColor].CGColor;
    teble.layer.borderWidth   = 1;
    teble.delegate   = self;
    teble.dataSource = self;
    [self.view addSubview:teble];
    return teble;
}
- (void)initVariable{
    _width  = self.view.frame.size.width;
    _height = self.view.frame.size.height;
    _controllers = [NSArray arrayWithObjects:
                    @"播放demo",
                    @"文件格式探测",
                    @"播放自动化测试 ",
                    @"网络探测",
                    nil];
}


- (void)initFrame{
    
    CGFloat textX   = 1;
    CGFloat textY   = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat textWdh = _width-2;
    CGFloat textHgh = 30;
    CGRect textRect = CGRectMake(textX, textY, textWdh, textHgh);
    _textFiled.frame = textRect;
    
    CGFloat adTaY   = textY + textHgh;
    CGFloat adTaHgh = _height / 2 - adTaY;
    CGRect addressTableRect = CGRectMake(textX, adTaY, textWdh, adTaHgh);
    _addressTable.frame = addressTableRect;
    
    CGFloat tableX   = 1;
    CGFloat tableY   = _height / 2;
    CGFloat tableWdh = _width  - 2;
    CGFloat tableHgh = _height / 2;
    CGRect tableRect = CGRectMake(tableX, tableY, tableWdh, tableHgh);
    _ctrTableView.frame = tableRect;
}
- (void)initLiveVCUI{
    _textFiled    = [self addTextField];
    _addressTable = [self addAddressTable];
    _ctrTableView = [self addTableView];
    [self addLeftNavigationBarButton];
    [self addRightNavigationBarButton];
    [self initFrame];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _ctrTableView) {
        return _controllers.count;
    }else if(tableView == _addressTable){
        return _addressMulArray.count;
    }else{
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identify"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"identify"];
    }
    if (tableView == _ctrTableView) {
        cell.textLabel.text = _controllers[indexPath.row];
    }else if(tableView == _addressTable){
        cell.textLabel.text = _addressMulArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        UIView *cellView = [[UIView alloc]initWithFrame:cell.frame];
        cellView.backgroundColor = [UIColor grayColor];
        cell.backgroundView = cellView;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _ctrTableView) {
        NSURL *url = nil;
        if (_textFiled.text.length > 0) {
            NSLog(@"url:%@",_textFiled.text);
            [NSURL URLWithString:_textFiled.text];
            url = [NSURL URLWithString:_textFiled.text];
            NSString *scheme = [url scheme];
            if(!scheme)
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%s%@", NSHomeDirectory(), "/Documents/", _textFiled.text]];
        }
        UIViewController* vc = nil;
        if (indexPath.row == 0) {
            vc = [[KSYPlayerCfgVC alloc]initWithURL:url fileList:nil];
        }else if (indexPath.row == 1){
            vc = [[KSYProberVC alloc] initWithURL:url];
        }else if(indexPath.row == 2){
            vc = [[KSYMonkeyTestVC alloc] init];
        }
        else if (indexPath.row == 3){
            vc = [[KSYNetTrackerVC alloc]init];
        }
        
        if (vc){
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else if(tableView == _addressTable){
        _textFiled.text = _addressMulArray[indexPath.row];
        [_textFiled resignFirstResponder];
    }
}
#pragma mark 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _ctrTableView) {
        return @"控制器栏";
    }else if (tableView == _addressTable){
        return @"地址栏";
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (void)closeKeyBoard{
    [_textFiled resignFirstResponder];
    [[KSYSQLite sharedInstance]insertAddress:_textFiled.text];
}
- (void)scanQR{
    
    __weak __typeof(self)wself = self;
    
    QRViewController *QRview = [[QRViewController alloc]init];
    QRview.getQrCode = ^(NSString *stringQR){
        [wself showAddress:stringQR];
    };
    
    [self.navigationController pushViewController:QRview animated:YES];
}

- (void)showAddress:(NSString *)str{
    _textFiled.text = str;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textFiled resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)myReloadData{
    NSArray *addressArray = [[KSYSQLite sharedInstance] getAddress];
    for(NSDictionary *dic in addressArray){
        NSString *address = [dic objectForKey:@"address"];
        [_addressMulArray addObject:address];
    }
    [_addressTable reloadData];
}

@end
