//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "MainNaviagationRouter.h"
#import "SearchGalleryViewController.h"
#import "SearchGalleryViewModel.h"
#import "SearchAPIService.h"
#import "ConfigurationProtocol.h"
#import "PhotoDetailsViewController.h"
#import "PhotoDetailsTransitionController.h"


@interface MainNaviagationRouter ()

@property (nonatomic, strong) id<ConfigurationProtocol> configuration;
@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation MainNaviagationRouter

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
                               configuration:(id<ConfigurationProtocol>)configuration {
    if (self = [super init]) {
        self.navigationController = navigationController;
        self.configuration = configuration;
    }
    return self;
}

#pragma mark - Main Routing

- (void)showMainGalleryAnimated:(BOOL)animated {
    if (self.navigationController.viewControllers.count > 0) {
        [self.navigationController popToRootViewControllerAnimated:animated];
        return;
    }

    SearchAPIService *apiService = [[SearchAPIService alloc] initWithConfiguration:self.configuration];
    SearchGalleryViewModel *viewModel = [[SearchGalleryViewModel alloc] initWithRouter:self
                                                                         searchService:apiService];
    SearchGalleryViewController *viewController = [[SearchGalleryViewController alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)showPhotoDetails {
    PhotoDetailsViewController *photosViewController = [[PhotoDetailsViewController alloc] initWithViewModel:nil];
    [self.navigationController presentViewController:photosViewController animated:YES completion:nil];
}

- (void)dismissDetails {
    if (self.navigationController.presentedViewController) {
        [self.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


@end