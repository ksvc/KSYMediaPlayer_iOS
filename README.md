# KSY MediaPlayer iOS SDK使用手册

## 阅读对象 

本文档面向所有使用该SDK的开发人员, 测试人员等, 要求读者具有一定的iOS编程开发经验。

## 1.产品概述

金山云播放内核涵盖Android、iOS、Flash和浏览器插件四个平台，基于FFmpeg自主研发音视频媒体播放内核，作为一款全平台兼容的软件播放方案，金山云播放内核提供了跨终端平台的播放器SDK，以及开放的音视频播放、控制接口和完整的开源调用示例，不仅极大降低开发门槛，同时支持客户快速在多个平台发布产品。
KSY MediaPlayer iOS SDK是金山云播放内核官方推出的iOS平台上使用的软件开发工具包(SDK)，为iOS开发者提供简单、快捷的接口，帮助开发者实现iOS平台上的多媒体播放应用。

## 2.KSYMediaPlayer SDK 功能说明

* 与系统播放器MPMoviePlayerController接口一致，可以无缝快速切换至KSYMediaPlayer；
* 本地全媒体格式支持, 并对主流的媒体格式(mp4, avi, wmv, flv, mkv, mov, rmvb 等 )进行优化；
* 支持广泛的流式视频格式, HLS, RTMP, HTTP Rseudo-Streaming 等；
* 低延时直播体验，配合金山云推流sdk，可以达到全程直播稳定的4秒内延时；
* 实现快速满屏播放，为用户带来更快捷优质的播放体验；
* 版本适配支持iOS 7.0以上版本；
* 业内一流的H.265解码；
* 小于2M大小的超轻量级直播sdk；

## 3.运行环境

KSY MediaPlayer iOS SDK可运行于 iPhone/iPod Touch/iPad，支持 iOS 7.0 及以上版本; 支持 armv7/arm64以及虚拟机运行。

## 4.下载并安装SDK

### 4.1 Step1 下载SDK
KSYMediaPlayer的下载方法：
* 请使用金山云账户邮件向 taochuntang@kingsoft.com索取;
* 从github下载: https://github.com/ksvc/KSYMediaPlayer_iOS.git;
* 更新日志查看地址: https://github.com/ksvc/KSYMediaPlayer_iOS/releases;

解压缩后包含 demo、doc、framework、README.md 四个部分, 解压后的目录结构如下所示:
* domo/ 目录存放KSYPlayerDemo，双击打开KSYPlayerDemo.xcodeproj即可使用iOS示例工程，用于帮助开发都快速了解如何使用SDK。
* doc/ 目录存放接口参考文档，双击打开html/index.html即可看到相关appledoc风格的接口说明。
* framework/ 目录存放了KSYMediaPlayer.framework，该库支持armv7/arm64/x86_64和i386四种体系结构。
* README.md 即本文档。

### 4.2 Step2 集成framework
将金山云SDK解压后，将framework目录下KSYMediaPlayer.framework复制到项目下，选择需要集成的target，在target->Build Phases->Link Binary With Libraries下，将KSYMediaPlayer.framework添加进去，然后添加另外四个系统库：
* VideoToolbox.framework
* libstdc++.6.tbd 或者libstdc++.6.dylib
* libbz2.tbd 或者 libbz2.dylib
* libz.tbd 或者 libz.dylib

![framework集成](http://121.40.49.231/ksyun/media/ios_player_framework.png)

### 4.3 Step3 调用

1. 打开需要集成播放视频功能的视图源码PlayerViewController.m，把如下代码复制并粘贴到你将播放视频的位置，例如到播放按钮的方法中。 先导入头文件#import <KSYMediaPlayer/KSYMediaPlayer.h>

2. 初始化auth认证

需要从金山云获取的认证信息如下：
* appid
* ak
* sk

金山云将sk和当前时间进行了一次md5运行，用以保护开发者sk。
<pre>
//MD5函数请见demo
- (void)initKSYAuth
{
    NSString* time = [NSString stringWithFormat:@"%d",(int)[[NSDate date]timeIntervalSince1970]];
    NSString* sk = [NSString stringWithFormat:@"this_is_skey%@", time];
    NSString* sksign = [self MD5:sk];
    [[KSYPlayerAuth sharedInstance]setAuthInfo:@"this_is_appid" accessKey:@"this_is_ak" secretKeySign:sksign timeSeconds:time];
}
</pre>

3. 初始化player
初始化需要几个步骤：

* 准备需要视频播放的UIView；
* 新建player；
* 设置url；
* 调用prepareToPlay开始播放。由于已经设置shouldAutoplay为TRUE，则prepare完成后立即开始播放。

<pre>
    KSYMoviePlayerController *_player;
    UIView *videoView;
    _videoView = [[UIView alloc] init];
    _videoView.frame = CGRectMake( 0, 0,  self.view.bounds.size.width,  self.view.bounds.size.height);;
    _videoView.backgroundColor = [UIColor lightGrayColor];
    _player =    [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:@"http://121.42.58.232:8980/hls_test/1.m3u8"]];
    _player.controlStyle = MPMovieControlStyleNone;
    [_player.view setFrame: _videoView.bounds];  // player's frame must match parent's
    [_videoView addSubview: _player.view];
    _videoView.autoresizesSubviews = TRUE;
    _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _player.shouldAutoplay = TRUE;
    _player.scalingMode = MPMovieScalingModeAspectFit;
    [_player prepareToPlay];
</pre>
4. 设置监听
当前提供了四个Notification监听，分别可以获取如下信息：

* MPMediaPlaybackIsPreparedToPlayDidChangeNotification，完成Prepared;
* MPMoviePlayerPlaybackStateDidChangeNotification，播放器状态改变；
* MPMoviePlayerPlaybackDidFinishNotification，播放完成；
* MPMoviePlayerLoadStateDidChangeNotification，数据加载状态改变；
<pre>
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:nil];

</pre>
5. 销毁播放器
播放器在stop中完成内存释放，new一次KSYMoviePlayerController，需要stop一次。如果两者未配对调用，将引发内存泄露。
<pre>
        [_player stop];
</pre>

## 特性说明
当前下载版本为轻量级播放sdk，该版本有如下特性：

1. 支持h.264/h.265/aac/mp3编码格式；
2. 支持rtmp/hls/http-flv直播；
3. 支持hls和http点播，封装格式为mp4/flv/ts；

如有其他编码和封装格式，请直接联系金山云客服获取其他版本。

## 接口说明

[主要接口说明](https://github.com/ksvc/KSYMediaPlayer_iOS/wiki/%E6%8E%A5%E5%8F%A3%E8%AF%B4%E6%98%8E)

更详细的文档请见doc目录下的详细接口说明
