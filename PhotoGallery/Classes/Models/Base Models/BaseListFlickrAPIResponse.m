//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "BaseListFlickrAPIResponse.h"


@implementation BaseListFlickrAPIResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"page" : @"page",
            @"totalPages" : @"pages",
            @"itemsPerPage" : @"perpage",
            @"totalItems" : @"total"
    };
}

@end