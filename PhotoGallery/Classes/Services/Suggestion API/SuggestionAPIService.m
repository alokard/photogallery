//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "SuggestionAPIService.h"
#import "Networking.h"
#import "NetworkService.h"
#import "SuggestionTagResponse.h"
#import "RACSignal.h"
#import "OVCResponse.h"


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

    return [[self.networkService rac_GET:@"" parameters:params] map:^id(OVCResponse *response) {
        NSDictionary *responseDict = response.result;
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