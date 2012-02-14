//
//  AC34ThirdViewController.h
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AC34ThirdViewController : UIViewController <UITextFieldDelegate>
{
//    NSString *userName; // Why is this even here?
    
}
- (IBAction)clickMe:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *theLabel;
@property (nonatomic, copy) NSString *userName;

@end
