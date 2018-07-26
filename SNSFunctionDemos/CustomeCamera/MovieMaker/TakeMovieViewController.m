//
//  TakeMovieViewController.m
//  ZZYWeiXinShortMovie
//
//  Created by zhangziyi on 16/3/23.
//  Copyright © 2016年 GLaDOS. All rights reserved.
//
#define Screen_width [UIScreen mainScreen].bounds.size.width
#define Screen_height [UIScreen mainScreen].bounds.size.height
#import "TakeMovieViewController.h"
#import "Camera.h"
#import "StartButton.h"
#import <QuartzCore/QuartzCore.h>
//#import <MediaPlayer/MediaPlayer.h>
#define VIDEO_FOLDER    @"videos"
#import "SVProgressHUD.h"
#import "PlayMovieViewController.h"
#define  MinTime  3
#define  MaxTime  30
@interface TakeMovieViewController () <AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureFileOutputRecordingDelegate,UIGestureRecognizerDelegate>
{
    Camera *_camera;
    UIView *cameraView;
    BOOL isStart;
    BOOL isCancel;
    CALayer *progressLayer;
    StartButton *startButton;
    UILabel *tipsLabel;
    NSTimer *timer;
    NSInteger time;
    NSString *filePath;
    NSURL *_finashURL;
//    MPMoviePlayerController *_player;
}
@property (nonatomic,assign) CGFloat cameraTime;
@property (nonatomic,assign) NSInteger frameNum;

@property (nonatomic ,strong) UIView *preViewView;
@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@end

@implementation TakeMovieViewController

- (instancetype)initWithCameraTime:(CGFloat)cameraTime frameNum:(NSInteger)frameNum {
    
    self = [super init];
    if (self) {
        self.cameraTime = cameraTime;
        self.frameNum = frameNum;
    }
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.tintColor = [UIColor greenColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //创建视频存储目录
    [[self class] createVideoFolderIfNotExist];
    
    isStart = NO;
//    imagesArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor blackColor];
    [self initCamera];//初始化摄像头
    [self initPreView];//初始化预览gif的view
    [self initStartButton];//初始化开始拍摄按钮
    //相机权限受限提示
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied ||authStatus == AVAuthorizationStatusRestricted) {
        NSLog(@"相机权限受限");
    }
    //拍摄手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    panGesture.delegate = self;
    [startButton addGestureRecognizer:panGesture];
    UILongPressGestureRecognizer *longPressGeture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(startAction:)];
    longPressGeture.delegate = self;
    longPressGeture.minimumPressDuration = 0.1;
    [startButton addGestureRecognizer:longPressGeture];
    
    UIBarButtonItem *redoButton = [[UIBarButtonItem alloc]initWithTitle:@"重拍" style:UIBarButtonItemStylePlain target:self action:@selector(resetCamera:)];
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItems = @[finishButton,redoButton];
}

+ (BOOL)createVideoFolderIfNotExist
{
    // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path =[NSString stringWithFormat:@"%@/tmp/",NSHomeDirectory()];
    
    //[paths objectAtIndex:0];
    
    NSString *folderPath = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建图片文件夹失败");
            return NO;
        }
        return YES;
    }
    return YES;
}

-(void)initCamera{
    cameraView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height/2)];
    [self.view insertSubview:cameraView atIndex:0];
    _camera = [[Camera alloc]init];
    _camera.frameNum = _frameNum;
    [_camera embedLayerWithView:cameraView];
//    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
//    [_camera.deviceVideoOutput setSampleBufferDelegate:self queue:queue];
    [_camera startCamera];
}
-(void)initPreView{
    self.preViewView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 320, 320)];
    [self.view addSubview:self.preViewView];
    self.preViewView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPreView)];
    [self.preViewView addGestureRecognizer:tap];
    
}
- (void)initPlayer {
    if (_finashURL) {
        AVURLAsset *movieAsset    = [[AVURLAsset alloc]initWithURL:_finashURL options:nil];
        
        
        self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
        
//        [self.playerItem addObserver:self forKeyPath:@"status" options:0 context:NULL];
        
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        playerLayer.frame = self.preViewView.frame;
        
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        
        [self.preViewView.layer addSublayer:playerLayer];
        self.player.volume = 0;
//        [self.player setAllowsExternalPlayback:YES];
        [self.player play];
    }
}
-(void)initStartButton{
    startButton = [[StartButton alloc]initWithFrame:CGRectMake(Screen_width/4, Screen_height/2+Screen_height/16, Screen_width/2, Screen_width/2)];
    [self.view addSubview:startButton];
}
-(void)initProgress{
    progressLayer = [CALayer layer];
    progressLayer.backgroundColor = [UIColor greenColor].CGColor;
    progressLayer.frame = CGRectMake(0, Screen_height/2, Screen_width, 5);
    [self.view.layer addSublayer:progressLayer];
    CABasicAnimation *countTime = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    countTime.toValue = @0;
    countTime.duration = _cameraTime;
    countTime.removedOnCompletion = NO;
    countTime.fillMode = kCAFillModeForwards;
    [progressLayer addAnimation:countTime forKey:@"progressAni"];
}
- (void)touchPreView {
    [self.player pause];
    [self play];
}
-(void)panAction:(UIPanGestureRecognizer*)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    if (point.y < Screen_height/2) {
        isCancel = YES;
        progressLayer.backgroundColor = [UIColor redColor].CGColor;
        tipsLabel.text = @"松手取消";
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.backgroundColor = [UIColor redColor];
    }
    else{
        isCancel = NO;
        progressLayer.backgroundColor = [UIColor greenColor].CGColor;
        tipsLabel.text = @"⬆️上移取消";
        tipsLabel.textColor = [UIColor greenColor];
        tipsLabel.backgroundColor = [UIColor clearColor];
    }
}
+ (NSString *)getVideoSaveFilePathString
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //  NSString *path = [paths objectAtIndex:0];
    
    NSString *path =[NSString stringWithFormat:@"%@/tmp/",NSHomeDirectory()];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    
    return fileName;
    
}
-(void)startAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        isStart = YES;
        isCancel = NO;
        [startButton disappearAnimation];
        [self initProgress];
        tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(Screen_width/2-42, Screen_height/2-30, 84, 20)];
        tipsLabel.font = [UIFont systemFontOfSize:14];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.text = @"⬆️上移取消";
        tipsLabel.textColor = [UIColor greenColor];
        [self.view addSubview:tipsLabel];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        time = 0;
        NSLog(@"start");
        filePath = [[self class] getVideoSaveFilePathString];
        [_camera.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:filePath] recordingDelegate:self];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if (isCancel) {
            NSLog(@"cancel");
            isStart = NO;
            [timer invalidate];
            [progressLayer removeFromSuperlayer];
            [tipsLabel removeFromSuperview];
            [startButton appearAnimation];
            [_camera.movieFileOutput stopRecording];
            return;
        }
        else{
            if (time < MinTime) {
                isStart = NO;
                [timer invalidate];
//                [imagesArray removeAllObjects];
                [progressLayer removeFromSuperlayer];
                [startButton appearAnimation];
                tipsLabel.text = @"手指不要放开";
                tipsLabel.textColor = [UIColor whiteColor];
                tipsLabel.backgroundColor = [UIColor redColor];
                [UIView animateWithDuration:2.0 animations:^{
                    tipsLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    [tipsLabel removeFromSuperview];
                }];
                [_camera.movieFileOutput stopRecording];
                
                return;
            }
            else if(time >=MinTime && time < _cameraTime){
                [self finishCamera];
            }
        }
    }
}
-(void)countDown:(NSTimer*)timerer{
    time++;
    if (time >= _cameraTime) {
        [self finishCamera];
    }
    NSLog(@"%ld",(long)time);
}
-(void)resetCamera:(UIBarButtonItem*)sender{
    cameraView.hidden = NO;
    [_camera startCamera];
    startButton.hidden = NO;
    [startButton appearAnimation];
    NSFileManager *file = [[NSFileManager alloc] init];
    [file removeItemAtPath:filePath error:nil];
//    [imagesArray removeAllObjects];
}
- (void)finishCamera{
    [timer invalidate];
//    NSLog(@"%@",imagesArray);
//    NSLog(@"totle=%ld",(unsigned long)imagesArray.count);
//    [_camera stopCamera];
    [_camera.movieFileOutput stopRecording];
    isStart = NO;
    [progressLayer removeFromSuperlayer];
    [tipsLabel removeFromSuperview];
    startButton.hidden = YES;
//    //预览gif动画
//    preView.animationImages = imagesArray;
//    preView.animationDuration = time;
//    preView.animationRepeatCount = 0;
//    preView.hidden = NO;
    self.preViewView.hidden = NO;
    cameraView.hidden = YES;
//    [preView startAnimating];
    [SVProgressHUD showWithStatus:@"请稍等..."];
    
}
#pragma mark - 合成文件
- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray
{
    NSError *error = nil;
    
    CGSize renderSize = CGSizeMake(0, 0);
    
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    CMTime totalDuration = kCMTimeZero;
    
    //先去assetTrack 也为了取renderSize
    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    
    
    for (NSURL *fileURL in fileURLArray)
    {
        
        AVAsset *asset = [AVAsset assetWithURL:fileURL];
        
        if (!asset) {
            continue;
        }
        NSLog(@"%@---%@",asset.tracks,[asset tracksWithMediaType:@"vide"]);
        
        [assetArray addObject:asset];
        
        
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:@"vide"] objectAtIndex:0];
        
        [assetTrackArray addObject:assetTrack];
        
        renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
        renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
    }
    
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    
    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {
        
        AVAsset *asset = [assetArray objectAtIndex:i];
        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:totalDuration
                              error:nil];
        
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        //fix orientationissue
        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
        
        CGFloat rate;
        rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影响
        layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
        
        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
        
        //data
        [layerInstructionArray addObject:layerInstruciton];
    }
    
    //get save path
    NSString *lastFilePath = [[self class] getVideoMergeFilePathString];
    
    NSURL *mergeFileURL = [NSURL fileURLWithPath:lastFilePath];
    
    //export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _finashURL=mergeFileURL;
            [SVProgressHUD dismiss];
            
            [self initPlayer];
//            UISaveVideoAtPathToSavedPhotosAlbum(lastFilePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            
            
            
            //            if ([_delegate respondsToSelector:@selector(videoRecorder:didFinishMergingVideosToOutPutFileAtURL:)]) {
            //                [_delegate videoRecorder:self didFinishMergingVideosToOutPutFileAtURL:mergeFileURL];
            //            }
        });
    }];
}
+ (NSString *)getVideoMergeFilePathString
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //  NSLog(@"",);
    NSString *path =[NSString stringWithFormat:@"%@/tmp/",NSHomeDirectory()];
    // [paths objectAtIndex:0];
    
    path = [path stringByAppendingPathComponent:VIDEO_FOLDER];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@"merge.mp4"];
    
    return fileName;
}

-(void)done:(UIBarButtonItem*)sender{
    //push viewcontroller
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    
    NSLog(@"%@",videoPath);
    
    NSLog(@"%@",error);
    
}
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
//    [self startCountDurTimer];
    NSLog(@"didStartRecordingToOutputFileAtURL");
    
    //    self.currentFileURL = fileURL;
    //
    //    self.currentVideoDur = 0.0f;
    //    [self startCountDurTimer];
    //
    //    if ([_delegate respondsToSelector:@selector(videoRecorder:didStartRecordingToOutPutFileAtURL:)]) {
    //        [_delegate videoRecorder:self didStartRecordingToOutPutFileAtURL:fileURL];
    //    }
}
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
     NSLog(@"didFinishRecordingToOutputFileAtURL---%@",outputFileURL);
    if (!isCancel && time >= 1) {
        [self mergeAndExportVideosAtFileURLs:@[[NSURL fileURLWithPath:filePath]]];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
//    if (isStart) {
//        UIImage *image = [self imageFromSampleBuffer:&sampleBuffer];
//        image = [self normalizedImage:image];
//        [imagesArray addObject:image];
//    }
//}
//-(UIImage*) imageFromSampleBuffer:(CMSampleBufferRef*)sampleBuffer{
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(*sampleBuffer);
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
//    void *basdAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(basdAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    UIImage *image  = [UIImage imageWithCGImage:quartzImage scale:1.0 orientation:UIImageOrientationRight];
//    CGImageRelease(quartzImage);
//    return (image);
//}
//- (UIImage *)normalizedImage:(UIImage*)image {
//    if (image.imageOrientation == UIImageOrientationUp) return image;
//    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
//    [image drawInRect:(CGRect){0, 0, image.size}];
//    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return normalizedImage;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)play {
    
    PlayMovieViewController *playVideoVC=[[PlayMovieViewController alloc]init];
    playVideoVC.fileURL=_finashURL;
    [self.navigationController pushViewController:playVideoVC animated:YES];
//        _player  = [[MPMoviePlayerController alloc] initWithContentURL:_finashURL];
//    
//        _player.scalingMode = MPMovieScalingModeAspectFit;
//    
//        [self.view addSubview:_player.view];
//    
//        [_player setFullscreen:YES animated:YES];
//        [_player prepareToPlay];
//    
//        [_player play];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com