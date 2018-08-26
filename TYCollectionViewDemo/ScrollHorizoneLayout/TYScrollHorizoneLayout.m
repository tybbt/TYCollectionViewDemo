//
//  TYScrollHorizoneLayout.m
//  TYCollectionViewDemo
//
//  Created by tybbt on 2018/8/19.
//  Copyright © 2018年 tybbt. All rights reserved.
//

#import "TYScrollHorizoneLayout.h"

@interface TYScrollHorizoneLayout()
{
    CGFloat _viewHeight;
    CGFloat _itemHeight;
}
@end

@implementation TYScrollHorizoneLayout

- (void)prepareLayout
{
    [super prepareLayout];
    if (self.visibleCount < 1) {
        self.visibleCount = 5;
    }
    _viewHeight = self.collectionView.frame.size.height;
    _itemHeight = self.itemSize.height;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, (_viewHeight-_itemHeight)/2, 0, (_viewHeight-_itemHeight)/2);
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerY = self.collectionView.contentOffset.x + _viewHeight / 2;
    NSInteger index = centerY / _itemHeight;
    NSInteger count = (self.visibleCount - 1) / 2;
    NSInteger minIndex = MAX(0, (index - count));
    NSInteger maxIndex = MIN((cellCount - 1), (index + count));
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = minIndex; i <= maxIndex; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attributes];
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    CGFloat cY = self.collectionView.contentOffset.x + _viewHeight / 2;
    CGFloat attributesY = _itemHeight * indexPath.row + _itemHeight / 2;
    attributes.zIndex = -ABS(attributesY - cY);
    
    CGFloat delta = cY - attributesY;
    CGFloat ratio =  - delta / (_itemHeight * 2);
    CGFloat scale = 1 - ABS(delta) / (_itemHeight * 6.0) * cos(ratio * M_PI_4);
    attributes.transform = CGAffineTransformMakeScale(scale, scale);
    
    CGFloat centerY = attributesY;
    
    centerY = cY + sin(ratio * M_PI_2) * _itemHeight * 0.65;
    
    
    attributes.center = CGPointMake(centerY, CGRectGetHeight(self.collectionView.frame) / 2);
    
    return attributes;
}

//这个方法的返回值，就决定了collectionView停止滚动时的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat index = roundf((proposedContentOffset.x + _viewHeight / 2 - _itemHeight / 2) / _itemHeight);
    proposedContentOffset.x = _itemHeight * index + _itemHeight / 2 - _viewHeight / 2;
    return proposedContentOffset;
}

//这个方法的返回值，决定了当collectionview的显示范围发生改变的时候，是否需要刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}



@end
