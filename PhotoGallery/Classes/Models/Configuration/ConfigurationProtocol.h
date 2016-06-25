//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConfigurationProtocol <NSObject>

@required
- (id)settingForKey:(NSString *)key;

@end