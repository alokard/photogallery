//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotoDetailsTransitionAnimator.h"

@interface PhotoDetailsTransitionAnimator ()

@property (nonatomic, readonly) BOOL shouldPerformZoomingAnimation;

@end

@implementation PhotoDetailsTransitionAnimator

+ (UIView *)newAnimationViewFromView:(UIView *)view {
    if (!view) {
        return nil;
    }

    UIView *animationView;
    if (view.layer.contents) {
        if ([view isKindOfClass:[UIImageView class]]) {
            animationView = [(UIImageView *)[[view class] alloc] initWithImage:((UIImageView *)view).image];
            animationView.bounds = view.bounds;
        }
        else {
            animationView = [[UIView alloc] initWithFrame:view.frame];
            animationView.layer.contents = view.layer.contents;
            animationView.layer.bounds = view.layer.bounds;
        }

        animationView.layer.cornerRadius = view.layer.cornerRadius;
        animationView.layer.masksToBounds = view.layer.masksToBounds;
        animationView.contentMode = view.contentMode;
        animationView.transform = view.transform;
    }
    else {
        animationView = [view snapshotViewAfterScreenUpdates:YES];
    }

    return animationView;
}

#pragma mark - Setup

- (void)setupTransitionContainerHierarchyWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    if (![toView isDescendantOfView:transitionContext.containerView]) {
        [transitionContext.containerView addSubview:toView];
    }
    
    if (self.isDismissing) {
        [transitionContext.containerView bringSubviewToFront:fromView];
    }
}

#pragma mark - Fading animation

- (void)performFadeAnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *viewToFade = toView;
    CGFloat beginningAlpha = 0.0;
    CGFloat endingAlpha = 1.0;
    
    if (self.isDismissing) {
        viewToFade = fromView;
        beginningAlpha = 1.0;
        endingAlpha = 0.0;
    }
    
    viewToFade.alpha = beginningAlpha;
    
    [UIView animateWithDuration:[self fadeDurationForTransitionContext:transitionContext] animations:^{
        viewToFade.alpha = endingAlpha;
    } completion:^(BOOL finished) {
        if (!self.shouldPerformZoomingAnimation) {
            [self completeTransitionWithTransitionContext:transitionContext];
        }
    }];
}

- (CGFloat)fadeDurationForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.shouldPerformZoomingAnimation) {
        return (CGFloat) ([self transitionDuration:transitionContext] * 0.45f);
    }
    
    return (CGFloat) [self transitionDuration:transitionContext];
}

#pragma mark - Zooming animation

- (void)performZoomingAnimationWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;

    UIView *startingViewForAnimation = [[self class] newAnimationViewFromView:self.startingView];
    
    UIView *endingViewForAnimation = self.endingViewForAnimation;
    if (!endingViewForAnimation) {
        endingViewForAnimation = [[self class] newAnimationViewFromView:self.endingView];
    }
    
    CGAffineTransform finalEndingViewTransform = self.endingView.transform;

    CGFloat endingViewInitialTransform = CGRectGetHeight(startingViewForAnimation.frame) / CGRectGetHeight(endingViewForAnimation.frame);
    CGPoint translatedStartingViewCenter = [[self class] centerPointForView:self.startingView
                                                  translatedToContainerView:containerView];
    
    startingViewForAnimation.center = translatedStartingViewCenter;
    
    endingViewForAnimation.transform = CGAffineTransformScale(endingViewForAnimation.transform, endingViewInitialTransform, endingViewInitialTransform);
    endingViewForAnimation.center = translatedStartingViewCenter;
    endingViewForAnimation.alpha = 0.0;
    
    [transitionContext.containerView addSubview:startingViewForAnimation];
    [transitionContext.containerView addSubview:endingViewForAnimation];
    
    // Hide the original ending view and starting view until the completion of the animation.
    self.endingView.alpha = 0.0;
    self.startingView.alpha = 0.0;
    
    CGFloat fadeInDuration = (CGFloat) ([self transitionDuration:transitionContext] * 0.1f);
    CGFloat fadeOutDuration = (CGFloat) ([self transitionDuration:transitionContext] * 0.05f);
    
    // Ending view / starting view replacement animation
    [UIView animateWithDuration:fadeInDuration
                          delay:0
                        options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         endingViewForAnimation.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:fadeOutDuration
                                               delay:0
                                             options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                              startingViewForAnimation.alpha = 0.0;
                          } completion:^(BOOL f) {
                              [startingViewForAnimation removeFromSuperview];
                          }];
                     }];
    
    CGFloat startingViewFinalTransform = 1.f / endingViewInitialTransform;
    CGPoint translatedEndingViewFinalCenter = [[self class] centerPointForView:self.endingView
                                                     translatedToContainerView:containerView];
    
    // Zoom animation
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         endingViewForAnimation.transform = finalEndingViewTransform;
                         endingViewForAnimation.center = translatedEndingViewFinalCenter;
                         startingViewForAnimation.transform = CGAffineTransformScale(startingViewForAnimation.transform, startingViewFinalTransform, startingViewFinalTransform);
                         startingViewForAnimation.center = translatedEndingViewFinalCenter;
                     }
                     completion:^(BOOL finished) {
                         [endingViewForAnimation removeFromSuperview];
                         self.endingView.alpha = 1.0;
                         self.startingView.alpha = 1.0;
        
                         [self completeTransitionWithTransitionContext:transitionContext];
                     }];
}

#pragma mark - Helper methods

- (BOOL)shouldPerformZoomingAnimation {
    return self.startingView && self.endingView;
}

- (void)completeTransitionWithTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (transitionContext.isInteractive) {
        if (transitionContext.transitionWasCancelled) {
            [transitionContext cancelInteractiveTransition];
        }
        else {
            [transitionContext finishInteractiveTransition];
        }
    }
    
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
}

+ (CGPoint)centerPointForView:(UIView *)view translatedToContainerView:(UIView *)containerView {
    CGPoint centerPoint = view.center;
    
    // Special case for zoomed scroll views.
    if ([view.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view.superview;
        
        if (scrollView.zoomScale != 1.0) {
            centerPoint.x += (CGRectGetWidth(scrollView.bounds) - scrollView.contentSize.width) / 2.0 + scrollView.contentOffset.x;
            centerPoint.y += (CGRectGetHeight(scrollView.bounds) - scrollView.contentSize.height) / 2.0 + scrollView.contentOffset.y;
        }
    }
    
    return [view.superview convertPoint:centerPoint toView:containerView];
}

#pragma mark - UIViewControllerAnimatedTransitioning protocol

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.shouldPerformZoomingAnimation) {
        return 0.5;
    }
    
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self setupTransitionContainerHierarchyWithTransitionContext:transitionContext];
    
    [self performFadeAnimationWithTransitionContext:transitionContext];
    
    if (self.shouldPerformZoomingAnimation) {
        [self performZoomingAnimationWithTransitionContext:transitionContext];
    }
}

@end
