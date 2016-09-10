//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "SearchGalleryViewModel.h"
#import "CollectionStorage.h"
#import "SearchAPI.h"
#import "CollectionStorageProtocol.h"
#import "PhotoSearchFlickrAPIResponse.h"
#import "PhotoCellViewModel.h"
#import "SuggestionTagViewModel.h"


@interface SearchGalleryViewModel ()

@property (nonatomic, weak) id<MainRouting> router;
@property (nonatomic, strong) id<SearchAPI> searchService;

@property (nonatomic, strong) CollectionStorage *storage;
@property (nonatomic, strong) RACCommand *reloadCommand;

@property (nonatomic, strong) PhotoSearchFlickrAPIResponse *response;

@property (nonatomic, strong) NSString *errorMessage;

@end

@implementation SearchGalleryViewModel

- (instancetype)initWithRouter:(id<MainRouting>)router searchService:(id<SearchAPI>)searchService {
    if (self = [super init]) {
        self.storage = [CollectionStorage new];
        self.searchService = searchService;
        self.router = router;

        [self setupCommands];
        @weakify(self);
        [[RACObserve(self, searchText) distinctUntilChanged] subscribeNext:^(NSString *search) {
            @strongify(self);
            if (search.length > 0) {
                [self.reloadCommand execute:nil];
            }
            else {
                [self.storage resetItems:nil];
            }
        }];
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
        self.response = response;
        [self updateStorageWithPhotos:response.photos];
    }] doError:^(NSError *error) {
        @strongify(self);
        self.errorMessage = error.localizedDescription;
    }];
}

- (void)updateStorageWithPhotos:(NSArray<Photo *> *)photos {
    RACSequence *cellViewModels = [photos.rac_sequence map:^PhotoCellViewModel *(Photo *photo) {
        return [[PhotoCellViewModel alloc] initWithPhoto:photo];
    }];
    [self.storage resetItems:cellViewModels.array];
}

#pragma mark - Collection Selectable

- (void)selectItemAtSection:(NSInteger)section index:(NSInteger)index {
    if (self.response.photos.count > index) {
        Photo *photo = self.response.photos[index];
        [self.router showPhotoDetailsForPhoto:photo itemIndex:index inArray:self.response.photos];
    }
}

@end