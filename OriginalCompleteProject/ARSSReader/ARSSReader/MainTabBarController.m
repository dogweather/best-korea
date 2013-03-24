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


- (void) viewWillAppear:(BOOL)animated {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app setMyTitle:self.navigationItem];
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
        NSLog(@"Leaving alternate reality.");
        [self leaveAlternateReality];
    } else if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && ! [self inAlternateReality]) {
        NSLog(@"Changing to alternate reality.");
        [self enterAlternateReality];
    }
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
}


- (BOOL)inAlternateReality {
    BOOL result = [[NSUserDefaults standardUserDefaults] boolForKey:PREF_ALTERNATE_REALITY];
    NSLog(@"inAlternateReality? %u", result);
    return result;
}


- (void)enterAlternateReality {
    [self setAlternateReality:YES];
}


- (void)leaveAlternateReality {
    [self setAlternateReality:NO];
}


- (void)setAlternateReality:(BOOL)option {
    [[NSUserDefaults standardUserDefaults] setBool:option forKey:PREF_ALTERNATE_REALITY];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app setLookAndFeel];
    [self.selectedViewController viewWillAppear:YES];
}

@end
