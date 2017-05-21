//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "NetworkService.h"
#import "Configuration.h"
#import "ConfigurationKeys.h"
#import "FlickrAPIRequestSerializer.h"
#import "FlickrAPIErrorResponse.h"
#import "ResponseSerializerProtocol.h"
#import "FlickrAPIResponseSerializer.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface NetworkService ()

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) id <RequestSerializerProtocol> requestSerializer;
@property (nonatomic, strong) id <ResponseSerializerProtocol> responseSerializer;

@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation NetworkService

#pragma mark - Initialization

+ (instancetype)defaultNetworkService {
    return [[self alloc] init];
}

- (instancetype)init {
    return [self initWithConfiguration:[Configuration defaultConfiguration]];
}

- (instancetype)initWithConfiguration:(id<ConfigurationProtocol>)configuration {
    NSURL *url = [NSURL URLWithString:[configuration settingForKey:ConfigurationKeys.baseURLString]];
    self = [super init];
    if (self) {
        self.baseURL = url;
        self.urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSString *apiKey = [configuration settingForKey:ConfigurationKeys.apiKey];
        self.requestSerializer = [FlickrAPIRequestSerializer serializerWithAPIKey:apiKey];
        self.responseSerializer = [FlickrAPIResponseSerializer new];
    }
    return self;
}

#pragma mark - Networking

- (RACSignal *)rac_GET:(NSString *)URLString parameters:(id)parameters {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self GET:URLString
                                            parameters:parameters
                                            completion:^(id response, NSError *error) {
                                                if (!error) {
                                                    [subscriber sendNext:response];
                                                    [subscriber sendCompleted];
                                                } else {
                                                    [subscriber sendError:error];
                                                }
                                            }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];

    return [signal catch:[self errorCatchingBlock]];
}

- (RACSignal *)rac_POST:(NSString *)URLString parameters:(id)parameters {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self POST:URLString
                                             parameters:parameters
                                             completion:^(id response, NSError *error) {
                                                 if (!error) {
                                                     [subscriber sendNext:response];
                                                     [subscriber sendCompleted];
                                                 } else {
                                                     [subscriber sendError:error];
                                                 }
                                             }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];

    return [signal catch:[self errorCatchingBlock]];
}

- (NSURLSessionDataTask *)GET:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion {
    return [self dataTaskWithMethod:@"GET" URLString:urlString parameters:parameters completion:completion];
}

- (NSURLSessionDataTask *)POST:(NSString *)urlString parameters:(id)parameters completion:(void (^)(id, NSError *))completion {
    return [self dataTaskWithMethod:@"POST" URLString:urlString parameters:parameters completion:completion];
}

#pragma mark - Helpers

- (NSURLSessionDataTask *)dataTaskWithMethod:(NSString *)method URLString:(NSString *)urlString parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion {
    NSError *error = nil;
    NSURL *fullURL = [NSURL URLWithString:urlString relativeToURL:self.baseURL];
    NSURLRequest *request = [self.requestSerializer requestWithMethod:method URL:fullURL parameters:parameters error:&error];
    if (error) {
        if (completion) {
            completion(nil, error);
        }
    }
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *requestError) {
        if (!completion) {
            return;
        }

        if (error) {
            completion(nil, error);
            return;
        }

        NSError *serializingError = nil;
        id result = [self.responseSerializer serializedResponseFromURLResponse:response data:data error:&serializingError];
        if (serializingError) {
            completion(nil, serializingError);
        }
        completion(result, nil);
    }];
    [task resume];

    return task;
}

- (RACSignal *(^)(NSError *))errorCatchingBlock {
    return ^(NSError *error) {
        NSError *result = error;
        FlickrAPIErrorResponse *errorResponse = error.userInfo[kFlickrAPIErrorResponseKey];
        if ([errorResponse isKindOfClass:[FlickrAPIErrorResponse class]]) {
            NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
            userInfo[NSLocalizedDescriptionKey] = errorResponse.errorMessage;
            result = [NSError errorWithDomain:error.domain code:errorResponse.errorCode userInfo:userInfo];
        }
        return [RACSignal error:result];
    };
}


@end