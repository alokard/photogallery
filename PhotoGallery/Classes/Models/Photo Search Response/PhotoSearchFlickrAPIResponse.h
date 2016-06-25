//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseListFlickrAPIResponse.h"

@class Photo;


@interface PhotoSearchFlickrAPIResponse : BaseListFlickrAPIResponse

@property (nonatomic, readonly) NSArray<Photo *> *photos;

@end