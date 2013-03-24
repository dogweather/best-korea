//
//  MasterViewController.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

#import "TableHeaderView.h"

#import "RSSLoader.h"
#import "RSSItem.h"

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
    
    self.icon_index = 1;
    feedURL = [NSURL URLWithString:@"https://news.google.com/news/feeds?hl=en&gl=us&q=north+korea&um=1&ie=UTF-8&output=rss"];
    
    //add refresh control to the table view
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    
    NSString* fetchMessage = [NSString stringWithFormat:@"Refresh"];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    [self.tableView addSubview: refreshControl];
    [self refreshFeed];
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app setMyTitle:self.navigationItem];
}





-(void) refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self refreshFeed];
}

-(void)refreshFeed
{
    RSSLoader* rss = [[RSSLoader alloc] init];
    [rss fetchRssWithURL:feedURL
                complete:^(NSString *title, NSArray *results) {

                    //completed fetching the RSS
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //UI code on the main queue
                        [(TableHeaderView*)self.tableView.tableHeaderView setText:title];
                        
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
    NSString *placeholder_icon = [NSString stringWithFormat:@"icon%d.png", self.icon_index];
    
    RSSItem *object = _objects[indexPath.row];
    cell.textLabel.text         = object.title;
    cell.detailTextLabel.text   = object.publication;
    cell.imageView.image        = [UIImage imageNamed:placeholder_icon];
    self.icon_index++;
    if (self.icon_index > ICON_COUNT) {
        self.icon_index = 1;
    }
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

- (IBAction)togglePartyMode:(UIBarButtonItem *)sender {
    NSLog(@"togglePartyMode");
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app toggleRealityFor: self];
}

@end
