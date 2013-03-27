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
#import "AboutViewController.h"
#import "App.h"

@interface MainTabBarController ()

@property UIView *spinner;

@end



@implementation MainTabBarController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // Pre-load the about page
    AboutViewController *aboutController;
    aboutController = (AboutViewController *)[[self viewControllers] objectAtIndex:2];
    NSLog(@"Got controller: %@",aboutController);
//    [aboutController loadTheContent];
}


- (void) fadeInAndSpin {
    if ([App inAlternateReality])
        [self spinUp];
    else
        [self fadeInLong];
}


- (void) spinUp {
    NSLog(@"spinUp");
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
    group.duration = 1.5;
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
    NSLog(@"fadeIn");
    [UIView beginAnimations:@"fadeIn" context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.blackView.alpha = 0;
    [UIView commitAnimations];
}


- (void) fadeInLong {
    NSLog(@"fadeInLong");
    [UIView beginAnimations:@"fadeIn" context:NULL];
    [UIView setAnimationDuration:2.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.blackView.alpha = 0;
    [UIView commitAnimations];
}



// Allow all orientations
- (BOOL) shouldAutorotate; { return YES; }
- (NSUInteger) supportedInterfaceOrientations { return UIInterfaceOrientationMaskAll; }



@end
