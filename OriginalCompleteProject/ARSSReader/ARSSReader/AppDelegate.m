//
//  AppDelegate.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "UISS.h"

@interface AppDelegate ()

@property(nonatomic, strong) UISS *uiss;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *appDefaults;
    NSString *style;
    
    // Register the preference defaults
    appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:PREF_ALTERNATE_REALITY];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    // Initial L&F setup
    style = [self inAlternateReality] ? ALTERNATE_STYLE : NORMAL_STYLE;
    self.uiss = [UISS configureWithJSONFilePath: [[NSBundle mainBundle] pathForResource:style ofType:@"json"]];

    return YES;
}


- (void) toggleRealityFor: (UIViewController*) controller {
    UIFont * navbarFont;
    [[NSUserDefaults standardUserDefaults] setBool:![self inAlternateReality] forKey:PREF_ALTERNATE_REALITY];
    [self setLookAndFeel];
    
    // Refresh the current view's navigation bar
    [self _setMyTitle: controller.navigationItem];
    if ([self inAlternateReality])
        navbarFont = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:18.0f];
    else
        navbarFont = [UIFont fontWithName:@"Georgia-Bold" size:18.0f];
    [controller.navigationController.navigationBar setTitleTextAttributes: @{UITextAttributeFont: navbarFont}];
    [controller.navigationController.navigationBar setNeedsLayout];
}


- (void) setLookAndFeel {
    if ([self inAlternateReality])
        [self switchToAlternateLook];
    else
        [self switchToNormalLook];
}


- (void) switchToAlternateLook {
    NSLog(@"switchToAlternateLook");
    [self switchTo:ALTERNATE_STYLE];
}


- (void) switchToNormalLook {
    NSLog(@"switchToNormalLook");
    [self switchTo:NORMAL_STYLE];
}


- (void) switchTo:(NSString*)style {
    self.uiss.style.url = [NSURL fileURLWithPath:
                           [[NSBundle mainBundle] pathForResource:style ofType:@"json"]];
    [self.uiss reloadStyleAsynchronously];
}


- (BOOL)inAlternateReality {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ALTERNATE_REALITY];
}



// TODO: Refactor the text out to the app constants header.
- (void) _setMyTitle:(UINavigationItem *)navItem {
    if ([self inAlternateReality])
        navItem.title = @"BEST KOREA";
    else
        navItem.title = @"Best Korea";
}


// Call this from a view controller's will appear method.
- (void) setMyTitle:(UINavigationItem *)navItem andFont:(UIViewController *)controller {
    UIFont *navbarFont;
    
    [self _setMyTitle:navItem];
    
    if ([self inAlternateReality])
        navbarFont = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:18.0f];
    else
        navbarFont = [UIFont fontWithName:@"Georgia-Bold" size:18.0f];
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
