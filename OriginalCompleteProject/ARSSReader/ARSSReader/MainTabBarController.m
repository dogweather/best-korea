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
    NSLog(@"Changing to alternate reality.");
    [self setAlternateReality:YES];
}


- (void)leaveAlternateReality {
    NSLog(@"Leaving alternate reality.");
    [self setAlternateReality:NO];
}


- (void)setAlternateReality:(BOOL)option {
    NSLog(@"setAlternateReality: %u", option);
    [[App app] setAlternateRealityTo:option for:[self selectedViewController]];
}

@end
