//
//  NewsViewController.h
//

#import <UIKit/UIKit.h>
#import "RealityUpdateListener.h"
#import "MBProgressHUD.h"


@interface NewsTableViewController : UITableViewController <RealityUpdateListener>

@property int icon_index;

- (IBAction)togglePartyMode:(id)sender;
@property MBProgressHUD *hud;

@end
