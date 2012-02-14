//
//  AC34AppDelegate.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AC34AppDelegate.h"
#import "AC34SecondViewController.h"
#import "AC34BoatDataController.h"
#import "AC34StreamHandler.h"

@implementation AC34AppDelegate

@synthesize window = _window;
@synthesize streamHandler = _streamHandler;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
    // Setup the "Second view controller" for tab 2 with a boat list data controller.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    
    // Note: we know the "SecondViewController" ias at index 1.
    AC34SecondViewController *secondViewController = (AC34SecondViewController *)[[navigationController viewControllers] objectAtIndex:1];
    
    NSString *className = NSStringFromClass([secondViewController class]); 
    NSLog(@"Second controller class name %@", className);
    
    AC34BoatDataController *aDataController = [[AC34BoatDataController alloc] init];
    secondViewController.dataController = aDataController;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    self.streamHandler = [[AC34StreamHandler alloc] init];
    [self.streamHandler connectToServer:@"localhost" port:4941];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
