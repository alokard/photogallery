//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "PhotoViewCell.h"
#import "View+MASAdditions.h"
#import "PhotoCellViewModel.h"
#import "PINImageView+PINRemoteImage.h"

@interface PhotoViewCell ()

@property (nonatomic, strong) PINImageView *imageView;

@end

@implementation PhotoViewCell

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
    }

    return self;
}

- (void)updateWithViewModel:(PhotoCellViewModel *)model {
    NSParameterAssert([model isKindOfClass:[PhotoCellViewModel class]]);
    [self.imageView pin_setImageFromURL:model.photoURL];
}

@end