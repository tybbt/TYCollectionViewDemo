//
//  TYWaterFlowCollectionLayout.h
//  TYCollectionViewDemo
//
//  Created by tybbt on 2018/8/23.
//  Copyright © 2018年 tybbt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYWaterFlowCollectionLayout;
@protocol TYWaterFlowCollectionLayout <UICollectionViewDelegate>

@required
/** 获取每个item布局高度 */
- (CGFloat)waterFallLayout:(TYWaterFlowCollectionLayout *)waterFallLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@optional
/** 有多少列 */
- (NSUInteger)numberOfItemInLine: (TYWaterFlowCollectionLayout *)waterFallLayout;

/** 每列之间的间距 */
- (CGFloat)minimumLineSpacingInWaterFallLayout:(TYWaterFlowCollectionLayout *)waterFallLayout;

/** 每行之间的间距 */
- (CGFloat)minimumInteritemSpacingInWaterFallLayout:(TYWaterFlowCollectionLayout *)waterFallLayout;

/** 每个item的内边距 */
- (UIEdgeInsets)itemEdgeInsetdInWaterFallLayout:(TYWaterFlowCollectionLayout *)waterFallLayout;

/** 每个section的内边距 */
- (UIEdgeInsets)sectionEdgeInsetdInWaterFallLayout:(TYWaterFlowCollectionLayout *)waterFallLayout;

@end

@interface TYWaterFlowCollectionLayout : UICollectionViewLayout
@property (nonatomic, weak) id<TYWaterFlowCollectionLayout> delegate;
@end
