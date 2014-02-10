//
//  CVBaseCardCollectionViewLayout.h
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/10/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const CVStackedSectionItemCellKind;
extern NSString * const CVStackedSectionPageCellKind;

@interface CVBaseCardCollectionViewLayout : UICollectionViewFlowLayout

@property (strong) NSMutableDictionary *itemTransforms;
@property (strong) NSDictionary *layoutAttributes;
@property (assign) CGSize contentSize;

- (CGPoint)pageOriginForSection:(NSIndexPath *)indexPath;
@end
