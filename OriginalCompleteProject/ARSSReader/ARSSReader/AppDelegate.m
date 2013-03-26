//
//  AppDelegate.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import "AppDelegate.h"
#import "App.h"
#import "Constants.h"
#import "UISS.h"

@interface AppDelegate ()

@property(nonatomic, strong) UISS *uiss;

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


// TODO: Refactor the text out to the app constants header.
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
