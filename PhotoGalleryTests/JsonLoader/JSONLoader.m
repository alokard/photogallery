//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "JSONLoader.h"

@implementation JSONLoader

+ (NSDictionary *)payloadFromResource:(NSString *)resource ofType:(NSString *)type {
    NSError *error;
    NSDictionary *json;
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:resource ofType:type];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if(content) {
        NSData *objectData = [content dataUsingEncoding:NSUTF8StringEncoding];
        json = [NSJSONSerialization JSONObjectWithData:objectData
                                               options:NSJSONReadingMutableContainers
                                                 error:&error];
    }
    if(error) {
        [NSException raise:NSStringFromClass([self class]) format:@"Couldn't load JSON data from file %@.%@", resource, type];
    }
    return json;
}

@end
