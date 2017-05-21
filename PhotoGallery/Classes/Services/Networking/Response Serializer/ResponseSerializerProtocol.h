//
// Created by Eugene on 5/21/17.
// Copyright (c) 2017 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResponseSerializerProtocol <NSObject>

- (id)serializedResponseFromURLResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError * __autoreleasing *)error;

@end