//
//  CVViewController.m
//  CollectionViewGrouping
//
//  Created by Brian Michel on 2/7/14.
//  Copyright (c) 2014 URBN. All rights reserved.
//

#import "CVViewController.h"
#import "CVContainerReusableView.h"
#import "CVStackedSectionFlowLayout.h"
#import "CVPagedSectionTableCollectionViewLayout.h"
#import "CVSideBySideCollectionViewLayout.h"

#define CV_ITEM_SIZE CGSizeMake(150, 200)

NSString * const CVViewControllerContainerID = @"container";

@interface CVViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong) UICollectionView *collectionView;
@property (strong) CVStackedSectionFlowLayout *layout;
@property (strong) CVSideBySideCollectionViewLayout *sideBySideLayout;
@property (assign) BOOL open;
@end

@implementation CVViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.sideBySideLayout = [[CVSideBySideCollectionViewLayout alloc] initWithItemSize:CV_ITEM_SIZE];
        self.layout = [[CVStackedSectionFlowLayout alloc] initWithItemSize:CV_ITEM_SIZE];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CVStackedSectionItemCellKind];
        [self.collectionView registerClass:[CVContainerReusableView class] forSupplementaryViewOfKind:CVStackedSectionPageCellKind withReuseIdentifier:CVViewControllerContainerID];
        
        self.collectionView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = self.collectionView.showsVerticalScrollIndicator = NO;
        
        self.open = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat height = self.view.bounds.size.height * 1.0;
    self.collectionView.frame = CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height);
    [self.view addSubview:self.collectionView];
    
    self.sideBySideLayout.itemTransforms = self.layout.itemTransforms;
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UICollectionView DataSource / Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 9;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CVStackedSectionItemCellKind forIndexPath:indexPath];
    cell.backgroundColor = [self backgroundColorForIndexPath:indexPath];
    
    //Remove jagged edges from transformation
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;

    //This is *NOT* performant on devices, we would need
    //an asset based shadow solution more than likely.
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowOpacity = 0.3;
    cell.layer.shadowRadius = 1.0;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CVViewControllerContainerID forIndexPath:indexPath];
        
    return view;
}

- (UIColor *)backgroundColorForIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberInSection = [self numberOfSectionsInCollectionView:self.collectionView];
    return [UIColor colorWithHue:((indexPath.section * 28) / 256.0) saturation:1.0 - (indexPath.row / numberInSection) brightness:1.0 alpha:1.0];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CV_ITEM_SIZE;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    UICollectionViewLayout *layoutToGoTo = self.open ? self.layout : self.sideBySideLayout;
    CGFloat springDampening = self.open ? 1.0 : 0.8;
    CGFloat initalSpringVelocity = self.open ? 1.0 : 0.2;
    CGFloat duration = self.open ? 0.3 : 0.6;
    
    self.sideBySideLayout.transitioning = YES;
    self.sideBySideLayout.offsetForTransition = CGPointMake(indexPath.section * collectionView.frame.size.width, 0);
 
    __weak typeof(self) weak = self;
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:springDampening initialSpringVelocity:initalSpringVelocity options:0 animations:^{
        [self.collectionView setCollectionViewLayout:layoutToGoTo];
    } completion:^(BOOL finished) {
        self.open = !self.open;
        BOOL paging = weak.sideBySideLayout.collectionView ? YES : NO;
        weak.collectionView.pagingEnabled = paging;
        weak.sideBySideLayout.transitioning = NO;
    }];
}

@end
