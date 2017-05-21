//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestSerializerProtocol.h"

extern NSInteger const kFlickrAPIItemsPerPage;

@interface FlickrAPIRequestSerializer : NSObject <RequestSerializerProtocol>

+ (instancetype)serializerWithAPIKey:(NSString *)apiKey;

@end