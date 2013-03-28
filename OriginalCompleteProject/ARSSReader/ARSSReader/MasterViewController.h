//
//  MasterViewController.h
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "RealityUpdateListener.h"
#import "MBProgressHUD.h"


@interface MasterViewController : UITableViewController <RealityUpdateListener>

@property int icon_index;

- (IBAction)togglePartyMode:(id)sender;
@property MBProgressHUD *hud;
@property NSString *databasePath;
@property (nonatomic) sqlite3 *seenDB;

// Methods for views to store and find out which
// of their content has already been seen.
-(void)markAsSeen:(NSString *)url;
-(BOOL)wasSeen:(NSString *)url;

@end
