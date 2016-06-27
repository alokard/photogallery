//
// Created by Eugene on 6/27/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainRouting;
@class Photo;
@class RACCommand;


@interface PhotoDetailsViewModel : NSObject

@property (nonatomic, readonly) NSURL *photoURL;
@property (nonatomic, readonly) NSString *title;

@property (nonatomic, readonly) UIImage *placeholder;

@property (nonatomic, readonly) RACCommand *doneCommand;

- (instancetype)initWithRouter:(id <MainRouting>)router photo:(Photo *)photo index:(NSInteger)index;

- (id)parentReference;

@end