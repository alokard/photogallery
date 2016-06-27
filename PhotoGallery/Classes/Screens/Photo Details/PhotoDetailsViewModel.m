//
// Created by Eugene on 6/27/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <ReactiveCocoa/RACCommand.h>
#import "PhotoDetailsViewModel.h"
#import "MainRouting.h"
#import "RACSignal.h"
#import "Photo.h"
#import "PINRemoteImageManager.h"


@interface PhotoDetailsViewModel ()

@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSURL *placeholderURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger parentIndex;

@property (nonatomic, strong) RACCommand *doneCommand;

@property (nonatomic, strong) id <MainRouting> router;

@end

@implementation PhotoDetailsViewModel

- (instancetype)initWithRouter:(id <MainRouting>)router photo:(Photo *)photo index:(NSInteger)index {
    if (self = [super init]) {
        self.router = router;
        self.photoURL = photo.photoURL;
        self.placeholderURL = photo.thumbnailURL;
        self.title = photo.title;
        self.parentIndex = index;

        [self setupCommands];
    }
    return self;
}

- (void)setupCommands {
    self.doneCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.router dismissDetails];
        return [RACSignal return:@YES];
    }];

}

- (id)parentReference {
    return [self.router referenceViewForPhotoAtIndex:self.parentIndex];
}

- (UIImage *)placeholder {
    NSString *cacheKey = [[PINRemoteImageManager sharedImageManager] cacheKeyForURL:self.placeholderURL processorKey:nil];
    if (cacheKey) {
        return [[PINRemoteImageManager sharedImageManager] synchronousImageFromCacheWithCacheKey:cacheKey
                                                                                         options:PINRemoteImageManagerDownloadOptionsNone].image;
    }
    return nil;
}

@end