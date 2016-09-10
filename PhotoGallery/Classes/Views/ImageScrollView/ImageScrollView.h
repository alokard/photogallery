//
//  ImageScrollView.h
//  PhotoGallery
//
//  Created by Eugene on 6/26/16.
//  Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame;
- (instancetype)initWithImageURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder frame:(CGRect)frame;

- (void)setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder;

- (void)updateWithImage:(UIImage *)image;
- (void)centerScrollViewContents;

@end
