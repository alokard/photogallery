//
// Created by Eugene on 8/15/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotosFlowLayout.h"

@interface PhotosFlowLayoutState : NSObject

@property (nonatomic) CGSize size;
@property (nonatomic) UICollectionViewScrollDirection direction;

- (instancetype)initWithSize:(CGSize)size direction:(UICollectionViewScrollDirection)direction;

@end

@implementation PhotosFlowLayoutState

- (instancetype)initWithSize:(CGSize)size direction:(UICollectionViewScrollDirection)direction {
    if (self = [super init]) {
        self.size = size;
        self.direction = direction;
    }
    return self;
}

- (BOOL)isEqual:(PhotosFlowLayoutState *)object {
    return (CGSizeEqualToSize(self.size, object.size) && (self.direction == object.direction));
}

@end

@interface PhotosFlowLayout()

@property (nonatomic, strong) PhotosFlowLayoutState *state;

@end

@implementation PhotosFlowLayout

#pragma mark - Private methods

- (void)updateLayout {
    CGSize size = self.collectionView.bounds.size;
    self.itemSize = size;

    CGSize collectionSize = self.collectionView.bounds.size;
    BOOL isHorizontal = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal);

    CGFloat yInset = (collectionSize.height - self.itemSize.height) / 2;
    CGFloat xInset = (collectionSize.width - self.itemSize.width) / 2;
    self.sectionInset = UIEdgeInsetsMake(yInset, xInset, yInset, xInset);

    CGFloat side = isHorizontal ? self.itemSize.width : self.itemSize.height;
    CGFloat scaledItemOffset =  (side - side * self.sideItemScale) / 2;
    self.minimumLineSpacing = self.spacing - scaledItemOffset;
}

- (void)setupCollectionView {
    if (self.collectionView.decelerationRate != UIScrollViewDecelerationRateFast) {
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
}

#pragma mark - Public methods

- (void)prepareLayout {
    [super prepareLayout];

    PhotosFlowLayoutState *currentState = [[PhotosFlowLayoutState alloc] initWithSize:self.collectionView.bounds.size
                                                                            direction:self.scrollDirection];

    if (![self.state isEqual:currentState]) {
        [self setupCollectionView];
        [self updateLayout];
        self.state = currentState;
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [super layoutAttributesForElementsInRect:rect];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    if (self.collectionView.pagingEnabled) {
        return [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
    NSArray *layoutAttributes = [self layoutAttributesForElementsInRect:self.collectionView.bounds];

    BOOL isHorizontal = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal);

    CGFloat midSide = (isHorizontal ? self.collectionView.bounds.size.width : self.collectionView.bounds.size.height) / 2;
    CGFloat proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide;

    CGPoint targetContentOffset;
    if (isHorizontal) {
        UICollectionViewLayoutAttributes *closest = [[layoutAttributes sortedArrayUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes *obj1, UICollectionViewLayoutAttributes *obj2) {
            if (fabs(obj1.center.x - proposedContentOffsetCenterOrigin) < fabs(obj2.center.x - proposedContentOffsetCenterOrigin)) {
                return NSOrderedAscending;
            }
            else if (fabs(obj1.center.x - proposedContentOffsetCenterOrigin) == fabs(obj2.center.x - proposedContentOffsetCenterOrigin)) {
                return NSOrderedSame;
            }
            return NSOrderedDescending;
        }] firstObject] ?: [UICollectionViewLayoutAttributes new];
        targetContentOffset = CGPointMake(floorf(closest.center.x - midSide), proposedContentOffset.y);
    }
    else {
        UICollectionViewLayoutAttributes *closest = [[layoutAttributes sortedArrayUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes *obj1, UICollectionViewLayoutAttributes *obj2) {
            if (fabs(obj1.center.y - proposedContentOffsetCenterOrigin) < fabs(obj2.center.y - proposedContentOffsetCenterOrigin)) {
                return NSOrderedAscending;
            }
            else if (fabs(obj1.center.y - proposedContentOffsetCenterOrigin) == fabs(obj2.center.y - proposedContentOffsetCenterOrigin)) {
                return NSOrderedSame;
            }
            return NSOrderedDescending;
        }] firstObject] ?: [UICollectionViewLayoutAttributes new];
        targetContentOffset = CGPointMake(proposedContentOffset.x, floorf(closest.center.y - midSide));
    }

    return targetContentOffset;
}


@end