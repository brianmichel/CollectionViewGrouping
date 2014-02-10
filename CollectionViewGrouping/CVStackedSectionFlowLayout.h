//
//  CVStackedSectionFlowLayout.h
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/7/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVBaseCardCollectionViewLayout.h"

@interface CVStackedSectionFlowLayout : CVBaseCardCollectionViewLayout

@property (assign) CGSize itemSize;

- (instancetype)initWithItemSize:(CGSize)size;
- (CGPoint)stackCenterForIndexPath:(NSIndexPath *)indexPath;
@end
