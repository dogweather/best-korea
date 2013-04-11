//
//  VideoTableViewController.h
//  bestkorea
//
//  Created by Robb Shecter on 3/21/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealityUpdateListener.h"
#import "MBProgressHUD.h"


@interface VideoTableViewController : UITableViewController <RealityUpdateListener>

- (IBAction)togglePartyMode:(id)sender;

@end
