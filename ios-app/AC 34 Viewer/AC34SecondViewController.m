//
//  AC34SecondViewController.m
//  AC 34 Viewer
//
//  Created by Douglas De Couto on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AC34SecondViewController.h"
#import "AC34BoatDataController.h"
#import "AC34Boat.h"

@implementation AC34SecondViewController

@synthesize dataController = _dataController;

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

// Table view delegate code.
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataController countOfList];
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

@end
