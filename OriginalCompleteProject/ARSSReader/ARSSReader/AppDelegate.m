//
//  AppDelegate.m
//

#import "UISS.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "App.h"
#import "MainTabBarController.h"
#import "AboutViewController.h"


@interface AppDelegate ()

@property(nonatomic, strong) UISS *uiss;
@property NSString *databasePath;
@property (nonatomic) sqlite3 *seenDB;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *appDefaults;
    NSString *styleFile;
    
    // Register the preference defaults
    appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:PREF_ALTERNATE_REALITY];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    // Initial L&F setup
    styleFile = [App inAlternateReality] ? ALTERNATE_STYLE_FILE : NORMAL_STYLE_FILE;
    self.uiss = [UISS configureWithJSONFilePath: [[NSBundle mainBundle] pathForResource:styleFile ofType:@"json"]];
    
    // The Seen DB
    [self prepareTheSeenDB];
    
    return YES;
}


- (void) toggleRealityFor: (UIViewController*) controller {
    [self setAlternateRealityTo:![App inAlternateReality] for:controller];
}


// Set the reality mode, making changes if necessary. Persist the
// new value and update the app's look & feel.
- (void) setAlternateRealityTo:(BOOL)alternate for:(UIViewController*)controller {
    // Do nothing if we're already there.
    if (alternate == [App inAlternateReality])
        return;
    
    // Save the preference.
    [[NSUserDefaults standardUserDefaults] setBool:alternate forKey:PREF_ALTERNATE_REALITY];
    
    // Change the app's look & feel.
    // Apply the hack-fix.
    [self setLookAndFeel];
    [self setMyTitle:controller.navigationItem andFont:controller];
}


- (void) setLookAndFeel {
    NSString *file = [App inAlternateReality] ? ALTERNATE_STYLE_FILE : NORMAL_STYLE_FILE;
    self.uiss.style.url = [NSURL fileURLWithPath:
                           [[NSBundle mainBundle] pathForResource:file ofType:@"json"]];
    [self.uiss reloadStyleAsynchronously];
}


- (void) setTitleOf:(UINavigationItem *)navItem {
    if ([App inAlternateReality])
        navItem.title = ALTERNATE_APP_NAME;
    else
        navItem.title = REALITY_APP_NAME;
}


// Call this from a view controller's will appear method.
- (void) setMyTitle:(UINavigationItem *)navItem andFont:(UIViewController *)controller {
    UIFont *navbarFont;
    
    [self setTitleOf:navItem];
    
    if ([App inAlternateReality])
        navbarFont = [UIFont fontWithName:ALTERNATE_NAVBAR_FONT size:18.0f];
    else
        navbarFont = [UIFont fontWithName:REALITY_NAVBAR_FONT size:18.0f];
    [controller.navigationController.navigationBar setTitleTextAttributes: @{UITextAttributeFont: navbarFont}];
    [controller.navigationController.navigationBar setNeedsDisplay];
}




//
// The Seen DB Implementation /////////////////////////////////////////
//


-(void)prepareTheSeenDB {
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
            // Marked as seen
        } else {
            // Not marked as seen
        }
        sqlite3_finalize(statement);
        sqlite3_close(_seenDB);
    }
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
