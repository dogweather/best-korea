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
#import "MBProgressHUD.h"


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
    
    // Refresh control
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh"
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    [self.tableView addSubview:refreshControl];

    // News feed
    self.icon_index = 1;
    feedURL = [NSURL URLWithString:[App inAlternateReality] ? ALTERNATE_NEWS_FEED : REALITY_NEWS_FEED];
    [self refreshFeed];
    
    [self prepareDatabase];
}



-(void)prepareDatabase {
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    self.databasePath = [[NSString alloc]
                         initWithString: [docsDir stringByAppendingPathComponent:
                                          @"contacts.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: self.databasePath ] == NO)
    {
        const char *dbpath = [self.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_seenDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS URLS (URL TEXT PRIMARY KEY)";
            
            if (sqlite3_exec(self.seenDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            sqlite3_close(self.seenDB);
            NSLog(@"Successfully created the SQLite database");
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
}


-(BOOL)wasSeen:(NSString *)url {
    BOOL result = NO;
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &_seenDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT url FROM urls WHERE url=\"%@\"",
                              url];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_seenDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                result = YES;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_seenDB);
    }
    return result;
}



-(void)markAsSeen:(NSString *)url {
    sqlite3_stmt    *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_seenDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO URLS (url) VALUES (\"%@\")",
                               url];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_seenDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Marked as seen: %@", url);
        } else {
            NSLog(@"Could NOT mark as seen: %@", url);
        }
        sqlite3_finalize(statement);
        sqlite3_close(_seenDB);
    }
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RSSLoader* rssLoader = [[RSSLoader alloc] init];
    
    [rssLoader fetchRssWithURL:feedURL
                complete:^(NSString *title, NSArray *results) {

                    //completed fetching the RSS
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSLog(@"  Received the result from %@",feedURL);
                        _objects = results;
                        [self.tableView reloadData];
                        
                        // Stop refresh control
                        [refreshControl endRefreshing];
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
        [self markAsSeen:[rss.resolvedUrl absoluteString]];
        [[segue destinationViewController] setDetailItem:rss];
    }
}


- (void)updateForNewReality {
    NSLog(@"Update for new reality received by MasterViewController");
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
}
@end
