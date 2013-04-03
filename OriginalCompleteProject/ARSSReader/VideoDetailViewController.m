//
//  VideoDetailViewController.m
//  bestkorea
//
//  Created by Robb Shecter on 3/22/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "AppDelegate.h"

@interface VideoDetailViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}
@end


@implementation VideoDetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    // Set the share button to correct state
    self.shareButton.enabled = (self.shareUrl != nil);
    
    // Load the video page if necessary
    if (self.url != self.prevUrl) {
        NSURLRequest * videoRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: self.url]];
        [webView loadRequest: videoRequest];
        self.prevUrl = self.url;
    }    
}


- (IBAction)startShare:(id)sender {
    if (self.shareUrl == nil) {
        NSLog(@"Not sharing: no share url.");
        return;
    }
    
    NSString *marketing     = [@"Via " stringByAppendingString:MARKETING_DN];
    NSArray* dataToShare    = @[self.shareUrl, marketing];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}

@end
