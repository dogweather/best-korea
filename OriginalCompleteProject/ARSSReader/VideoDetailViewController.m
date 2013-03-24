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
    if (self.url != self.prevUrl) {
        NSURLRequest * videoRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: self.url]];
        [webView loadRequest: videoRequest];
        self.prevUrl = self.url;
    }
}


- (void) viewWillAppear:(BOOL)animated {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
