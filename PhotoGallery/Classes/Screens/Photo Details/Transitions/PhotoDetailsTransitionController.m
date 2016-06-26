//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotoDetailsTransitionController.h"
#import "PhotoDetailsTransitionAnimator.h"
#import "PhotoDismissInteractionController.h"

@interface PhotoDetailsTransitionController ()

@property (nonatomic, strong) PhotoDetailsTransitionAnimator *animator;
@property (nonatomic, strong) PhotoDismissInteractionController *interactionController;

@end

@implementation PhotoDetailsTransitionController

#pragma mark - NSObject

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.animator = [[PhotoDetailsTransitionAnimator alloc] init];
        self.interactionController = [[PhotoDismissInteractionController alloc] init];
        self.forcesNonInteractiveDismissal = YES;
    }
    
    return self;
}

#pragma mark - Public methods

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    [self.interactionController didPanWithPanGestureRecognizer:panGestureRecognizer viewToPan:viewToPan anchorPoint:anchorPoint];
}

- (UIView *)startingView {
    return self.animator.startingView;
}

- (void)setStartingView:(UIView *)startingView {
    self.animator.startingView = startingView;
}

- (UIView *)endingView {
    return self.animator.endingView;
}

- (void)setEndingView:(UIView *)endingView {
    self.animator.endingView = endingView;
}

#pragma mark - UIViewControllerTransitioning delegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.animator.dismissing = NO;
    
    return self.animator;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animator.dismissing = YES;
    
    return self.animator;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.forcesNonInteractiveDismissal) {
        return nil;
    }
    
    // The interaction controller will be hiding the ending view, so we should get and set a visible version now.
    self.animator.endingViewForAnimation = [[self.animator class] newAnimationViewFromView:self.endingView];
    
    self.interactionController.animator = animator;
    self.interactionController.shouldAnimateUsingAnimator = self.endingView != nil;
    self.interactionController.viewToHideWhenBeginningTransition = self.startingView ? self.endingView : nil;
    
    return self.interactionController;
}

@end
