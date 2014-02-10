//
//  CVBaseCardCollectionViewLayout.m
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/10/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import "CVBaseCardCollectionViewLayout.h"

NSString * const CVStackedSectionItemCellKind = @"stacked_item_cell";
NSString * const CVStackedSectionPageCellKind = @"page_item_cell";

@implementation CVBaseCardCollectionViewLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        self.itemTransforms = [NSMutableDictionary dictionary];
    }
    return self;
}
- (CGPoint)pageOriginForSection:(NSIndexPath *)indexPath {
    CGFloat originX = self.collectionView.bounds.size.width * indexPath.section;
    return CGPointMake(originX, 0);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutAttributes.count];
    
    [self.layoutAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier, NSDictionary *elementsInfo, BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}
@end
