//
//  SearchGalleryViewController.h
//  PhotoGallery
//
//  Created by Eugene on 6/25/16.
//  Copyright © 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACCommand;
@class SearchGalleryViewModel;

@interface SearchGalleryViewController : UIViewController

- (instancetype)initWithViewModel:(SearchGalleryViewModel *)viewModel;

@end

