//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDismissInteractionController : NSObject <UIViewControllerInteractiveTransitioning>

@property (nonatomic, strong) id <UIViewControllerAnimatedTransitioning> animator;
@property (nonatomic, strong) UIView *viewToHideWhenBeginningTransition;

@property (nonatomic) BOOL shouldAnimateUsingAnimator;

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint;

@end
