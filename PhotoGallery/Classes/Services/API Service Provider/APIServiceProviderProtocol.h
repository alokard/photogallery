//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConfigurationProtocol;

@protocol APIServiceProviderProtocol <NSObject>

- (id)serviceForProtocol:(Protocol *)aProtocol;

@end