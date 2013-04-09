//
//  NewsViewController.h
//

#import <UIKit/UIKit.h>
#import "RealityUpdateListener.h"
#import "MBProgressHUD.h"


@interface NewsTableViewController : UITableViewController <RealityUpdateListener>

- (IBAction)togglePartyMode:(id)sender;

@end
