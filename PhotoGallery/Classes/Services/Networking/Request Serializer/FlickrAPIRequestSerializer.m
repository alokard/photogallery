//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "FlickrAPIRequestSerializer.h"

NSInteger const kFlickrAPIItemsPerPage = 100;

@interface FlickrAPIRequestSerializer ()

@property(nonatomic, strong) NSString *apiKey;

@end

@implementation FlickrAPIRequestSerializer

#pragma mark - Initializers

+ (instancetype)serializerWithAPIKey:(NSString *)apiKey {
    FlickrAPIRequestSerializer *serializer = [self new];
    serializer.apiKey = apiKey;
    return serializer;
}

#pragma mark - Protocol methods

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URL:(NSURL *)url parameters:(NSDictionary *)parameters error:(NSError *__nullable __autoreleasing *)error {
    NSParameterAssert(self.apiKey);
    NSMutableDictionary *fullParameters;
    if (self.apiKey) {
        fullParameters = [@{
                @"api_key" : self.apiKey,
                @"format" : @"json",
                @"nojsoncallback" : @1,
                @"per_page" : @(kFlickrAPIItemsPerPage)
        } mutableCopy];
        [fullParameters addEntriesFromDictionary:parameters];
    }
    else {
        fullParameters = [parameters mutableCopy];
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = method;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if ([method isEqual:@"GET"]) {
        NSString *query = [self serializeURIQueryFromDict:fullParameters];
        if (query.length > 0) {
            request.URL = [NSURL URLWithString:[[request.URL absoluteString] stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", query]];
        }
    }
    else {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fullParameters options:NSJSONWritingPrettyPrinted error:error];
        request.HTTPBody = jsonData;
    }

    return request;
}

#pragma mark - Private methods

- (NSString *)serializeURIQueryFromDict:(NSMutableDictionary *)dictionary {
    NSMutableArray *query = [NSMutableArray new];
    for (NSString *key in dictionary.allKeys) {
        NSString *value = [dictionary[key] description];
        value = [value stringByRemovingPercentEncoding];
        NSString *queryPart = [NSString stringWithFormat:@"%@=%@", [key stringByRemovingPercentEncoding], value];
        [query addObject:queryPart];
    }
    return [query componentsJoinedByString:@"&"];
}


@end