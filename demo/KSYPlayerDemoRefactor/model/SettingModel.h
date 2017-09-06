//
//  SettingModel.h
//  KSYPlayerDemo
//
//  Created by devcdl on 2017/8/22.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KSYMediaPlayer/KSYMoviePlayerDefines.h>

@interface SettingModel : NSObject

@property (nonatomic, assign) MPMovieVideoDecoderMode videoDecoderMode;

@property (nonatomic, assign) NSTimeInterval bufferTimeMax;

@property (nonatomic, assign) NSTimeInterval bufferSizeMax;

@property (nonatomic, assign) NSInteger preparetimeOut;

@property (nonatomic, assign) NSInteger readtimeOut;

@property (nonatomic, assign) BOOL  shouldLoop;

@property (nonatomic, assign) BOOL  recording;

@end
