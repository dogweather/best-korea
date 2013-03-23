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
    RSSItem* item = (RSSItem*)self.detailItem;
    self.title = item.title;
    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];

//    NSURLRequest* articleRequest = [NSURLRequest requestWithURL: item.link];
//    [webView loadRequest: articleRequest];
    
    NSURLRequest * videoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bestkorea.srsly.co/media/video/hyeonseo_lee_my_escape_from_north_korea.html"]];
    [webView loadRequest: videoRequest];
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