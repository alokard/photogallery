//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//


#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SearchAPIService.h"
#import "FlickrAPIErrorResponse.h"
#import "Networking.h"
#import "PhotoSearchFlickrAPIResponse.h"
#import "NetworkService.h"

@interface SearchAPIService ()

@property (nonatomic, strong) id<Networking> networkService;

@end

@implementation SearchAPIService

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithNetworking:[NetworkService defaultNetworkService]];
}

- (instancetype)initWithNetworking:(id <Networking>)networkingService {
    if (self = [super init]) {
        self.networkService = networkingService;
    }
    return self;
}

#pragma mark - SearchAPI Protocol

- (RACSignal *)searchPhotosWithText:(NSString *)searchText tagsOnly:(BOOL)tagsOnly {
    NSParameterAssert(searchText);
    if (searchText.length == 0) {
        return [RACSignal return:nil];
    }
    NSDictionary *params = @{
            @"text"     : searchText,
            @"method"   : @"flickr.photos.search"
    };
    return [[self.networkService rac_GET:@"" parameters:params] map:^id(id response) {
        NSDictionary *responseDict = response;
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