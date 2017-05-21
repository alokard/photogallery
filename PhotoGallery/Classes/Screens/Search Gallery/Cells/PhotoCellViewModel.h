//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;


@interface PhotoCellViewModel : NSObject

@property (nonatomic, strong) NSURL *photoURL;

- (instancetype)initWithPhoto:(Photo *)photo;

- (void)getPhotoWithCompletion:(void(^)(id image))completion;
- (void)cancelPhotoDownload;

@end