//
//  AC34AppDelegate.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AC34AppDelegate : UIResponder <UIApplicationDelegate, NSStreamDelegate> {
    
	CFReadStreamRef  readStream;
	CFWriteStreamRef writeStream;
}

@property (strong, nonatomic) UIWindow *window;

@end
