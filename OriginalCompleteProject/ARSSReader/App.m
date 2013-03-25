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

@implementation App


+ (void) toggleRealityFor: (UIViewController *) controller {
    [[self app] toggleRealityFor:controller];
}


+ (void) setMyTitle: (UINavigationItem*) navItem {
    [[self app] setMyTitle:navItem];
}


+ (AppDelegate *) app {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


@end
