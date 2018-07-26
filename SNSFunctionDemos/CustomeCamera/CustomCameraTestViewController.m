//
//  CustomCameraTestViewController.m
//  SNSFunctionDemos
//
//  Created by wenjuanjiang on 24/5/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "CustomCameraTestViewController.h"
#import "SCCaptureCameraController.h"
#import "PostViewController.h"
#import "SCNavigationController.h"
#import "TakeMovieViewController.h"
#import "SHAnimationalManager.h"
@interface CustomCameraTestViewController ()<SCNavigationControllerDelegate>

@end

@implementation CustomCameraTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    [testBtn setTitle:@"show Camera" forState:UIControlStateNormal];
    [testBtn.titleLabel setFont:[UIFont systemFontOfSize:26]];
    [testBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(showCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
//    UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 200, 50)];
//    [videoBtn setTitle:@"take Video" forState:UIControlStateNormal];
//    [videoBtn.titleLabel setFont:[UIFont systemFontOfSize:26]];
//    [videoBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [videoBtn addTarget:self action:@selector(tabkVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
//    [self.view addSubview:videoBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCameraAction:(UIButton *)sender {
    SCNavigationController *nav = [[SCNavigationController alloc] init];
    nav.scNaigationDelegate = self;
    [nav showCameraWithParentController:self];
}
//- (void)tabkVideoAction:(UIButton *)sender {
//    TakeMovieViewController *takeMovie = [[TakeMovieViewController alloc] initWithCameraTime:5 frameNum:20];
//    
//    [self.navigationController pushViewController:takeMovie animated:YES];
//}
#pragma mark - SCNavigationController delegate
- (void)didTakePicture:(SCCaptureCameraController*)viewController image:(UIImage*)image {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    PostViewController *con = [[PostViewController alloc] init];
    con.postImage = image;
    [self.navigationController pushViewController:con animated:YES];
}
- (void)changeToTakeVideo:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:NO completion:nil];
     TakeMovieViewController *takeMovie = [[TakeMovieViewController alloc] initWithCameraTime:5 frameNum:20];
    CATransition *animation = [[SHAnimationalManager sharedInstance] animationWithType:AnimationType_OglFlip subType:kCATransitionFromRight];
    [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
    [self.navigationController pushViewController:takeMovie animated:NO];
}
@end
