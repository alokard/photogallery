//
// Created by Eugene on 6/27/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainRouting;


@interface PhotoDetailsViewModel : NSObject

- (instancetype)initWithRouter:(id <MainRouting>)router;

@end