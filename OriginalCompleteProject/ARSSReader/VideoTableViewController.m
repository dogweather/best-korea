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

@interface VideoTableViewController ()
@end


@implementation VideoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    Video *video;
    self.videos = [NSMutableArray arrayWithCapacity:2];

    video = [[Video alloc] init];
    video.title     = @"Dennis Rodman 'This Week' Interview";
    video.source    = @"ABC News";
    video.url       = @"http://BestKoreaApp.com/media/video/dennis-rodman-this-week-interview.html";
    video.pubDate   = @"2013-03-03";
    [self.videos addObject:video];

    video = [[Video alloc] init];
    video.title     = @"My Escape from North Korea";
    video.source    = @"TED";
    video.url       = @"http://BestKoreaApp.com/media/video/hyeonseo_lee_my_escape_from_north_korea.html";
    video.pubDate   = @"2013-02";
    [self.videos addObject:video];

    video = [[Video alloc] init];
    video.title     = @"Why the World Needs Charter Cities";
    video.source    = @"TED";
    video.url       = @"http://BestKoreaApp.com/media/video/paul-romer-why-the-world-needs-charter-cities.html";
    video.pubDate   = @"2007-07";
    [self.videos addObject:video];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
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
   
    NSLog(@"Loading an image");
    NSURL *imageURL         = [NSURL URLWithString:video.imageUrl];
//    NSData *imageData       = [NSData dataWithContentsOfURL:imageURL];
//    cell.imageView.image    = [UIImage imageWithData:imageData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            cell.imageView.image    = [UIImage imageWithData:imageData];
        });
    });
    
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





@end
