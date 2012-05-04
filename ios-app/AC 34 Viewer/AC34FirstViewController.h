//
//  AC34FirstViewController.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

// Followed tutorial at http://38leinad.wordpress.com/2011/10/19/practical-blender-with-glkit-part-1-introducing-glkit/

// We are making the GLKViewController its own delegate.
@interface AC34FirstViewController : GLKViewController <GLKViewControllerDelegate, GLKViewDelegate> {
@private
    GLKBaseEffect *effect;
}

#pragma mark GLKViewControllerDelegate
/* called each time before a new frame will be render. 
 * You can use it for any kind of calculations that have 
 * to be performed prior to the actual rendering; so, 
 * the render-method itself is as lightweight as possible. 
 * In a game you might also use this method to update your 
 * game-physics and -state.
 */
- (void) glkViewControllerUpdate:(GLKViewController *)controller;

#pragma mark GLKViewDelegate
// The actual render method.
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect;


@end
