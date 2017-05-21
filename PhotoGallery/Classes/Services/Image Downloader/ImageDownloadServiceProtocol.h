//
// Created by Eugene on 5/21/17.
// Copyright (c) 2017 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageDownloadServiceProtocol <NSObject>

- (void)loadImageFromURL:(NSURL *)url completionBlock:(void (^)(BOOL success, UIImage *image, NSError *error))completion;
- (void)cancelLoadingForURL:(NSURL *)url;

@end