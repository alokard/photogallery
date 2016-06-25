//
// Created by Eugene on 6/25/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import "Configuration.h"

static NSString *const kConfigurationPlistKey = @"ConfigurationPlist";

@interface Configuration ()

@property (nonatomic, readwrite, strong) NSDictionary *store;

@end

@implementation Configuration

+ (instancetype)defaultConfiguration {
    return [[self alloc] init];
}

- (id)init {
    if (self = [super init]) {
        [self registerDefaultConfiguration];
    }

    return self;
}

- (id)settingForKey:(NSString *)key {
    return [self.store valueForKeyPath:key];
}

- (void)registerDefaultConfiguration {
    self.store = [self loadDefaults];
}

- (NSDictionary *)loadDefaults {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *plistName = [bundle objectForInfoDictionaryKey:kConfigurationPlistKey];
    NSString *plistPath = [bundle pathForResource:plistName ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

@end
