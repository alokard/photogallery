//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSONLoader : NSObject

+ (NSDictionary *)payloadFromResource:(NSString *)resource ofType:(NSString *)type;

@end
