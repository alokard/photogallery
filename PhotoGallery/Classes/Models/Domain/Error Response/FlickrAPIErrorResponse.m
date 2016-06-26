//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "FlickrAPIErrorResponse.h"


@implementation FlickrAPIErrorResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"errorMessage" : @"message",
            @"errorCode" : @"code"
    };
}

@end