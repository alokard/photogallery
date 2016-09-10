//
// Created by Eugene on 8/15/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "PhotoCellView.h"
#import "ImageScrollView.h"
#import "PhotoCellViewModel.h"


@interface PhotoCellView ()

@property (nonatomic, readwrite) ImageScrollView *imageScrollView;

@end

@implementation PhotoCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageScrollView = [[ImageScrollView alloc] initWithImage:nil
                                                                frame:frame];
        [self.contentView addSubview:self.imageScrollView];

        [self.imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }

    return self;
}

#pragma mark - DefaultCellProtocol

- (void)updateWithViewModel:(PhotoCellViewModel *)model {
    NSParameterAssert([model isKindOfClass:[PhotoCellViewModel class]]);
    [self.imageScrollView setImageWithURL:model.photoURL placeholder:nil];
}

@end