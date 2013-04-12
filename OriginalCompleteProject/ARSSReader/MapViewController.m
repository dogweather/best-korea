//
//  MapViewController.m
//  bestkorea
//
//  Created by Robb Shecter on 4/11/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end


@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Setting image to %@", self.mapFileName);
    self.mapImageView.image = [UIImage imageNamed:self.mapFileName];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
