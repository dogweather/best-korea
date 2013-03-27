//
//  AboutViewController.m
//  bestkorea
//
//  Created by Robb Shecter on 3/26/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import "AboutViewController.h"


@interface AboutViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}
@end


@implementation AboutViewController

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *htmlFile   = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    NSURL    *baseURL    = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    
    [webView loadHTMLString:htmlString baseURL:baseURL];
}

@end
