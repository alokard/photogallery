//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotoCellViewModel.h"
#import "Photo.h"
#import "ImageDownloadServiceProtocol.h"
#import "ImageDownloadService.h"


@interface PhotoCellViewModel()

@property (nonatomic, strong) id <ImageDownloadServiceProtocol> imageDownloadService;

@end


@implementation PhotoCellViewModel

- (instancetype)initWithPhoto:(Photo *)photo {
    if (self = [super init]) {
        self.photoURL = photo.thumbnailURL;
        self.imageDownloadService = [ImageDownloadService sharedService];
    }
    return self;
}

- (void)getPhotoWithCompletion:(void (^)(id image))completion {
    if (!completion) {
        return;
    }

    [self.imageDownloadService loadImageFromURL:self.photoURL completionBlock:^(BOOL success, UIImage *image, NSError *error) {
        completion(image);
    }];
}

- (void)cancelPhotoDownload {
    [self.imageDownloadService cancelLoadingForURL:self.photoURL];
}


@end