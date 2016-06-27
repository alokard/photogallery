//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;

@protocol MainRouting <NSObject>

- (void)showMainGalleryAnimated:(BOOL)animated;

- (void)showPhotoDetailsForPhoto:(Photo *)photo itemIndex:(NSInteger)index;
- (void)dismissDetails;

- (id)referenceViewForPhotoAtIndex:(NSInteger)index;

@end