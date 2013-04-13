//
//  NewsViewController.m
//

#import "NewsDetailViewController.h"
#import "AppDelegate.h"
#import "App.h"
#import "RSSItem.h"
#import "Constants.h"

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
    // TODO: Refactor this into an app-specific strategy
    //       class. I.e., not all apps will want uppercase
    //       titles in alternate reality.
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
    RSSItem  *rss            = (RSSItem*)self.detailItem;
    NSString *url           = [rss.link absoluteString];
    NSString *marketing     = [@"via " stringByAppendingString:MARKETING_DN];
    NSArray* dataToShare    = @[url, marketing];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}
@end