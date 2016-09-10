//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDetailsTransitionController.h"

@class DefaultCollectionViewDataSource;

@interface PhotoDetailsViewController : UIViewController

@property (nonatomic, readonly) PhotoDetailsTransitionController *transitionController;

- (instancetype)initWithViewModel:(id)viewModel;

@end