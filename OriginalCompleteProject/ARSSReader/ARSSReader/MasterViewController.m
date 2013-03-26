//
//  MasterViewController.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "App.h"
#import "Constants.h"

#import "RSSLoader.h"
#import "RSSItem.h"
#import "TFHpple.h"


@interface MasterViewController ()
{
    NSArray *_objects;
    NSURL* feedURL;
    UIRefreshControl* refreshControl;
}
@end


@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the refresh control
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    [self.tableView addSubview:refreshControl];

    // Set up the news feed
    self.icon_index = 1;
    feedURL = [NSURL URLWithString:[App inAlternateReality] ? ALTERNATE_NEWS_FEED : REALITY_NEWS_FEED];
    [self refreshFeed];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [App setMyTitle:self.navigationItem andFont:self];
}





-(void) refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self refreshFeed];
}

-(void)refreshFeed
{
    RSSLoader* rssLoader = [[RSSLoader alloc] init];
    
    [rssLoader fetchRssWithURL:feedURL
                complete:^(NSString *title, NSArray *results) {

                    //completed fetching the RSS
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _objects = results;
                        [self.tableView reloadData];
                        
                        // Stop refresh control
                        [refreshControl endRefreshing];
                    });
                }];
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    RSSItem *rss = _objects[indexPath.row];
    cell.textLabel.text       = rss.title;
    cell.detailTextLabel.text = rss.publication;
    if (rss.image != nil) {
        NSLog(@"Reading image from the cache");
        cell.imageView.image = rss.image;
        return cell;
    }
    
    
    NSString *url = rss.imageUrl;
    
    // No image url in the RSS? Then either
    // * Leave blank (Reality), or
    // * Put in a placeholder (Alternate Reality)
    if (url == nil) {
        if ([App inAlternateReality]) {
            NSString *placeholder_icon = [NSString stringWithFormat:@"icon%d.png", self.icon_index];
            cell.imageView.image = [UIImage imageNamed:placeholder_icon];
            self.icon_index++;
            if (self.icon_index > ICON_COUNT) {
                self.icon_index = 1;
            }
        } else {
            cell.imageView.image = nil;
        }
        return cell;
    }
    
    // Load the image from the network:
    // It wasn't cached, and we do have a url.
    NSLog(@"Loading an image: %@", url);
    NSURL *imageURL = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        rss.image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            cell.imageView.image = rss.image;
        });
    });
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSSItem *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}


- (void)updateForNewReality {
    feedURL = [NSURL URLWithString:
               [App inAlternateReality] ? ALTERNATE_NEWS_FEED : REALITY_NEWS_FEED];
    
    // Clear the table
    _objects = @[];
    [self.tableView reloadData];
    
    // Read from the new datasource.
    [self refreshFeed];
}


- (IBAction)togglePartyMode:(id)sender {
    [App toggleRealityFor:self];
    [self updateForNewReality];
}
@end
