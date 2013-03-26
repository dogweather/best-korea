//
//  MainTabBarController.m
//  bestkorea
//
//  Created by Robb Shecter on 3/19/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "Constants.h"
#import "MainTabBarController.h"
#import "MasterViewController.h"
#import "App.h"

@interface MainTabBarController ()

@property UIView *blackView;
@property UIView *spinner;

@end



@implementation MainTabBarController


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


- (void) fadeInAndSpin {
    if ([App inAlternateReality])
        [self spinUp];
    else
        [self fadeInLong];
}


- (void) spinUp {
    if (self.spinner == nil) {
        self.spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spinner.png"]];
        self.spinner.center = self.view.center;
        self.spinner.alpha = 0;
        [self.blackView addSubview:self.spinner];
    }

    CABasicAnimation *makeBiggerAnim=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    makeBiggerAnim.fromValue=[NSNumber numberWithDouble:0.05];
    makeBiggerAnim.toValue=[NSNumber numberWithDouble:1.0];
    
    CABasicAnimation *fadeAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue=[NSNumber numberWithDouble:0.1];
    fadeAnim.toValue=[NSNumber numberWithDouble:1.0];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 9];
    rotationAnimation.cumulative = YES;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 2;
    group.repeatCount = 1;
    group.autoreverses = YES;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.animations = @[makeBiggerAnim, rotationAnimation, fadeAnim];
    group.delegate = self;
    [self.spinner.layer addAnimation:group forKey:@"allMyAnimations"];
}


- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self fadeIn];
}


- (void) fadeIn {
    [UIView beginAnimations:@"fadeIn" context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.blackView.alpha = 0;
    [UIView commitAnimations];
}


- (void) fadeInLong {
    [UIView beginAnimations:@"fadeIn" context:NULL];
    [UIView setAnimationDuration:2.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.blackView.alpha = 0;
    [UIView commitAnimations];
}


- (void)setAlternateReality:(BOOL)option {
    NSLog(@"setAlternateReality to: %u", option);
    
    // 1. Tell the app to make the change.
    [[App app] setAlternateRealityTo:option for:[self selectedViewController]];
    
    // 2. Tell the tabs to update their contents.
    for (id v in self.viewControllers) {
        [self sendUpdateMessageTo:v];
    }
    
    [self fadeInAndSpin];
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
