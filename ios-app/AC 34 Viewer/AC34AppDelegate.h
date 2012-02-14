//
//  AC34AppDelegate.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AC34StreamHandler;

@interface AC34AppDelegate : UIResponder <UIApplicationDelegate, NSStreamDelegate> {
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AC34StreamHandler *streamHandler;

@end
