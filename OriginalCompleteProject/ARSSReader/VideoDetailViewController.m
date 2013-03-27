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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.url != self.prevUrl) {
        NSURLRequest * videoRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: self.url]];
        [webView loadRequest: videoRequest];
        self.prevUrl = self.url;
    }
}

@end
