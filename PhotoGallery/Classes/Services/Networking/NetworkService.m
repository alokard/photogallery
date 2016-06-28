//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "NetworkService.h"
#import "Configuration.h"
#import "ConfigurationKeys.h"
#import "FlickrAPIRequestSerializer.h"
#import "ConfigurationProtocol.h"
#import "FlickrAPIErrorResponse.h"
#import "RACSignal.h"
#import "NSError+OVCResponse.h"
#import "OVCResponse.h"
#import "RACSignal+Operations.h"

@implementation NetworkService

+ (Class)errorModelClass {
    return [FlickrAPIErrorResponse class];
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{};
}

#pragma mark - Initialization

+ (instancetype)defaultNetworkService {
    return [[self alloc] init];
}

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

#pragma mark - Networking

- (RACSignal *)rac_GET:(NSString *)URLString parameters:(id)parameters {
    return [[super rac_GET:URLString parameters:parameters] catch:[self errorCatchingBlock]];
}

- (RACSignal *)rac_POST:(NSString *)URLString parameters:(id)parameters {
    return [[super rac_POST:URLString parameters:parameters] catch:[self errorCatchingBlock]];
}

#pragma mark - Helpers

- (RACSignal *(^)(NSError *))errorCatchingBlock {
    return ^(NSError *error) {
        NSError *result = error;
        FlickrAPIErrorResponse *errorResponse = error.ovc_response.result;
        if ([errorResponse isKindOfClass:[FlickrAPIErrorResponse class]]) {
            NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
            userInfo[NSLocalizedDescriptionKey] = errorResponse.errorMessage;
            result = [NSError errorWithDomain:error.domain code:errorResponse.errorCode userInfo:userInfo];
        }
        return [RACSignal error:result];
    };
}


@end