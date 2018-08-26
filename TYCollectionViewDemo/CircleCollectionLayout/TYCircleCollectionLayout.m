//
//  TYCircleCollectionLayout.m
//  TYCollectionViewDemo
//
//  Created by tybbt on 2018/8/24.
//  Copyright © 2018年 tybbt. All rights reserved.
//

#import "TYCircleCollectionLayout.h"

static const UIEdgeInsets defaultInsets = {5,5,5,5};

@interface TYCircleCollectionLayout()
@property (nonatomic, strong) NSMutableArray * attrArray;
@property (nonatomic, strong) NSMutableArray * coordinateArray;

/** required argument */
- (CGSize)itemSizeAtIndex:(NSIndexPath *)indexPath;
- (NSUInteger)itemCount;

/** optional argument */
@property (nonatomic, assign) CGPoint centerPoint; //prepare for custom center point,if custom,need confirm to protocol or it will be default.
- (CGFloat)radius;
- (CGFloat)degrees;
- (UIEdgeInsets)sectionInsets;
- (CGPoint)centerPointInFrame:(CGRect)frame;
@end

@implementation TYCircleCollectionLayout
#pragma 数据处理
- (CGSize)itemSizeAtIndex:(NSIndexPath *)indexPath
{
    NSAssert(self.delegate && [_delegate respondsToSelector:@selector(SizeOfItemInLayout:atIndexPath:)], @"ensure you have an delegate and your delegate is confirm to function -SizeOfItemInLayout:atIndexPath:");
    return [_delegate SizeOfItemInLayout:self atIndexPath:indexPath];
}

- (NSUInteger)itemCount
{
    NSAssert(self.delegate && [_delegate respondsToSelector:@selector(numberOfItemInCircleLayout:)], @"ensure  you have an delegate and your delegate is confirm to function -numberOfItemInCircleLayout:");
    return [_delegate numberOfItemInCircleLayout:self];
}

- (CGFloat)radius
{
    NSAssert((self.delegate && [_delegate respondsToSelector:@selector(CollectionViewCircleRadiusInLayout:)]), @"ensure  you have an delegate and your delegate is confirm to function -CollectionViewCircleRadiusInLayout:");
    return [_delegate CollectionViewCircleRadiusInLayout:self];
}

- (CGFloat)degrees
{
    if (self.delegate && [_delegate respondsToSelector:@selector(degreesBetweenEachItemInCircleLayout:)])
    {
        return [_delegate degreesBetweenEachItemInCircleLayout:self];
    }
    /** when use degrees,you should use formula: realDegrees = (degrees/360)*PI to calculate the coordinate on circle*/
    return [self calculateDefaultDegress];
}

- (UIEdgeInsets)sectionInsets
{
    if (self.delegate && [_delegate respondsToSelector:@selector(sectionEdgeInsetsInLayout:)])
    {
        return [_delegate sectionEdgeInsetsInLayout:self];
    } else {
        return defaultInsets;
    }
}

- (CGPoint)centerPointInFrame:(CGRect)frame
{
    if (self.delegate && [_delegate respondsToSelector:@selector(CircleCenterPointRelativeToLayoutFrame:)] && !_circleCenterDefault)
    {
        return [_delegate CircleCenterPointRelativeToLayoutFrame:frame];
    }
    return self.collectionView.center;
}

- (CGFloat)calculateDefaultDegress
{
    return 360/self.itemCount;
}

#pragma lazy load
- (NSMutableArray *)attrArray
{
    if (!_attrArray)
    {
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

- (NSMutableArray *)coordinateArray
{
    if (!_coordinateArray)
    {
        _coordinateArray = [NSMutableArray array];
    }
    return _coordinateArray;
}

- (CGPoint)centerPoint
{
    if (!CGPointEqualToPoint(_centerPoint, CGPointZero))
    {
        [self centerPointInFrame:self.collectionView.bounds];
    }
    return _centerPoint;

}

#pragma Layout function
- (void)prepareLayout
{
    [super prepareLayout];
    [self calculateCoordinate];
    [self.attrArray removeAllObjects];
    for(NSUInteger i=0; i<self.itemCount; i++)
    {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrArray addObject:attribute];
    }
}

- (void)calculateCoordinate
{
    [self.coordinateArray removeAllObjects];
    CGPoint originPoint = CGPointMake(self.centerPoint.x, self.centerPoint.y-self.radius); //base coordinate is in y axes,radius from center
    [self.coordinateArray addObject:@(originPoint)];
    for(NSUInteger i=1; i<self.itemCount; i++)
    {
        CGFloat x = self.centerPoint.x + self.radius * sin((self.degrees*i)/360 * M_PI);
        CGFloat y = self.centerPoint.y + self.radius * cos((self.degrees*i)/360 * M_PI);
        [self.coordinateArray addObject:@(CGPointMake(x, y))];
    }
}
/**
 | coordinate point
 +-----------------------------+    when layout must calculate the coordinate with center point.
 |                             |
 |                             |
 |       center . Point        |
 |                             |
 |                             |
 +-----------------------------+
 
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGSize itemSize = [self itemSizeAtIndex:indexPath];
    CGFloat halfWidth = itemSize.width /2;
    CGFloat halfHeight = itemSize.height /2;
    
    NSValue * val = self.coordinateArray[indexPath.item];
    CGPoint center = [val CGPointValue];
    attribute.frame = CGRectMake(center.x - halfWidth, center.y - halfHeight, itemSize.width, itemSize.height);
    
    return attribute;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrArray;
}

@end
