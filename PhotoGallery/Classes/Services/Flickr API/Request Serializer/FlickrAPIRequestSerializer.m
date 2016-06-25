//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "FlickrAPIRequestSerializer.h"


@interface FlickrAPIRequestSerializer ()

@property(nonatomic, strong) NSString *apiKey;

@end

@implementation FlickrAPIRequestSerializer

#pragma mark - Initializers

+ (instancetype)serializerWithAPIKey:(NSString *)apiKey {
    FlickrAPIRequestSerializer *serializer = [self serializer];
    serializer.apiKey = apiKey;
    return serializer;
}

#pragma mark - Overwritten methods

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__nullable __autoreleasing *)error {
    NSParameterAssert(self.apiKey);
    if ([parameters isKindOfClass:[NSDictionary class]] && self.apiKey) {
        NSMutableDictionary *fullParameters = [@{
                @"api_key" : self.apiKey,
                @"format" : @"json",
                @"nojsoncallback" : @1
        } mutableCopy];
        [fullParameters addEntriesFromDictionary:(NSDictionary *)parameters];
        return [super requestWithMethod:method URLString:URLString parameters:fullParameters error:error];
    }

    return [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
}


@end