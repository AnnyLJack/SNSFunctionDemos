//
//  constants.h
//  SNSClient
//
//  Created by pf on 14-9-25.
//  Copyright (c) 2014年 sohu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SNSLogDefine.h"
#pragma mark - 设备信息
#define iPhone4       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(320, 480), [[UIScreen mainScreen] currentMode].size): NO)
#define iPhone5       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iPhone6       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iPhone6Plus   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen mainScreen].bounds.size.height == 667.0)
#define iPhone6Plus ([UIScreen mainScreen].bounds.size.height == 736.0)
/////iPhone 6 Plus物理分辨率是1920×1080，苹果实际上是以2208×1242的分辨率在@3x模式下进行画面渲染，然后再缩放到1080p分辨率的。
#define iOS6          ([[UIDevice currentDevice].systemVersion intValue] >= 6?YES:NO)
#define iOS7          ([[UIDevice currentDevice].systemVersion intValue] >= 7?YES:NO)
#define iOS8          ([[UIDevice currentDevice].systemVersion intValue] >= 8?YES:NO)
#define iOS9          ([[UIDevice currentDevice].systemVersion intValue] >= 9?YES:NO)

#define kBaseVersion             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]//APP版本号
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kDividingLineSpace       (1.0/[UIScreen mainScreen].scale)//分割线间隔
#define fontTrans 0.5

#pragma mark functionDefine
#define feed_counts @"10"                   //定义每次获取feed的个数
#define MaxYear @"3000-01-01 01:01:01.000"      //定义最远年数，表示第一次获取列表
#define MinYear @"2015-01-01 01:01:01.000"  //流逝的时间
#define TimelinePhotoWith ([UIScreen mainScreen].bounds.size.width > 320)?160/2:200/3;
//.5625
#define fontHeigh(x) [@"我" sizeWithFont:[UIFont systemFontOfSize:x * 0.5] constrainedToSize:CGSizeMake(2000, 2000) lineBreakMode:NSLineBreakByWordWrapping].height

#define SNSImageName(file)  [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[@"SNSResources.bundle/images" stringByAppendingPathComponent:file]]
#define SNSFileName(file)  [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:[@"SNSResources.bundle/file" stringByAppendingPathComponent:file]]

#define SNSbyImageName(file) [@"SNSResources.bundle/images" stringByAppendingPathComponent:file]

#define MainBundle(file) [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:file]


#define IsNight [[[NSUserDefaults standardUserDefaults] objectForKey:@"dayAndNightChange"] isEqual:@"2"]
#define CanSNSLog [[[NSUserDefaults standardUserDefaults] objectForKey:@"CanSNSLog"] isEqual:@"2"]

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#pragma mark keyDefine
#define kAppKey         @"3843628477"
#define kRedirectURI    @"http://sns.whalecloud.com/sina2/callback"

#define dayAndNightNotification @"dayAndNightNotification"
#define kThirdLoginNotification @"kThirdLoginNotification"
#define ChangeCityNotification @"ChangeCityNotification"
#define RefreshTimelineNotification @"RefreshTimelineNotification"
#define ChangeTabToMyNotification @"ChangeTabToMyNotification"
#define BindPhoneNotifition @"BindPhoneNotifition"
#define BindSinaNotifition @"BindSinaNotifition"
#define LoginOutNotifition @"LoginOutNotifition"
#define UserDidLoginNotification    (@"notifyLogin")
#define ChangeBackGroundImageNotifition @"ChangeBackGroundImageNotifition"

#define RefreshFeedByTopChangeNotifition @"RefreshFeedByTopChangeNotifition"
#define RefreshFeedByTranChangeNotifition @"RefreshFeedByTranChangeNotifition"
#define RefreshFeedByDeleteFeedNotifition @"RefreshFeedByDeleteFeedNotifition"

#define UpdateUserInfoNotifition @"UpdateUserInfoNotifition"
#define MessageListChangeNotifition @"MessageListChangeNotifition"
#define NewChatNotifition @"NewChatNotifition"
#define NewChatListNotifition @"NewChatListNotifition"
#define SecretMessageUnRead @"SecretMessageUnRead"
#define SendMessageResultNotifition @"SendMessageResultNotifition"
#define TimeLineClearChatNotifition @"TimeLineClearChatNotifition"

#define FirstChatNotifition @"FirstChatNotifition"
#define HiddenQRcodeRedPoint @"HiddenQRcodeRedPoint"

#define SNSNavigationDidPopAViewController @"SNNavigationDidPopAViewController"
#define UnreadMessageNotification @"UnreadMessageNotification"
#define UnreadNumber @"UnreadNumber"  //未读消息数

#define kProtocolSubHome                    (@"subHome://")
#define kProtocolUserInfoProfile            (@"userInfo://")
#define SNSUpURL @"SNSUpURL"

#define ManageSelfMediaUrl @"http://mp.sohu.com/m/"
#define LIBVERSION @"2.0"
