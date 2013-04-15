//
//  App.m
//  bestkorea
//
//  Provides application-wide settings and changes.
//
//
//  Created by Robb Shecter on 3/24/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//


#import "App.h"
#import "Constants.h"
#import "RealityUpdateListener.h"
#import "MainTabBarController.h"
#import "NewsTableViewController.h"

@interface App()

@end



@implementation App

//
// Return a text color taking into account:
// 1. Whether the resource has been seen, and
// 2. Whether we're in reality or alternate reality.
+ (UIColor *) colorForTitleOfResource:(NSString *)identifier {
    return [[self appDelegate] wasSeen:identifier] ? [self colorForSeenTitle] : [self colorForUnseenTitle];
}

//
// Return a text color taking into account:
// 1. Whether the resource has been seen, and
// 2. Whether we're in reality or alternate reality.
+ (UIColor *) colorForSubTitleOfResource:(NSString *)identifier {
    return [[self appDelegate] wasSeen:identifier] ? [self colorForSeenSubTitle] : [self colorForUnseenSubTitle];
}

+ (UIColor *) colorForUnseenTitle {
    if ([self inAlternateReality])
        // A blend between communist red, #89170F, and black.
        return [UIColor colorWithRed:(41/255.0) green:(7/255.0) blue:(5/255.0) alpha:1];
    else
        return [UIColor blackColor];
}

+ (UIColor *) colorForSeenTitle {
    if ([self inAlternateReality])
        // A blend between communist red, #89170F, and light gray, #999.
        return [UIColor colorWithRed:(150/255.0) green:(127/255.0) blue:(125/255.0) alpha:1];
    else
        return [UIColor grayColor];
}

+(UIColor *) colorForTableSeparator {
    if ([self inAlternateReality])
        return [UIColor colorWithRed:(221/255.0) green:(209/255.0) blue:(209/255.0) alpha:1];
    else
        return [UIColor colorWithWhite:(230/255.0) alpha:1];
}

+(UIColor *) colorForTableCellBg {
    if ([self inAlternateReality])
        return [UIColor colorWithRed:(244/255.0) green:(239/255.0) blue:(238/255.0) alpha:1];
    else
        return [UIColor colorWithWhite:(250/255.0) alpha:1];
}

+ (UIColor *) colorForUnseenSubTitle {
    return [self colorForSeenTitle];
}

+ (UIColor *) colorForSeenSubTitle {
    return [self colorForSeenTitle];
}


+ (UIColor *) communistGold {
    return [UIColor colorWithRed:(222/255.0) green:(172/255.0) blue:(0/255.0) alpha:1];
}






+ (BOOL) inAlternateReality {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ALTERNATE_REALITY];
}



+ (void) toggleRealityFor: (UIViewController *) controller {
    [self fadeOutWithDuration:0.2];
}


+ (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [[self appDelegate] toggleRealityFor:[[self tabController] selectedViewController]];
    [self sendRealityChangeNotifications];
    [[self tabController] fadeInAndSpin];
}


+ (void) fadeOutWithDuration:(float)duration {
    if ([self tabController].blackView == nil)
        [self tabController].blackView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self tabController].blackView.alpha = 0;
    [[self tabController].blackView setBackgroundColor:[UIColor blackColor]];
    [[self tabController].view.superview addSubview:[self tabController].blackView];
    
    CABasicAnimation *fadeAnim=[CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue=[NSNumber numberWithDouble:0.0];
    [self tabController].blackView.layer.opacity = 1;
    fadeAnim.duration = duration;
    fadeAnim.delegate = self;
    fadeAnim.fillMode = kCAFillModeForwards;
    fadeAnim.removedOnCompletion = NO;
    [[self tabController].blackView.layer addAnimation:fadeAnim forKey:@"fadeOut"];
}





+ (void) setMyTitle:(UINavigationItem *)navItem andFont:(UIViewController *)controller {
    [[self appDelegate] setMyTitle:navItem andFont:controller];
}


+ (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


+ (MainTabBarController *) tabController {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    return (MainTabBarController *) rootViewController;
}


+ (void) sendUpdateMessageTo:(UIViewController *)aController {
    UIViewController <RealityUpdateListener> *listener;
    
    // Is this a navigation controller?
    if ([aController isKindOfClass:[UINavigationController class]]) {
        // Go back to the root/top, and use the root as the listener.
        [(UINavigationController *)aController popToRootViewControllerAnimated:YES];
        aController = [(UINavigationController *)aController topViewController];
    }
    
    // Try to notify the current view controller
    if ([aController conformsToProtocol:@protocol(RealityUpdateListener)]) {
        listener = (UIViewController <RealityUpdateListener> *) aController;
        [listener updateForNewReality];
    } else {
        NSLog(@"It's not a listener: %@", aController);
    }
}


+ (void) sendRealityChangeNotifications {
    for (id c in [self tabController].viewControllers) {
        [self sendUpdateMessageTo:c];
    }
}


@end
