//
//  DetailViewController.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import "DetailViewController.h"
#import "RSSItem.h"

@interface DetailViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}
@end

@implementation DetailViewController

-(void)viewDidAppear:(BOOL)animated
{
    NSURLRequest* articleRequest;
    RSSItem* item = (RSSItem*)self.detailItem;
    self.title = item.title;
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];

    articleRequest = [NSURLRequest requestWithURL: item.link];
    [webView loadRequest: articleRequest];    
}


-(void)viewDidDisappear:(BOOL)animated
{
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