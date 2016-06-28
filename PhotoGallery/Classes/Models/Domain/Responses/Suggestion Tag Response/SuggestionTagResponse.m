//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "SuggestionTagResponse.h"
#import "Tag.h"

@implementation SuggestionTagResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"sourceTag"    : @"source",
            @"tags"         : @"tag"
    };
}

+ (NSValueTransformer *)photosJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Tag class]];
}

@end