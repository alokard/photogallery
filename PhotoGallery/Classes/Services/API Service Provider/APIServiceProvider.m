//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "APIServiceProvider.h"
#import "SearchAPI.h"
#import "SearchAPIService.h"
#import "NetworkService.h"
#import "SuggestionAPI.h"
#import "SuggestionAPIService.h"


@interface APIServiceProvider ()

@property(nonatomic, strong) id <ConfigurationProtocol> configuration;

@end

@implementation APIServiceProvider

- (instancetype)initWithConfiguration:(id<ConfigurationProtocol>)configuration {
    if (self = [super init]) {
        self.configuration = configuration;
    }
    return self;
}

- (id)serviceForProtocol:(Protocol *)aProtocol {
    if ([NSStringFromProtocol(aProtocol) isEqual:NSStringFromProtocol(@protocol(SearchAPI)]) {
        NetworkService *networkService = [[NetworkService alloc] initWithConfiguration:self.configuration];
        SearchAPIService *apiService = [[SearchAPIService alloc] initWithNetworking:networkService];
        return apiService;
    }
    else if ([NSStringFromProtocol(aProtocol) isEqual:NSStringFromProtocol(@protocol(SuggestionAPI)]) {
        NetworkService *networkService = [[NetworkService alloc] initWithConfiguration:self.configuration];
        SuggestionAPIService *apiService = [[SuggestionAPIService alloc] initWithNetworking:networkService];
        return apiService;
    }
    return nil;
}


@end