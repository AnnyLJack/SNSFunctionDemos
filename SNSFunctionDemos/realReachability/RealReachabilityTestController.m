//
//  RealReachabilityTestController.m
//  SNSFunctionDemos
//
//  Created by SohuSns on 24/2/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "RealReachabilityTestController.h"
#import "RealReachability.h"
@interface RealReachabilityTestController ()
@property (nonatomic,strong) UILabel *flagLabel;
@end

@implementation RealReachabilityTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.flagLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, self.view.frame.size.width - 40, 60)];
    
    [self.view addSubview:self.flagLabel];
    
    UIButton *testBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.frame = CGRectMake(20, 170, 200, 50);
    [testBtn setTitle:@"newwork change test" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    [GLobalRealReachability startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)testAction:(id)sender
{
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status)
        {
            case RealStatusNotReachable:
            {
                [[[UIAlertView alloc] initWithTitle:@"RealReachability" message:@"Nothing to do! offlineMode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil] show];
                break;
            }
                
            case RealStatusViaWiFi:
            {
                [[[UIAlertView alloc] initWithTitle:@"RealReachability" message:@"Do what you want! free!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil] show];
                break;
            }
                
            case RealStatusViaWWAN:
            {
                [[[UIAlertView alloc] initWithTitle:@"RealReachability" message:@"Take care of your money! You are in charge!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil] show];
                break;
            }
                
            default:
                break;
        }
    }];
    
}

- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    NSLog(@"currentStatus:%@",@(status));
    
    if (status == RealStatusNotReachable)
    {
        self.flagLabel.text = @"Network unreachable!";
    }
    
    if (status == RealStatusViaWiFi)
    {
        self.flagLabel.text = @"Network wifi! Free!";
    }
    
    if (status == RealStatusViaWWAN)
    {
        self.flagLabel.text = @"Network WWAN! In charge!";
    }
}
@end
