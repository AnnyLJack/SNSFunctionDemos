//
//  VideoOperationBaseController.h
//  SNSFunctionDemos
//
//  Created by SohuSns on 26/1/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVPlayerViewController.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger,ActionType)
{
    ActionType_Play,
    ActionType_RecordAndSave
};

@interface VideoOperationBaseController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,assign) ActionType actionType;
@property (nonatomic,strong) AVAsset *firstAsset;
- (BOOL)startCameraControllerFromViewController: (UIViewController*) controller
                                  usingDelegate: (id <UIImagePickerControllerDelegate,
                                                  UINavigationControllerDelegate>) delegate;

@end
