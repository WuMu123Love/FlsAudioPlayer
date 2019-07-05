//
//  FlsAudioPlayer.m
//  ceshiAvplay
//
//  Created by fls on 2019/6/4.
//  Copyright © 2019年 fls. All rights reserved.
//

#import "FlsAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface FlsAudioPlayer()
@property(nonatomic,strong) AVPlayer * avPlayer;
@property(nonatomic,strong) AVPlayerItem * playerItem;
@property(nonatomic,strong) id timeObserver;

@end

@implementation FlsAudioPlayer
- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI{
    [self avPlayer];
}


-(AVPlayer *)avPlayer{
    if (!_avPlayer) {
        
        _avPlayer =[AVPlayer playerWithPlayerItem:self.playerItem];;
        _avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[_avPlayer currentItem]];

        //监控时间进度
        self.timeObserver = [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 5) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            NSInteger currentTime =  (NSInteger)CMTimeGetSeconds(time);
            NSLog(@"%ld",(long)currentTime);
        }];
    }
    return _avPlayer;
}

/**
 播放完成的通知(用于重复播放)
 */
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    [self stop];
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
    }];
    if (self.audioPlayEndBlock) {
        self.audioPlayEndBlock();
    }
}
- (void)stop{
    [self.avPlayer pause];
    
}
- (void)play{
    [self.avPlayer play];
}

- (void)setUrl:(NSString *)url{
    _url = url;
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    [self.avPlayer replaceCurrentItemWithPlayerItem:self.playerItem];
    
    // 观察status属性
    [_playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        //获取更改后的状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            CMTime duration = item.duration; // 获取视频长度
            NSLog(@"%f",CMTimeGetSeconds(duration));
            // 播放
            [self play];
        } else if (status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        } else {
            NSLog(@"AVPlayerStatusUnknown");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        NSTimeInterval timeInterval = [self availableDurationRanges]; // 缓冲时间
//        CGFloat totalDuration = CMTimeGetSeconds(_playerItem.duration); // 总时间
//        [self.loadedProgress setProgress:timeInterval / totalDuration animated:YES]; // 更新缓冲条
    }
}
- (void)dealloc{
    // 移除时间观察者
    [self.avPlayer removeTimeObserver:self.timeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.avPlayer = nil;
    self.playerItem = nil;
    
}
@end
