//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigurationProtocol.h"


@interface Configuration : NSObject <ConfigurationProtocol>

+ (instancetype)defaultConfiguration;

@end
