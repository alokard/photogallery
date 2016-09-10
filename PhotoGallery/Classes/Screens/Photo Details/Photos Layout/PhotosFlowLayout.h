//
// Created by Eugene on 8/15/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotosFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, readwrite) IBInspectable CGFloat sideItemScale;
@property (nonatomic, readwrite) IBInspectable CGFloat sideItemAlpha;

@property (nonatomic, readwrite) IBInspectable CGFloat spacing;

@end