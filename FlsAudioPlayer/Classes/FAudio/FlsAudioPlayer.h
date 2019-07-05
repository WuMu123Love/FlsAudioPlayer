//
//  FlsAudioPlayer.h
//  ceshiAvplay
//
//  Created by fls on 2019/6/4.
//  Copyright © 2019年 fls. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlsAudioPlayer : NSObject
@property(nonatomic,copy) NSString * url;
@property(nonatomic,copy) void(^audioPlayEndBlock)(void);
- (void)play;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
