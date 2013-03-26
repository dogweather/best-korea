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
@property UIView *blackView;
@end

@implementation MainTabBarController


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


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if ((toInterfaceOrientation == UIInterfaceOrientationPortrait && [App inAlternateReality]) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && ! [App inAlternateReality])) {
        // We're going to be switching, so black out the UI.
        [self fadeOut];
    }
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait)
        && [App inAlternateReality]) {
        [self setAlternateReality:NO];
    } else if (([UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown)
               && ! [App inAlternateReality]) {
        [self setAlternateReality:YES];
    }
    
    [self fadeIn];
}


- (void) fadeOut {
    if (self.blackView == nil)
        self.blackView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.blackView.alpha = 0;
    [self.blackView setBackgroundColor:[UIColor blackColor]];
    [self.view.superview addSubview:self.blackView];
    [UIView beginAnimations:@"fadeOut" context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.blackView.alpha = 1.0;
    [UIView commitAnimations];
}


- (void) fadeIn {
    [UIView beginAnimations:@"fadeIn" context:NULL];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.blackView.alpha = 0;
    [UIView commitAnimations];
//    [self.blackView removeFromSuperview];
}


- (void)setAlternateReality:(BOOL)option {
    NSLog(@"setAlternateReality to: %u", option);
    
    // 1. Tell the app to make the change.
    [[App app] setAlternateRealityTo:option for:[self selectedViewController]];
    
    // 2. Tell the tabs to update their contents.
    for (id v in self.viewControllers) {
        [self sendUpdateMessageTo:v];
    }
}


- (void) sendUpdateMessageTo:(UIViewController *)currentView {
    UIViewController <RealityUpdateListener> *listener;
    
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
