//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainRouting.h"

@protocol ConfigurationProtocol;


@interface MainNaviagationRouter : NSObject <MainRouting>

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
                               configuration:(id<ConfigurationProtocol>)configuration;

@end