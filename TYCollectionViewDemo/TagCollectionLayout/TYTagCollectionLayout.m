//
//  TYTagCollectionLayout.m
//  TYCollectionViewDemo
//
//  Created by tybbt on 2018/8/25.
//  Copyright © 2018年 tybbt. All rights reserved.
//

/**
'--' itemWidth  '__' emptyWidth  '.' minLineSpacing
 
---.----.---.-----.---_
-- ---- ---- -- --- ---
---- -- --- ---- - ----
--- ---- - - ---- -- __
----- - --- ---- --- --
-- ---
 
 */
#import "TYTagCollectionLayout.h"
#define MAXLineEmptyWidth CGRectGetWidth(self.collectionView.frame)-self.sectionInset.left-self.sectionInset.right

@interface TYTagCollectionLayout()
@property (nonatomic, strong) NSMutableArray * attrArray;
@property (nonatomic, assign) NSInteger itemCount;

@property (nonatomic, assign) CGFloat currentXOffset;
@property (nonatomic, assign) CGFloat currentYOffset;
@property (nonatomic, assign) CGFloat currentLineEmptyWidth;
@end

@implementation TYTagCollectionLayout

- (NSMutableArray *)attrArray
{
    if (!_attrArray)
    {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

#pragma mark - @Override
- (void)prepareLayout
{
    [super prepareLayout];
    self.itemCount = [self.collectionView numberOfItemsInSection:0];
    self.currentXOffset = self.sectionInset.left;
    self.currentYOffset = self.sectionInset.top;
    self.currentLineEmptyWidth = MAXLineEmptyWidth;
    
    [self.attrArray removeAllObjects];
    for(NSInteger i=0; i<_itemCount; i++)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrArray addObject:attribute];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    self.itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    if (self.itemSize.width > _currentLineEmptyWidth) {
        CGFloat h = self.itemSize.height;
        self.itemSize = CGSizeMake(_currentLineEmptyWidth, h);
    }
    CGFloat cellX = 0.0;
    CGFloat cellY = 0.0;
    if (_currentLineEmptyWidth > self.itemSize.width)
    {
        cellX = _currentXOffset;
        cellY = _currentYOffset;
        self.currentXOffset = _currentYOffset + self.itemSize.width + self.minimumLineSpacing;
        self.currentLineEmptyWidth = _currentLineEmptyWidth - self.itemSize.width - self.minimumLineSpacing;
    } else {
        self.currentXOffset = self.sectionInset.left;
        self.currentYOffset = _currentYOffset + self.itemSize.height + self.minimumInteritemSpacing;
        self.currentLineEmptyWidth = MAXLineEmptyWidth;
        cellX = _currentXOffset;
        cellY = _currentYOffset;
        self.currentXOffset = _currentYOffset + self.itemSize.width + self.minimumLineSpacing;
        self.currentLineEmptyWidth = _currentLineEmptyWidth - self.itemSize.width - self.minimumLineSpacing;
    }
    attribute.frame = CGRectMake(cellX, cellY, self.itemSize.width, self.itemSize.height);
    return attribute;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrArray;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.currentYOffset + self.itemSize.height +self.sectionInset.bottom);
}

@end
