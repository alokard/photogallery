//
// Created by Eugene on 5/21/17.
// Copyright (c) 2017 Tulusha.com. All rights reserved.
//

#import "ImageDownloadService.h"

#import <ReactiveCocoa/RACEXTScope.h>

@interface ImageDownloadService ()

@property (nonatomic, strong) NSCache *imageCache;

@property (nonatomic, strong) NSMutableDictionary *imagesLoadingDict;
@property (nonatomic, strong) NSLock *imagesLoadingDictLock;

@property (nonatomic, strong) NSURLSession *downloadingSession;


@end


@implementation ImageDownloadService

+ (instancetype)sharedService {
    static ImageDownloadService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageDownloadService alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.imageCache = [NSCache new];
        self.imagesLoadingDict = [NSMutableDictionary new];
        self.imagesLoadingDictLock = [NSLock new];
    }
    return self;
}

- (instancetype)initWithURLSession:(NSURLSession *)urlSession {
    if (self = [self init]) {
        _downloadingSession = urlSession;
    }
    return self;
}

#pragma mark - Lazy loading

- (NSURLSession *)downloadingSession {
    if (!_downloadingSession) {
        _downloadingSession = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    }
    return _downloadingSession;
}

#pragma mark - Image Download Session Protocol

- (void)loadImageFromURL:(NSURL *)url completionBlock:(void (^)(BOOL success, UIImage *image, NSError *error))completion {
    if (!completion) {
        return;
    }

    id cachedImage = [self.imageCache objectForKey:url.absoluteString];

    if (cachedImage) {
        completion(YES, cachedImage, nil);
    }
    else {
        [self downloadImageFromURL:url completionBlock:completion];
    }
}

- (void)cancelLoadingForURL:(NSURL *)url {
    NSURLSessionDataTask *loadingTask = self.imagesLoadingDict[url.absoluteString];
    if (loadingTask) {
        [loadingTask cancel];
        [self setDataTask:nil forURL:url];
    }
}

#pragma mark - Private methods

- (void)downloadImageFromURL:(NSURL *)url completionBlock:(void (^)(BOOL success, UIImage *image, NSError *error))completion {
    if (!completion) {
        return;
    }

    NSURLSessionDataTask *loadingTask = self.imagesLoadingDict[url.absoluteString];
    if (!loadingTask) {
        @weakify(self);
        loadingTask = [self.downloadingSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            @strongify(self);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (error) {
                    completion(NO, nil, error);
                }
                else {
                    UIImage *image = [UIImage imageWithData:data];
                    [self.imageCache setObject:image forKey:url.absoluteString];
                    completion(YES, image, nil);
                }
                [self setDataTask:nil forURL:url];
            }];
        }];

        [self setDataTask:loadingTask forURL:url];
        [loadingTask resume];
    }
}

#pragma mark - Thread safety

- (void)setDataTask:(NSURLSessionDataTask *)task forURL:(NSURL *)url {
    [self.imagesLoadingDictLock lock];

    if (task) {
        self.imagesLoadingDict[url.absoluteString] = task;
    }
    else {
        [self.imagesLoadingDict removeObjectForKey:url.absoluteString];
    }

    [self.imagesLoadingDictLock unlock];
}

@end