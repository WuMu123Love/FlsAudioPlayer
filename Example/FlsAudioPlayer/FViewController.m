//
//  FViewController.m
//  FlsAudioPlayer
//
//  Created by 1361825681@qq.com on 07/05/2019.
//  Copyright (c) 2019 1361825681@qq.com. All rights reserved.
//

#import "FViewController.h"
#import "FlsAudioPlayer.h"

@interface FViewController ()
@property(nonatomic,strong) FlsAudioPlayer * audioPlayer;

@end

@implementation FViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString * urlStr = @"http://res.inoot.cn/d5/voice/2019/06/03/162665e0-becd-499b-8bd7-6104c81b1acf.m4a";
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 100, 50)];
    [btn addTarget:self action:@selector(ClickButton) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    self.audioPlayer = [[FlsAudioPlayer alloc] init];
    self.audioPlayer.url = urlStr;
    self.audioPlayer.audioPlayEndBlock = ^{
        NSLog(@"播放结束");
    };
}
- (void)ClickButton{
    [self.audioPlayer play];

    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
