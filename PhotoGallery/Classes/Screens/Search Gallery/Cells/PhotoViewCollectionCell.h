//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultCellProtocol.h"


@interface PhotoViewCollectionCell : UICollectionViewCell <DefaultCellProtocol>

@property (nonatomic, readonly) UIImageView *imageView;

@end