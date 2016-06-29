//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "DefaultCollectionViewDelegate.h"
#import "CollectionSelectable.h"

@interface DefaultCollectionViewDelegate ()

@property (nonatomic, weak) id<CollectionSelectable> viewModel;

@end

@implementation DefaultCollectionViewDelegate

- (instancetype)initWithViewModel:(id<CollectionSelectable>)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.viewModel respondsToSelector:@selector(selectItemAtSection:index:)]) {
        [self.viewModel selectItemAtSection:indexPath.section index:indexPath.item];
    }
}

@end