//
//  CVPagedSectionTableCollectionViewLayout.h
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/7/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVPagedSectionTableCollectionViewLayout : UICollectionViewFlowLayout
- (CGPoint)offsetForSection:(NSInteger)section;
@end
