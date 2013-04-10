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
#import "Constants.h"
#import "TFHpple.h"


@interface VideoTableViewController ()
    @property NSMutableArray    *videos;
    @property UIRefreshControl  *refreshControl;
    @property UIView  *normalCellBg;
    @property UIView  *alternateCellBg;
@end




@implementation VideoTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _alternateCellBg = [[UIView alloc] init];
    _alternateCellBg.backgroundColor = [UIColor colorWithRed:(137/255.0) green:(23/255.0) blue:(15/255.0) alpha:1];
    
    _normalCellBg = [[UIView alloc] init];
    _normalCellBg.backgroundColor = [UIColor colorWithRed:(17/255.0) green:(118/255.0) blue:(223/255.0) alpha:1];


    // Set up the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    self.videos = [NSMutableArray arrayWithCapacity:10];
    [self refreshFeed];
}


-(void) refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self refreshFeed];
}

- (void) refreshFeed {
    [self getVideos];
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
        detailViewController.video = video;
        [[App appDelegate] markAsSeen:video.url];
        [self performSelector:@selector(reloadCurrentRow) withObject:nil afterDelay:1.0];
    }
}


-(void)reloadCurrentRow {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
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
    cell.textLabel.textColor  = [[App appDelegate] wasSeen:video.url] ? [UIColor grayColor] : [UIColor blackColor];
    cell.textLabel.text= video.title;
    cell.detailTextLabel.text = video.source;
    cell.selectedBackgroundView = [App inAlternateReality] ? _alternateCellBg : _normalCellBg;

   
    if (video.image == nil) {
        NSURL *imageURL = [NSURL URLWithString:video.imageUrl];
        cell.imageView.image = [UIImage imageNamed:@"white-video.jpg"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            video.image = [UIImage imageWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                cell.imageView.image = video.image;
            });
        });
    } else {
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
- (void) getVideos {
    NSString *filename = [App inAlternateReality] ? @"alternate.html" : @"reality.html";
    NSString *url      = [@"http://bestkoreaapp.com/media/video/index-" stringByAppendingString:filename];
    NSURL *indexUrl    = [NSURL URLWithString:url];
    NSURLRequest *req  = [NSURLRequest requestWithURL:indexUrl];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // Background Task:
        // Load and parse the html into Video objects
        Video *v;
        NSURLResponse* response = nil;
        NSData *data    = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:nil];
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        TFHpple *parser = [TFHpple hppleWithHTMLData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
        NSArray *nodes  = [parser searchWithXPathQuery:@"//article"];
        
        [self.videos removeAllObjects];
        
        for (id article in nodes) {
            v = [[Video alloc] init];
            v.title    = [article objectForKey:@"data-title"];
            v.url      = [article objectForKey:@"data-slug"];
            v.source   = [article objectForKey:@"data-source"];
            v.pubDate  = [article objectForKey:@"data-pubdate"];
            v.shareUrl = [article objectForKey:@"data-shareurl"];

            v.url = [@"http://bestkoreaapp.com/media/video/" stringByAppendingString:v.url];
            v.url = [v.url stringByAppendingString:@".html"];
            [self.videos addObject:v];
        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
}


- (IBAction)togglePartyMode:(id)sender {
    [App toggleRealityFor: self];
}


- (void)updateForNewReality {
    // Clear the table
    [self.videos removeAllObjects];
    [self.tableView reloadData];
    
    // Read from the new datasource.
    [self refreshFeed];
}


@end
