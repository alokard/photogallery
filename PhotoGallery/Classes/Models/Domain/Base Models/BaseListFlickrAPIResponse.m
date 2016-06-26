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

+ (NSValueTransformer *)totalPagesJSONTransformer {
    return [self stringToNumberTransformer];
}

+ (NSValueTransformer *)totalItemsJSONTransformer {
    return [self stringToNumberTransformer];
}

+ (NSValueTransformer *)stringToNumberTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }
        return @([value integerValue]);
    } reverseBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

@end