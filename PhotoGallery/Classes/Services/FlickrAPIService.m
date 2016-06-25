//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "FlickrAPIService.h"
#import "RACSignal.h"

static NSString *const kFlickrAPIKey = @"FLICKR_API_KEY";

@interface FlickrAPIService ()

@property(nonatomic, strong) NSString *apiKey;

@end

@implementation FlickrAPIService

- (instancetype)init {
    if (self = [super init]) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        self.apiKey = [bundle objectForInfoDictionaryKey:kFlickrAPIKey];
        NSAssert([self.apiKey isKindOfClass:[NSString class]], @"FLICKR_API_KEY should be set and should be String");
    }
    return self;
}

#pragma mark - FlickrAPI Protocol

- (RACSignal *)searchPhotosWithText:(NSString *)searchText tagsOnly:(BOOL)tagsOnly {
    return [RACSignal return:@YES];
}

@end