//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "SearchGalleryViewModel.h"
#import "CollectionStorage.h"
#import "FlickrAPI.h"
#import "CollectionStorageProtocol.h"
#import "PhotoSearchFlickrAPIResponse.h"


@interface SearchGalleryViewModel ()

@property (nonatomic, weak) id<MainRouting> router;
@property (nonatomic, strong) id<FlickrAPI> searchService;

@property (nonatomic, strong) CollectionStorage *storage;
@property (nonatomic, strong) RACCommand *reloadCommand;

@property (nonatomic, strong) NSString *errorMessage;

@end

@implementation SearchGalleryViewModel

- (instancetype)initWithRouter:(id<MainRouting>)router searchService:(id<FlickrAPI>)searchService {
    if (self = [super init]) {
        self.storage = [CollectionStorage new];
        self.searchService = searchService;
        self.router = router;

        [self setupCommands];
    }
    return self;
}

- (void)setupCommands {
    self.reloadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self reloadSignal];
    }];
}

#pragma mark - Helper Signals

- (RACSignal *)reloadSignal {
    @weakify(self);
    return [[[self.searchService searchPhotosWithText:self.searchText tagsOnly:NO] doNext:^(PhotoSearchFlickrAPIResponse *response) {
        @strongify(self);
        self.storage.
    }] doError:^(NSError *error) {
        @strongify(self);
        self.errorMessage = error.localizedDescription;
    }];
}

#pragma mark - Collection Selectable

- (void)selectItemAtSection:(NSInteger)section index:(NSInteger)index {
    [self.router showPhotoDetails];
}

@end