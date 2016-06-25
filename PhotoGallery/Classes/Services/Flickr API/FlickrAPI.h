//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol FlickrAPI <NSObject>

- (RACSignal *)searchPhotosWithText:(NSString *)searchText tagsOnly:(BOOL)tagsOnly;

@end