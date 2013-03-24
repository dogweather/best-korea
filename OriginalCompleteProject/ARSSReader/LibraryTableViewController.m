//
//  LibraryTableViewController.m
//  bestkorea
//
//  Created by Robb Shecter on 3/24/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "LibraryTableViewController.h"
#import "AppDelegate.h"

@interface LibraryTableViewController ()

@end

@implementation LibraryTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    // TODO: Set up the table data
}


- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app setMyLookAndFeel:self];
    [app setMyTitle:self];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}


@end
