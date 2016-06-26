//
//  AppDelegate.m
//  PhotoGallery
//
//  Created by Eugene on 6/25/16.
//  Copyright © 2016 Tulusha.com. All rights reserved.
//

#import "AppDelegate.h"
#import "MainNaviagationRouter.h"
#import "Configuration.h"
#import "UIColor+PhotoGallery.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *mainNavigationController;
@property (nonatomic, strong) id<MainRouting> navigationRouter;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    self.mainNavigationController = [[UINavigationController alloc] init];
    self.mainNavigationController.navigationBar.translucent = NO;
    self.mainNavigationController.navigationBar.barTintColor = [UIColor pg_blueColor];
    self.mainNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.mainNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationRouter = [[MainNaviagationRouter alloc] initWithNavigationController:self.mainNavigationController
                                                                          configuration:[Configuration defaultConfiguration]];
    [self.navigationRouter showMainGalleryAnimated:NO];

    [self.window setRootViewController:self.mainNavigationController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
