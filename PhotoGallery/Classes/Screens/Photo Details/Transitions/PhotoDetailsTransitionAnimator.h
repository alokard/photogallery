//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailsTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIView *startingView;
@property (nonatomic, strong) UIView *endingView;

@property (nonatomic, getter=isDismissing) BOOL dismissing;

@property (nonatomic, strong) UIView *endingViewForAnimation;

+ (UIView *)newAnimationViewFromView:(UIView *)view;

@end
