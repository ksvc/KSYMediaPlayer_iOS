Pod::Spec.new do |spec|
  spec.name         = 'KSYMediaPlayer_iOS'
  spec.version      = '3.0.4'
  spec.license      = {
:type => 'Proprietary',
:text => <<-LICENSE
      Copyright 2015 kingsoft Ltd. All rights reserved.
      LICENSE
  }
  spec.homepage     = 'http://v.ksyun.com/doc.html'
  spec.authors      = { 'FanpingZeng' => 'zengfanping@kingsoft.com' }
  spec.summary      = 'KSYMediaPlayer_iOS sdk manages the playback of a movie or live streaming.'
  spec.description  = <<-DESC
    KSYUN Live Streaming player SDK, upporting RTMP HTTP-FLV HLS protocol, Living delay less than 2 or 3 seconds.
    KSYMediaPlayer_iOS.framework is a static framework.
  DESC
  spec.platform     = :ios, '7.0'
  spec.requires_arc = true
  spec.frameworks   = 'VideoToolbox'
  spec.ios.library = 'z', 'iconv', 'c++', 'bz2'
  spec.source = {
	  :git => 'https://github.com/ksvc/KSYMediaPlayer_iOS.git', 
	  :tag => 'v'+spec.version.to_s
  }
 
  spec.default_subspec = 'KSYMediaPlayer_live'

  spec.subspec 'KSYMediaPlayer_live'  do |sub| 
    sub.vendored_frameworks = 'framework/live/KSYMediaPlayer.framework'
  end
  
#   spec.subspec 'KSYMediaPlayer_live_dy'  do |sub| 
#     sub.vendored_frameworks = 'framework/live_dy/KSYMediaPlayer.framework'
#   end
  
  spec.subspec 'KSYMediaPlayer_vod'  do |sub| 
    sub.vendored_frameworks = 'framework/vod/KSYMediaPlayer.framework'
  end

#   spec.subspec 'KSYMediaPlayer_vod_dy'  do |sub| 
#     sub.vendored_frameworks = 'framework/vod_dy/KSYMediaPlayer.framework'
#   end
end
