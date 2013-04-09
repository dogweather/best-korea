//
//  VideoDetailViewController.m
//  bestkorea
//
//  Created by Robb Shecter on 3/22/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "AppDelegate.h"
#import "App.h"

@interface VideoDetailViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}
@end


@implementation VideoDetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    // Set up the nav bar.
    self.shareButton.enabled = (self.video.shareUrl != nil);
    if ([App inAlternateReality])
        self.title = [self.video.title uppercaseString];
    else
        self.title = self.video.title;
    
    // Load the video page if necessary
    if (self.video.url != self.prevUrl) {
        NSURLRequest * videoRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: self.video.url]];
        [webView loadRequest: videoRequest];
        self.prevUrl = self.video.url;
    }
}


- (IBAction)startShare:(id)sender {
    if (self.video.shareUrl == nil) {
        NSLog(@"Not sharing: no share url.");
        return;
    }
    
    NSString *marketing     = [@"Via " stringByAppendingString:MARKETING_DN];
    NSArray* dataToShare    = @[self.video.shareUrl, marketing];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}


//
// TODO: These are not working, but I'm not sure why.
//
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    webView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


@end
