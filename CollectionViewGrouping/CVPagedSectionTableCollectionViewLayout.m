//
//  CVPagedSectionTableCollectionViewLayout.m
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/7/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import "CVPagedSectionTableCollectionViewLayout.h"

@interface CVPagedSectionTableCollectionViewLayout ()
@property (strong) NSDictionary *layoutAttributes;
@end

@implementation CVPagedSectionTableCollectionViewLayout

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribs = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect frame = [self frameForSection:indexPath.section];
    CGFloat centerX = CGRectGetMidX(frame);
    CGFloat centerY = (200 + indexPath.row * 420);
    
    attribs.center = CGPointMake(centerX, centerY);
    
    return attribs;
}

- (void)prepareLayout {
    [super prepareLayout];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfitems = [self.collectionView numberOfItemsInSection:i];
        NSMutableArray *attributeArray = [NSMutableArray arrayWithCapacity:numberOfitems];
        for (int j = 0; j < numberOfitems; j++) {
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            attributeArray[j] = attributes;
        }
        attributes[@(i)] = attributeArray;
    }
    
    self.layoutAttributes = [NSDictionary dictionaryWithDictionary:attributes];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray array];
    for (NSNumber *sectionID in [_layoutAttributes allKeys]) {
        [allAttributes addObjectsFromArray:_layoutAttributes[sectionID]];
    }
    return allAttributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.numberOfSections * self.collectionView.frame.size.width, (self.collectionView.frame.size.height * 2));
}

- (CGRect)frameForSection:(NSInteger)section {
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    
    CGFloat originX = section * width;
    CGFloat originY = 0;
    
    return CGRectMake(originX, originY, width, height);
}

- (CGPoint)offsetForSection:(NSInteger)section {
    return [self frameForSection:section].origin;
}
@end
