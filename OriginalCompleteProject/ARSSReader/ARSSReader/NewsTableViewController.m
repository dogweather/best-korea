//
//  NewsTableViewController.m
//

#import "NewsTableViewController.h"
#import "NewsDetailViewController.h"
#import "App.h"
#import "Constants.h"

#import "RSSLoader.h"
#import "RSSItem.h"
#import "TFHpple.h"
#import "MBProgressHUD.h"


@interface NewsTableViewController ()
{
    NSArray *_objects;
    NSURL* feedURL;
}
@end


@implementation NewsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // The "refresh control"
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshInvoked:forState:)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];

    // News feed
    self.icon_index = 1;
    feedURL = [NSURL URLWithString:[App inAlternateReality] ? ALTERNATE_NEWS_FEED : REALITY_NEWS_FEED];
    [self refreshFeedwithActivityDisplay:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [App setMyTitle:self.navigationItem andFont:self];
}


-(void) refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self refreshFeedwithActivityDisplay:NO];
}


-(void)refreshFeedwithActivityDisplay:(BOOL)useHud
{
    if (useHud)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RSSLoader* rssLoader = [[RSSLoader alloc] init];
    
    [rssLoader fetchRssWithURL:feedURL
                complete:^(NSArray *results) {

                    // completed fetching the RSS
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _objects = results;
                        [self.tableView reloadData];
                        
                        // Stop the refresh control
                        [self.refreshControl endRefreshing];
                        if (useHud)
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    cell.textLabel.textColor  = [[App appDelegate] wasSeen:[rss.resolvedUrl absoluteString]] ? [UIColor grayColor] : [UIColor blackColor];
    cell.textLabel.text       = rss.title;
    cell.detailTextLabel.text = rss.publication;
    if (rss.image != nil) {
        cell.imageView.image = rss.image;
        return cell;
    }
    
    
    NSString *url = rss.imageUrl;
    
    // No image url in the RSS? Then either
    // * Leave blank (Reality), or
    // * Put in a placeholder (Alternate Reality)
    if (url == nil) {
        if ([App inAlternateReality]) {
            NSString *placeholder_icon = [NSString stringWithFormat:@"square-placeholder-%d.jpg", self.icon_index];
            cell.imageView.image = [UIImage imageNamed:placeholder_icon];
            self.icon_index++;
            if (self.icon_index > ALTERNATE_PLACEHOLDER_ICONS) {
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
        RSSItem *rss = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:rss];

        // This item has now been seen.
        [[App appDelegate] markAsSeen:[rss.resolvedUrl absoluteString]];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:false];
    }
}


- (void)updateForNewReality {
    feedURL = [NSURL URLWithString:
               [App inAlternateReality] ? ALTERNATE_NEWS_FEED : REALITY_NEWS_FEED];
    
    // Clear the table
    _objects = @[];
    [self.tableView reloadData];
    
    // Read from the new datasource.
    [self refreshFeedwithActivityDisplay:NO];
}


- (IBAction)togglePartyMode:(id)sender {
    [App toggleRealityFor:self];
}
@end
