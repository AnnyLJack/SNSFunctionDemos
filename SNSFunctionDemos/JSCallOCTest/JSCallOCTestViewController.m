//
//  JSCallOCTestViewController.m
//  SNSFunctionDemos
//
//  Created by SohuSns on 22/3/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "JSCallOCTestViewController.h"
#import "JKWebView.h"
@interface JSCallOCTestViewController ()

@end

@implementation JSCallOCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    JKWebView *view = [[JKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
