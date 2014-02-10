//
//  CVSideBySideCollectionViewLayout.m
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/10/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import "CVSideBySideCollectionViewLayout.h"

@interface CVSideBySideCollectionViewLayout ()
@property (strong) NSDictionary *layoutAttributes;
@property (strong) NSDictionary *supplementaryAttributes;
@end

@implementation CVSideBySideCollectionViewLayout
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[CVStackedSectionItemCellKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[CVStackedSectionPageCellKind][indexPath];
}

- (void)prepareLayout {
    [super prepareLayout];
    NSMutableDictionary *allAttributes = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *stackedCellAtributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *containerCellAttributes = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfitems = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < numberOfitems; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];

            UICollectionViewLayoutAttributes *attributes = [self attributesForCellAtIndexPath:indexPath];
            stackedCellAtributes[indexPath] = attributes;
            
            if (j == 0) {
                UICollectionViewLayoutAttributes *footerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:CVStackedSectionPageCellKind withIndexPath:indexPath];
                footerAttributes.frame = [self footerFrameWithIndexPath:indexPath];
                footerAttributes.zIndex = -1;
                containerCellAttributes[indexPath] = footerAttributes;
            }
        }
    }
    
    allAttributes[CVStackedSectionItemCellKind] = stackedCellAtributes;
    allAttributes[CVStackedSectionPageCellKind] = containerCellAttributes;
    
    self.layoutAttributes = [NSDictionary dictionaryWithDictionary:allAttributes];
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

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    if (self.transitioning) {
        return self.offsetForTransition;
    }
    return proposedContentOffset;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.numberOfSections * self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (CGPoint)pageOffsetForPoint:(CGPoint)point {
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++) {
        CGRect rect = [self frameForSection:section];
        if (CGRectContainsPoint(rect, point)) {
            return rect.origin;
        }
    }
    return CGPointZero;
}

#pragma mark - Private
- (UICollectionViewLayoutAttributes *)attributesForCellAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGRect frame = [self frameForSection:indexPath.section];
    
    CGRect rect = CGRectMake(frame.origin.x + 20, 30 + (indexPath.row * 200), 150, 200);
    attribs.frame = rect;
    attribs.zIndex = 1.0;
    
    CGFloat rotationValue = round((arc4random_uniform(2000) / 423.0) * (arc4random() % 2 == 0 ? 1 : -1));
    attribs.transform = CGAffineTransformMakeRotation(rotationValue * (M_PI / 180));
    
    return attribs;
}

- (CGRect)footerFrameWithIndexPath:(NSIndexPath *)indexPath {
    CGRect sectionFrame = [self frameForSection:indexPath.section];
    CGFloat footerWidth = self.collectionView.frame.size.width - 130;

    CGFloat height = self.collectionView.frame.size.height - 20;
    CGRect footerFrame = CGRectMake(sectionFrame.origin.x + 120, round(self.collectionView.frame.size.height/2 - height/2), footerWidth, height);
    
    return footerFrame;
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
