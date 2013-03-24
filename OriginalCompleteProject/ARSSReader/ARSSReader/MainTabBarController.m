//
//  MainTabBarController.m
//  bestkorea
//
//  Created by Robb Shecter on 3/19/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "Constants.h"
#import "MainTabBarController.h"
#import "AppDelegate.h"

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
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        if ([self inAlternateReality]) {
            NSLog(@"Changing to Party-Pooper Mode");
            [self leaveAlternateReality];
        }
    } else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        if (! [self inAlternateReality]) {
            NSLog(@"Changing to Party Mode");
            [self enterAlternateReality];
        }
    }
}


- (BOOL)inAlternateReality {
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ALTERNATE_REALITY];
    NSLog(@"inAlternateReality: %u", result);
    return result;
}


- (void)enterAlternateReality {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_ALTERNATE_REALITY];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app switchToAlternateLook];
}


- (void)leaveAlternateReality {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_ALTERNATE_REALITY];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app switchToNormalLook];
}

@end
