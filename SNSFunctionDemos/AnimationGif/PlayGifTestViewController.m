//
//  PlayGigTestViewController.m
//  SNSFunctionDemos
//
//  Created by SohuSns on 1/2/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "PlayGifTestViewController.h"

@interface PlayGifTestViewController ()

@property (nonatomic,strong) UIImageView *theFirstAnimatedGif;
@property (nonatomic,strong) UIImageView *theSecondAnimatedGif;

@end

@implementation PlayGifTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Gif Test"];
    
    UILabel *localGif = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 100, 30)];
    [localGif setText:@"local Gif"];
    [self.view addSubview:localGif];

    NSURL *firstUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"11" ofType:@"gif"]];
    UIImageView *firstAnimation = [AnimatedGif getAnimationForGifAtUrl:firstUrl];
    [firstAnimation setFrame:CGRectMake(20, 100, 100, 200)];
    [self.view addSubview:firstAnimation];
    
    NSURL *secUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"apple_logo_animated" ofType:@"gif"]];
    UIImageView *localTwoView = [AnimatedGif getAnimationForGifAtUrl:secUrl];
    [localTwoView setFrame:CGRectMake(120, 100, 150, 150)];
    [self.view addSubview:localTwoView];
    
    NSURL *thirdUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"gif"]];
    UIImageView *localThirdView = [AnimatedGif getAnimationForGifAtUrl:thirdUrl];
    [localThirdView setFrame:CGRectMake(280, 100, 50, 50)];
    [self.view addSubview:localThirdView];
    
    for (int i = 0; i< 3; i++)
    {
        UILabel *remoteGif = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 100, 30)];
        [remoteGif setText:@"remote Gif"];
        [self.view addSubview:remoteGif];
        NSURL * secondUrl = [NSURL URLWithString:@"http://www.gifs.net/Animation11/Food_and_Drinks/Fruits/Apple_jumps.gif"];
        UIImageView * secondAnimation = [AnimatedGif getAnimationForGifAtUrl:secondUrl];
        secondAnimation.tag = i;
        [secondAnimation setFrame:CGRectMake(20 + i*100, 330, 200, 200)];
        [self.view addSubview:secondAnimation];
    }
    
}

- (void)dealloc {
    NSLog(@"PlayGigTestViewController dealloc");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
