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
    
    // Register the preference defaults early
    appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:PREF_ALTERNATE_REALITY];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];

    return YES;
}


- (void) switchToAlternateLookFor: (UIViewController*) controller {
    NSLog(@"SwitchToAlternateLook");
    UINavigationBar *navBar;
//    self.uiss = [UISS configureWithJSONFilePath: [[NSBundle mainBundle] pathForResource:@"uiss-alternative" ofType:@"json"]];
    
    // Colors and fonts
    UIColor * communistRed  = [UIColor colorWithRed:0.53f green:0.09f blue:0.06f alpha:0.0f];
    UIFont * navbarFont     = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:20.0f];
    
    // Global
    
    [[UINavigationBar appearance] setTintColor: communistRed];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                     UITextAttributeFont: navbarFont
     }];
    
    // This controller
    navBar = controller.navigationController.navigationBar;
    [navBar setTintColor: communistRed];
    [navBar setTitleTextAttributes: @{ UITextAttributeFont: navbarFont }];
    [controller.navigationController.navigationBar setNeedsLayout];
}


- (void) switchToNormalLookFor: (UIViewController*) controller {
    //    self.uiss = [UISS configureWithJSONFilePath: [[NSBundle mainBundle] pathForResource:@"uiss" ofType:@"json"]];
    NSLog(@"SwitchToNormalLook");
    
    // Colors and fonts
    UIColor * navBarTint    = [UIColor blackColor];
    UIFont * navbarFont     = [UIFont fontWithName:@"Georgia-Bold" size:18.0f];

    // Global
    [[UINavigationBar appearance] setTintColor: navBarTint];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                     UITextAttributeFont: navbarFont
     }];
    
    // This controller
    [controller.navigationController.navigationBar setTintColor: navBarTint];
    [controller.navigationController.navigationBar setTitleTextAttributes: @{
                                     UITextAttributeFont: navbarFont
     }];
    [controller.navigationController.navigationBar setNeedsLayout];
}


- (BOOL)inAlternateReality {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ALTERNATE_REALITY];
}


- (void) setMyLookAndFeel:(UIViewController *)controller {
    if ([self inAlternateReality])
        [self switchToAlternateLookFor: controller];
    else
        [self switchToNormalLookFor: controller];
}


- (void) setMyTitle:(UIViewController *)controller {
    if ([self inAlternateReality])
        controller.title = @"BEST KOREA";
    else
        controller.title = @"Best Korea";
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
