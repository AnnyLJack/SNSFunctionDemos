//
//  PreviewPhotoCollectionView.m
//  SNSFunctionDemos
//
//  Created by wenjuanjiang on 24/5/16.
//  Copyright © 2016年 SohuSns. All rights reserved.
//

#import "PreviewPhotoCollectionView.h"
#import "PhotoAssetsCell.h"
#import "XMNPhotoManager.h"
@implementation PhotoFlowLayOut
- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    
    
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    
    
    for (UICollectionViewLayoutAttributes *att in arr) {
        if (att.representedElementCategory == UICollectionElementCategoryCell) {
            PhotoAssetsCell *cell = (PhotoAssetsCell *)[self.collectionView cellForItemAtIndexPath:att.indexPath];
            
            float offSet_x = fabs(self.collectionView.contentOffset.x - (att.frame.origin.x - CGRectGetWidth(self.collectionView.frame)));
            CGRect cellRect  = cell.photoStateButton.frame;
            cellRect.origin.x = MIN(offSet_x>MHeaderImaCellBtn_width?offSet_x-MHeaderImaCellBtn_width:0, fabs(CGRectGetWidth(att.frame) - CGRectGetWidth(cell.photoStateButton.frame)));
            cell.photoStateButton.frame = cellRect;
            
        }
    }
    
    return arr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

@end


@interface PreviewPhotoCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *assets;
@end

@implementation PreviewPhotoCollectionView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        PhotoFlowLayOut *layout = [[PhotoFlowLayOut alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 4;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        [self.collectionView registerClass:[PhotoAssetsCell class] forCellWithReuseIdentifier:@"imageCell"];
        self.collectionView.collectionViewLayout = layout;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        
        self.assets ? nil : [self _loadAssets];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)_loadAssets {
    
    __weak typeof(*&self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[XMNPhotoManager sharedManager] getAlbumsPickingVideoEnable:YES completionBlock:^(NSArray<XMNAlbumModel *> *albums) {
            if (albums && [albums firstObject]) {
                
                [[XMNPhotoManager sharedManager] getAssetsFromResult:[[albums firstObject] fetchResult] pickingVideoEnable:YES completionBlock:^(NSArray<XMNAssetModel *> *assets) {
                    __weak typeof(*&self) self = wSelf;
                    NSMutableArray *tempAssets = [NSMutableArray array];
                    [assets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(XMNAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [tempAssets addObject:obj];
                        *stop = ( tempAssets.count > 20);
                    }];
                    self.assets = [NSArray arrayWithArray:tempAssets];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        __weak typeof(*&self) self = wSelf;
                        [self.collectionView reloadData];
                    });
                }];
            }
        }];
    });
    
}
#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoAssetsCell *assetCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
//    assetCell.backgroundColor = [UIColor lightGrayColor];
    assetCell.contentView.clipsToBounds = NO;
    [assetCell configPreviewCellWithItem:self.assets[indexPath.row]];
    
//    __weak typeof(*&self) wSelf = self;
//    // 设置assetCell willChangeBlock
//    [assetCell setWillChangeSelectedStateBlock:^BOOL(XMNAssetModel *asset) {
//        if (!asset.selected) {
//            __weak typeof(*&self) self = wSelf;
//            if (asset.type == XMNAssetTypeVideo) {
//                if ([self.selectedAssets firstObject] && [self.selectedAssets firstObject].type != XMNAssetTypeVideo) {
//                    [self.parentController showAlertWithMessage:@"不能同时选择照片和视频"];
//                }else if ([self.selectedAssets firstObject]){
//                    [self.parentController showAlertWithMessage:@"一次只能发送1个视频"];
//                }else {
//                    return YES;
//                }
//                return NO;
//            }else if (self.selectedAssets.count > self.maxCount){
//                [self.parentController showAlertWithMessage:[NSString stringWithFormat:@"一次最多只能选择%d张图片",(int)self.maxCount]];
//                return NO;
//            }
//            return YES;
//        }else {
//            return NO;
//        }
//    }];
//    
//    // 设置assetCell didChangeBlock
//    [assetCell setDidChangeSelectedStateBlock:^(BOOL selected, XMNAssetModel *asset) {
//        __weak typeof(*&self) self = wSelf;
//        if (selected) {
//            [self.selectedAssets containsObject:asset] ? nil : [self.selectedAssets addObject:asset];
//            asset.selected = YES;
//        }else {
//            [self.selectedAssets containsObject:asset] ? [self.selectedAssets removeObject:asset] : nil;
//            asset.selected = NO;
//        }
//        [self _updatePhotoLibraryButton];
//    }];
//    
//    [assetCell setDidSendAsset:^(XMNAssetModel *asset, CGRect frame) {
//        if (asset.type == XMNAssetTypePhoto) {
//            self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(@[asset.previewImage],@[asset]) : nil;
//        }else {
//            self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(asset.previewImage , asset) : nil;
//        }
//    }];
    
    return assetCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMNAssetModel *asset = self.assets[indexPath.row];
    CGSize size = asset.previewImage.size;
    CGFloat scale = (size.width - 10)/size.height;
    return CGSizeMake(scale * (self.collectionView.frame.size.height),self.collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XMNAssetModel *assetModel = self.assets[indexPath.row];
//    if (assetModel.type == XMNAssetTypeVideo) {
//        XMNVideoPreviewController *videoPreviewC = [[XMNVideoPreviewController alloc] init];
//        videoPreviewC.selectedVideoEnable = self.selectedAssets.count == 0;
//        videoPreviewC.asset = assetModel;
//        __weak typeof(*&self) wSelf = self;
//        [videoPreviewC setDidFinishPickingVideo:^(UIImage *coverImage, XMNAssetModel *asset) {
//            __weak typeof(*&self) self = wSelf;
//            self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(coverImage,asset) : nil;
//            [self hideAnimated:NO];
//            [self.parentController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [self.parentController presentViewController:videoPreviewC animated:YES completion:nil];
//    }else {
//        XMNPhotoPreviewController *previewC = [[XMNPhotoPreviewController alloc] initWithCollectionViewLayout:[XMNPhotoPreviewController photoPreviewViewLayoutWithSize:[UIScreen mainScreen].bounds.size]];
//        previewC.assets = self.assets;
//        previewC.maxCount = self.maxCount;
//        previewC.selectedAssets = [NSMutableArray arrayWithArray:self.selectedAssets];
//        previewC.currentIndex = indexPath.row;
//        __weak typeof(*&self) wSelf = self;
//        [previewC setDidFinishPreviewBlock:^(NSArray<XMNAssetModel *> *selectedAssets) {
//            __weak typeof(*&self) self = wSelf;
//            self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
//            [self _updatePhotoLibraryButton];
//            [self.collectionView reloadData];
//            [self.parentController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        
//        [previewC setDidFinishPickingBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
//            __weak typeof(*&self) self = wSelf;
//            [self.selectedAssets removeAllObjects];
//            self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(images,assets) : nil;
//            [self hideAnimated:NO];
//            [self.parentController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        
//        [self.parentController presentViewController:previewC animated:YES completion:nil];
//    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}
@end
