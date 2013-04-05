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

- (void) viewDidLoad {
    [super viewDidLoad];
    [self loadTheContent];
}


- (void) loadTheContent {
    if (self.htmlString == nil) {
        NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *version       = [@"<h2>Version</h2><ul><li>" stringByAppendingString:versionNumber];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MMM-dd"];
        [dateFormat setDateStyle:NSDateFormatterLongStyle];
        NSString *date = [@"<li>" stringByAppendingString:[dateFormat stringFromDate:[NSDate date]]];
        
        
        NSString *htmlFile      = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];

        self.htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        self.htmlString = [self.htmlString stringByAppendingString:version];
        self.htmlString = [self.htmlString stringByAppendingString:date];
        self.htmlString = [self.htmlString stringByAppendingString:@"</ul>"];
        
        [webView loadHTMLString:self.htmlString baseURL:baseURL];
    }
}


- (IBAction)shareBestKorea:(id)sender {
    NSArray* dataToShare = @[@"North Korea news for the iPhone – BestKoreaApp.com"];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
}
@end
