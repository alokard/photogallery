//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import "MTLJSONAdapter.h"


@interface Tag : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *content;

@end