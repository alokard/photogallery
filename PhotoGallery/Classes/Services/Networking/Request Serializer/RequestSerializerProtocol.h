//
// Created by Eugene on 5/21/17.
// Copyright (c) 2017 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestSerializerProtocol <NSObject>

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URL:(NSURL *)url parameters:(NSDictionary *)parameters error:(NSError * __autoreleasing *)error;

@end