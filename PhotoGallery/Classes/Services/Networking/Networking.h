//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol Networking <NSObject>

- (RACSignal *)rac_GET:(NSString *)URLString parameters:(id)parameters;
- (RACSignal *)rac_POST:(NSString *)URLString parameters:(id)parameters;

@end