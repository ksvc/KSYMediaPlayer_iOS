Pod::Spec.new do |spec|
  spec.name         = 'KSYMediaPlayer_iOS'
  spec.version      = '0.0.1'
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
    KSYMediaPlayer_iOS sdk supoort iOS 7.0 and later, 
  DESC
  spec.platform     = :ios, '7.0'
  spec.requires_arc = true
  spec.frameworks   = 'VideoToolbox'
  spec.ios.library = 'z', 'iconv', 'stdc++.6'
  spec.source = { :git => 'https://github.com/qyvideo/libqylive.git', :tag => 'v0.0.1'}
  spec.preserve_paths      = 'framework/KSYMediaPlayer_iOS.framework'
  spec.public_header_files = 'framework/KSYMediaPlayer_iOS.framework/Headers'
  spec.vendored_frameworks = 'KSYMediaPlayer_iOS.framework'
end
