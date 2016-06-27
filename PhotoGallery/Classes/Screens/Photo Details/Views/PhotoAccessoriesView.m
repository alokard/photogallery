//
//  PhotoAccessoriesView.m
//  PhotoGallery
//
//  Created by Eugene on 6/26/16.
//  Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Masonry/MASConstraintMaker.h>
#import "PhotoAccessoriesView.h"
#import "View+MASAdditions.h"
#import "PhotoDetailsViewModel.h"
#import "PhotoDetailsViewModel.h"

@interface PhotoAccessoriesView ()

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UITextView *titleTextView;

@end

@implementation PhotoAccessoriesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDoneButton];
        [self setupTitleView];
    }

    return self;
}

- (void)setupDoneButton {
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *doneImage = [UIImage imageNamed:@"close_button"];
    [self.doneButton setImage:doneImage forState:UIControlStateNormal];
    [self addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(8);
        make.height.width.equalTo(@45);
    }];
}

- (void)setupTitleView {
    self.titleTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.titleTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleTextView.editable = NO;
    self.titleTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.titleTextView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    self.titleTextView.textColor = [UIColor whiteColor];
    self.titleTextView.font = [UIFont systemFontOfSize:14.f];

    [self addSubview:self.titleTextView];
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.2f);
    }];
}

- (void)updateWithViewModel:(PhotoDetailsViewModel *)viewModel {
    self.titleTextView.text = viewModel.title;
    [self layoutIfNeeded];
}

#pragma mark - PassThrough touches if needed

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 &&
                view.userInteractionEnabled &&
                [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }

    return NO;
}

@end
