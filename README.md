# KSY MediaPlayer iOS SDK使用手册

## 阅读对象  
<br/>
&#160; &#160; &#160; &#160;本文档面向所有使用该SDK的开发人员, 测试人员等, 要求读者具有一定的iOS编程开发经验。

## 1. 概述  
<br/>
&#160; &#160; &#160; &#160;金山云播放内核涵盖Android、iOS、Flash和浏览器插件四个平台，基于FFmpeg自主研发音视频媒体播放内核，作为一款全平台兼容的软件播放方案，金山云播放内核提供了跨终端平台的播放器SDK，以及开放的音视频播放、控制接口和完整的开源调用示例，不仅极大降低开发门槛，同时支持客户快速在多个平台发布产品。
KSY MediaPlayer iOS SDK是金山云播放内核官方推出的iOS平台上使用的软件开发工具包(SDK)，为iOS开发者提供简单、快捷的接口，帮助开发者实现iOS平台上的多媒体播放应用。

## 2. KSYMediaPlayer SDK 功能说明

* 与系统播放器MPMoviePlayerController接口一致，可以无缝快速切换至KSYMediaPlayer；
* 本地全媒体格式支持, 并对主流的媒体格式(mp4, avi, wmv, flv, mkv, mov, rmvb 等 )进行优化；
* 支持广泛的流式视频格式, HLS, RTMP, HTTP Rseudo-Streaming 等；
* 低延时直播体验，配合金山云推流sdk，可以达到全程直播稳定的4秒内延时；
* 实现快速满屏播放，为用户带来更快捷优质的播放体验；
* 版本适配支持iOS 7.0以上版本；
* 业内一流的H.265解码；
* 小于2M大小的超轻量级直播sdk；

## 3. 运行环境
<br/>
&#160; &#160; &#160; &#160;KSY MediaPlayer iOS SDK可运行于 iPhone/iPod Touch/iPad，支持 iOS 7.0 及以上版本; 支持 armv7/arm64以及虚拟机运行。

## 4. 开发指南

### 4.1 Step1 下载SDK  
<br/>
&#160; &#160; &#160; &#160;KSYMediaPlayer的下载方法：

* 从github下载: [https://github.com/ksvc/KSYMediaPlayer_iOS.git](https://github.com/ksvc/KSYMediaPlayer_Android.git);
* 更新日志查看地址: [https://github.com/ksvc/KSYMediaPlayer_iOS/releases](https://github.com/ksvc/KSYMediaPlayer_Android.git);

&#160; &#160; &#160; &#160;解压缩后包含 demo、doc、framework、README.md 四个部分, 解压后的目录结构如下所示:  

* domo/ 目录存放KSYPlayerDemo，双击打开KSYPlayerDemo.xcodeproj即可使用iOS示例工程，用于帮助开发都快速了解如何使用SDK。  
* doc/ 目录存放接口参考文档，双击打开html/index.html即可看到相关appledoc风格的接口说明。 
* framework/ 目录存放了KSYMediaPlayer.framework，该库支持armv7/arm64/x86_64和i386四种体系结构。 
* README.md 即本文档。

### 4.2 Step2 集成framework
<br/>
&#160; &#160; &#160; &#160;将金山云SDK解压后，将framework目录下KSYMediaPlayer.framework复制到项目下，选择需要集成的target，在target->Build Phases->Link Binary With Libraries下，将KSYMediaPlayer.framework添加进去，然后添加另外四个系统库：

* VideoToolbox.framework
* libstdc++.6.tbd 或者libstdc++.6.dylib
* libbz2.tbd 或者 libbz2.dylib
* libz.tbd 或者 libz.dylib

![framework集成](http://ksy.vcloud.sdk.ks3-cn-beijing.ksyun.com/picture/ios_player_framework.png)

### 4.3 Step3 调用
</br>
&#160; &#160; &#160; &#160;打开需要集成播放视频功能的视图源码，把如下代码复制并粘贴到你将播放视频的位置，例如到播放/停止按钮的方法中。  

1. 先导入头文件#import <KSYMediaPlayer/KSYMediaPlayer.h>  

2. 初始化player   
</br>
初始化需要几个步骤：

	* 准备需要视频播放的UIView;
	
	* 新建player;
	
	* 设置url;
	
	* 调用[prepareToPlay](#prepareToPlay)开始播放。由于已经设置[shouldAutoplay](#shouldAutoplay)为TRUE，则prepare完成后立即开始播放。 
   
 	```
   KSYMoviePlayerController *_player;
   UIView *videoView;
   _videoView = [[UIView alloc] init];
   _videoView.frame = CGRectMake( 0, 0,  self.view.bounds.size.width,  self.view.bounds.size.height);
   _videoView.backgroundColor = [UIColor lightGrayColor];
   _player = [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:@"http://121.42.58.232:8980/hls_test/1.m3u8"]];
   _player.controlStyle = MPMovieControlStyleNone;
   [_player.view setFrame: _videoView.bounds];  // player's frame must match parent's
   [_videoView addSubview: _player.view];
   _videoView.autoresizesSubviews = TRUE;
   _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
   _player.shouldAutoplay = TRUE;
   _player.scalingMode = MPMovieScalingModeAspectFit;
   [_player prepareToPlay];
	```
	
3. 设置监听  
   
   当前提供了七个Notificaton监听，具体可参考[6.10 通知](#Notification)
  
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
   [[NSNotificationCenter defaultCenter]addObserver:self
                        selector:@selector(handlePlayerNotify:)
                        name:(MPMovieNaturalSizeAvailableNotification)
                        object:nil];
   [[NSNotificationCenter defaultCenter]addObserver:self
                        selector:@selector(handlePlayerNotify:)
                        name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                        object:nil];
   [[NSNotificationCenter defaultCenter]addObserver:self
                        selector:@selector(handlePlayerNotify:)
                        name:(MPMoviePlayerFirstAudioFrameRenderedNotification)
                        object:nil];</pre>

4. 销毁播放器  

   播放器在stop中完成内存释放，new一次KSYMoviePlayerController，需要stop一次。如果两者未配对调用，将引发内存泄露。
   	<pre>[_player stop]</pre>

## 5. 特性说明
</br>
&#160; &#160; &#160; &#160;当前下载版本为轻量级播放sdk，该版本有如下特性：  

* 支持h.264/h.265/aac/mp3编码格式;  
* 支持rtmp/hls/http-flv直播;  
* 支持hls和http点播，封装格式为mp4/flv/ts；

&#160; &#160; &#160; &#160;如有其他编码和封装格式，请直接联系金山云客服获取其他版本。

## 6. 接口说明

### 6.1 创建和初始化对象
________________________

* **initWithContentURL**
  
  **描述：**  
  &#160; &#160; &#160; &#160;设置播放地址并初始化播放器
  
  **声明：**  
  &#160; &#160; &#160; &#160;-(instancetype)initWithContentURL:(NSURL \*)url NS_DESIGNATED_INITIALIZER;
  
  **参数：**  
  &#160; &#160; &#160; &#160;url - 视频播放地址，该地址可以是本地地址或者服务器地址
  
  **返回值：**  
  &#160; &#160; &#160; &#160;返回KSYMoviePlayerController对象，该对象的视频播放地址ContentURL已经初始化。
此时播放器状态为[MPMoviePlaybackStateStopped](#PlaybackStateStopped)。
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法初始化了播放器，并设置了播放地址，但是并没有将播放器对视频文件进行初始化，需要调用[prepareToPlay](#prepareToPlay)方法对视频文件进行初始化。当前支持的协议包括:http, rtmp, file；
  
  &#160; &#160; &#160; &#160;必须调用该方法进行初始化，不能调用init方法；
	
  &#160; &#160; &#160; &#160;当前版本只支持单实例的KSYMoviePlayerController对象，多实例将导致播放异常。
  
### 6.2 开始/停止播放
________________________
  
* <span id="prepareToPlay">**prepareToPlay**</span>  
  
  **描述：**  
  &#160; &#160; &#160; &#160;准备视频播放  
  
  **声明：**  
  &#160; &#160; &#160; &#160;- (void)prepareToPlay;

  **说明：**  
  &#160; &#160; &#160; &#160;prepareToPlay处理逻辑：
    
  &#160; &#160; &#160; &#160;如果[isPreparedToPlay](#isPreparedToPlay)为FALSE，直接调用[play](#play)则在play内部自动调用prepareToPlay接口；
  
  &#160; &#160; &#160; &#160;prepareToPlay调用后，由[MPMediaPlaybackIsPreparedToPlayDidChangeNotification](#IsPreparedToPlayDidChangeNotification)通知完成准备工作，查询[isPreparedToPlay](#isPreparedToPlay)可以获得具体属性值。

* <span id="play">**play**</span>

  **描述：**  
  &#160; &#160; &#160; &#160;播放当前视频
    
  **声明：**  
  &#160; &#160; &#160; &#160;- (void)play;

  **说明：**  
  &#160; &#160; &#160; &#160;play的使用逻辑：  
  
  &#160; &#160; &#160; &#160;如果调用play方法前已经调用[prepareToPlay](#prepareToPlay)完成播放器对视频文件的初始化，且[shouldAutoplay](#shouldAutoplay)属性为NO，则调用play方法将开始播放当前视频。此时播放器状态为[MPMoviePlaybackStatePlaying](#PlaybackStatePlaying)；如果[shouldAutoplay](#shouldAutoplay)属性为YES，则调用play方法将暂停播放当前视频，实现效果和[pause](#pause)一致； 
   
  &#160; &#160; &#160; &#160;如果调用play方法前未调用[prepareToPlay](#prepareToPlay)完成播放器对视频文件的初始化，则播放器自动调用[prepareToPlay](#prepareToPlay)进行视频文件的初始化工作；  
  
  &#160; &#160; &#160; &#160;如果调用play方法前已经调用[pause](#pause)暂停了正在播放的视频，则重新开始启动播放视频。

* <span id="pause">**pause**</span>

  **描述：**  
  &#160; &#160; &#160; &#160;暂停播放当前视频

  **声明：**  
  &#160; &#160; &#160; &#160;- (void)pause;

  **说明：**

   &#160; &#160; &#160; &#160;pause调用逻辑：

   &#160; &#160; &#160; &#160;如果当前视频播放已经暂停，调用该方法将不产生任何效果；
     
   &#160; &#160; &#160; &#160;重新回到播放状态，需要调用[play](#play)方法；  
   
   &#160; &#160; &#160; &#160;如果调用pause方法后视频暂停播放，此时播放器状态处于[MPMoviePlaybackStatePaused](#PlaybackStatePaused)。  
   
   &#160; &#160; &#160; &#160;后台播放逻辑：

   &#160; &#160; &#160; &#160;需要APP有后台执行权限，在工程Info.plist中添加后台运行模式，设置为audio。具体是添加UIBackgroundModes项，值为audio；  
   
   &#160; &#160; &#160; &#160;当用户点击home按钮后，播放器进入后台继续读取数据并播放音频；
     
   &#160; &#160; &#160; &#160;当APP回到前台后，音频继续播放。图像渲染内容保持和音频同步；  
   
   &#160; &#160; &#160; &#160;如果在开启后台运行模式后，需要切换后台暂停，需要监听相关事件并主动调用pause操作。

* <span id="stop">**stop**</span>

  **描述：**  
  &#160; &#160; &#160; &#160;结束当前视频的播放
    
  **声明：**  
  &#160; &#160; &#160; &#160;- (void)stop;
  
  **说明：**
  
  &#160; &#160; &#160; &#160;stop调用逻辑：

  &#160; &#160; &#160; &#160;调用stop方法后，播放器开始进入关闭当前播放的操作；  
  
  &#160; &#160; &#160; &#160;如果需要重新播放该视频，需要调用[prepareToPlay](#prepareToPlay)方法。  

* <span id="isPreparedToPlay">**isPreparedToPlay**</span>  
  
  **描述：**  
  &#160; &#160; &#160; &#160;查询视频准备是否完成
    
  **声明：**  
  &#160; &#160; &#160; &#160;@property(nonatomic, readonly) BOOL isPreparedToPlay;
  
  **说明：**
  
  &#160; &#160; &#160; &#160;isPreparedToPlay处理逻辑：

  &#160; &#160; &#160; &#160;如果isPreparedToPlay为TRUE，则可以调用[play](＃play)接口开始播放；
    
  &#160; &#160; &#160; &#160;如果isPreparedToPlay为FALSE，则需要调用[prepareToPlay](＃prepareToPlay)接口开始准备工作；
  
  &#160; &#160; &#160; &#160;如果isPreparedToPlay为FALSE，直接调用[play](#play)，则在play内部自动调用[prepareToPlay](#prepareToPlay)接口。
  
* **reload**

  **描述：**  
  &#160; &#160; &#160; &#160;重新启动拉流
      
  **声明：**  
  &#160; &#160; &#160; &#160;- (void)reload:(NSURL *)aUrl is_flush:(bool)is_flush;
  
  **参数：**  
  &#160; &#160; &#160; &#160;url - 视频播放地址，该地址可以是本地地址或者服务器地址。如果为nil，则使用前一次播放地址
  
  &#160; &#160; &#160; &#160;is_flush - 是否清除上一个url的缓冲区内容，该值为FALSE不清除，为TRUE则清除
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口
  
  &#160; &#160; &#160; &#160;reload调用场景如下：
    
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;(1)当播放器调用方发现卡顿时，可以主动调用;  
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;(2)当估计出更优质的拉流ip时，可以主动调用;  
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;(3)当发生WiFi/3G网络切换时，可以主动调用;  
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;(4)当播放器回调体现播放完全时，可以主动调用;  
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;(5)播放器SDK不会自动调用reload功能。

### 6.3 播放器设置
________________________

* **shouldAutoplay**

  **描述：**  
  &#160; &#160; &#160; &#160;播放视频时是否需要自动播放，默认值为YES。
  
  **声明：**  
  &#160; &#160; &#160; &#160;@property (nonatomic) BOOL shouldAutoplay;
  
  **说明：**  
  &#160; &#160; &#160; &#160;如果shouldAutoplay值为YES，则调用[prepareToPlay](#prepareToPlay)方法后，播放器完成初始化后将自动调用[play](#play)方法播放视频；  
  
  &#160; &#160; &#160; &#160;如果shouldAutoplay值为NO，则播放器完成初始化后将等待外部调用[play](#play)方法。  
  
  &#160; &#160; &#160; &#160;开发者可以监听播放SDK发送的[MPMediaPlaybackIsPreparedToPlayDidChangeNotification](#IsPreparedToPlayDidChangeNotification)通知。在收到该通知后进行其他操作并主动调用[play](#play])方法开启播放。

* **shouldEnableVideoPostProcessing**

  **描述：**  
  &#160; &#160; &#160; &#160;是否开启视频后处理，默认关闭
  
  **声明：**  
  &#160; &#160; &#160; &#160;@property(nonatomic)  BOOL  shouldEnableVideoPostProcessing;
 
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。  
  
  &#160; &#160; &#160; &#160;只在[prepareToPlay](#prepareToPlay)调用前设置生效。

* **shouldUseHWCodec**

  **描述：**  
  &#160; &#160; &#160; &#160;是否开启硬件解码，默认关闭
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property(nonatomic) BOOL shouldUseHWCodec;
 
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。  
  
  &#160; &#160; &#160; &#160;只在[prepareToPlay](#prepareToPlay)调用前设置生效。

* **shouldLoop**

  **描述：**  
  &#160; &#160; &#160; &#160;是否循环播放，默认不循环
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property(nonatomic) BOOL shouldLoop;
 
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。  
  
  &#160; &#160; &#160; &#160;只有点播生效，直播场景请勿设置。
 
* **setTimeout**

  **描述：**  
  &#160; &#160; &#160; &#160;设置拉流超时时间，单位是秒，默认值是30秒
    
  **声明：**    
  &#160; &#160; &#160; &#160;- (void)setTimeout:(int)timeout;
  
  **参数：**  
  &#160; &#160; &#160; &#160;timeout － 拉流超时时间，单位是秒
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
  
* **bufferTimeMax**

  **描述：**  
  &#160; &#160; &#160; &#160;指定直播流播放时的最大缓冲时长，单位为秒，默认值是2秒
      
  **声明：**    
  &#160; &#160; &#160; &#160;@property NSTimeInterval bufferTimeMax;
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
  
  &#160; &#160; &#160; &#160;该属性仅对直播有效，该值为负数时，关闭直播追赶。

* **scalingMode**

  **描述：**  
  &#160; &#160; &#160; &#160;当前视频的缩放显示模式，默认为[MPMovieScalingModeAspectFit](#ScalingModeAspectFit)。
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic) MPMovieScalingMode scalingMode;
  
  **说明：**  
  &#160; &#160; &#160; &#160;具体显示模式请参考[MPMovieScalingMode](#MPMovieScalingMode)。
 
* **rotateDegress**
 
  **描述：**  
  &#160; &#160; &#160; &#160;显示画面旋转角度
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic) int rotateDegress;
 
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。  
  
  &#160; &#160; &#160; &#160;画面旋转为逆时针旋转，设置下来的角度只能是0，90，180，270，不符合上述值不进行旋转。

* **shouldMute**

  **描述：**  
  &#160; &#160; &#160; &#160;是否静音，默认不静音
    
  **声明：**    
  &#160; &#160; &#160; &#160;@property(nonatomic) BOOL shouldMute;
 
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
  
* **setVolume**

  **描述：**  
  &#160; &#160; &#160; &#160;指定播放器输出音量
  
  **声明：**    
  &#160; &#160; &#160; &#160;- (void)setVolume:(float)leftVolume rigthVolume:(float)rightVolume;
 
  **参数：**  
  &#160; &#160; &#160; &#160;leftVolume - 左声道音量值，范围是[0~1.0f]  
  
  &#160; &#160; &#160; &#160;rightVolume - 右声道音量值，范围是[0~1.0f]
	  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
 
  &#160; &#160; &#160; &#160;输出到speaker时需要同时设置左右音量为有效值，如：  
  
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;leftVolume ＝ rightVolume ＝ 0.5f  
  
  &#160; &#160; &#160; &#160;音量值不在有效范围内该功能不起作用。
    
### 6.4 播放信息
________________________

* **contentURL**

  **描述：**  
  &#160; &#160; &#160; &#160;视频文件的URL地址，该地址可以是本地地址或者服务器地址
    
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, copy) NSURL *contentURL;  
  
  **说明：**  
  &#160; &#160; &#160; &#160;当播放器正在播放视频时，设置contenURL将不会导致播放新视频。如果希望播放新视频，需要调用[prepareToPlay](＃prepareToPlay)方法。
     
* <span id="playbackState">**playbackState**</span>

  **描述：**  
  &#160; &#160; &#160; &#160;当前播放器的播放状态（只读）
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) MPMoviePlaybackState playbackState;
 
  **说明：**  
  &#160; &#160; &#160; &#160;可以通过该属性获取视频播放状态，具体播放状态请参考[MPMoviePlaybackState](#MPMoviePlaybackState)。

* <span id="loadState">**loadState;**</span>

  **描述：**  
  &#160; &#160; &#160; &#160;当前网络加载情况
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) MPMovieLoadState loadState;
    
  **说明：**  
  &#160; &#160; &#160; &#160;可以通过该属性获取视频加载情况，具体加载状态请参考[MPMovieLoadState](#MPMovieLoadState)。

* <span id="currentPlaybackTime">**currentPlaybackTime**</span>

  **描述：**  
  &#160; &#160; &#160; &#160;播放视频的当前时刻,单位是秒
  
  **声明：**   
  &#160; &#160; &#160; &#160;@property(nonatomic) NSTimeInterval currentPlaybackTime;
  
  **说明：**  
  &#160; &#160; &#160; &#160;视频正常播放时，如果改变currentPlaybackTime的值，将会导致播放行为跳转到新的currentPlaybackTime位置播放；
  
  &#160; &#160; &#160; &#160;如果在视频未播放前设置currentPlaybackTime的值，将导致播放时刻从currentPlaybackTime位置播放。
  
* <span id="duration">**duration**</span>

  **描述：**  
  &#160; &#160; &#160; &#160;当前视频总时长，单位是秒
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) NSTimeInterval duration;
  
  **说明：**  
  &#160; &#160; &#160; &#160;直播视频源总时长为0；若该信息未知，则总时长默认为0。
  
* <span id="playableDuration">**playableDuration**</span>

  **描述：**  
  &#160; &#160; &#160; &#160;当前视频可播放长度，单位是秒
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) NSTimeInterval playableDuration;
    
  **说明：**  
  &#160; &#160; &#160; &#160;[currentPlaybackTime](#currentPlaybackTime)标记的是播放器当前已播放的时长； 
   
  &#160; &#160; &#160; &#160;playableDuration 标记的是播放器缓冲的时间，会稍大于currentPlaybackTime，与currentPlaybackTime的差值则是缓冲长度；  
  
  &#160; &#160; &#160; &#160;[duration](#duration) 是视频总时长。

* **naturalSize**

  **描述：**  
  &#160; &#160; &#160; &#160;当前视频宽高
    
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) CGSize naturalSize;  
   
  **说明：**  
  &#160; &#160; &#160; &#160;播放过程中，宽高信息可能会产生更改。
  
* **serverAddress**

  **描述：**  
  &#160; &#160; &#160; &#160;视频流的服务器地址
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) NSString* serverAddress;
    
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
  
  &#160; &#160; &#160; &#160;当收到[MPMediaPlaybackIsPreparedToPlayDidChangeNotification](#IsPreparedToPlayDidChangeNotification)通知后，即可以查询当前连接的视频流server ip。
  
* **getMetadata**

  **描述：**  
  &#160; &#160; &#160; &#160;获取播放流的Meta信息
  
  **声明：**    
  &#160; &#160; &#160; &#160;- (NSDictionary *)getMetadata;
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。 
   
  &#160; &#160; &#160; &#160;当收到[MPMediaPlaybackIsPreparedToPlayDidChangeNotification](#IsPreparedToPlayDidChangeNotification)通知后，才能获取到数据。  
  
  &#160; &#160; &#160; &#160;暂时支持的查询包括：  
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;kKSYPLYFormat  
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;kKSYPLYHttpFirstDataTime  
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;kKSYPLYHttpConnectTime  
  &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;kKSYPLYHttpAnalyzeDns
    
* **qosInfo**

  **描述**：  
  &#160; &#160; &#160; &#160;获取视频流qos信息
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, strong) KSYQosInfo *qosInfo;

  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。  
  
  &#160; &#160; &#160; &#160;在播放过程中，查询当前连接的视频流qos信息。

* **readSize**

  **描述：**  
  &#160; &#160; &#160; &#160;已经加载的数据大小，单位是兆
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) double readSize;  
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。  
  
  &#160; &#160; &#160; &#160;已经加载的全部数据大小，包括已经播放的和当前的cache数据。

* **bufferEmptyDuration**

  **描述：**  
  &#160; &#160; &#160; &#160;buffer为空时，拉取数据所耗的时长，单位是秒
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) NSTimeInterval bufferEmptyDuration;  
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
	
  &#160; &#160; &#160; &#160;该值为每次cache所消耗时间的累加，单次cache的统计方法为： 
   
  &#160; &#160; &#160; &#160;当[MPMoviePlayerLoadStateDidChangeNotification](#LoadStateDidChangeNotification)通知发起：
    
  &#160; &#160; &#160; &#160;[MPMovieLoadState](#MPMovieLoadState)状态为[MPMovieLoadStateStalled](#LoadStateStalled)开始计时；  
  
  &#160; &#160; &#160; &#160;[MPMovieLoadState](#MPMovieLoadState)状态为[MPMovieLoadStatePlayable](#LoadStatePlayable)或者[MPMovieLoadStatePlaythroughOK](#LoadStatePlaythroughOK)时，结束计时。

* **bufferEmptyCount**

  **描述：**  
  &#160; &#160; &#160; &#160;发起cache的次数
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) NSInteger bufferEmptyCount;
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
  
  &#160; &#160; &#160; &#160;当buffer为空时，统计一次，统计的条件为当[MPMoviePlayerLoadStateDidChangeNotification](#LoadStateDidChangeNotification)通知发起且[MPMovieLoadState](#MPMovieLoadState)状态为[MPMovieLoadStateStalled](#LoadStateStalled)。

* **isPlaying**

  **描述：**  
  &#160; &#160; &#160; &#160;当前播放器是否在播放
     
  **声明：**    
  &#160; &#160; &#160; &#160;- (BOOL)isPlaying;
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
  
  &#160; &#160; &#160; &#160;获取[playbackState](#playbackState])信息，如果当前状态为[MPMoviePlaybackStatePlaying](#PlaybackStatePlaying)，则返回TRUE。其他情况返回FALSE。

### 6.5 获取view
________________________

* **view**

  **描述：**  
  &#160; &#160; &#160; &#160;包含视频播放内容的VIEW（只读）
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, readonly) UIView *view;
 	  
  **说明：**  
  &#160; &#160; &#160; &#160;view的使用逻辑：  
  
  &#160; &#160; &#160; &#160;可以通过frame设置view的大小;   
  
  &#160; &#160; &#160; &#160;使用[scalingMode](#scalingMode)可以更改视频内容在VIEW中的显示情况。  

### 6.6 截图
________________________

* **thumbnailImageAtCurrentTime**

  **描述：**  
  &#160; &#160; &#160; &#160;截取当前时刻的视频图像
    
  **声明：**    
  &#160; &#160; &#160; &#160;- (UIImage *)thumbnailImageAtCurrentTime;
 
  **返回值：**  
  &#160; &#160; &#160; &#160;返回当前时刻的视频UIImage图像
	 
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
 
### 6.7 获取版本号
________________________

* **getVersion**

  **描述：**  
  &#160; &#160; &#160; &#160;获取iOS播放sdk版本号
  
  **声明：**    
  &#160; &#160; &#160; &#160;- (NSString *)getVersion;
 
  **返回值：**  
  &#160; &#160; &#160; &#160;iOS播放sdk版本号
	  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。

### 6.8 其它
________________________

* **shouldEnableKSYStatModule**

  **描述：**  
  &#160; &#160; &#160; &#160;收集日志的状态，默认开启
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, assign) BOOL shouldEnableKSYStatModule;

  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。
  
* **(^logBlock)**

  **描述：**  
  &#160; &#160; &#160; &#160;获取播放器日志
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, copy)void (^logBlock)(NSString *logJson);
  
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。 
   
  &#160; &#160; &#160; &#160;调用[prepareToPlay](#prepareToPlay)方法之前设置生效，回调数据为日志信息。日志相关字段说明请联系金山云技术支持。
  
* **videoDataBlock**

  **描述：**  
  &#160; &#160; &#160; &#160;视频数据回调
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, copy)KSYPlyVideoDataBlock videoDataBlock;
    
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。 
    
  &#160; &#160; &#160; &#160;KSYPlyVideoDataBlock的定义为：
  
  ```
  typedef void (^KSYPlyVideoDataBlock)(CVPixelBufferRef pixelBuffer);
  ```
  
  &#160; &#160; &#160; &#160;调用[prepareToPlay](#prepareToPlay)方法之前设置生效，回调数据为同步完成后的视频数据。

* **audioDataBlock**

  **描述：**  
  &#160; &#160; &#160; &#160;音频数据回调
  
  **声明：**    
  &#160; &#160; &#160; &#160;@property (nonatomic, copy)KSYPlyAudioDataBlock audioDataBlock;
    
  **说明：**  
  &#160; &#160; &#160; &#160;该方法由金山云引入，不是原生系统接口。  
  
  &#160; &#160; &#160; &#160;KSYPlyAudioDataBlock的定义为:
  	
  ```
  typedef void (^KSYPlyAudioDataBlock)(CMSampleBufferRef sampleBuffer);
  ```
  
  &#160; &#160; &#160; &#160;调用[prepareToPlay](#prepareToPlay)方法之前设置生效，回调数据为同步完成后的音频数据。  

### 6.9 常量
________________________

* <span id="MPMoviePlaybackState">**播放状态**</span>  

  **描述：**  
  &#160; &#160; &#160; &#160; 说明播放器当前所处状态
  
  **声明：**  
	<pre>typedef NS_ENUM(NSInteger, MPMoviePlaybackState) {
    	MPMoviePlaybackStateStopped,
    	MPMoviePlaybackStatePlaying,
    	MPMoviePlaybackStatePaused,
    	MPMoviePlaybackStateInterrupted,
    	MPMoviePlaybackStateSeekingForward,
    	MPMoviePlaybackStateSeekingBackward
	};</pre>
	
  **变量：**   
  &#160; &#160; &#160; &#160; <span id="PlaybackStateStopped">MPMoviePlaybackStateStopped</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;播放停止  
  &#160; &#160; &#160; &#160; <span id="PlaybackStatePlaying">MPMoviePlaybackStatePlaying</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;正在播放  
  &#160; &#160; &#160; &#160; <span id="PlaybackStatePaused">MPMoviePlaybackStatePaused</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;播放暂停  
  &#160; &#160; &#160; &#160; <span id="PlaybackStateInterrupted">MPMoviePlaybackStateInterrupted</span>&#160; &#160; &#160; &#160;&#160; &#160; &#160; &#160; &#160; &#160; 播放被打断  
  &#160; &#160; &#160; &#160; <span &#160;id="PlaybackStateSeekingForward">MPMoviePlaybackStateSeekingForward</span>&#160; &#160; &#160; &#160;&#160; &#160; 向前seeking中  
  &#160; &#160; &#160; &#160; <span id="PlaybackStateSeekingBackward">MPMoviePlaybackStateSeekingBackward</span>&#160; &#160; &#160; &#160; 向后seeking中 
 
* <span id="MPMovieLoadState">**加载状态**</span>  
  
  **描述：**  
  &#160; &#160; &#160; &#160; 说明视频当前加载状态
     
  **声明：**  
	<pre>typedef NS_OPTIONS(NSUInteger, MPMovieLoadState) {
    	MPMovieLoadStateUnknown        = 0,
    	MPMovieLoadStatePlayable       = 1 << 0,
    	MPMovieLoadStatePlaythroughOK  = 1 << 1,
    	MPMovieLoadStateStalled        = 1 << 2,
	};</pre>
	
  **变量：**   
  &#160; &#160; &#160; &#160; <span id="LoadStateUnknown">MPMovieLoadStateUnknown</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 加载情况未知  
  &#160; &#160; &#160; &#160; <span id="LoadStatePlayable">MPMovieLoadStatePlayable</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 加载完成，可以播放  
  &#160; &#160; &#160; &#160; <span id="LoadStatePlaythroughOK">MPMovieLoadStatePlaythroughOK</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;加载完成，如果shouldAutoPlay为YES，将自动开始播放  
  &#160; &#160; &#160; &#160; <span id="LoadStateStalled">MPMovieLoadStateStalled</span>&#160; &#160; &#160; &#160;&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;加载中 

* <span id="MPMovieScalingMode">**显示模式**</span>  
  
  **描述：**  
  &#160; &#160; &#160; &#160; 视频画面的显示模式
     
  **声明：**  
	<pre>typedef NS_ENUM(NSInteger, MPMovieScalingMode) {
		MPMovieScalingModeNone,
    	MPMovieScalingModeAspectFit,
    	MPMovieScalingModeAspectFill,
    	MPMovieScalingModeFill
    };</pre>
    
  **变量：**  
  &#160; &#160; &#160; &#160; <span id="ScalingModeNone">MPMovieScalingModeNone</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;无缩放  
  &#160; &#160; &#160; &#160; <span id="ScalingModeAspectFit">MPMovieScalingModeAspectFit</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 同比适配，某个方向会有黑边  
  &#160; &#160; &#160; &#160; <span id="ScalingModeAspectFill">MPMovieScalingModeAspectFill</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 同比填充，某个方向的显示内容可能被裁剪  
  &#160; &#160; &#160; &#160; <span id="ScalingModeFill">MPMovieScalingModeFill</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;满屏填充，与原始视频比例不一致

* <span id="MPMovieFinishReason">**结束原因**</span>  

  **描述：**  
  &#160; &#160; &#160; &#160; 播放结束的具体原因
     
  **声明：**  
	<pre>typedef NS_ENUM(NSInteger, MPMovieFinishReason) {
       MPMovieFinishReasonPlaybackEnded,
       MPMovieFinishReasonPlaybackError,
       MPMovieFinishReasonUserExited
	};</pre>
    
  **变量：**  
	&#160; &#160; &#160; &#160; <span id="PlaybackEnded">MPMovieFinishReasonPlaybackEnded</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;播放结束  
  &#160; &#160; &#160; &#160; <span id="PlaybackError">MPMovieFinishReasonPlaybackError</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 播放错误  
  &#160; &#160; &#160; &#160; <span id="UserExited">MPMovieFinishReasonUserExited</span>&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 用户主动退出  
  
* <span id="KSYMPErrorCode">**错误码**</span>  

  **描述：**  
  &#160; &#160; &#160; &#160; 发生错误无法播放时上抛的错误类型
  
  **声明：**  
	<pre>typedef NS_ENUM(NSInteger, KSYMPErrorCode) {
		KSYMPOK								= 0,
		KSYMPErrorCodeUnknownError			= 1,
		KSYMPErrorCodeFileIOError			= -1004,
		KSYMPErrorCodeUnsupportProtocol  	= -10001,
		KSYMPErrorCodeDNSParseFailed	  	= -10002,
		KSYMPErrorCodeCreateSocketFailed 	= -10003,
		KSYMPErrorCodeConnectServerFailed	= -10004,
		KSYMPErrorCodeBadRequest			= -10005,
		KSYMPErrorCodeUnauthorizedClient	= -10006,
		KSYMPErrorCodeAccessForbidden		= -10007,
		KSYMPErrorCodeTargetNotFound		= -10008,
		KSYMPErrorCodeOtherErrorCode		= -10009,
		KSYMPErrorCodeServerException		= -10010,
		KSYMPErrorCodeInvalidData			= -10011,
		KSYMPErrorCodeUnsupportVideoCodec	= -10012,
		KSYMPErrorCodeUnsupportAudioCodec	= -10013,
	};</pre>

  **变量：**  
  &#160; &#160; &#160; &#160; KSYMPOK&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;正常  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeUnknownError&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 未知错误  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeFileIOError&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 读写数据异常  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeUnsupportProtocol&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;不支持的流媒体协议  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeDNSParseFailed&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;DNS解析失败  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeCreateSocketFailed&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 创建socket失败  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeConnectServerFailed&#160; &#160; &#160; &#160; &#160; &#160; &#160; 链接服务器失败  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeBadRequest&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; http请求返回400  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeUnauthorizedClient&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160;http请求返回401  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeAccessForbidden&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; http请求返回403  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeTargetNotFound&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; http请求返回404  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeOtherErrorCode&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; http请求返回其它4xx错误  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeServerException&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; http请求返回5xx错误  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeInvalidData&#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; &#160; 无效的媒体数据  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeUnsupportVideoCodec&#160; &#160; &#160; &#160; &#160; &#160;不支持的视频编码类型  
  &#160; &#160; &#160; &#160; KSYMPErrorCodeUnsupportAudioCodec&#160; &#160; &#160; &#160; &#160; &#160;不支持的音频编码类型

### <span id="Notification">6.10 通知</span>
________________________

* <span id="IsPreparedToPlayDidChangeNotification">**MPMediaPlaybackIsPreparedToPlayDidChangeNotification**</span>  
  
  **描述：**  
  &#160; &#160; &#160; &#160; 播放器完成对视频文件的初始化时发送此通知

* <span id="PlaybackStateDidChangeNotification">**MPMoviePlayerPlaybackStateDidChangeNotification**</span>  

  **描述：**  
  &#160; &#160; &#160; &#160; 播放状态发生改变时发送此通知

* <span id="PlaybackStateDidFinishNotification">**MPMoviePlayerPlaybackDidFinishNotification**</span>
  
  **描述：**  
  &#160; &#160; &#160; &#160; 正常播放结束或者因为错误播放失败时发送此通知
  
  &#160; &#160; &#160; &#160; userInfo字典中，关键字MPMoviePlayerPlaybackDidFinishReasonUserInfoKey指明了具体的结束原因，具体原因可参考[MPMovieFinishReason](#MPMovieFinishReason)。
  
  &#160; &#160; &#160; &#160; 当结束原因为[MPMovieFinishReasonPlaybackError](#PlaybackError)时，userInfo字典中的关键字error指明了具体的错误码，具体错误码可参考[KSYMPErrorCode](#KSYMPErrorCode)。

* <span id="LoadStateDidChangeNotification">**MPMoviePlayerLoadStateDidChangeNotification**</span>
  
  **描述：**  
  &#160; &#160; &#160; &#160; 数据加载状态发生改变时发送此通知

* <span id="NaturalSizeAvailableNotification">**MPMovieNaturalSizeAvailableNotification**</span>
  
  **描述：**  
  &#160; &#160; &#160; &#160; 第一次检测出视频的宽高或者播放过程中宽高发生改变时发送此通知

* <span id="FirstVideoFrameRenderNotification">**MPMoviePlayerFirstVideoFrameRenderedNotification**</span>
  
  **描述：**  
  &#160; &#160; &#160; &#160; 渲染第一帧视频时发送此通知

* <span id="FirstAudioFrameRenderNotification">**MPMoviePlayerFirstAudioFrameRenderedNotification**</span>
  
  **描述：**  
  &#160; &#160; &#160; &#160; 渲染第一帧音频时发送此通知

## 7. 反馈与建议
- 主页：[金山云](http://www.ksyun.com/)
- 邮箱：<linsong2@kingsoft.com>
