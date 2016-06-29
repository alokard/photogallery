//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionSelectable;

@interface DefaultCollectionViewDelegate : NSObject <UICollectionViewDelegate>

- (instancetype)initWithViewModel:(id <CollectionSelectable>)viewModel;

@end