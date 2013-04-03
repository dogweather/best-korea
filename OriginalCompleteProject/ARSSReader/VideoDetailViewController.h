//
//  VideoDetailViewController.h
//  bestkorea
//
//  Created by Robb Shecter on 3/22/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface VideoDetailViewController : UIViewController

@property NSString *url;
@property NSString *prevUrl;
@property NSString *shareUrl;

- (IBAction)startShare:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end
