//
//  App.h
//  bestkorea
//
//  Created by Robb Shecter on 3/24/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MainTabBarController.h"

@interface App : NSObject


+(BOOL)inAlternateReality;

+ (AppDelegate*) appDelegate;
+(void)toggleRealityFor:(UIViewController *)controller;
+(void)setMyTitle:(UINavigationItem*)navItem andFont:(UIViewController *)controller;
+(MainTabBarController *)tabController;
+(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;


// Global L&F services
+(UIColor *) colorForTitleOfResource:(NSString *)identifier;
+(UIColor *) colorForSubTitleOfResource:(NSString *)identifier;
+(UIColor *) colorForTableSeparator;
+(UIColor *) colorForTableCellBg;
+(UIColor *) colorForTitle;
+(UIColor *) communistGold;

@end
