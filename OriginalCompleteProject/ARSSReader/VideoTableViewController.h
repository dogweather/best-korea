//
//  VideoTableViewController.h
//  bestkorea
//
//  Created by Robb Shecter on 3/21/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealityUpdateListener.h"

@interface VideoTableViewController : UITableViewController <RealityUpdateListener>

@property (nonatomic, strong) NSMutableArray *videos;
- (IBAction)togglePartyMode:(id)sender;

@end
