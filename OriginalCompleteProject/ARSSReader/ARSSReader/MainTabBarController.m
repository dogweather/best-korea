//
//  MainTabBarController.m
//  bestkorea
//
//  Created by Robb Shecter on 3/19/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "Constants.h"
#import "MainTabBarController.h"
#import "MasterViewController.h"
#import "App.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Allow all rotations. Necessary to override these:
- (BOOL)shouldAutorotate;
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


// Change our view of reality when the UI is about
// to rotate.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait && [self inAlternateReality]) {
        [self leaveAlternateReality];
    } else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && ! [self inAlternateReality]) {
        [self enterAlternateReality];
    }
}

//
//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//}


- (BOOL)inAlternateReality {
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ALTERNATE_REALITY];
    NSLog(@"inAlternateReality? %u", result);
    return result;
}


- (void)enterAlternateReality {
    [self setAlternateReality:YES];
}


- (void)leaveAlternateReality {
    [self setAlternateReality:NO];
}


- (void)setAlternateReality:(BOOL)option {
    NSLog(@"setAlternateReality to: %u", option);
    UIViewController <RealityUpdateListener> *listener;
    
    // Tell the app to make the change
    [[App app] setAlternateRealityTo:option for:[self selectedViewController]];
    
    // Figure out which view to notify
    UIViewController *currentView = self.selectedViewController;
    // Is this a navigation controller?
    if ([currentView isKindOfClass:[UINavigationController class]]) {
        NSLog(@"Urp, this is a nav controller. Reset it and go to the root view.");
        // Go back to the root/top, and use the root as the listener.
        [(UINavigationController *)currentView popToRootViewControllerAnimated:YES];
        currentView = [(UINavigationController *)currentView topViewController];
    }

    // Try to notify the current view controller
    NSLog(@"Trying to notify the view...");
    if ([currentView conformsToProtocol:@protocol(RealityUpdateListener)]) {
        listener = (UIViewController <RealityUpdateListener> *) currentView;
        [listener updateForNewReality];
    } else {
        NSLog(@"It's not a listener: %@", currentView);
    }
}

@end
