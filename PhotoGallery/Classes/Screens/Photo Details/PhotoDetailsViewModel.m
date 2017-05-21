//
// Created by Eugene on 6/27/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PhotoDetailsViewModel.h"
#import "MainRouting.h"
#import "Photo.h"
#import "CollectionStorage.h"
#import "PhotoCellViewModel.h"
#import "CollectionStorageProtocol.h"


@interface PhotoDetailsViewModel ()

@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSURL *placeholderURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<Photo *> *photos;

@property (nonatomic, strong) id <CollectionStorageProtocol> storage;

@property (nonatomic, strong) RACCommand *doneCommand;

@property (nonatomic, strong) id <MainRouting> router;


@end

@implementation PhotoDetailsViewModel

- (instancetype)initWithRouter:(id <MainRouting>)router index:(NSInteger)index inArray:(NSArray<Photo *> *)photos {
    if (self = [super init]) {
        self.router = router;
        self.photos = photos;

        [self updateWithPageIndex:index];

        self.storage = [CollectionStorage new];
        [self.storage resetItems:[photos.rac_sequence map:^PhotoCellViewModel *(Photo *value) {
            return [[PhotoCellViewModel alloc] initWithPhoto:value];
        }].array];

        [self setupCommands];
    }
    return self;
}

- (void)updateWithPageIndex:(NSInteger)index {
    if (index < self.photos.count) {
        Photo *photo = nil;
        photo = self.photos[index];
        self.photoURL = photo.photoURL;
        self.placeholderURL = photo.thumbnailURL;
        self.title = photo.title;
        self.parentIndex = index;
    }
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
    return nil;
}

@end