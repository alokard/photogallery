//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIServiceProviderProtocol.h"


@interface APIServiceProvider : NSObject <APIServiceProviderProtocol>

- (instancetype)initWithConfiguration:(id <ConfigurationProtocol>)configuration;

@end