//
//  PhotoAssetsCell.h
//  SNSFunctionDemos
//
//  Created by wenjuanjiang on 24/5/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMNAssetModel.h"
static float MHeaderImaCellBtn_x_space = 5;
static float MHeaderImaCellBtn_width = 40;
@interface PhotoAssetsCell : UICollectionViewCell
/**
 *  具体的资源model
 */
@property (nonatomic, strong, readonly, nonnull) XMNAssetModel *asset;

@property (nonatomic, strong) UIImageView *photoImageView;
/** 选中按纽*/
@property (nonatomic, strong) UIButton *photoStateButton;
/**
 *  XMNPhotoCollectionController 中配置collectionView的cell
 *
 *  @param item 具体的AssetModel
 */
- (void)configCellWithItem:(XMNAssetModel * _Nonnull )item;

/**
 *  XMNPhotoPicker 中配置collectionView的cell
 *
 *  @param item 具体的AssetModel
 */
- (void)configPreviewCellWithItem:(XMNAssetModel * _Nonnull )item;
@end
