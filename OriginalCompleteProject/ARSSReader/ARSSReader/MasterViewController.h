//
//  MasterViewController.h
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import <UIKit/UIKit.h>
#import "RealityUpdateListener.h"


@interface MasterViewController : UITableViewController <RealityUpdateListener>

@property int icon_index;

- (IBAction)togglePartyMode:(id)sender;

@end
