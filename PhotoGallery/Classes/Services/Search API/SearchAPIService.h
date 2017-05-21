//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "SearchAPI.h"

@protocol ConfigurationProtocol;
@protocol Networking;


@interface SearchAPIService : NSObject <SearchAPI>

- (instancetype)initWithNetworking:(id <Networking>)networkingService;

@end