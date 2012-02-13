//
//  AC34AppDelegate.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AC34AppDelegate.h"

@implementation AC34AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
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
    CFStreamCreatePairWithSocketToHost(NULL, CFSTR("localhost"), 4941, 
									   &self->readStream, &self->writeStream);
	NSInputStream *inputStream = (__bridge NSInputStream *) self->readStream;
	[inputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream open];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void) stream:(NSStream *)theStream handleEvent:(NSStreamEvent) streamEvent {
	/* Handle a stream event */
	switch (streamEvent) {
        case NSStreamEventHasBytesAvailable:
            /* Do read */
            break;
            
        case NSStreamEventEndEncountered:
            /* Close it up */
            break;
            
            /* The following events aren't handled */
        case NSStreamEventHasSpaceAvailable:
        case NSStreamEventNone: 
        case NSStreamEventOpenCompleted:
            break;
            
        case NSStreamEventErrorOccurred: {
            /* Handle stream errors, e.g. couldn't connect to host, etc. */
            NSError *theError = [theStream streamError];
            NSLog([NSString stringWithFormat:@"Error reading stream (%i): %@",
                   [theError code], [theError localizedDescription]]);
            
            [theStream close];
        }
            break;
            
        default:
            assert(0);
	}	
}


@end
