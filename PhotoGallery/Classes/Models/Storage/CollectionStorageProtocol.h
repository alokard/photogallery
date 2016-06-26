//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CollectionStorageProtocol <NSObject>

- (id)modelForSection:(NSInteger)section item:(NSInteger)item;
- (NSInteger)numberOfItems;

- (void)setAppendedItems:(void (^)(NSArray *appendedItems))addedNewItems;
- (void (^)(NSArray *appendedItems))appendedItems;

- (void)setDataReloaded:(void (^)())dataReloaded;
- (void (^)())dataReloaded;

@end