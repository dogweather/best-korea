//
//  NewsViewController.m
//

#import "NewsDetailViewController.h"
#import "AppDelegate.h"
#import "App.h"
#import "RSSItem.h"

@interface NewsDetailViewController () <UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}
@end


@implementation NewsDetailViewController

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

- (IBAction)startShare:(id)sender {
    RSSItem* item        = (RSSItem*)self.detailItem;
    NSString* someText   = [item.link absoluteString];
    NSArray* dataToShare = @[someText];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}
@end