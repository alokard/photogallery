//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotoDetailsViewController.h"
#import "ImageScrollView.h"
#import "View+MASAdditions.h"
#import "PhotoAccessoriesView.h"
#import "PhotoDetailsViewModel.h"

@interface PhotoDetailsViewController ()

@property (nonatomic, strong) PhotoDetailsViewModel *viewModel;

@property (nonatomic, weak) ImageScrollView *imageScrollView;
@property (nonatomic, weak) UIView *accessoriesView;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;

@property (nonatomic, strong) PhotoDetailsTransitionController *transitionController;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic) BOOL overlayWasHiddenBeforeTransition;

@end

@implementation PhotoDetailsViewController

- (instancetype)initWithViewModel:(PhotoDetailsViewModel *)viewModel {
    if (self = [super init]) {
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanWithGestureRecognizer:)];
        self.singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTapWithGestureRecognizer:)];
        self.transitionController = [[PhotoDetailsTransitionController alloc] init];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.transitionController;
        self.modalPresentationCapturesStatusBarAppearance = YES;
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    [self setupContentView];
    [self setupImageScrollView];
    [self setupAccessoriesView];

    self.transitionController.startingView = self.viewModel.parentReference;
    UIView *endingView = self.imageScrollView.imageView;
    self.transitionController.endingView = endingView;
}

- (void)setupContentView {
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    [self.contentView addGestureRecognizer:self.panGestureRecognizer];
    [self.contentView addGestureRecognizer:self.singleTapGestureRecognizer];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupImageScrollView {
    ImageScrollView *imageScrollView = [[ImageScrollView alloc] initWithImageURL:self.viewModel.photoURL
                                                                     placeholder:self.viewModel.placeholder
                                                                           frame:self.view.bounds];
    [self.contentView addSubview:imageScrollView];
    [imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    self.imageScrollView = imageScrollView;

    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.imageScrollView.doubleTapGestureRecognizer];
}

- (void)setupAccessoriesView {
    PhotoAccessoriesView *accessoriesView = [[PhotoAccessoriesView alloc] initWithFrame:self.view.bounds];
    [accessoriesView updateWithViewModel:self.viewModel];
    [self.view addSubview:accessoriesView];
    [accessoriesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.accessoriesView = accessoriesView;
}

#pragma mark - Status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - Accessory views

- (void)setAccessoriesViewHidden:(BOOL)hidden animated:(BOOL)animated {
    if (hidden == self.accessoriesView.hidden) {
        return;
    }

    if (animated) {
        self.accessoriesView.hidden = NO;

        self.accessoriesView.alpha = hidden ? 1.f : 0.f;

        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.accessoriesView.alpha = hidden ? 0.f : 1.f;
        } completion:^(BOOL finished) {
            self.accessoriesView.alpha = 1.f;
            self.accessoriesView.hidden = hidden;
        }];
    }
    else {
        self.accessoriesView.hidden = hidden;
    }
}

#pragma mark - Gesture Recognizers

- (void)didSingleTapWithGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self setAccessoriesViewHidden:!self.accessoriesView.hidden animated:YES];
}

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.transitionController.forcesNonInteractiveDismissal = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        self.transitionController.forcesNonInteractiveDismissal = YES;
        [self.transitionController didPanWithPanGestureRecognizer:panGestureRecognizer viewToPan:self.contentView anchorPoint:self.boundsCenterPoint];
    }
}

- (CGPoint)boundsCenterPoint {
    return CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

#pragma mark - View Controller Dismissal

- (void)dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.presentedViewController) {
        [super dismissViewControllerAnimated:animated completion:completion];
        return;
    }

    UIView *startingView = self.imageScrollView.imageView;
    self.transitionController.startingView = startingView;
    self.transitionController.endingView = self.viewModel.parentReference;

    self.overlayWasHiddenBeforeTransition = self.accessoriesView.hidden;
    [self setAccessoriesViewHidden:YES animated:animated];
    
    [super dismissViewControllerAnimated:animated completion:^{
        BOOL isStillOnscreen = self.view.window != nil; // Happens when the dismissal is canceled.

        if (isStillOnscreen && !self.overlayWasHiddenBeforeTransition) {
            [self setAccessoriesViewHidden:NO animated:YES];
        }

        if (completion) {
            completion();
        }
    }];
}

@end