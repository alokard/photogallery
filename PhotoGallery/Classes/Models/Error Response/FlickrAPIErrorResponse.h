//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface FlickrAPIErrorResponse : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *errorMessage;

@property (nonatomic, readonly) NSInteger errorCode;

@end