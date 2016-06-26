//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DefaultCollectionViewDataSource.h"
#import "DefaultCellProtocol.h"
#import "CollectionStorageProtocol.h"


static NSString *const kDefaultCellIdentifier = @"kDefaultCellIdentifier";

@interface DefaultCollectionViewDataSource ()

@property(nonatomic, weak) id <CollectionStorageProtocol> storage;

@end

@implementation DefaultCollectionViewDataSource

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                             cellClass:(Class<DefaultCellProtocol>)cellClass
                               storage:(id<CollectionStorageProtocol>)storage {
    NSAssert([cellClass conformsToProtocol:@protocol(DefaultCellProtocol)], @"Cell class shoudl confirm to DefaultCellProtocol");
    if (self = [super init]) {
        collectionView.dataSource = self;
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:kDefaultCellIdentifier];
        self.storage = storage;
        @weakify(collectionView)
        self.storage.appendedItems = ^(NSArray *appendedItems) {
            @strongify(collectionView);
            [collectionView performBatchUpdates:^{
                NSMutableArray *indexPaths = [NSMutableArray new];
                NSInteger itemIndex = [collectionView numberOfItemsInSection:0];
                for (id item in appendedItems) {
                    [indexPaths addObject:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
                    itemIndex++;
                }
                [collectionView insertItemsAtIndexPaths:indexPaths];
            } completion:nil];
        };
        self.storage.dataReloaded = ^{
            @strongify(collectionView);
            [collectionView reloadData];
        };
    }
    return self;
}

#pragma mark - CollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.storage.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell<DefaultCellProtocol> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultCellIdentifier
                                                                           forIndexPath:indexPath];

    [cell updateWithViewModel:[self.storage modelForSection:indexPath.section item:indexPath.item]];

    return cell;
}

@end