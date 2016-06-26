//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "AutoUpdatingLayout.h"

static CGFloat const kOffset = 8.0f;
static CGFloat const kMinItemWidth = 120;

@implementation AutoUpdatingLayout

- (instancetype)initWithBounds:(CGRect)bounds {
    self = [super init];
    if (self) {
        self.itemSize = [self itemSizeForBounds:bounds];
        self.minimumLineSpacing = 8;
        self.minimumInteritemSpacing = 8;
        self.sectionInset = UIEdgeInsetsMake(8, 8, 0, 8);
    }

    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    self.itemSize = [self itemSizeForBounds:newBounds];

    return YES;
}

- (CGSize)itemSizeForBounds:(CGRect)newBounds {


    NSInteger itemsCount = [self calculateItemsCountForWidth:CGRectGetWidth(newBounds)];

    CGFloat itemHeigh = (newBounds.size.width - (kOffset * (itemsCount + 1))) / itemsCount;
    return CGSizeMake(itemHeigh,  itemHeigh);
}

- (NSInteger)calculateItemsCountForWidth:(CGFloat)width {
    //this will return items count for width 120-180
    return (NSInteger) ((width - kOffset) / (kMinItemWidth + kOffset));
}

@end