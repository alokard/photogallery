//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CollectionSelectable <NSObject>

- (void)selectItemAtSection:(NSInteger)section index:(NSInteger)index;

@end