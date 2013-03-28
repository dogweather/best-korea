//
//  DetailViewController.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "App.h"
#import "RSSItem.h"

@interface DetailViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}
@end

@implementation DetailViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSURLRequest* articleRequest;
    RSSItem* item = (RSSItem*)self.detailItem;
    if ([App inAlternateReality])
        self.title = [item.title uppercaseString];
    else
        self.title = item.title;
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];

    articleRequest = [NSURLRequest requestWithURL: [item resolvedUrl]];
    [webView loadRequest: articleRequest];    
}


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