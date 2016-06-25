//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface BaseListFlickrAPIResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSInteger page;
@property (nonatomic, readonly) NSInteger totalPages;
@property (nonatomic, readonly) NSInteger itemsPerPage;
@property (nonatomic, readonly) NSInteger totalItems;

@end