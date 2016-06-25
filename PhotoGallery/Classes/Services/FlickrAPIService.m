//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Overcoat/Overcoat.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "FlickrAPIService.h"
#import "FlickrAPIErrorResponse.h"
#import "Configuration.h"
#import "ConfigurationKeys.h"
#import "PhotoSearchFlickrAPIResponse.h"


@interface FlickrAPIService ()

@property(nonatomic, strong) NSString *apiKey;

@end

@implementation FlickrAPIService

+ (Class)errorModelClass {
    return [FlickrAPIErrorResponse class];
}

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithConfiguration:[Configuration defaultConfiguration]];
}

- (instancetype)initWithConfiguration:(id<ConfigurationProtocol>)configuration {
    NSURL *url = [NSURL URLWithString:[configuration settingForKey:ConfigurationKeys.baseURLString]];
    self = [super initWithBaseURL:url sessionConfiguration:nil];
    if (self) {
        self.apiKey = [configuration settingForKey:ConfigurationKeys.apiKey];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    }
    return self;
}

#pragma mark - FlickrAPI Protocol

- (RACSignal *)searchPhotosWithText:(NSString *)searchText tagsOnly:(BOOL)tagsOnly {
    return [[self rac_GET:@"" parameters:nil] map:^id(OVCResponse *response) {
        NSDictionary *responseDict = response.result;
        PhotoSearchFlickrAPIResponse *result = [MTLJSONAdapter modelOfClass:[PhotoSearchFlickrAPIResponse class]
                                                         fromJSONDictionary:responseDict[@"photos"]
                                                                      error:nil];
        return result;
    }];

}

@end