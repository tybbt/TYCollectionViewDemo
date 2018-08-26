//
//  TYTagCollectionLayout.h
//  TYCollectionViewDemo
//
//  Created by tybbt on 2018/8/25.
//  Copyright © 2018年 tybbt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYTagCollectionLayout;
@protocol TYTagCollectionLayout <UICollectionViewDelegateFlowLayout>
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface TYTagCollectionLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<TYTagCollectionLayout> delegate;
@end
