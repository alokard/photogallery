//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DefaultCellProtocol;
@protocol CollectionStorageProtocol;


@interface DefaultTableViewDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithTableView:(UITableView *)tableView
                        cellClass:(Class <DefaultCellProtocol>)cellClass
                          storage:(id <CollectionStorageProtocol>)storage;
@end