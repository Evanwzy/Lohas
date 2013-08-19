//
//  RKAppDelegate.m
//  Lohas
//
//  Created by Evan on 13-8-15.
//  Copyright (c) 2013年 Evan. All rights reserved.
//

#import "RKAppDelegate.h"

@implementation RKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Notification TODO
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushViewControllerEvent:) name:@"PUSHCONTROLLER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewControllerEvent:) name:@"POPCONTROLLER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToRootViewControllerEvent:) name:@"POPTOROOTCONTROLLER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentModalViewControllerEvent:) name:@"PRESENTCONTROLLER" object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RKHomeViewController *hvCtr =[[RKHomeViewController alloc]init];
    UINavigationController *naviCtr =[[UINavigationController alloc]initWithRootViewController:hvCtr];
    naviCtr.navigationBarHidden =YES;
    self.naviController =naviCtr;
    
    self.window.rootViewController =_naviController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - NSNotificationCenter

- (void)pushViewControllerEvent:(NSNotification *)notification
{
    UIViewController *controller = (UIViewController*)[notification object];
    if (controller == nil || self.naviController == nil) {
        return;
    }
    @try {
        [self.naviController pushViewController:controller animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"{%@} push controller error",self.class);
    }
    @finally {
        
    }
}

- (void)popViewControllerEvent:(NSNotification *)notification
{
    @try {
        [self.naviController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"{%@} pop controller error",self.class);
    }
    @finally {
        
    }
}

- (void)popToRootViewControllerEvent:(NSNotification *)notification
{
    @try {
        [self.naviController popToRootViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"{%@} push controller error",self.class);
    }
    @finally {
        
    }
}

- (void)presentModalViewControllerEvent:(NSNotification *)notification
{
    UIViewController *controller = (UIViewController*)[notification object];
    if (controller == nil || self.naviController == nil) {
        return;
    }
    @try {
        [self.naviController presentModalViewController:controller animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"{%@} pop controller error",self.class);
    }
    @finally {
        
    }
}

@end
