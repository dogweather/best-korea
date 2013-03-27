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

@interface App : NSObject


+(BOOL)inAlternateReality;

+ (AppDelegate*) appDelegate;
+(void)toggleRealityFor:(UIViewController *)controller;
+(void)setMyTitle:(UINavigationItem*)navItem andFont:(UIViewController *)controller;

+ (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;


@end
