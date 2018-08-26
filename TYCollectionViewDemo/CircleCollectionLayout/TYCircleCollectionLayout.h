//
//  TYCircleCollectionLayout.h
//  TYCollectionViewDemo
//
//  Created by tybbt on 2018/8/24.
//  Copyright © 2018年 tybbt. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 1.full collection : all cell have equal distance to each coordinate;
                cell
 
 
        cell            cell
 
 
 cell                           cell
 
 
        cell            cell
 
 
                cell
 
 2.sector collection: cell distance to each is equal but have some empty coordinate in circle make it seems like sector;
                cell
                  |
      empty       |      cell
                  |    /
                  |   /
                  |  /
                  |_/degrees
empty             |/                 cell
 
 
 
        cell            cell
 
 
                cell
 */

@class TYCircleCollectionLayout;

@protocol TYCircleCollectionLayout <NSObject>
@required

/**
 @method: numberOfItemInCircleLayout:
 @description: the method is requied to give the item in circle ,the collection default show item in equidistance and equal degrees.
 */
- (NSUInteger)numberOfItemInCircleLayout:(TYCircleCollectionLayout *)circleLayout;

/**
 @method: SizeOfItemInLayout:SizeOfItemInLayout:
 @description: provide the size at each index;
 */
- (CGSize)SizeOfItemInLayout:(TYCircleCollectionLayout *)circleLayout atIndexPath:(NSIndexPath *)indexPath;

/**
 @method: CollectionViewCircleRadiusInLayout:
 @description: make the radius for custom,if not implement function, layout will calculate the most & max fit radius length.
 it can not make your all item show certainly,so if you provide the radius ,you should determine the fit radius yourself.
 */
- (CGFloat)CollectionViewCircleRadiusInLayout:(TYCircleCollectionLayout *)circleLayout;

@optional

/**
 @method: degreesBetweenEachItemInCircleLayout:
 @description: the method is make for custom collection whick can show item with sector.
 the return is an CGFloat number and it's a number to 360 degrees ,like  degrees = num/360;
 */
- (CGFloat)degreesBetweenEachItemInCircleLayout: (TYCircleCollectionLayout *)circleLayout;

/**
 @method: sectionEdgeInsetsInLayout:
 @description: provide the UIEdgeInsets in section,default is UIEdgeInsetsZero.
 */
- (UIEdgeInsets)sectionEdgeInsetsInLayout: (TYCircleCollectionLayout *)circleLayout;

/**
 @method: CircleCenterPointRelativeToLayoutFrame:
 @description: replace the center point of circle collection with point,it can not sure the all item can be show truly unless you have been calculate it correctly,if not implementatioin the function,the point is default frame center.
 */
- (CGPoint)CircleCenterPointRelativeToLayoutFrame:(CGRect)layoutFrame;
@end

@interface TYCircleCollectionLayout : UICollectionViewLayout
@property (nonatomic, weak) id<TYCircleCollectionLayout> delegate;
@property (nonatomic, assign) BOOL circleCenterDefault;
@end
