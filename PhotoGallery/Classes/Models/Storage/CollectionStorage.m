//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionStorage.h"
#import "PhotoCellViewModel.h"

@interface CollectionStorage ()

@property (nonatomic, copy) void (^dataReloaded)();
@property (nonatomic, copy) void (^appendedItems)(NSArray *appendedItems);

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation CollectionStorage

@synthesize dataReloaded, appendedItems;

- (instancetype)init {
    if (self = [super init]) {
        self.items = [NSMutableArray new];
    }
    return self;
}

#pragma mark - CollectionStorage protocol

- (void)reloadData {
    if (self.dataReloaded) {
        self.dataReloaded();
    }
}

- (void)appendItems:(NSArray *)items {
    [self.items addObjectsFromArray:items];
    if (self.appendedItems) {
        self.appendedItems(items);
    }
}

- (void)resetItems:(NSArray *)items {
    self.items = [items mutableCopy];
    [self reloadData];
}

- (NSInteger)numberOfItems {
    return self.items.count;
}

- (id)modelForSection:(NSInteger)section item:(NSInteger)item {
    if (item < self.items.count) {
        return self.items[item];
    }
    return nil;
}


@end