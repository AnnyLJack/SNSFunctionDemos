//
//  PhotoAssetsCell.m
//  SNSFunctionDemos
//
//  Created by wenjuanjiang on 24/5/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "PhotoAssetsCell.h"

@implementation PhotoAssetsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.photoImageView.clipsToBounds = YES;
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoStateButton.frame = CGRectMake(frame.size.width - 27, 0, 27, 27);
        [self.photoStateButton setBackgroundColor:[UIColor greenColor]];
        [self.photoStateButton addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.photoImageView];
        [self.contentView addSubview:self.photoStateButton];
    }
    return self;
}

/**
 *  XMNPhotoCollectionController 中配置collectionView的cell
 *
 *  @param item 具体的AssetModel
 */
- (void)configCellWithItem:(XMNAssetModel * _Nonnull )item {
    _asset = item;
    switch (item.type) {
        case XMNAssetTypeVideo:
        case XMNAssetTypeAudio:
            break;
        case XMNAssetTypeLivePhoto:
        case XMNAssetTypePhoto:
            break;
    }
    self.photoStateButton.selected = item.selected;
    self.photoImageView.image = item.thumbnail;
    [self.photoStateButton setBackgroundColor:self.photoStateButton.isSelected?[UIColor redColor]:[UIColor greenColor]];
}

/**
 *  XMNPhotoPicker 中配置collectionView的cell
 *
 *  @param item 具体的AssetModel
 */
- (void)configPreviewCellWithItem:(XMNAssetModel * _Nonnull )item {
    _asset = item;
    switch (item.type) {
        case XMNAssetTypeVideo:
        case XMNAssetTypeAudio:
            break;
        case XMNAssetTypeLivePhoto:
        case XMNAssetTypePhoto:
            break;
    }
    self.photoImageView.image = item.previewImage;
    self.photoStateButton.selected = item.selected;
    [self.photoStateButton setBackgroundColor:self.photoStateButton.isSelected?[UIColor redColor]:[UIColor greenColor]];
}

- (void)selectBtnAction:(UIButton *)sender {
    [self.photoStateButton setSelected:!self.photoStateButton.isSelected];
    [self.photoStateButton setBackgroundColor:self.photoStateButton.isSelected?[UIColor redColor]:[UIColor greenColor]];
}
@end
