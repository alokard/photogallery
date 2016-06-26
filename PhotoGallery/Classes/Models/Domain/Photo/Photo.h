//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Mantle/Mantle.h>


@interface Photo : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSString *photoId;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *ownerId;
@property (nonatomic, readonly) NSString *secret;
@property (nonatomic, readonly) NSString *server;
@property (nonatomic, readonly) NSInteger farm;

@property (nonatomic, readonly) NSURL *thumbnailURL;
@property (nonatomic, readonly) NSURL *photoURL;

@end