#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSDictionary+Overcoat.h"
#import "NSError+OVCResponse.h"
#import "OVCHTTPManager.h"
#import "OVCModelResponseSerializer.h"
#import "OVCResponse.h"
#import "OVCURLMatcher.h"
#import "OVCUtilities.h"
#import "Overcoat.h"
#import "OVCHTTPRequestOperationManager.h"
#import "OVCHTTPSessionManager.h"
#import "ReactiveCocoa+Overcoat.h"
#import "OVCHTTPRequestOperationManager+ReactiveCocoa.h"
#import "OVCHTTPSessionManager+ReactiveCocoa.h"

FOUNDATION_EXPORT double OvercoatVersionNumber;
FOUNDATION_EXPORT const unsigned char OvercoatVersionString[];

