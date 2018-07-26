//
//  ContactTestViewController.m
//  SNSFunctionDemos
//
//  Created by SohuSns on 2/2/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "ContactTestViewController.h"
#import "AddressBookManager.h"
@interface ContactTestViewController ()

@property (nonatomic,assign) NSUInteger taptime;
@end

@implementation ContactTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Contact Test"];
    UIButton *observeContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [observeContactBtn setTitle:@"contact Test" forState:UIControlStateNormal];
    [observeContactBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [observeContactBtn setFrame:CGRectMake(100, 100, 200, 30)];
    [observeContactBtn addTarget:self action:@selector(contactTestAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:observeContactBtn];
    
    UILabel *useTime = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(observeContactBtn.frame), self.view.frame.size.width - 20, 50)];
    [useTime setTextColor:[UIColor redColor]];
    useTime.tag = 'time';
    [useTime setNumberOfLines:0];
    [useTime setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:useTime];
    
    UILabel *changeName = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(useTime.frame) + 10, 300, 300)];
    changeName.tag = 'name';
    [changeName setTextColor:[UIColor redColor]];
    [changeName setFont:[UIFont systemFontOfSize:15.0f]];
    [changeName setLineBreakMode:NSLineBreakByWordWrapping];
    [changeName setNumberOfLines:0];
    [self.view addSubview:changeName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactDidChange:) name:SystemContactDidChangeNotification object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)contactDidChange:(NSNotification *)notify {
    [self contactTestAction:nil];
}
- (void)contactTestAction:(UIButton *)sender {
    
    NSUInteger curr = [[NSDate date] timeIntervalSince1970];
    if (curr - self.taptime < 3)
    {
        return; //忽略多次短时间通知，或双击
    }
    self.taptime = curr;
    AddressBookManager *addressBook = [AddressBookManager shareInstance];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDate *nowData = [NSDate date];
        [addressBook getNeedsUploadPhonesComplete:^(NSMutableArray *uploadPhoneArray) {
            NSTimeInterval timeInterval = [nowData timeIntervalSinceNow];
            CGFloat getUseTime = -timeInterval;
            NSLog(@"getNeedsUploadPhonesComplete = %@,time=%@",uploadPhoneArray,[NSDate dateWithTimeIntervalSinceNow:0]);
            __block NSMutableString *nameStr = [NSMutableString string];
            [uploadPhoneArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ContactEntity *entity = (ContactEntity *)obj;
                NSString *fullName = @"";
                if ([entity.firstName length]){
                    fullName = [entity.lastName stringByAppendingFormat:@"%@",entity.firstName];
                }
                else if([entity.lastName length]){
                    fullName = entity.lastName;
                }
                [nameStr appendString:[NSString stringWithFormat:@"%@/",fullName]];
            }];
//            NSTimeInterval totalInterval = [nowData timeIntervalSinceNow];
//            CGFloat totalTime = -totalInterval;
            NSLog(@"complet time=%@ nameStr = %@",[NSDate dateWithTimeIntervalSinceNow:0],nameStr);
            dispatch_sync(dispatch_get_main_queue(), ^{
                UILabel *nameLable = (UILabel *)[self.view viewWithTag:'name'];
                [nameLable setText:nameStr];
                UILabel *timeLable = (UILabel *)[self.view viewWithTag:'time'];
                [timeLable setText:[NSString stringWithFormat:@"getContacts used time: %.2f\nNeed upload names:",getUseTime]];
                NSLog(@"refresh UI complete");
            });
        }];
    });
}

@end
