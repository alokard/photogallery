//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotoSearchFlickrAPIResponse.h"
#import "Photo.h"


@implementation PhotoSearchFlickrAPIResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:@{
            @"photos" : @"photos.photo"
    }];
}

+ (NSValueTransformer *)zoomBottomRightLocationPointJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Photo class]];
}

@end
