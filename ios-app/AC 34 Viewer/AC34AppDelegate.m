//
//  AC34AppDelegate.m
//  AC 34 Viewer
//

// Copyright (c) 2012, Douglas S. J. De Couto, decouto@alum.mit.edu http://decouto.bm
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright
//   notice, this list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright
//   notice, this list of conditions and the following disclaimer in the
//   documentation and/or other materials provided with the distribution.
//
// * Neither the name of the Douglas S. J. De Couto nor the names of other 
//   contributors to this project may be used to endorse or promote products
//   derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

#import "AC34AppDelegate.h"
#import "AC34FirstViewController.h"
#import "AC34SecondViewController.h"
#import "AC34BoatDataController.h"
#import "AC34StreamHandler.h"

@implementation AC34AppDelegate

@synthesize window = _window;
@synthesize streamHandler = _streamHandler;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
    // Setup the "Second view controller" for tab 2 with a boat list data controller.
    UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;
    
    // Note: we know the "SecondViewController" is at index 0 -- we re-ordered the tabs to make 'second' be first.
    AC34SecondViewController *secondViewController = (AC34SecondViewController *)[[navigationController viewControllers] objectAtIndex:0];
    AC34FirstViewController *firstViewController = (AC34FirstViewController *) [[navigationController viewControllers] objectAtIndex:1];
    
    NSString *className = NSStringFromClass([secondViewController class]); 
    NSLog(@"Second controller class name %@", className);

    className = NSStringFromClass([firstViewController class]); 
    NSLog(@"First controller class name %@", className);

    AC34BoatDataController *aDataController = [[AC34BoatDataController alloc] init];
    firstViewController.dataController = aDataController;
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
    // Setup the "Second view controller" for tab 2 with a boat list data controller.
    UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;
    
    // Note: we know the "SecondViewController" is at index 1.
    AC34SecondViewController *secondViewController = (AC34SecondViewController *)[[navigationController viewControllers] objectAtIndex:0];

    self.streamHandler = [[AC34StreamHandler alloc] init];
    self.streamHandler.delegate = secondViewController;
    
    [self.streamHandler connectToServer:@"localhost" port:4941];
    //  [self.streamHandler connectToServer:@"157.125.69.155" port:4940];
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
