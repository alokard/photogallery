//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Overcoat/OVCHTTPSessionManager.h>
#import "SearchAPI.h"

@protocol ConfigurationProtocol;


@interface SearchAPIService : OVCHTTPSessionManager <SearchAPI>

- (instancetype)initWithConfiguration:(id <ConfigurationProtocol>)configuration;

@end