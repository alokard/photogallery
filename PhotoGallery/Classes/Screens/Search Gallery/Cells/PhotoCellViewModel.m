//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotoCellViewModel.h"
#import "Photo.h"


@implementation PhotoCellViewModel

- (instancetype)initWithPhoto:(Photo *)photo {
    if (self = [super init]) {
        self.photoURL = photo.thumbnailURL;
    }
    return self;
}

@end