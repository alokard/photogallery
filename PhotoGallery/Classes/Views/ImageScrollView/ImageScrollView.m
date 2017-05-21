//
//  ImageScrollView.m
//  PhotoGallery
//
//  Created by Eugene on 6/26/16.
//  Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "ImageScrollView.h"
#import "ImageDownloadServiceProtocol.h"
#import "ImageDownloadService.h"

#import <ReactiveCocoa/RACEXTScope.h>

@interface ImageScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *loadingView;

@property (nonatomic, strong) id <ImageDownloadServiceProtocol> imageDownloadService;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation ImageScrollView

- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generalSetup];
        [self setupInternalImageViewWithImage:image];
    }
    return self;
}

- (instancetype)initWithImageURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generalSetup];
        [self setupInternalImageViewWithImageURL:imageURL placeholder:placeholder];
    }
    return self;
}

- (void)generalSetup {
    [self setupScrollView];
    [self setupGestureRecognizers];
    self.delegate = self;
    self.imageDownloadService = [ImageDownloadService sharedService];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateZoomScale];
    [self centerScrollViewContents];
}

- (void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    [self updateWithImage:placeholder];
    @weakify(self);
    [self.imageDownloadService loadImageFromURL:imageURL
                                completionBlock:^(BOOL success, UIImage *image, NSError *error) {
                                    if (image) {
                                        @strongify(self);
                                        [self updateWithImage:image];
                                    }
                                }];
}

#pragma mark - Setup helpers

- (void)setupInternalImageViewWithImage:(UIImage *)image {
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self updateWithImage:image];

    [self addSubview:self.imageView];

    UIView *view = [UIView new];
    view.frame = CGRectMake(20, 20, 30, 30);
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
}

- (void)setupInternalImageViewWithImageURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder {
    self.imageView = [[UIImageView alloc] init];

    [self setImageWithURL:imageURL placeholder:placeholder];

    [self addSubview:self.imageView];
}

- (void)setupScrollView {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
}

- (void)updateZoomScale {
    if (self.imageView.image) {
        CGRect scrollViewFrame = self.bounds;

        CGFloat scaleWidth = scrollViewFrame.size.width / self.imageView.image.size.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / self.imageView.image.size.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);

        self.minimumZoomScale = minScale;
        self.maximumZoomScale = MAX(minScale, 2.f);

        self.zoomScale = self.minimumZoomScale;

        self.panGestureRecognizer.enabled = NO;
    }
}

- (void)setupGestureRecognizers {
    self.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTapWithGestureRecognizer:)];
    self.doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.doubleTapGestureRecognizer];
}

- (UIView *)loadingView {
    if (!_loadingView) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicator startAnimating];
        _loadingView = activityIndicator;
    }
    return _loadingView;
}

#pragma mark - Public methods

- (void)updateWithImage:(UIImage *)image {
    self.imageView.transform = CGAffineTransformIdentity;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);

    self.contentSize = image.size;

    [self updateZoomScale];
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents {
    CGFloat horizontalInset = 0;
    CGFloat verticalInset = 0;

    if (self.contentSize.width < CGRectGetWidth(self.bounds)) {
        horizontalInset = (CGRectGetWidth(self.bounds) - self.contentSize.width) * 0.5f;
    }

    if (self.contentSize.height < CGRectGetHeight(self.bounds)) {
        verticalInset = (CGRectGetHeight(self.bounds) - self.contentSize.height) * 0.5f;
    }

    if (self.window.screen.scale < 2.0) {
        horizontalInset = floorf(horizontalInset);
        verticalInset = floorf(verticalInset);
    }

    self.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
}

#pragma mark - Gesture Recognisers

- (void)didDoubleTapWithGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    CGPoint pointInView = [recognizer locationInView:self.imageView];

    CGFloat newZoomScale = self.maximumZoomScale;

    if (self.zoomScale > self.minimumZoomScale) {
        newZoomScale = self.minimumZoomScale;
    }

    CGSize scrollViewSize = self.bounds.size;

    CGFloat width = scrollViewSize.width / newZoomScale;
    CGFloat height = scrollViewSize.height / newZoomScale;
    CGFloat originX = pointInView.x - (width / 2.f);
    CGFloat originY = pointInView.y - (height / 2.f);

    CGRect rectToZoomTo = CGRectMake(originX, originY, width, height);

    [self zoomToRect:rectToZoomTo animated:YES];
}

#pragma mark - ScrollView delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.panGestureRecognizer.enabled = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scrollView.zoomScale == scrollView.minimumZoomScale) {
        scrollView.panGestureRecognizer.enabled = NO;
    }
}


@end
