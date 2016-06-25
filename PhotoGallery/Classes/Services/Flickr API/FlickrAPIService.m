//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//


#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Overcoat/OVCHTTPSessionManager+ReactiveCocoa.h>
#import <Overcoat/OVCResponse.h>
#import "FlickrAPIService.h"
#import "FlickrAPIErrorResponse.h"
#import "Configuration.h"
#import "ConfigurationKeys.h"
#import "PhotoSearchFlickrAPIResponse.h"
#import "FlickrAPIRequestSerializer.h"


@implementation FlickrAPIService

+ (Class)errorModelClass {
    return [FlickrAPIErrorResponse class];
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{};
}

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithConfiguration:[Configuration defaultConfiguration]];
}

- (instancetype)initWithConfiguration:(id<ConfigurationProtocol>)configuration {
    NSURL *url = [NSURL URLWithString:[configuration settingForKey:ConfigurationKeys.baseURLString]];
    self = [super initWithBaseURL:url sessionConfiguration:nil];
    if (self) {
        NSString *apiKey = [configuration settingForKey:ConfigurationKeys.apiKey];
        self.requestSerializer = [FlickrAPIRequestSerializer serializerWithAPIKey:apiKey];
    }
    return self;
}

#pragma mark - FlickrAPI Protocol

- (RACSignal *)searchPhotosWithText:(NSString *)searchText tagsOnly:(BOOL)tagsOnly {
    NSParameterAssert(searchText);
    if (searchText.length == 0) {
        return [RACSignal return:nil];
    }
    NSDictionary *params = @{
            @"text"     : searchText,
            @"method"   : @"flickr.photos.search"
    };
    return [[self rac_GET:@"" parameters:params] map:^id(OVCResponse *response) {
        NSDictionary *responseDict = response.result;
        NSError *error = nil;
        PhotoSearchFlickrAPIResponse *result = [MTLJSONAdapter modelOfClass:[PhotoSearchFlickrAPIResponse class]
                                                         fromJSONDictionary:responseDict[@"photos"]
                                                                      error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        return result;
    }];
}

@end