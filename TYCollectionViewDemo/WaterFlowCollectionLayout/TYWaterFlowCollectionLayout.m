//
//  TYWaterFlowCollectionLayout.m
//  TYCollectionViewDemo
//
//  Created by tybbt on 2018/8/23.
//  Copyright © 2018年 tybbt. All rights reserved.
//
//  关于自定义CollectionView相关重栽方法参见:
//  https://www.jianshu.com/p/45ff718090a8
//
//  BeforeShowRelationView: prepareLayout -> collectionViewContentSize -> layoutAttributesForElementsInRect
//  RealLayout: prepareLayout -> layoutAttributesForItemAtIndexPath -> collectionViewContentSize -> layoutAttributesForElementsInRect
//

#import "TYWaterFlowCollectionLayout.h"

static const NSUInteger kNumberOfItemInLine = 2;
static const CGFloat kMinimumLineSpacing = 3;
static const CGFloat kMinimumInteritemSpacing = 3;
static const UIEdgeInsets defaultInsets = {5,5,5,5};

@interface TYWaterFlowCollectionLayout()
@property (nonatomic, strong) NSMutableArray * attrArray;
@property (nonatomic, strong) NSMutableArray * heightArray;
@property (nonatomic, assign) CGFloat MaxCollectionHeight;
- (NSUInteger)columnCount;
- (CGFloat)minLineSpacing;
- (CGFloat)minInteritemSpacing;
- (UIEdgeInsets)itemEdgeInsets;
- (UIEdgeInsets)sectionInsets;
@end

@implementation TYWaterFlowCollectionLayout
#pragma function argument
- (NSUInteger)columnCount
{
    if (self.delegate && [_delegate respondsToSelector:@selector(numberOfItemInLine:)]) {
        return [_delegate numberOfItemInLine:self];
    }
    return kNumberOfItemInLine;
}

- (CGFloat)minLineSpacing
{
    if (self.delegate && [_delegate respondsToSelector:@selector(minLineSpacing)]) {
        return [_delegate minimumLineSpacingInWaterFallLayout:self];
    }
    return kMinimumLineSpacing;
}

- (CGFloat)minInteritemSpacing
{
    if (self.delegate && [_delegate respondsToSelector:@selector(minimumLineSpacingInWaterFallLayout:)]) {
        return [_delegate minimumInteritemSpacingInWaterFallLayout:self];
    }
    return kMinimumInteritemSpacing;
}

- (UIEdgeInsets)itemEdgeInsets
{
    if (self.delegate && [_delegate respondsToSelector:@selector(itemEdgeInsetdInWaterFallLayout:)]) {
        return [_delegate itemEdgeInsetdInWaterFallLayout:self];
    }
    return defaultInsets;
}

- (UIEdgeInsets)sectionInsets
{
    if (self.delegate && [_delegate respondsToSelector:@selector(sectionEdgeInsetdInWaterFallLayout:)]) {
        return [_delegate sectionEdgeInsetdInWaterFallLayout:self];
    }
    return defaultInsets;
}

#pragma lazy load
- (NSMutableArray *)attrArray
{
    if (!_attrArray) {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

- (NSMutableArray *)heightArray
{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

#pragma Layout prefix & calculate
/** 预计算布局相关属性 */
- (void)prepareLayout
{
    [super prepareLayout];
    self.MaxCollectionHeight = 0;
    [self.attrArray removeAllObjects];
    [self.heightArray removeAllObjects];
    // 设置每一列默认的高度
    for (NSInteger i = 0; i < kNumberOfItemInLine ; i ++) {
        [self.heightArray addObject:@(self.sectionInsets.top)];
    }
    
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        
        // 创建位置
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 获取indexPath位置上cell对应的布局属性
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrArray addObject:attrs];
    }
}

/** IndexPath位置上的item布局属性 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionWidth = self.collectionView.frame.size.width;
    
    CGFloat cellW = collectionWidth - (self.sectionInsets.left+self.sectionInsets.right) - self.minLineSpacing*(self.columnCount-1)/self.columnCount;
    CGFloat cellH = [_delegate waterFallLayout:self heightForItemAtIndexPath:indexPath itemWidth:cellW];
    
    NSInteger minValueIndex = 0;
    CGFloat minColumnHeight = [self.heightArray[minValueIndex] doubleValue];
    NSInteger i = 0;
    for (id obj in self.heightArray)
    {
        if (minColumnHeight < [obj doubleValue])
        {
            minColumnHeight = [obj doubleValue];
            minValueIndex = i;
        }
        i++;
    }
    
    CGFloat cellX = self.sectionInsets.left + minValueIndex * (cellW+self.minLineSpacing);
    CGFloat cellY = minColumnHeight;
    if (cellY != self.sectionInsets.top) {
        cellY += self.minInteritemSpacing;
    }
    attribute.frame = CGRectMake(cellX, cellY, cellW, cellH);
    
    [self.heightArray replaceObjectAtIndex:minValueIndex withObject:@(CGRectGetMaxY(attribute.frame))];
    self.MaxCollectionHeight = (self.MaxCollectionHeight < CGRectGetMaxY(attribute.frame)) ? CGRectGetMaxY(attribute.frame) : _MaxCollectionHeight;
    
    return attribute;
}

/** collectionview域内所有item的布局属性 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrArray;
}

/** 计算最终scrollview的contentsize */
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, _MaxCollectionHeight + self.sectionInsets.bottom);
}

/** 用于获取滑动惯性，velocity是速度，x、y分别是水平一直垂直方向速度，+-代表速度方向 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
}

@end
