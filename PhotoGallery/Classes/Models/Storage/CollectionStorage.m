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
        for (int i = 0; i < 10; i++) {
            PhotoCellViewModel *photo = [PhotoCellViewModel new];
            photo.photoURL = [NSURL URLWithString:@"https://farm8.staticflickr.com/7255/26678463923_dd60064463_m.jpg"];
            [self.items addObject:photo];
        }
    }
    return self;
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