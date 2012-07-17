//
//  AC34SecondViewController.h
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
