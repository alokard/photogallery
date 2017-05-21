//
// Created by Eugene on 5/21/17.
// Copyright (c) 2017 Tulusha.com. All rights reserved.
//

#import "ImageDownloadServiceProtocol.h"

@interface ImageDownloadService : NSObject <ImageDownloadServiceProtocol>

+ (instancetype)sharedService;

- (instancetype)initWithURLSession:(NSURLSession *)urlSession;

@end