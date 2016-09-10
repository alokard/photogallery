//
// Created by Eugene on 8/15/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefaultCellProtocol.h"

@class ImageScrollView;


@interface PhotoCellView : UICollectionViewCell <DefaultCellProtocol>

@property (nonatomic, readonly) ImageScrollView *imageScrollView;

@end