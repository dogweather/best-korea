//
//  MapViewController.m
//  bestkorea
//
//  Created by Robb Shecter on 4/11/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
{
    UIImageView *imageView;
}
@end


@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Setting image to %@", self.mapFileName);
    
    if ([App inAlternateReality])
        self.title = [self.title uppercaseString];
    
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.mapFileName]];
    
    // Enable gestures
    float edge = 32.0;
    [self.scrollView setCanCancelContentTouches:NO];
    self.scrollView.contentSize         = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    self.scrollView.contentInset        = UIEdgeInsetsMake(edge, edge, edge, edge);
    self.scrollView.minimumZoomScale    = 0.1;
    self.scrollView.maximumZoomScale    = 1.0;
    self.scrollView.delegate            = self;
    self.scrollView.backgroundColor     = [UIColor blackColor];
    
    [self.scrollView addSubview:imageView];
    [self.scrollView setScrollEnabled:YES];
}


// Required to enable gestures
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
