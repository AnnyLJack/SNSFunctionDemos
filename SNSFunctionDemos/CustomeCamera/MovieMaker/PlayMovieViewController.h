//
//  PlayMovieViewController.h
//  SNSFunctionDemos
//
//  Created by wenjuanjiang on 31/5/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TakeMovieViewController;
@interface PlayMovieViewController : UIViewController
@property(nonatomic,strong)NSURL   *fileURL;
@property(nonatomic,weak)TakeMovieViewController *delegate;
@end
