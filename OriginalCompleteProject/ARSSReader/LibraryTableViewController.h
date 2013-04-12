//
//  LibraryTableViewController.h
//  bestkorea
//
//  Created by Robb Shecter on 4/11/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealityUpdateListener.h"
#import "App.h"

@interface LibraryTableViewController : UITableViewController <RealityUpdateListener>
- (IBAction)togglePartyMode:(id)sender;

@end
