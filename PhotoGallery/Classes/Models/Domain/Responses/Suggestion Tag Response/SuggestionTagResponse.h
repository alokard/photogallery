//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@class Tag;


@interface SuggestionTagResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *sourceTag;
@property (nonatomic, readonly) NSArray<Tag *> *tags;

@end