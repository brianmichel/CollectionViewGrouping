//
//  CVStackedSectionFlowLayout.m
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/7/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import "CVStackedSectionFlowLayout.h"

extern NSString * const CVStackedSectionSupplementaryItemKind = @"CVStackedSectionSupplementaryItemKind";

@interface CVStackedSectionFlowLayout ()
@property (strong) NSDictionary *layoutAttributes;
@property (strong) NSMutableDictionary *transforms;
@property (assign) CGSize contentSize;
@end

@implementation CVStackedSectionFlowLayout

- (instancetype)initWithItemSize:(CGSize)size {
    self = [super init];
    if (self) {
        self.itemSize = size;
        self.transforms = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[CVStackedSectionItemCellKind][indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributes[CVStackedSectionSupplementaryItemKind][[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
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
            
            CGFloat endX = CGRectGetMaxX(attributes.frame);
            CGFloat endY = CGRectGetMaxY(attributes.frame);
            self.contentSize = CGSizeMake(MAX(endX, self.contentSize.width), MAX(endY, self.contentSize.height));
            
            if (indexPath.item == 0) {
                UICollectionViewLayoutAttributes *footerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:CVStackedSectionSupplementaryItemKind withIndexPath:indexPath];
                footerAttribute.alpha = 0.0;
                footerAttribute.zIndex = -1;
                CGFloat originX = self.collectionView.bounds.size.width * indexPath.section;
                footerAttribute.center = CGPointMake(originX + round(self.collectionView.bounds.size.width/2), CGRectGetMidY(self.collectionView.bounds));
                footerAttributes[indexPath] = footerAttribute;
            }
        }
    }
    newLayoutInformation[CVStackedSectionItemCellKind] = stackAttributes;
    newLayoutInformation[CVStackedSectionSupplementaryItemKind] = footerAttributes;
    self.layoutAttributes = [NSDictionary dictionaryWithDictionary:newLayoutInformation];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForStackAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribs = [super layoutAttributesForItemAtIndexPath:indexPath];

    attribs.center = [self stackCenterForIndexPath:indexPath];
    
    NSValue *transformValue = self.transforms[indexPath];
    if (transformValue) {
        attribs.transform = [transformValue CGAffineTransformValue];
    } else {
        CGFloat rotationValue = round((arc4random_uniform(2000) / 423.0) * (arc4random() % 2 == 0 ? 1 : -1));
        attribs.transform = CGAffineTransformMakeRotation(rotationValue * (M_PI / 180));
        self.transforms[indexPath] = [NSValue valueWithCGAffineTransform:attribs.transform];
    }
    
    return attribs;
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

@end
