//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Overcoat/OVCHTTPSessionManager.h>
#import "FlickrAPI.h"

@protocol ConfigurationProtocol;


@interface FlickrAPIService : OVCHTTPSessionManager <FlickrAPI>

- (instancetype)initWithConfiguration:(id <ConfigurationProtocol>)configuration;

@end