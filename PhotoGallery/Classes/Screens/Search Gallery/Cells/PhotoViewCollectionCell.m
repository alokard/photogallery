//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotoViewCollectionCell.h"
#import "PhotoCellViewModel.h"
#import <ReactiveCocoa/RACEXTScope.h>

#import <Masonry/View+MASAdditions.h>

@interface PhotoViewCollectionCell ()

@property (nonatomic, strong) UIImageView *maskImage;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) PhotoCellViewModel *viewModel;

@end

@implementation PhotoViewCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];

        self.maskImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_photo_cell"]];
        [self.contentView addSubview:self.maskImage];
        [self.maskImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }

    return self;
}

- (void)prepareForReuse {
    if (self.viewModel) {
        [self.viewModel cancelPhotoDownload];
        self.viewModel = nil;
    }
}

- (void)updateWithViewModel:(PhotoCellViewModel *)model {
    NSParameterAssert([model isKindOfClass:[PhotoCellViewModel class]]);
    self.viewModel = model;
    @weakify(self);
    [model getPhotoWithCompletion:^(UIImage *image) {
        @strongify(self);
        self.imageView.image = image;
    }];
}

@end