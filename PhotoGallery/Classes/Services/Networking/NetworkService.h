//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Networking.h"

@protocol ConfigurationProtocol;


@interface NetworkService : NSObject <Networking>

+ (instancetype)defaultNetworkService;

- (instancetype)initWithConfiguration:(id <ConfigurationProtocol>)configuration;

@end