//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionStorage.h"
#import "CollectionSelectable.h"
#import "MainRouting.h"

@class RACCommand;
@protocol SearchAPI;


@interface SearchGalleryViewModel : NSObject <CollectionSelectable>

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, readonly) NSString *errorMessage;

@property (nonatomic, readonly) CollectionStorage *storage;

@property (nonatomic, readonly) RACCommand *reloadCommand;

- (instancetype)initWithRouter:(id<MainRouting>)router searchService:(id <SearchAPI>)searchService;

@end