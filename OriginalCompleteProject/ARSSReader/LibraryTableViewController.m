//
//  LibraryTableViewController.m
//  bestkorea
//
//  Created by Robb Shecter on 4/11/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "LibraryTableViewController.h"

@interface LibraryTableViewController ()
{
    NSArray *items;
}
@end


@implementation LibraryTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    items = @[@"Maps"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [App setMyTitle:self.navigationItem andFont:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"libraryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Reality Update Listener

- (void)updateForNewReality {
    // So far, not much to do.
}

@end
