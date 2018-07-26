//
//  MergeMuiltVideoController.m
//  SNSFunctionDemos
//
//  Created by SohuSns on 26/1/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "MergeMuiltVideoController.h"

@interface MergeMuiltVideoController ()

@end
@implementation MergeMuiltVideoController
@synthesize activityView;
@synthesize firstAsset,secondAsset,audioAsset;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityView];
    
    UIButton *loadAsset1 = [UIButton buttonWithType:UIButtonTypeCustom];
    loadAsset1.frame = CGRectMake(50, 100, 300, 30);
    [loadAsset1 setTitle:@"LoadAsset1" forState:UIControlStateNormal];
    [loadAsset1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loadAsset1 addTarget:self action:@selector(LoadAssetOne:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadAsset1];
    
    UIButton *loadAsset2 = [UIButton buttonWithType:UIButtonTypeCustom];
    loadAsset2.frame = CGRectMake(50, 150, 300, 30);
    [loadAsset2 setTitle:@"loadAsset2" forState:UIControlStateNormal];
    [loadAsset2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loadAsset2 addTarget:self action:@selector(LoadAssetTwo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadAsset2];
    
    UIButton *LoadAudio = [UIButton buttonWithType:UIButtonTypeCustom];
    LoadAudio.frame = CGRectMake(50, 200, 300, 30);
    [LoadAudio setTitle:@"LoadAudio" forState:UIControlStateNormal];
    [LoadAudio setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [LoadAudio addTarget:self action:@selector(LoadAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LoadAudio];
    
    UIButton *mergeAndSaveVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    mergeAndSaveVideo.frame = CGRectMake(50, 250, 300, 30);
    [mergeAndSaveVideo setTitle:@"mergeAndSaveVideo" forState:UIControlStateNormal];
    [mergeAndSaveVideo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [mergeAndSaveVideo addTarget:self action:@selector(MergeAndSave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mergeAndSaveVideo];
    
    UIButton *clipAndSaveVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    clipAndSaveVideo.frame = CGRectMake(50, 300, 300, 30);
    [clipAndSaveVideo setTitle:@"clipAndSaveVideo(5,5)" forState:UIControlStateNormal];
    [clipAndSaveVideo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clipAndSaveVideo addTarget:self action:@selector(clipAndSaveWithVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clipAndSaveVideo];
    
    UIButton *clipAndSaveAudioFromFirstVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    clipAndSaveAudioFromFirstVideo.frame = CGRectMake(50, 350, 300, 30);
    [clipAndSaveAudioFromFirstVideo setTitle:@"clipAudioFromFirstVideo" forState:UIControlStateNormal];
    [clipAndSaveAudioFromFirstVideo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clipAndSaveAudioFromFirstVideo addTarget:self action:@selector(clipAndSaveAudioFromFirstVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clipAndSaveAudioFromFirstVideo];
    
    UIButton *mergeAudioAndVideoToOneVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    mergeAudioAndVideoToOneVideo.frame = CGRectMake(50, 400, 300, 30);
    [mergeAudioAndVideoToOneVideo setTitle:@"mergeAudioAndVideoToOneVideo" forState:UIControlStateNormal];
    [mergeAudioAndVideoToOneVideo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [mergeAudioAndVideoToOneVideo addTarget:self action:@selector(mergeAudioAndVideoToOneVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mergeAudioAndVideoToOneVideo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LoadAssetOne:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Saved Album Found"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];
    }else{
        isSelectingAssetOne = TRUE;
        [self startMediaBrowserFromViewController: self
                                    usingDelegate: self];
    }
}
- (void)LoadAssetTwo:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Saved Album Found"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];
        
    }else{
        isSelectingAssetOne = FALSE;
        [self startMediaBrowserFromViewController: self
                                    usingDelegate: self];
    }
}

- (void)LoadAudio:(id)sender{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
    mediaPicker.delegate = self;
    mediaPicker.prompt = @"Select Audio";
    [self presentViewController:mediaPicker animated:YES completion:nil];
}


- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    NSArray * SelectedSong = [mediaItemCollection items];
    if([SelectedSong count]>0){
        MPMediaItem * SongItem = [SelectedSong objectAtIndex:0];
        NSURL *SongURL = [SongItem valueForProperty: MPMediaItemPropertyAssetURL];
        
        audioAsset = [AVAsset assetWithURL:SongURL];
        NSLog(@"Audio Loaded");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Audio Loaded"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
        [alert show];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}
// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        if(isSelectingAssetOne){
            NSLog(@"Video One  Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Video One Loaded"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [alert show];
            firstAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        }else{
            NSLog(@"Video two Loaded");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Asset Loaded" message:@"Video Two Loaded"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [alert show];
            secondAsset = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        }
    }
}

- (void)MergeAndSave:(id)sender{
    if(firstAsset !=nil && secondAsset!=nil){
        [activityView startAnimating];
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
        
        //AUDIO TRACK
//        if(audioAsset!=nil){
        AVMutableCompositionTrack *firstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        AVMutableCompositionTrack *secAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [secAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:firstAsset.duration error:nil];
//        }
        
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration));
        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
        BOOL  isFirstAssetPortrait_  = NO;
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)  {FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;}
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)  {FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;}
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)   {FirstAssetOrientation_ =  UIImageOrientationUp;}
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0) {FirstAssetOrientation_ = UIImageOrientationDown;}
        CGFloat FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.width;
        if(isFirstAssetPortrait_){
            FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }else{
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        AVMutableVideoCompositionLayerInstruction *SecondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        AVAssetTrack *SecondAssetTrack = [[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        UIImageOrientation SecondAssetOrientation_  = UIImageOrientationUp;
        BOOL  isSecondAssetPortrait_  = NO;
        CGAffineTransform secondTransform = SecondAssetTrack.preferredTransform;
        if(secondTransform.a == 0 && secondTransform.b == 1.0 && secondTransform.c == -1.0 && secondTransform.d == 0)  {SecondAssetOrientation_= UIImageOrientationRight; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 0 && secondTransform.b == -1.0 && secondTransform.c == 1.0 && secondTransform.d == 0)  {SecondAssetOrientation_ =  UIImageOrientationLeft; isSecondAssetPortrait_ = YES;}
        if(secondTransform.a == 1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == 1.0)   {SecondAssetOrientation_ =  UIImageOrientationUp;}
        if(secondTransform.a == -1.0 && secondTransform.b == 0 && secondTransform.c == 0 && secondTransform.d == -1.0) {SecondAssetOrientation_ = UIImageOrientationDown;}
        CGFloat SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.width;
        if(isSecondAssetPortrait_){
            SecondAssetScaleToFitRatio = 320.0/SecondAssetTrack.naturalSize.height;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor) atTime:firstAsset.duration];
        }else{
            ;
            CGAffineTransform SecondAssetScaleFactor = CGAffineTransformMakeScale(SecondAssetScaleToFitRatio,SecondAssetScaleToFitRatio);
            [SecondlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(SecondAssetTrack.preferredTransform, SecondAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:firstAsset.duration];
        }
        
        
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,SecondlayerInstruction,nil];;
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(320.0, 480.0);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self exportDidFinish:exporter];
             });
         }];
    }
}
- (void)clipAndSaveAudioFromFirstVideo:(UIButton *)sender {
    if (firstAsset == nil) {
        return;
    }
    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    //创建一个AVMutableComposition实例
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 2 - Video track
    //创建一个轨道,类型是AVMediaTypeAudio
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //获取firstAsset中的音频,插入轨道
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                        ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    
    // 4 - Get path
    //创建输出路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    
    // 5 - Create exporter
    //创建输出对象
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    //        @"com.apple.quicktime-movie";
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportAudioDidFinish:exporter];
        });
    }];
}
- (void)exportAudioDidFinish:(AVAssetExportSession*)session {

    if (session.status == AVAssetExportSessionStatusCompleted) {

        NSURL *outputURL = session.outputURL;
        MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc]
                                                 initWithContentURL:outputURL];
        [self presentMoviePlayerViewControllerAnimated:theMovie];
    }
    audioAsset = nil;
    firstAsset = nil;
    secondAsset = nil;
    
    
}

- (void)clipAndSaveWithVideo:(UIButton *)sender {
    if (firstAsset == nil) {
        return;
    }
    [activityView startAnimating];
    // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3 - Video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    if ([firstAsset tracksWithMediaType:AVMediaTypeVideo].count > 0) {
        [videoTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(5, 30), CMTimeMakeWithSeconds(5, 30))
                            ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                             atTime:kCMTimeZero error:nil];
    }
    
    // 3 - Audio track
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    if ([firstAsset tracksWithMediaType:AVMediaTypeAudio].count > 0) {
        [audioTrack insertTimeRange:CMTimeRangeMake(CMTimeMakeWithSeconds(5, 30), CMTimeMakeWithSeconds(5, 30))
                            ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:kCMTimeZero error:nil];
    }
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(5, 30));
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:CMTimeMakeWithSeconds(5, 30)];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];

    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.videoComposition = mainCompositionInst;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self exportDidFinish:exporter];
         });
     }];
    
}
- (void)mergeAudioAndVideoToOneVideo:(UIButton *)sender {
    
//    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audioUrl options:nil];
//    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                         atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                                   ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                          presetName:AVAssetExportPresetPassthrough];
    
    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    NSURL *exportUrl = [NSURL fileURLWithPath:exportPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {        
         dispatch_async(dispatch_get_main_queue(), ^{
             [self exportDidFinish:_assetExport];
         });
     }];
}

- (void)exportDidFinish:(AVAssetExportSession*)session
{
    if(session.status == AVAssetExportSessionStatusCompleted){
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                        completionBlock:^(NSURL *assetURL, NSError *error){
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
                                                    [alert show];
                                                }else{
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                                                    [alert show];
                                                }
                                                
                                            });
                                            
                                        }];
        }
    }
    
    audioAsset = nil;
    firstAsset = nil;
    secondAsset = nil;
    [activityView stopAnimating];
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

/*音频截取
 1. 创建AVURLAsset对象（继承了AVAsset）
 NSString *path = [[NSBundle mainBundle] pathForResource:@"陈奕迅 - 想哭" ofType:@"mp3"];
 NSURL *songURL = [NSURL fileURLWithPath:path];
 AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:songURL options:nil];
 2.创建音频文件
 NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
 NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
 NSString *exportPath = [[documentsDirectoryPath stringByAppendingPathComponent:EXPORT_NAME] retain];//EXPORT_NAME为导出音频文件名
 if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]) {
 [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
 }
 NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
 AVAssetWriter *assetWriter = [[AVAssetWriter assetWriterWithURL:exportURL
 fileType:AVFileTypeCoreAudioFormat
 error:&assetError]
 retain];
 if (assetError) {
 NSLog (@"error: %@", assetError);
 return;
 }
 
 3.创建音频输出会话
 AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:songAsset
 presetName:AVAssetExportPresetAppleM4A];
 4.设置音频截取时间区域 （CMTime在Core Medio框架中，所以要事先导入框架）
 CMTime startTime = CMTimeMake([_startTime.text floatValue], 1);
 CMTime stopTime = CMTimeMake([_endTime.text floatValue], 1);
 CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
 5.设置音频输出会话并执行
 exportSession.outputURL = [NSURL fileURLWithPath:filePath]; // output path
 exportSession.outputFileType = AVFileTypeAppleM4A; // output file type
 exportSession.timeRange = exportTimeRange; // trim time range
 [exportSession exportAsynchronouslyWithCompletionHandler:^{
 
 if (AVAssetExportSessionStatusCompleted == exportSession.status) {
 NSLog(@"AVAssetExportSessionStatusCompleted");
 } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
 // a failure may happen because of an event out of your control
 // for example, an interruption like a phone call comming in
 // make sure and handle this case appropriately
 NSLog(@"AVAssetExportSessionStatusFailed");
 } else {
 NSLog(@"Export Session Status: %d", exportSession.status);
 }
 }];
 */
@end
