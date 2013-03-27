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


@implementation App

+(BOOL)inAlternateReality {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ALTERNATE_REALITY];
}


+ (void) toggleRealityFor: (UIViewController *) controller {
    [[self appDelegate] toggleRealityFor:controller];
    [self sendRealityChangeNotifications];
}


+ (void) setMyTitle:(UINavigationItem *)navItem andFont:(UIViewController *)controller {
    [[self appDelegate] setMyTitle:navItem andFont:controller];
}


+ (AppDelegate *) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


+ (UITabBarController *) tabController {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    return (UITabBarController *) rootViewController;
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
