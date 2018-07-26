//
//  VideoOperationsController.m
//  SNSFunctionDemos
//
//  Created by SohuSns on 26/1/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "VideoOperationsController.h"
#import "MergeMuiltVideoController.h"
@implementation VideoOperationsController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *selectAndPlayVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAndPlayVideo.frame = CGRectMake(50, 100, 200, 30);
    [selectAndPlayVideo setTitle:@"SelectAndPlayVideo" forState:UIControlStateNormal];
    [selectAndPlayVideo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [selectAndPlayVideo addTarget:self action:@selector(selectAndPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectAndPlayVideo];
    
    UIButton *recordAndSaveVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    recordAndSaveVideo.frame = CGRectMake(50, 150, 200, 30);
    [recordAndSaveVideo setTitle:@"RecordAndSaveVideo" forState:UIControlStateNormal];
    [recordAndSaveVideo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [recordAndSaveVideo addTarget:self action:@selector(recordAndSaveVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordAndSaveVideo];
    
    UIButton *mergeMultipeVideos = [UIButton buttonWithType:UIButtonTypeCustom];
    mergeMultipeVideos.frame = CGRectMake(50, 200, 200, 30);
    [mergeMultipeVideos setTitle:@"MergeMultipeVideos" forState:UIControlStateNormal];
    [mergeMultipeVideos setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [mergeMultipeVideos addTarget:self action:@selector(mergeMultipeVideos:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mergeMultipeVideos];
}

- (void)selectAndPlayVideo:(UIButton *)sender {
    self.actionType = ActionType_Play;
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void)recordAndSaveVideo:(UIButton *)sender {
    self.actionType = ActionType_RecordAndSave;
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void)mergeMultipeVideos:(UIButton *)sender {
    MergeMuiltVideoController *mergeCtrl = [[MergeMuiltVideoController alloc] init];
    [self.navigationController pushViewController:mergeCtrl animated:NO];
}

@end
