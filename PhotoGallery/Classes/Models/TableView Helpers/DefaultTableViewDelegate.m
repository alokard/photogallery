//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "DefaultTableViewDelegate.h"
#import "CollectionSelectable.h"

@interface DefaultTableViewDelegate ()

@property (nonatomic, weak) id<CollectionSelectable> viewModel;

@end

@implementation DefaultTableViewDelegate

- (instancetype)initWithViewModel:(id<CollectionSelectable>)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

#pragma mark - CollectionView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.viewModel respondsToSelector:@selector(selectItemAtSection:index:)]) {
        [self.viewModel selectItemAtSection:indexPath.section index:indexPath.item];
    }
}

@end