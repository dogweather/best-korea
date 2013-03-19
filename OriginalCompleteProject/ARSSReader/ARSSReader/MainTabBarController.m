//
//  MainTabBarController.m
//  bestkorea
//
//  Created by Robb Shecter on 3/19/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "MainTabBarController.h"
#import "Constants.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        if ([self inAlternateReality] == YES) {
            [self leaveAlternateReality];
        }
    } else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        if ([self inAlternateReality] == NO) {
            [self enterAlternateReality];
        }
    }
}


- (BOOL)inAlternateReality {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ALTERNATE_REALITY];
}


- (void)enterAlternateReality {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_ALTERNATE_REALITY];
    // TODO: Adjust the app for the reality state.
}


- (void)leaveAlternateReality {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_ALTERNATE_REALITY];
    // TODO: Adjust the app for the reality state.
}

@end
