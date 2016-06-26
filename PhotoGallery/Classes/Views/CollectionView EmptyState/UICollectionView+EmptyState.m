//
// Created by Eugene on 6/26/16.
// Copyright (c) 2016 Tulusha.com. All rights reserved.
//

#import <objc/runtime.h>
#import "UICollectionView+EmptyState.h"

static char *const kEmptyStateView = "emptyDataSetView";

void pgES_swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

@implementation UICollectionView (EmptyState)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class c = [UICollectionView class];
        pgES_swizzle(c, @selector(reloadData), @selector(pgES_reloadData));
    });
}

@dynamic pg_emptyStateView;
- (UIView *)pg_emptyStateView {
    UIView *view = objc_getAssociatedObject(self, kEmptyStateView);
    return view;
}

- (void)setPg_emptyStateView:(UIView *)view {
    if (self.pg_emptyStateView.superview) {
        [self.pg_emptyStateView removeFromSuperview];
    }
    objc_setAssociatedObject(self, kEmptyStateView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Updating

- (void)pgES_updateEmptyView {
    UIView *emptyView = self.pg_emptyStateView;

    if (!emptyView) return;

    if (!emptyView.superview) {
        if (self.subviews.count > 1) {
            [self insertSubview:emptyView atIndex:0];
        }
        else {
            [self addSubview:emptyView];
        }
    }

    // setup empty view frame
    CGRect frame = self.bounds;
    frame.origin = CGPointMake(0, 0);

    emptyView.frame = frame;
    emptyView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);

    // check available data
    BOOL emptyViewShouldBeShown = (self.pgES_itemsCount == 0);

    // show / hide empty view
    [UIView animateWithDuration:0.2 animations:^{
        emptyView.alpha = emptyViewShouldBeShown ? 1.0f : 0.0f;
    }];
}

- (NSInteger)pgES_itemsCount {
    NSInteger items = 0;

    id <UICollectionViewDataSource> dataSource = self.dataSource;

    NSInteger sections = 1;

    if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sections = [dataSource numberOfSectionsInCollectionView:self];
    }

    if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        for (NSInteger section = 0; section < sections; section++) {
            items += [dataSource collectionView:self numberOfItemsInSection:section];
        }
    }

    return items;
}

#pragma mark - Swizzling

- (void)pgES_reloadData {
    [self pgES_updateEmptyView];

    [self pgES_reloadData];
}

@end