//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuggestionAPI.h"

@protocol Networking;

@interface SuggestionAPIService : NSObject <SuggestionAPI>

- (instancetype)initWithNetworking:(id <Networking>)networkingService;

@end
