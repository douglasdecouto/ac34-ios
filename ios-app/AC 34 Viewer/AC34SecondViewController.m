//
//  AC34SecondViewController.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34SecondViewController.h"

#import "AC34.h"
#import "AC34Boat.h"
#import "AC34BoatDataController.h"

@implementation AC34SecondViewController

@synthesize dataController = _dataController;
@synthesize chatterTextView = _chatterTextView;
@synthesize rootView = _rootView;
@synthesize tableView = _tableView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.chatterTextView == nil) {
        NSLog(@"Chatter view is nil!");
    }
    else {
        self.chatterTextView.text = @"CHATTER CHATTER CHATTER !!!!!";
        NSLog(@"Successfully set text hidden=%@, alpha=%@", self.chatterTextView.hidden, self.chatterTextView.alpha);
        NSLog(@"Root view's frame (%f,%f)", self.rootView.frame.size.width, self.rootView.frame.size.height);
        NSLog(@"Chatter's frame (%f,%f)", self.chatterTextView.frame.size.width, self.chatterTextView.frame.size.height);
        NSLog(@"Table's frame (%f,%f)", self.tableView.frame.size.width, self.tableView.frame.size.height);
        // [self.chatterTextView setNeedsDisplay];
        // [self.rootView bringSubviewToFront:self.chatterTextView];
    }
}

- (void)viewDidUnload
{
    [self setChatterTextView:nil];
    [self setRootView:nil];
    [self setTableView:nil];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

// Custom code
- (void) addBoatWithName:(NSString *)boatName {
    [self.dataController addBoatWithName:boatName];
    // [self.tView reloadData];
}

- (void) addChatter:(NSString *) chatter withType:(NSString *) chatterType  {
    NSString *new, *old;
    
    old = self.chatterTextView.text;
    new = [NSString stringWithFormat:@"[%@] %@\n", chatterType, chatter];

    self.chatterTextView.text = [old stringByAppendingString:new];
}


// Table view delegate code.
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger n = [self.dataController countOfList];
    NSLog(@"%d rows in table", n);
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *__strong)indexPath {
    
    static NSString *CellIdentifier = @"BoatCell"; // Must match template cell ID in inspector
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSLog(@"cellForRowAt %d", indexPath.row);
    
    AC34Boat *boatAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    [[cell textLabel] setText:boatAtIndex.name];
    
    [[cell detailTextLabel] setText:@"Fake detail text"];    
    return cell;
}



// AC34StreamDelegate functions.
- (void) heartBeatFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withSeq:(UInt32) sequenceNum {
    // Quick hack to get this data displayed on screen
    NSString *chatter = [NSString stringWithFormat:@"Heartbeat %lu", sequenceNum];
    [self chatterFrom:sourceId at:timeStamp withType:kInternalChatter withChatter:chatter];
}

- (void) chatterFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withType:(UInt32) chatterType withChatter:(NSString *) chatter {
    NSString *new, *old, *chatterTypeStr, *timeStampStr;
    
    chatterTypeStr = [AC34 chatterTypeforCode:chatterType];
    timeStampStr = [AC34 formatDateISO:timeStamp];
    
    old = self.chatterTextView.text;
    new = [NSString stringWithFormat:@"%lu %@ [%@] %@\n", sourceId, timeStampStr, chatterTypeStr, chatter];
    
    self.chatterTextView.text = [old stringByAppendingString:new];
}

- (void) locationUpdateFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withLoc:(AC34BoatLocation *)loc {
    // Quick hack to get this data displayed on screen
    NSString *chatter = [NSString stringWithFormat:@"Location update"];
    [self chatterFrom:sourceId at:timeStamp withType:kInternalChatter withChatter:chatter];
    
}

- (void) xmlFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
     withXmlType:(UInt32) xmlType withXmlTimeStamp:(NSDate *) xmlTimeStamp
         withSeq:(UInt32) sequenceNum withAck:(UInt32) ack withData:(NSData *) xml {
    
    NSString *rootName;
    
    switch (xmlType) {
        case kRegattaXml:
            rootName = @"RegattaConfig";
            break;
        case kRaceXml:
            rootName = @"Race";
            break;
        case kBoatXml:
            rootName = @"root";
            break;
        default:
            NSLog(@"Unknown XML message type %lu from %lu", xmlType, sourceId);
            return;
    }
}

@end
