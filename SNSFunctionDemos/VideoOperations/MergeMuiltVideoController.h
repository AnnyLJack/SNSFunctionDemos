//
//  MergeMuiltVideoController.h
//  SNSFunctionDemos
//
//  Created by SohuSns on 26/1/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
@interface MergeMuiltVideoController : UIViewController<MPMediaPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isSelectingAssetOne;
}
@property(nonatomic,strong)AVAsset* firstAsset;
@property(nonatomic,strong)AVAsset* secondAsset;
@property(nonatomic,strong)AVAsset* audioAsset;
@property(strong, nonatomic) UIActivityIndicatorView *activityView;
- (void)LoadAssetOne:(id)sender;
- (void)LoadAssetTwo:(id)sender;
- (void)LoadAudio:(id)sender;
- (void)MergeAndSave:(id)sender;
- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate;
- (void)exportDidFinish:(AVAssetExportSession*)session;
@end
