//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "MainNavigationRouter.h"
#import "SearchGalleryViewController.h"
#import "SearchGalleryViewModel.h"
#import "SearchAPI.h"
#import "SuggestionAPI.h"
#import "ConfigurationProtocol.h"
#import "PhotoDetailsViewController.h"
#import "Photo.h"
#import "PhotoDetailsViewModel.h"
#import "APIServiceProviderProtocol.h"
#import "SuggestionTagViewModel.h"


@interface MainNavigationRouter ()

@property (nonatomic, strong) id<ConfigurationProtocol> configuration;
@property (nonatomic, strong) id <APIServiceProviderProtocol> serviceProvider;

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) SearchGalleryViewController *searchGalleryViewController;

@end

@implementation MainNavigationRouter

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
                               configuration:(id <ConfigurationProtocol>)configuration
                          apiServiceProvider:(id <APIServiceProviderProtocol>)serviceProvider {
    if (self = [super init]) {
        self.navigationController = navigationController;
        self.configuration = configuration;
        self.serviceProvider = serviceProvider;
    }
    return self;
}

#pragma mark - Main Routing

- (void)showMainGalleryAnimated:(BOOL)animated {
    if (self.navigationController.viewControllers.count > 0) {
        [self.navigationController popToRootViewControllerAnimated:animated];
        return;
    }

    id<SearchAPI> apiService = [self.serviceProvider serviceForProtocol:@protocol(SearchAPI)];
    SearchGalleryViewModel *viewModel = [[SearchGalleryViewModel alloc] initWithRouter:self
                                                                         searchService:apiService];
    id<SuggestionAPI> suggestionService = [self.serviceProvider serviceForProtocol:@protocol(SuggestionAPI)];
    SuggestionTagViewModel *suggestionViewModel = [[SuggestionTagViewModel alloc] initWithSuggestionService:suggestionService];
    viewModel.suggestionViewModel = suggestionViewModel;
    SearchGalleryViewController *viewController = [[SearchGalleryViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:viewController animated:animated];
    self.searchGalleryViewController = viewController;
}

- (void)showPhotoDetailsForPhoto:(Photo *)photo itemIndex:(NSInteger)index inArray:(NSArray<Photo *> *)photos {
    PhotoDetailsViewModel *viewModel = [[PhotoDetailsViewModel alloc] initWithRouter:self photo:photo index:index inArray:photos];
    PhotoDetailsViewController *photosViewController = [[PhotoDetailsViewController alloc] initWithViewModel:viewModel];
    [self.navigationController presentViewController:photosViewController animated:YES completion:nil];
}

- (void)dismissDetails {
    if (self.navigationController.presentedViewController) {
        [self.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (id)referenceViewForPhotoAtIndex:(NSInteger)index {
    return [self.searchGalleryViewController referenceViewForPhotoAtIndex:index];
}

@end