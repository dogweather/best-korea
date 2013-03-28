//
//  DetailViewController.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "App.h"
#import "RSSItem.h"

@interface DetailViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}
@end


@implementation DetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDatabase];
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



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSURLRequest* articleRequest;
    RSSItem* item = (RSSItem*)self.detailItem;
    if ([App inAlternateReality])
        self.title = [item.title uppercaseString];
    else
        self.title = item.title;
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];

    articleRequest = [NSURLRequest requestWithURL: [item resolvedUrl]];
    [webView loadRequest: articleRequest];
    
    [self markAsSeen:[[item resolvedUrl] absoluteString]];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    webView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end