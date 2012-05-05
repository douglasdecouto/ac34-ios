//
//  AC34FirstViewController.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34FirstViewController.h"
#import "AC34Boat.h"
#import "AC34BoatLocation.h"
#import "AC34BoatDataController.h"

@implementation AC34FirstViewController

@synthesize dataController = _dataController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
   
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView *glkView = (GLKView *)self.view;
    glkView.delegate = self;
    glkView.context = aContext;
    
    glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    glkView.drawableMultisample = GLKViewDrawableMultisample4X;
    
    self.delegate = self;
    self.preferredFramesPerSecond = 30;
    
    effect = [[GLKBaseEffect alloc] init];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


// GLK stuff

- (void) glkViewControllerUpdate:(GLKViewController *) controller
{
/*    
    static float transY = 0.0f;
    float y = sinf(transY) / 2.0f;
    transY += 0.175f;
*/    
    // From above code looks like visible y-values are in +/- 1
    
    float y = 0;
    GLKMatrix4 modelview = GLKMatrix4MakeTranslation(0, y, -5.0f);
    effect.transform.modelviewMatrix = modelview;
    
    GLfloat aspectRatio = self.view.bounds.size.width / self.view.bounds.size.height;
    GLKMatrix4 projection = GLKMatrix4MakePerspective(45.0f, aspectRatio, 0.1f, 20.0f);
    effect.transform.projectionMatrix = projection;

    // Work out bounding lat/lon
    int nBoats = [self.dataController countOfList];
    nBoatsWithLocs = 0;
    for (int i = 0; i < nBoats; i++) {
        AC34Boat *b = [self.dataController objectInListAtIndex:i];
        AC34BoatLocation *l = b.lastLocation;
        if (l == nil)
            continue;
        if (i == 0) {
            minLat = maxLat = l.latitude;
            minLon = maxLon = l.longitude;
        }
        else {
            minLat = MIN(minLat, l.latitude);
            maxLat = MAX(maxLat, l.latitude);
            minLon = MIN(minLon, l.longitude);
            maxLon = MAX(maxLon, l.longitude);
        }
        nBoatsWithLocs++;
    }
    
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect) rect
{
    [effect prepareToDraw];

    double maxX = 1.0;
    double minX = -1.0;
    double maxY = 1.0;
    double minY = -1.0;
    
    double dXdLon = (maxX - minX) / ((nBoatsWithLocs > 1) ? (maxLon - minLon) : 1.0);
    double dYdLat = (maxY - minY) / ((nBoatsWithLocs > 1) ? (maxLat - minLat) : 1.0);
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    int nBoats = [self.dataController countOfList];
    for (int i = 0; i < nBoats; i++) {
        AC34Boat *b = [self.dataController objectInListAtIndex:i];
        //NSLog(@"Drawing boat %@", [b displayName]);
        AC34BoatLocation *l = b.lastLocation;

        double boatX = (nBoatsWithLocs > 1) ? (minX + dXdLon*(l.longitude - minLon)) : 0;
        double boatY = (nBoatsWithLocs > 1) ? (minY + dYdLat*(l.latitude - minLat)) : 0;
        
        double eps = 0.05f; // half the length of square sides
    
        GLfloat squareVertices[4*3];
        squareVertices[0] = -eps + boatX;
        squareVertices[1] = -eps + boatY;
        squareVertices[2] = 1;
        squareVertices[3] = eps + boatX;
        squareVertices[4] = -eps + boatY;
        squareVertices[5] = 1;
        squareVertices[6] = -eps + boatX;
        squareVertices[7] = eps + boatY;
        squareVertices[8] = 1;
        squareVertices[9] = eps + boatX;
        squareVertices[10] = eps + boatY;
        squareVertices[11] = 1;
                
        static const GLubyte squareColors[] = {
            255, 255,   0, 255,
            0,   255, 255, 255,
            0,     0,   0,   0,
            255,   0, 255, 255,
        };
        
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, squareVertices);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, squareColors);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
        
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}


@end
