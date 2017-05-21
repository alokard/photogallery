//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <ReactiveCocoa/RACSignal.h>
#import <Mantle/MTLModel.h>
#import <Mantle/MTLJSONAdapter.h>
#import "SuggestionAPIService.h"
#import "Networking.h"
#import "NetworkService.h"
#import "SuggestionTagResponse.h"


@interface SuggestionAPIService ()

@property (nonatomic, strong) id <Networking> networkService;

@end

@implementation SuggestionAPIService

- (instancetype)init {
    return [self initWithNetworking:[NetworkService defaultNetworkService]];
}

- (instancetype)initWithNetworking:(id <Networking>)networkingService {
    if (self = [super init]) {
        self.networkService = networkingService;
    }
    return self;
}

#pragma mark Suggestion API

- (RACSignal *)loadSuggestionsForText:(NSString *)suggestionText {
    if (suggestionText.length < 3) {
        return [RACSignal return:@YES];
    }

    NSDictionary *params = @{
            @"method"   : @"flickr.tags.getRelated",
            @"tag"      : suggestionText
    };

    return [[self.networkService rac_GET:@"" parameters:params] map:^id(id response) {
        NSDictionary *responseDict = response;
        NSError *error = nil;
        SuggestionTagResponse *result = [MTLJSONAdapter modelOfClass:[SuggestionTagResponse class]
                                                  fromJSONDictionary:responseDict[@"tags"]
                                                               error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
        return result;
    }];
}


@end