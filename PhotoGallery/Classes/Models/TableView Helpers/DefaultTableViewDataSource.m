//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DefaultTableViewDataSource.h"
#import "DefaultCellProtocol.h"
#import "CollectionStorageProtocol.h"


static NSString *const kDefaultCellIdentifier = @"kDefaultCellIdentifier";

@interface DefaultCollectionViewDataSource ()

@property(nonatomic, weak) id <CollectionStorageProtocol> storage;

@end

@implementation DefaultTableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView
                        cellClass:(Class<DefaultCellProtocol>)cellClass
                          storage:(id<CollectionStorageProtocol>)storage {
    NSAssert([cellClass conformsToProtocol:@protocol(DefaultCellProtocol)], @"Cell class should confirm to DefaultCellProtocol");
    if (self = [super init]) {
        tableView.dataSource = self;
        [tableView registerClass:cellClass forCellReuseIdentifier:kDefaultCellIdentifier];
        self.storage = storage;
        @weakify(tableView)
        self.storage.appendedItems = ^(NSArray *appendedItems) {
            @strongify(tableView);
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