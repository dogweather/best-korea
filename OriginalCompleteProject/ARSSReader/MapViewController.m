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
    float edge;
}
@property (weak) UIImageView *imageView;
@end


@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad of %d", self.hash);
    NSLog(@"Setting image to %@", self.mapFileName);
    
    if ([App inAlternateReality])
        self.title = [self.title uppercaseString];
    
    edge = 16;
    
    // Enable gestures
    [self.scrollView setCanCancelContentTouches:NO];
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.contentInset        = UIEdgeInsetsMake(edge, edge, edge, edge);
    self.scrollView.minimumZoomScale    = 0.1;
    self.scrollView.maximumZoomScale    = 1.0;
    self.scrollView.delegate            = self;
    self.scrollView.backgroundColor     = [UIColor blackColor];    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIImageView *i;
    
    i = [[UIImageView alloc] initWithImage:[MapViewController imageFromMainBundleFile:self.mapFileName]];
    self.scrollView.contentSize = CGSizeMake(i.frame.size.width, i.frame.size.height);
    self.scrollView.zoomScale = (self.scrollView.bounds.size.width - (edge * 2.0)) / i.bounds.size.width;
    [self.scrollView addSubview:i];
    self.imageView = i;
}


+ (UIImage*)imageFromMainBundleFile:(NSString*)aFileName; {
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", bundlePath, aFileName]];
}


// Required to enable gestures
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Memory warning in MapViewController");
    // Dispose of any resources that can be recreated.
}

@end
