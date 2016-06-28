//
// Created by Eugene on 6/28/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SuggestionAPI;


@interface SuggestionTagViewModel : NSObject

@property (nonatomic, strong) NSString *searchText;

- (instancetype)initWithSuggestionService:(id <SuggestionAPI>)suggestionService;

@end