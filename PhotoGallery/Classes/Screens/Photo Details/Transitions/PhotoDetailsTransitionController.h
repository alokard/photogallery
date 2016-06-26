//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailsTransitionController : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIView *startingView;
@property (nonatomic, strong) UIView *endingView;

@property (nonatomic) BOOL forcesNonInteractiveDismissal;

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint;

@end