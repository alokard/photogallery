//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "MainNaviagationRouter.h"


@interface MainNaviagationRouter ()

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation MainNaviagationRouter

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    if (self = [super init]) {
        self.navigationController = navigationController;
    }
    return self;
}

@end