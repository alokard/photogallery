//
//  PhotoAccessoriesView.h
//  PhotoGallery
//
//  Created by Eugene on 6/26/16.
//  Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoDetailsViewModel;

@interface PhotoAccessoriesView : UIView

- (void)updateWithViewModel:(PhotoDetailsViewModel *)viewModel;

@end
