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
    float edge;
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
    imageView.hidden = YES;
    edge = 16;
    
    // Enable gestures
    [self.scrollView setCanCancelContentTouches:NO];
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.contentSize         = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    self.scrollView.contentInset        = UIEdgeInsetsMake(edge, edge, edge, edge);
    self.scrollView.minimumZoomScale    = 0.1;
    self.scrollView.maximumZoomScale    = 1.0;
    self.scrollView.delegate            = self;
    self.scrollView.backgroundColor     = [UIColor blackColor];    
    [self.scrollView addSubview:imageView];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.scrollView.zoomScale = (self.scrollView.bounds.size.width - (edge * 2.0)) / imageView.bounds.size.width;
    imageView.hidden = NO;
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
