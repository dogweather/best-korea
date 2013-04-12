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
    BOOL  appearedOnce;
}
@property (weak) UIImageView *imageView;
@end


@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([App inAlternateReality])
        self.title = [self.title uppercaseString];
    
    edge = 16;
    appearedOnce = NO;
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (! appearedOnce) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            UIImageView *i;
            i = [[UIImageView alloc] initWithImage:[MapViewController imageFromMainBundleFile:self.mapFileName]];
            
            // Enable gestures
            self.scrollView.contentSize = CGSizeMake(i.frame.size.width, i.frame.size.height);
            [self.scrollView setCanCancelContentTouches:NO];
            [self.scrollView setScrollEnabled:YES];
            self.scrollView.contentInset        = UIEdgeInsetsMake(edge, edge, edge, edge);
            self.scrollView.minimumZoomScale    = 0.1;
            self.scrollView.maximumZoomScale    = 1.0;
            self.scrollView.delegate            = self;
            self.imageView = i;
            
            self.scrollView.zoomScale = (self.scrollView.bounds.size.width - (edge * 2.0)) / self.imageView.bounds.size.width;
            [self.scrollView addSubview:i];
            appearedOnce = YES;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }
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
    NSLog(@"Memory warning in MapViewController %d", self.hash);
    // Dispose of any resources that can be recreated.
}

@end
