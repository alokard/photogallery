//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct ConfigurationKeysStruct {
    __unsafe_unretained NSString *environment;
    __unsafe_unretained NSString *baseURLString;
    __unsafe_unretained NSString *apiKey;
} ConfigurationKeysStruct;

extern const struct ConfigurationKeysStruct ConfigurationKeys;