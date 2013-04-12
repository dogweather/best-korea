//
//  MapCollectionViewController.m
//  bestkorea
//
//  Created by Robb Shecter on 4/11/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "MapCollectionViewController.h"

@interface MapCollectionViewController ()
{
    NSArray *mapNames;
}
@end

@implementation MapCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [App inAlternateReality] ? @"MAPS" : @"Maps";
    mapNames = @[
                 @"1969 DMZ",
                 @"2005 Admin. Divisions",
                 @"2006 Free Trade Zones",
                 @"2010 S. Pop. Density",
                 @"2011 Peninsula",
                 @"2012 Asia"
                 ];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return mapNames.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"mapCell";
    NSString *filename;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    
    UIImageView *mapImageView = (UIImageView *)[cell viewWithTag:100];
    
    filename = [[mapNames objectAtIndex:indexPath.row] stringByAppendingString:@" thumbnail.jpg"];
    mapImageView.image = [UIImage imageNamed:filename];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
    MapViewController *destViewController = segue.destinationViewController;
    NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
    destViewController.title        = [mapNames objectAtIndex:indexPath.row];
    destViewController.mapFileName  = [[mapNames objectAtIndex:indexPath.row] stringByAppendingString:@".jpg"];
    NSLog(@"Found filename: %@",destViewController.mapFileName);
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO: (How?)
    // Dispose of any resources that can be recreated.
}

@end
