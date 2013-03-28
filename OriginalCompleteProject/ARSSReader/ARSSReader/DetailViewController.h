//
//  DetailViewController.h
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface DetailViewController : UIViewController

@property id detailItem;
@property (weak) IBOutlet UILabel *detailDescriptionLabel;

@property NSString *databasePath;
@property (nonatomic) sqlite3 *seenDB;

@end
