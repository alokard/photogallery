//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SuggestionTagViewModel.h"
#import "SuggestionAPI.h"
#import "NSObject+RACPropertySubscribing.h"
#import "SuggestionTagResponse.h"


@interface SuggestionTagViewModel ()

@property (nonatomic, strong) id<SuggestionAPI> suggestionService;

@property (nonatomic, strong) RACSubject *cancelTagRequestSubject;

@end

@implementation SuggestionTagViewModel

- (instancetype)initWithSuggestionService:(id<SuggestionAPI>)suggestionService {
    if (self = [super init]) {
        self.suggestionService = suggestionService;

        [self setupObserving];
    }
    return self;
}

- (void)setupObserving {
    @weakify(self)
    [RACObserve(self, searchText) subscribeNext:^(NSString *search) {
        @strongify(self);
        [self.cancelTagRequestSubject sendNext:@YES];
        [[[[self.suggestionService loadSuggestionsForText:search] takeUntil:self.cancelTagRequestSubject] deliverOnMainThread] subscribeNext:^(SuggestionTagResponse *response) {
            @strongify(self);
            [self updateStorageWithResponse:response];
        }];
    }];
}

- (void)updateStorageWithResponse:(SuggestionTagResponse *)response {
    NSLog(@"Update tags");
}

- (RACSubject *)cancelTagRequestSubject {
    if (!_cancelTagRequestSubject) {
        _cancelTagRequestSubject = [RACSubject subject];
    }
    return _cancelTagRequestSubject;
}


@end