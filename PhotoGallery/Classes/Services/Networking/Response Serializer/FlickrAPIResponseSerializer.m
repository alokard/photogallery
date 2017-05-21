//
// Created by Eugene on 5/21/17.
// Copyright (c) 2017 Tulusha.com. All rights reserved.
//

#import "FlickrAPIResponseSerializer.h"
#import "FlickrAPIErrorResponse.h"

NSString *const kFlickrAPIErrorResponseKey = @"kFlickrAPIErrorResponseKey";

@implementation FlickrAPIResponseSerializer

- (id)serializedResponseFromURLResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__nullable __autoreleasing *)error {
    id responseObject = nil;
    if (data) {
        NSLog([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    }

    if (*error) {
        return nil;
    }

    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode > 299) {
            NSDictionary *userInfoDict;
            FlickrAPIErrorResponse *errorResponse = [MTLJSONAdapter modelOfClass:[FlickrAPIErrorResponse class]
                                                              fromJSONDictionary:responseObject
                                                                           error:error];
            if (*error) {
                return nil;
            }

            if (errorResponse) {
                userInfoDict = @{kFlickrAPIErrorResponseKey: responseObject};
            }
            *error = [NSError errorWithDomain:@"com.tulusha.photogallery" code:NSURLErrorBadServerResponse userInfo:userInfoDict];
            return nil;
        }
    }

    return responseObject;
}


@end