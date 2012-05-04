//
//  AC34SecondViewController.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AC34StreamDelegate.h"

@class AC34BoatDataController;
@class SMXMLDocument;

@interface AC34SecondViewController : UIViewController <UITableViewDelegate, UITextViewDelegate, AC34StreamDelegate>

@property (nonatomic, retain) AC34BoatDataController *dataController;
@property (weak, nonatomic) IBOutlet UITextView *chatterTextView;
@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


// Internal functions.

- (void) handleBoatXmlFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
    withXmlTimeStamp:(NSDate *) xmlTimeStamp
    withSeq:(UInt32) sequenceNum withAck:(UInt32) ack withDoc:(SMXMLDocument *)doc;

- (void) handleRaceXmlFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
    withXmlTimeStamp:(NSDate *) xmlTimeStamp
    withSeq:(UInt32) sequenceNum withAck:(UInt32) ack withDoc:(SMXMLDocument *)doc;

- (void) handleRegattaXmlFrom:(UInt32) sourceId at:(NSDate *) timeStamp 
    withXmlTimeStamp:(NSDate *) xmlTimeStamp
    withSeq:(UInt32) sequenceNum withAck:(UInt32) ack withDoc:(SMXMLDocument *)doc;

@end
