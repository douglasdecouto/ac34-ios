//
//  AC34FirstViewController.h
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

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

// Followed tutorial at http://38leinad.wordpress.com/2011/10/19/practical-blender-with-glkit-part-1-introducing-glkit/

@class AC34BoatDataController;

// We are making the GLKViewController its own delegate.
@interface AC34FirstViewController : GLKViewController <GLKViewControllerDelegate, GLKViewDelegate> {
@private
    GLKBaseEffect *effect;
    
    // bounding box for lat/lon
    double minLat, maxLat, minLon, maxLon;
    int nBoatsWithLocs;
}

@property (nonatomic, retain) AC34BoatDataController *dataController;

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
