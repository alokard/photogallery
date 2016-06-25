//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface BaseListFlickrAPIResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSNumber *page;
@property (nonatomic, readonly) NSNumber *totalPages;
@property (nonatomic, readonly) NSNumber *itemsPerPage;
@property (nonatomic, readonly) NSNumber *totalItems;

@end