//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotoDismissInteractionController.h"

static CGFloat const kDismissDistanceMultiplier = 50.f / 667.f; // distance in 50pxl for iPhone 6 screen.
static CGFloat const kMaxDismissDuration = 0.45f;
static CGFloat const kReturnVelocityMultiplier = 0.00005f;

@interface PhotoDismissInteractionController ()

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation PhotoDismissInteractionController

#pragma mark - Panning handling

- (void)didPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    CGPoint translatedPanGesturePoint = [panGestureRecognizer translationInView:fromView];
    CGPoint newCenterPoint = CGPointMake(anchorPoint.x, anchorPoint.y + translatedPanGesturePoint.y);
    
    // Pan the view on pace with the pan gesture.
    viewToPan.center = newCenterPoint;
    
    CGFloat verticalDelta = newCenterPoint.y - anchorPoint.y;
    
    CGFloat backgroundAlpha = [self backgroundAlphaForPanningWithVerticalDelta:verticalDelta];
    fromView.backgroundColor = [fromView.backgroundColor colorWithAlphaComponent:backgroundAlpha];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self finishPanWithPanGestureRecognizer:panGestureRecognizer verticalDelta:verticalDelta viewToPan:viewToPan anchorPoint:anchorPoint];
    }
}

- (void)finishPanWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer verticalDelta:(CGFloat)verticalDelta viewToPan:(UIView *)viewToPan anchorPoint:(CGPoint)anchorPoint {
    UIView *fromView = [self.transitionContext viewForKey:UITransitionContextFromViewKey];
    
    // Return to center case.
    CGFloat velocityY = [panGestureRecognizer velocityInView:panGestureRecognizer.view].y;
    
    CGFloat animationDuration = (ABS(velocityY) * kReturnVelocityMultiplier) + 0.2f;
    CGFloat animationCurve = UIViewAnimationOptionCurveEaseOut;
    CGPoint finalPageViewCenterPoint = anchorPoint;
    CGFloat finalBackgroundAlpha = 1.0;
    
    CGFloat dismissDistance = kDismissDistanceMultiplier * CGRectGetHeight(fromView.bounds);
    BOOL isDismissing = ABS(verticalDelta) > dismissDistance;
    
    BOOL didAnimateUsingAnimator = NO;
    
    if (isDismissing) {
        if (self.shouldAnimateUsingAnimator) {
            [self.animator animateTransition:self.transitionContext];
            didAnimateUsingAnimator = YES;
        }
        else {
            BOOL isPositiveDelta = verticalDelta >= 0;
            
            CGFloat modifier = isPositiveDelta ? 1 : -1;
            CGFloat finalCenterY = CGRectGetMidY(fromView.bounds) + modifier * CGRectGetHeight(fromView.bounds);
            finalPageViewCenterPoint = CGPointMake(fromView.center.x, finalCenterY);
            
            // Maintain the velocity of the pan, while easing out.
            animationDuration = ABS(finalPageViewCenterPoint.y - viewToPan.center.y) / ABS(velocityY);
            animationDuration = MIN(animationDuration, kMaxDismissDuration);
            
            animationCurve = UIViewAnimationOptionCurveEaseOut;
            finalBackgroundAlpha = 0.0;
        }
    }
    
    if (!didAnimateUsingAnimator) {
        [UIView animateWithDuration:animationDuration delay:0 options:animationCurve animations:^{
            viewToPan.center = finalPageViewCenterPoint;
            
            fromView.backgroundColor = [fromView.backgroundColor colorWithAlphaComponent:finalBackgroundAlpha];
        } completion:^(BOOL finished) {
            if (isDismissing) {
                [self.transitionContext finishInteractiveTransition];
            }
            else {
                [self.transitionContext cancelInteractiveTransition];
            }
            
            self.viewToHideWhenBeginningTransition.alpha = 1.0;
            
            [self.transitionContext completeTransition:isDismissing && !self.transitionContext.transitionWasCancelled];
            
            self.transitionContext = nil;
        }];
    }
    else {
        self.transitionContext = nil;
    }
}

- (CGFloat)backgroundAlphaForPanningWithVerticalDelta:(CGFloat)verticalDelta {
    CGFloat startingAlpha = 1.0;
    CGFloat finalAlpha = 0.1;
    CGFloat totalAvailableAlpha = startingAlpha - finalAlpha;
    
    CGFloat maximumDelta = CGRectGetHeight([self.transitionContext viewForKey:UITransitionContextFromViewKey].bounds) / 2.f; // Arbitrary value.
    CGFloat deltaAsPercentageOfMaximum = MIN(ABS(verticalDelta) / maximumDelta, 1.0);
    
    return startingAlpha - (deltaAsPercentageOfMaximum * totalAvailableAlpha);
}

#pragma mark - UIViewControllerInteractiveTransitioning protocol

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.viewToHideWhenBeginningTransition.alpha = 0.0;
    
    self.transitionContext = transitionContext;
}

@end
