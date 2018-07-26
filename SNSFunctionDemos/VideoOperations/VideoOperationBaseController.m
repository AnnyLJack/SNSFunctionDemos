//
//  VideoOperationBaseController.m
//  SNSFunctionDemos
//
//  Created by SohuSns on 26/1/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "VideoOperationBaseController.h"

@interface VideoOperationBaseController ()

@end

@implementation VideoOperationBaseController
@synthesize firstAsset;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    if (self.actionType == ActionType_RecordAndSave){
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        cameraUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;

    [controller presentViewController:cameraUI animated:YES completion:nil];
    return YES;
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.actionType == ActionType_Play)
    {
        if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0)
            == kCFCompareEqualTo) {
            MPMoviePlayerViewController* theMovie =
            [[MPMoviePlayerViewController alloc] initWithContentURL:[info objectForKey:
                                                                     UIImagePickerControllerMediaURL]];
            [self presentMoviePlayerViewControllerAnimated:theMovie];
            
            // Register for the playback finished notification
            [[NSNotificationCenter defaultCenter]
             addObserver: self
             selector: @selector(myMovieFinishedCallback:)
             name: MPMoviePlayerPlaybackDidFinishNotification
             object: theMovie];
        }
    }
    else if(self.actionType == ActionType_RecordAndSave)
    {
        // Handle a movie capture
        if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0)
            == kCFCompareEqualTo) {
            
            NSString *moviePath = [(NSURL *)[info objectForKey:
                                    UIImagePickerControllerMediaURL] path];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (moviePath,self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        }
    }
}
// When the movie is done, release the controller.
-(void) myMovieFinishedCallback: (NSNotification*) aNotification
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    MPMoviePlayerController* theMovie = [aNotification object];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: MPMoviePlayerPlaybackDidFinishNotification
     object: theMovie];
    // Release the movie instance created in playMovieAtURL:
}
#pragma mark recordAndSave
- (void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}
@end
