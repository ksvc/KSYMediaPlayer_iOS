Pod::Spec.new do |spec|
  spec.name         = 'KSYMediaPlayer_iOS'
  spec.version      = '1.8.5'
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
  spec.ios.library = 'z', 'iconv', 'stdc++.6'
  spec.source = { :git => 'https://github.com/ksvc/KSYMediaPlayer_iOS.git', :tag => 'v1.8.5'}
  spec.vendored_frameworks = 'framework/live/KSYMediaPlayer.framework'
end
