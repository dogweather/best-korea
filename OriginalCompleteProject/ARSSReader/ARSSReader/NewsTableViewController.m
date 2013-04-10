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
    NSURL   *feedURL;
    UIView  *normalCellBg;
    UIView  *alternateCellBg;
    NSArray *sections;
}
@end


@implementation NewsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // News feed
    feedURL = [NSURL URLWithString:[App inAlternateReality] ? ALTERNATE_NEWS_FEED : REALITY_NEWS_FEED];
    [self refreshFeedWithActivityDisplay:YES];
    
    alternateCellBg = [[UIView alloc] init];
    alternateCellBg.backgroundColor = [UIColor colorWithRed:(137/255.0) green:(23/255.0) blue:(15/255.0) alpha:1];
    
    normalCellBg = [[UIView alloc] init];
    normalCellBg.backgroundColor = [UIColor colorWithRed:(17/255.0) green:(118/255.0) blue:(223/255.0) alpha:1];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [App setMyTitle:self.navigationItem andFont:self];
}


-(void) refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self refreshFeedWithActivityDisplay:NO];
}


-(void)refreshFeedWithActivityDisplay:(BOOL)useHud
{
    if (useHud)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RSSLoader* rssLoader = [[RSSLoader alloc] init];
    
    [rssLoader fetchRssWithURL:feedURL
                complete:^(NSArray *results) {

                    // completed fetching the RSS
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _objects = results;
                        [self createSectionsWith:_objects];
                        [self.tableView reloadData];
                        
                        // Stop the refresh control
                        [self.refreshControl endRefreshing];
                        if (useHud)
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        // Add the "refresh control" if needed
                        if (self.refreshControl == nil) {
                            self.refreshControl = [[UIRefreshControl alloc] init];
                            [self.refreshControl addTarget:self
                                                    action:@selector(refreshInvoked:forState:)
                                          forControlEvents:UIControlEventValueChanged];
                            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"
                                                                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
                        }
                    });
                }];
}


-(void)createSectionsWith:(NSArray *)rssItems {
    // The table sections data structure
    sections = @[
                 [NSMutableDictionary dictionaryWithObjects:@[@"Today",     [NSMutableArray arrayWithCapacity:30]] forKeys:@[@"title", @"items"]],
                 [NSMutableDictionary dictionaryWithObjects:@[@"Yesterday", [NSMutableArray arrayWithCapacity:30]] forKeys:@[@"title", @"items"]],
                 [NSMutableDictionary dictionaryWithObjects:@[@"Earlier",   [NSMutableArray arrayWithCapacity:30]] forKeys:@[@"title", @"items"]]
                 ];
    
    for(RSSItem *i in rssItems) {
        if ([i isFromToday]) {
            [[[sections objectAtIndex:0] objectForKey:@"items"] addObject:i];
        } else if ([i isFromYesterday]) {
            [[[sections objectAtIndex:1] objectForKey:@"items"] addObject:i];
        } else {
            [[[sections objectAtIndex:2] objectForKey:@"items"] addObject:i];
        }
    }
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sections.count;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[sections objectAtIndex:section] objectForKey:@"title"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[sections objectAtIndex:section] objectForKey:@"items"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [App inAlternateReality] ? alternateCellBg : normalCellBg;

    RSSItem *rss = [[[sections objectAtIndex:indexPath.section] objectForKey:@"items"] objectAtIndex:indexPath.row];
    cell.textLabel.textColor  = [[App appDelegate] wasSeen:[rss.resolvedUrl absoluteString]] ? [UIColor grayColor] : [UIColor blackColor];
    cell.textLabel.text       = rss.title;
    cell.detailTextLabel.text = [[rss.publication stringByAppendingString:@", "] stringByAppendingString:rss.shortRelativeTime];
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
            int imageNumber      = (([rss.link hash] / 10) % [App appDelegate].party_placeholders) + 1;
            NSString *imageName  = [NSString stringWithFormat:@"square-placeholder-%d.jpg", imageNumber];
            cell.imageView.image = [UIImage imageNamed:imageName];
        } else {
            cell.imageView.image = nil;
        }
        return cell;
    }
    
    // Load the image from the network:
    // It wasn't cached, and we do have a url.
    NSLog(@"Loading an image: %@", url);
    NSURL *imageURL = [NSURL URLWithString:url];
    cell.imageView.image = [UIImage imageNamed:@"white-square.jpg"];
    
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

        // This item has now been seen. This needs a delay because otherwise
        // it interferes with the custom cell selection background.
        [[App appDelegate] markAsSeen:[rss.resolvedUrl absoluteString]];
        [self performSelector:@selector(reloadCurrentRow) withObject:nil afterDelay:1.0];
    }
}


-(void)reloadCurrentRow {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}


- (void)updateForNewReality {
    feedURL = [NSURL URLWithString:
               [App inAlternateReality] ? ALTERNATE_NEWS_FEED : REALITY_NEWS_FEED];
    
    // Clear the table
    _objects = @[];
    [self.tableView reloadData];
    
    // Read from the new datasource.
    [self refreshFeedWithActivityDisplay:YES];
}


- (IBAction)togglePartyMode:(id)sender {
    [App toggleRealityFor:self];
}
@end
