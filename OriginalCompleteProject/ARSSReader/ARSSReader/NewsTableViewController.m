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
    NSMutableArray *sections;
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
    
    [self.tableView setSeparatorColor:[App colorForTableSeparator]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [App setMyTitle:self.navigationItem andFont:self];
    [self.tableView setSeparatorColor:[App colorForTableSeparator]];
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
                        if ([_objects count] == 0) {
                            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network is unavailable"
                                                                              message:@"Cannot connect to the Internet to retrieve news items."
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                            [message show];
                        }
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
    sections = [NSMutableArray arrayWithCapacity:3];
    NSArray *potentialSections =
                @[
                 [NSMutableDictionary dictionaryWithObjects:@[@"Today",     [NSMutableArray arrayWithCapacity:30]] forKeys:@[@"title", @"items"]],
                 [NSMutableDictionary dictionaryWithObjects:@[@"Yesterday", [NSMutableArray arrayWithCapacity:30]] forKeys:@[@"title", @"items"]],
                 [NSMutableDictionary dictionaryWithObjects:@[@"Earlier",   [NSMutableArray arrayWithCapacity:30]] forKeys:@[@"title", @"items"]]
                 ];
    
    // Add pointers to the rss items
    for(RSSItem *i in rssItems) {
        if ([i isFromToday]) {
            [[[potentialSections objectAtIndex:0] objectForKey:@"items"] addObject:i];
        } else if ([i isFromYesterday]) {
            [[[potentialSections objectAtIndex:1] objectForKey:@"items"] addObject:i];
        } else {
            [[[potentialSections objectAtIndex:2] objectForKey:@"items"] addObject:i];
        }
    }
    
    // Add non-empty sections
    for (NSMutableDictionary *d in potentialSections) {
        if ([[d objectForKey:@"items"] count] > 0)
            [sections addObject:d];
    }
}



#pragma mark - Table View

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    if ([App inAlternateReality]) {
        [headerView setBackgroundColor:alternateCellBg.backgroundColor];
    } else {
        [headerView setBackgroundColor:[UIColor darkGrayColor]];
    }
    headerView.opaque = NO;
    headerView.alpha = 0.9f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width - 10, 22)];
    label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    label.textColor             = [UIColor whiteColor];
    label.backgroundColor       = [UIColor clearColor];
    label.shadowColor           = [UIColor blackColor];
    if ([App inAlternateReality]) {
        label.font = [UIFont fontWithName:ALTERNATE_NAVBAR_FONT size:17.0f];
    } else {
        label.font = [UIFont fontWithName:REALITY_NAVBAR_FONT size:17.0f];
    }
    label.opaque                = YES;
    label.shadowOffset          = CGSizeMake(0,1);
    label.layer.masksToBounds   = NO;
    [headerView addSubview:label];
    return headerView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sections.count;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([App inAlternateReality])
        return [[[sections objectAtIndex:section] objectForKey:@"title"] uppercaseString];
    else
        return [[sections objectAtIndex:section] objectForKey:@"title"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[sections objectAtIndex:section] objectForKey:@"items"] count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // This needs to happen here in order to set the background
    // color of the disclosure indicator.
    cell.backgroundColor = [App colorForTableCellBg];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    RSSItem *rss          = [[[sections objectAtIndex:indexPath.section] objectForKey:@"items"] objectAtIndex:indexPath.row];

    // Some of the L&F setup needs to happen at this point.
    cell.selectedBackgroundView     = [App inAlternateReality] ? alternateCellBg : normalCellBg;
    cell.detailTextLabel.textColor  = [App colorForSubTitleOfResource:[rss.resolvedUrl absoluteString]];
    cell.textLabel.textColor        = [App colorForTitleOfResource:[rss.resolvedUrl absoluteString]];
    
    // The cell's content
    cell.textLabel.text       = rss.title;
    cell.detailTextLabel.text = [[rss.publication stringByAppendingString:@", "] stringByAppendingString:rss.shortRelativeTime];
    
    // TODO: Refactor & cleanup this image logic.
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
        RSSItem *rss = [[[sections objectAtIndex:indexPath.section] objectForKey:@"items"] objectAtIndex:indexPath.row];
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
    NSLog(@"Clearing the table");
    _objects = @[];
    [self createSectionsWith:_objects];
    [self.tableView reloadData];
    
    // Read from the new datasource.
    NSLog(@"Launching the refresh thread");
    [self refreshFeedWithActivityDisplay:YES];
}


- (IBAction)togglePartyMode:(id)sender {
    [App toggleRealityFor:self];
}
@end
