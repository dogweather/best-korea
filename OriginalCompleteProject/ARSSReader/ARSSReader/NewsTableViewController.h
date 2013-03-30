//
//  MasterViewController.h
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import <UIKit/UIKit.h>
#import "RealityUpdateListener.h"
#import "MBProgressHUD.h"


@interface NewsTableViewController : UITableViewController <RealityUpdateListener>

@property int icon_index;

- (IBAction)togglePartyMode:(id)sender;
@property MBProgressHUD *hud;

@end
