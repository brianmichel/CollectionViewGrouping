//
//  CVSideBySideCollectionViewLayout.h
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/10/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVBaseCardCollectionViewLayout.h"

@interface CVSideBySideCollectionViewLayout : CVBaseCardCollectionViewLayout
@property (assign) BOOL transitioning;
@property (assign) CGPoint offsetForTransition;

- (CGPoint)pageOffsetForPoint:(CGPoint)point;
@end
