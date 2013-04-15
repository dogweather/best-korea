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
@property UIView  *normalCellBg;
@property UIView  *alternateCellBg;

@end


@implementation LibraryTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    items = @[@"Maps"];
    _alternateCellBg = [[UIView alloc] init];
    _alternateCellBg.backgroundColor = [UIColor colorWithRed:(137/255.0) green:(23/255.0) blue:(15/255.0) alpha:1];
    
    _normalCellBg = [[UIView alloc] init];
    _normalCellBg.backgroundColor = [UIColor colorWithRed:(17/255.0) green:(118/255.0) blue:(223/255.0) alpha:1];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [App setMyTitle:self.navigationItem andFont:self];
    self.tableView.backgroundColor = [App colorForTableCellBg];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [App colorForTableCellBg];
    self.tableView.backgroundColor = [App colorForTableCellBg];
}


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
    
    cell.textLabel.textColor       = [App colorForTitle];
    cell.selectedBackgroundView    = [App inAlternateReality] ? _alternateCellBg : _normalCellBg;

    
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Reality Update Listener

- (void)updateForNewReality {
    // So far, not much to do.
}

- (IBAction)togglePartyMode:(id)sender {
    [App toggleRealityFor: self];
}
@end
