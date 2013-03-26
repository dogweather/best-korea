//
//  VideoTableViewController.m
//  bestkorea
//
//  Created by Robb Shecter on 3/21/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "VideoTableViewController.h"
#import "VideoDetailViewController.h"
#import "Video.h"
#import "App.h"

@interface VideoTableViewController ()
@end


@implementation VideoTableViewController


- (void) viewDidLoad
{
    [super viewDidLoad];
    self.videos = [self getVideos];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [App setMyTitle:self.navigationItem andFont:self];
}



- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    NSIndexPath *indexPath;
    VideoDetailViewController *detailViewController;
    Video *video;
    
    if ([[segue identifier] isEqualToString:@"videoCellPressed"]) {
        indexPath = [self.tableView indexPathForSelectedRow];
        detailViewController = [segue destinationViewController];
        video = self.videos[indexPath.row];
        detailViewController.url = video.url;
    }
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Video *video = self.videos[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aVideoCell" forIndexPath:indexPath];
    cell.textLabel.text= video.title;
    cell.detailTextLabel.text = video.source;
   
    if (video.image == nil) {
        NSLog(@"Loading an image: %@", video.imageUrl);
        NSURL *imageURL         = [NSURL URLWithString:video.imageUrl];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            video.image = [UIImage imageWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                cell.imageView.image = video.image;
            });
        });
    } else {
        NSLog(@"Reading image from the cache");
        cell.imageView.image = video.image;
    }
    
    return cell;
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



// Return the list of Video objects that I should display.
// This includes Videos retrieved from online indexes,
// hardcoded values, as well as cached values.
//
// TODO: Refactor this into a library data access layer. It can be
//       used across all the News apps.
- (NSMutableArray *) getVideos {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:10];
    Video *v;
    
    if ([App inAlternateReality]) {
        // No videos yet!
    } else {
        v = [[Video alloc] init];
        v.title     = @"North Korea Threatens US Airbases in Japan";
        v.source    = @"The Guardian";
        v.url       = @"http://BestKoreaApp.com/media/video/guardian-nk-threatens-us-airbases.html";
        v.pubDate   = @"2013-03-21";
        [result addObject:v];
        
        v = [[Video alloc] init];
        v.title     = @"Dennis Rodman 'This Week' Interview";
        v.source    = @"ABC News";
        v.url       = @"http://BestKoreaApp.com/media/video/dennis-rodman-this-week-interview.html";
        v.pubDate   = @"2013-03-03";
        [result addObject:v];
        
        v = [[Video alloc] init];
        v.title     = @"My Escape from North Korea";
        v.source    = @"TED";
        v.url       = @"http://BestKoreaApp.com/media/video/hyeonseo_lee_my_escape_from_north_korea.html";
        v.pubDate   = @"2013-02";
        [result addObject:v];
        
        v = [[Video alloc] init];
        v.title     = @"Why the World Needs Charter Cities";
        v.source    = @"TED";
        v.url       = @"http://BestKoreaApp.com/media/video/paul-romer-why-the-world-needs-charter-cities.html";
        v.pubDate   = @"2007-07";
        [result addObject:v];
    }
    
    return result;
}


- (IBAction)togglePartyMode:(id)sender {
    NSLog(@"togglePartyMode");
    [App toggleRealityFor: self];
}


- (void) updateForNewReality {
    // TODO: implement.
}


@end
