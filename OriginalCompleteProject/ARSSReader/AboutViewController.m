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
    NSString *htmlFile   = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSLog(@"Trying to load %@", htmlFile);
    
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"Got HTML: %@", htmlString);
    
    [webView loadHTMLString:htmlString baseURL:nil];
}

@end
