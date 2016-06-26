//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "Photo.h"


@implementation Photo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"photoId" : @"id",
            @"title" : @"title",
            @"ownerId" : @"owner",
            @"secret" : @"secret",
            @"server" : @"server",
            @"farm" : @"farm"
    };
}

- (NSURL *)thumbnailURL {
    return [self photoURLWithSize:@"m"];
}

- (NSURL *)photoURL {
    return [self photoURLWithSize:@"o"];
}

- (NSURL *)photoURLWithSize:(NSString *)size {
    NSString *path = [NSString stringWithFormat:@"https://farm%li.staticflickr.com/%@/%@_%@_%@.jpg",
                    (long)self.farm, self.server, self.photoId, self.secret, size];
    return [NSURL URLWithString:path];
}

@end