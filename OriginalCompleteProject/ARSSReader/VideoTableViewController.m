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
    @property NSURL             *feedURL;
    @property UIRefreshControl  *refreshControl;
@end


@implementation VideoTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];

    // Set up the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    [self.tableView addSubview:self.refreshControl];
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
        NSLog(@"Got index: %@",responseString);
        
        [self.videos removeAllObjects];
        
        for (id article in nodes) {
            v = [[Video alloc] init];
            v.title   = [article objectForKey:@"data-title"];
            v.url     = [article objectForKey:@"data-slug"];
            v.source  = [article objectForKey:@"data-source"];
            v.pubDate = [article objectForKey:@"data-pubDate"];
            
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

- (NSMutableArray *) getStaticVideos {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:10];
    Video *v;
    
    if ([App inAlternateReality]) {
        v = [[Video alloc] init];
        v.title     = @"Light Industry Exhibition";
        v.source    = @"Korean Central News Agency / DPR of Korea";
        v.url       = @"http://BestKoreaApp.com/media/video/light-industry.html";
        v.pubDate   = @"2013-03-25";
        [result addObject:v];
        
        v = [[Video alloc] init];
        v.title     = @"DPRK People Reject UN \"Resolution on Sanctions\"";
        v.source    = @"Korean Central News Agency / DPR of Korea";
        v.url       = @"http://BestKoreaApp.com/media/video/people-reject.html";
        v.pubDate   = @"2013-03-11";
        [result addObject:v];

        v = [[Video alloc] init];
        v.title     = @"Life in the People's Paradise of DPRK";
        v.source    = @"DPRK";
        v.url       = @"http://BestKoreaApp.com/media/video/peoples-paradise.html";
        v.pubDate   = @"2010-10";
        [result addObject:v];
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
    [App toggleRealityFor: self];
}


- (void)updateForNewReality {
    self.feedURL = [NSURL URLWithString:
               [App inAlternateReality] ? @"TODO" : @"TODO"];
    
    // Clear the table
    [self.videos removeAllObjects];
    [self.tableView reloadData];
    
    // Read from the new datasource.
    [self refreshFeed];
}


@end
