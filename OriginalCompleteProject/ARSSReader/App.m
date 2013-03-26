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

@implementation App

+(BOOL)inAlternateReality {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ALTERNATE_REALITY];
}


+ (void) toggleRealityFor: (UIViewController *) controller {
    [[self app] toggleRealityFor:controller];
}


+ (void) setMyTitle:(UINavigationItem *)navItem andFont:(UIViewController *)controller {
    [[self app] setMyTitle:navItem andFont:controller];
}


+ (AppDelegate *) app {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


@end
