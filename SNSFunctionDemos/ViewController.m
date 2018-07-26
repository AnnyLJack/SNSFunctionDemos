//
//  ViewController.m
//  SNSFunctionDemos
//
//  Created by SohuSns on 26/1/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "ViewController.h"
#import "VideoOperationsController.h"
#import "PlayGifTestViewController.h"
#import "ContactTestViewController.h"
#import "LargeimageTestViewController.h"
#import "RealReachabilityTestController.h"
#import "JPViewController.h"
#import "ShapeLayerTestController.h"
#import "JSCallOCTestViewController.h"
#import "CustomCameraTestViewController.h"
#import "TakeMovieViewController.h"
@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *actionArray;

@property (nonatomic, strong) UITableView *testTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Function Demo"];
    self.titleArray = @[@"video Demo",@"xunfei Demo",@"lua Demo",@"JSPatch Demo",@"Gif Test",@"contact Test",@"image Select Test",@"apple Pay Test",@"realReachablityTest",@"shapeLayerTest",@"jsCallOCTest",@"customCamaraTest",@"takeVideo"];
    self.actionArray = @[@"pushToVideoDemo:",@"pushToXunFeiDemo:",@"pushToLuaDemo:",@"pushToJSPatchDemo:",@"pushToTestGif:",@"pushToContactTest:",@"pushToImageSelectTest:",@"applePayTest:",@"realReachablityTest:",@"shapeLayerTest:",@"jsCallOCTest:",@"customCamaraTest:",@"takeVideoAction:"];
    [self addLabel];
    UITableView *testTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    testTableView.dataSource = self;
    testTableView.delegate = self;
    self.testTableView = testTableView;
    [self.view addSubview:testTableView];
}

- (void)addLabel {
    NSLog(@"addLabel");
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BtnCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellBtn.frame = CGRectMake(50, 5, 250, 30);
        cellBtn.tag = 111;
        [cellBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:cellBtn];
    }
    UIButton *cellBtn = [cell.contentView viewWithTag:111];
    [cellBtn setTitle:self.titleArray[indexPath.row] forState:UIControlStateNormal];
    [cellBtn addTarget:self action:NSSelectorFromString(self.actionArray[indexPath.row]) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (void)pushToVideoDemo:(UIButton *)sender {
    VideoOperationsController *videoCtrl = [[VideoOperationsController alloc] init];
    [self.navigationController pushViewController:videoCtrl animated:YES];
}

- (void)pushToXunFeiDemo:(UIButton *)sender {
    
}

- (void)pushToLuaDemo:(UIButton *)sender {
    
}
- (void)pushToJSPatchDemo:(UIButton *)sender {
    JPViewController *JPVC = [[JPViewController alloc] init];
    [self.navigationController pushViewController:JPVC animated:YES];
}
- (void)pushToTestGif:(UIButton *)sender {
    PlayGifTestViewController *gifVC = [[PlayGifTestViewController alloc] init];
    [self.navigationController pushViewController:gifVC animated:YES];
}

- (void)pushToContactTest:(UIButton *)sender {
    ContactTestViewController *contactVC = [[ContactTestViewController alloc] init];
    [self.navigationController pushViewController:contactVC animated:YES];
    
    
}
- (void)pushToImageSelectTest:(UIButton *)sender {
    LargeImageTestViewController *imageVC = [[LargeImageTestViewController alloc] init];
    [self.navigationController pushViewController:imageVC animated:YES];
}
- (void)realReachablityTest:(UIButton *)sender {
    RealReachabilityTestController *networkVC = [[RealReachabilityTestController alloc] init];
    [self.navigationController pushViewController:networkVC animated:YES];
}
- (void)shapeLayerTest:(UIButton *)sender {
    ShapeLayerTestController *shapeVC = [[ShapeLayerTestController alloc] init];
    [self.navigationController pushViewController:shapeVC animated:YES];
}
- (void)jsCallOCTest:(UIButton *)sender {
    JSCallOCTestViewController *jsCallOC = [[JSCallOCTestViewController alloc] init];
    [self.navigationController pushViewController:jsCallOC animated:YES];
}
- (void)customCamaraTest:(UIButton *)sender {
    CustomCameraTestViewController *cameraVC = [[CustomCameraTestViewController alloc] init];
    [self.navigationController pushViewController:cameraVC animated:YES];
}
- (void)takeVideoAction:(UIButton *)sender {
    TakeMovieViewController *takeVideo = [[TakeMovieViewController alloc] initWithCameraTime:5 frameNum:20];
    [self.navigationController pushViewController:takeVideo animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -
#pragma mark applePay
/**
 *  支付开始
 *
 *  @param sender <#sender description#>
 */
- (void)applePayTest:(UIButton *)sender {
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        NSLog(@"支持支付");
        
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"鸡蛋"
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        
//        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"苹果"
//                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
//        
//        PKPaymentSummaryItem *widget3 = [PKPaymentSummaryItem summaryItemWithLabel:@"2个苹果"
//                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"2.00"]];
        
        PKPaymentSummaryItem *widget4 = [PKPaymentSummaryItem summaryItemWithLabel:@"总金额" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"] type:PKPaymentSummaryItemTypeFinal];
        
        request.paymentSummaryItems = @[widget1, widget4];
        
        request.countryCode = @"CN";
        request.currencyCode = @"CHW";
        //此属性限制支付卡，可以支付。PKPaymentNetworkChinaUnionPay支持中国的卡 9.2增加的
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantIdentifier = @"merchant.com.sohu.sohukan.SNSFunctionDemos";
        /*
         PKMerchantCapabilityCredit NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 2,   // 支持信用卡
         PKMerchantCapabilityDebit  NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 3    // 支持借记卡
         */
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        //增加邮箱及地址信息
        request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        
        
        if (!paymentPane) {
            NSLog(@"出问题了");
            
        }
        [self presentViewController:paymentPane animated:YES completion:nil];
        
        
    } else {
        NSLog(@"该设备不支持支付");
    }
}
/**
 *  支付状态
 *
 *  @param controller
 *  @param payment
 *  @param completion
 */
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"Payment was authorized: %@", payment);
    
//    NSError *error;
//    ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty);
//    NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
//    NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];
//    
//    // ... Send payment token, shipping and billing address, and order information to your server ...
//    
//    PKPaymentAuthorizationStatus status;  // From your server
//    completion(status);
    
    BOOL asyncSuccessful = FALSE;
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        // do something to let the user know the status
        
        NSLog(@"支付成功");
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        // do something to let the user know the status
        NSLog(@"支付失败");
        
    }
    
}
/**
 *  支付完成
 *
 *  @param controller
 */
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
