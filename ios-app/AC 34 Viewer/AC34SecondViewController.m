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
#import "AC34BoatLocation.h"
#import "AC34BoatDataController.h"

#import "SMXMLDocument.h"

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


/*
 * Table view delegate code.
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger n = [self.dataController countOfList];
    return n;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *__strong)indexPath {
    
    static NSString *CellIdentifier = @"BoatCell"; // Must match template cell ID in inspector
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    AC34Boat *boatAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    [[cell textLabel] setText:[boatAtIndex displayName]];
    [[cell detailTextLabel] setText:[boatAtIndex displaySubtitle]];
    
    // boatType is one of: Yacht, RC, Mark, Umpire, Marshall, Pin
    NSString *boatType = boatAtIndex.boatType;
    NSString *iconName = @"unknown-icon";
    if ([boatType isEqualToString:@"Yacht"])
        iconName = @"yacht-icon";
    else if ([boatType isEqualToString:@"RC"])
        iconName = @"umpire-icon";  // XXX
    else if ([boatType isEqualToString:@"Mark"])
        iconName = @"mark-icon";
    else if ([boatType isEqualToString:@"Umpire"])
        iconName = @"umpire-icon";
    else if ([boatType isEqualToString:@"Marshall"])
        iconName = @"umpire-icon";  // XXX
    else if ([boatType isEqualToString:@"Pin"])
        iconName = @"mark-icon";    // XXX
    
    // XXX Cache these paths?
    NSString *path = [[NSBundle mainBundle] pathForResource:iconName ofType:@"png"];
    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    cell.imageView.image = theImage;
    
    return cell;
}


/*
 * AC34StreamDelegate functions.
*/
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
    //XXX
    //self.chatterTextView.text = [old stringByAppendingString:new];
}

- (void) locationUpdateFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withLoc:(AC34BoatLocation *)loc {
    // Quick hack to get this data displayed on screen
    NSString *chatter = [NSString stringWithFormat:@"Location update"];
    [self chatterFrom:sourceId at:timeStamp withType:kInternalChatter withChatter:chatter];
    
    AC34Boat *b = [self.dataController boatForSourceId:sourceId];
    if (b == nil) {
        NSLog(@"Position update from unknown source %lu at %@", sourceId, timeStamp);
        return;
    }
    
    b.lastLocUpdateAt = timeStamp;
    b.lastLocation = loc;
    
    // XXX redraw display now!
}

- (void) xmlFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
     withXmlType:(UInt32) xmlType withXmlTimeStamp:(NSDate *) xmlTimeStamp
         withSeq:(UInt32) sequenceNum withAck:(UInt32) ack withData:(NSData *) xml {
    
    NSError *error;
    SMXMLDocument *doc;
    
    self.chatterTextView.text = [[NSString alloc] initWithData:xml encoding:NSUTF8StringEncoding];
    
    doc = [SMXMLDocument documentWithData:xml error:&error];
    if (error) {
        NSLog(@"Error parsing XML message type %lu from %lu: %@", xmlType, sourceId, error);
        return;
    }
    
    switch (xmlType) {
        case kRegattaXml:
            [self handleRegattaXmlFrom:sourceId at:timeStamp withXmlTimeStamp:xmlTimeStamp withSeq:sequenceNum withAck:ack withDoc:doc];
        case kRaceXml:
            [self handleRaceXmlFrom:sourceId at:timeStamp withXmlTimeStamp:xmlTimeStamp withSeq:sequenceNum withAck:ack withDoc:doc];
            break;
        case kBoatXml:
            [self handleBoatXmlFrom:sourceId at:timeStamp withXmlTimeStamp:xmlTimeStamp withSeq:sequenceNum withAck:ack withDoc:doc];
            break;
        default:
            NSLog(@"Unknown XML message type %lu from %lu", xmlType, sourceId);
            return;
    }
}


- (NSArray *) shapeFromXml:(SMXMLElement *) elem {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (SMXMLElement *vtx in [elem childrenNamed:@"Vtx"]) {
        // Hack: use point3d, put seq into z, and sort by z.
        AC34Point3D *p = [[AC34Point3D alloc] init];
        p.z = [[vtx attributeNamed:@"Seq"] intValue];
        p.x = [[vtx attributeNamed:@"X"] floatValue];
        p.y = [[vtx attributeNamed:@"Y"] floatValue];
        [arr addObject:p];
    }
    
    // Sort by seq, and extract the 2-D parts
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"z" ascending:true];
    NSArray *sorters = [[NSArray alloc] initWithObjects:sorter, nil];
    [arr sortUsingDescriptors:sorters];
    
    NSMutableArray *newArr = [NSMutableArray arrayWithCapacity:[arr count]];
    for (AC34Point3D *p in arr)
        [newArr addObject:[p point2D]];
    return newArr;
}

- (void) handleBoatXmlFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withXmlTimeStamp:(NSDate *) xmlTimeStamp
        withSeq:(UInt32) sequenceNum withAck:(UInt32) ack withDoc:(SMXMLDocument *)doc {
   
    // N.B. Treat shape IDs as strings, don't bother converting to integers.
    
    // shape ID -> AC34Point2D of points
    NSMutableDictionary *outlines = [[NSMutableDictionary alloc] init]; 
    
    // shape ID -> Dictionary of part name -> AC34Point2D of points
    NSMutableDictionary *hullParts = [[NSMutableDictionary alloc] init];
  
    // 1. Get all the boat shapes
    SMXMLElement *boatShapes = [doc.root childNamed:@"BoatShapes"];
    for (SMXMLElement *boatShape in [boatShapes childrenNamed:@"BoatShape"]) {
        NSString *shapeId = [boatShape attributeNamed:@"ShapeID"];
        for (SMXMLElement *child in [boatShape children]) {
            NSArray *shape = [self shapeFromXml:child];
            NSString *shapeName = [child name];
            if ([shapeName compare:@"Vertices"] == NSOrderedSame) {
                [outlines setValue:shape forKey:shapeId];   
            }
            else {
                NSMutableDictionary *parts = [hullParts valueForKey:shapeId];
                if (parts == nil) {
                    parts = [[NSMutableDictionary alloc] init];
                    [hullParts setValue:parts forKey:shapeId];
                }
                [parts setValue:shape forKey:shapeName];
            }
        }
    }
    
    // 2. Get the boats, and setup each boat with its shapes and other properties.
    SMXMLElement *boats = [doc.root childNamed:@"Boats"];
    for (SMXMLElement *boat in [boats childrenNamed:@"Boat"]) {
        NSString *boatType = [boat attributeNamed:@"Type"];
        NSString *boatIdStr = [boat attributeNamed:@"SourceID"]; 
        UInt32 boatId = [boatIdStr integerValue]; 
        NSString *shapeId = [boat attributeNamed:@"ShapeID"]; 
        NSString *hullNum = [boat attributeNamed:@"HullNum"]; 
        NSString *boatName = [boat attributeNamed:@"BoatName"]; 
        NSString *skipper = [boat attributeNamed:@"Skipper"]; 
        NSString *country = [boat attributeNamed:@"Country"]; 
        NSLog(@"BOAT %@ skipper %@ country %@ type %@ id %lu hull %@ shape %@", boatName, skipper, country, boatType, boatId, hullNum, shapeId);

        AC34Boat *b = [[AC34Boat alloc] initWithName:hullNum];
        b.sourceId = boatId;
        b.boatType = boatType;
        b.boatName = boatName;
        b.skipper = skipper;
        b.country = country;
        b.hullNum = hullNum;
        b.hullOutline = [outlines objectForKey:shapeId];
        b.hullShapes = [hullParts objectForKey:shapeId];

        // GPS position?
        // Flag position?
        
        [self.dataController addBoat:b];
    }

    // Tell the boat display tables to refresh.
    [self.tableView reloadData];
}

- (void) handleRaceXmlFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withXmlTimeStamp:(NSDate *) xmlTimeStamp
        withSeq:(UInt32) sequenceNum withAck:(UInt32) ack withDoc:(SMXMLDocument *)doc {
    
}

- (void) handleRegattaXmlFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
        withXmlTimeStamp:(NSDate *) xmlTimeStamp
        withSeq:(UInt32) sequenceNum withAck:(UInt32) ack withDoc:(SMXMLDocument *)doc {
    
}


@end
