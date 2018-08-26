//
//  TYScrollHorizoneLayout.h
//  TYCollectionViewDemo
//
//  Created by tybbt on 2018/8/19.
//  Copyright © 2018年 tybbt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYScrollHorizoneLayout : UICollectionViewLayout
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) NSInteger visibleCount;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@end
