//
//  CVStackedSectionFlowLayout.m
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/7/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import "CVStackedSectionFlowLayout.h"

@implementation CVStackedSectionFlowLayout

- (instancetype)initWithItemSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.itemSize = size;
    }
    
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];

    NSMutableDictionary *newLayoutInformation = [NSMutableDictionary dictionary];
    NSMutableDictionary *stackAttributes = [NSMutableDictionary dictionary];
    NSMutableDictionary *footerAttributes = [NSMutableDictionary dictionary];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (int i = 0; i < self.collectionView.numberOfSections; i++) {
        NSInteger numberOfitems = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < numberOfitems; j++) {
            indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForStackAtIndexPath:indexPath];
            stackAttributes[indexPath] = attributes;
            [self checkAndUpdateContentSizeIfNeededFromAttributes:attributes];
            
            if (indexPath.item == 0) { //create the header attributes
                footerAttributes[indexPath] = [self layoutAttributesForPageItemAtIndexPath:indexPath];
            }
        }
    }
    newLayoutInformation[CVStackedSectionItemCellKind] = stackAttributes;
    newLayoutInformation[CVStackedSectionPageCellKind] = footerAttributes;
    self.layoutAttributes = [NSDictionary dictionaryWithDictionary:newLayoutInformation];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[CVStackedSectionItemCellKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[CVStackedSectionPageCellKind][[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForStackAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    attribs.center = [self stackCenterForIndexPath:indexPath];
    attribs.size = self.itemSize;
    
    NSValue *transformValue = self.itemTransforms[indexPath];
    if (transformValue) {
        attribs.transform = [transformValue CGAffineTransformValue];
    } else {
        CGFloat rotationValue = round((arc4random_uniform(2000) / 423.0) * (arc4random() % 2 == 0 ? 1 : -1));
        attribs.transform = CGAffineTransformMakeRotation(rotationValue * (M_PI / 180));
        self.itemTransforms[indexPath] = [NSValue valueWithCGAffineTransform:attribs.transform];
    }
    
    return attribs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForPageItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *footerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:CVStackedSectionPageCellKind withIndexPath:indexPath];
    footerAttribute.alpha = 0.0;
    footerAttribute.zIndex = -1;
    CGFloat originX = [self pageOriginForSection:indexPath].x;
    footerAttribute.center = CGPointMake(originX + round(self.collectionView.bounds.size.width/2), CGRectGetMidY(self.collectionView.bounds));
    
    return footerAttribute;
}

- (CGPoint)stackCenterForIndexPath:(NSIndexPath *)indexPath {
    CGFloat widthAndHeight = self.collectionView.frame.size.width/3;
    
    NSInteger row = indexPath.section / 3;
    NSInteger column = indexPath.section % 3;
    return CGPointMake((column * widthAndHeight) + (widthAndHeight/2), (row * widthAndHeight) + (widthAndHeight/2));
}

- (CGSize)stackDimensions {
    return CGSizeMake(self.collectionView.frame.size.width/3, self.collectionView.frame.size.width/3);
}

- (void)checkAndUpdateContentSizeIfNeededFromAttributes:(UICollectionViewLayoutAttributes *)attributes {
    CGFloat endX = CGRectGetMaxX(attributes.frame);
    CGFloat endY = CGRectGetMaxY(attributes.frame);
    self.contentSize = CGSizeMake(MAX(endX, self.contentSize.width), MAX(endY, self.contentSize.height));
}

@end
