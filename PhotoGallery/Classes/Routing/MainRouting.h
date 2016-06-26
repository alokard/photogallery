//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MainRouting <NSObject>

- (void)showMainGalleryAnimated:(BOOL)animated;
- (void)showPhotoDetails;
- (void)dismissDetails;

@end