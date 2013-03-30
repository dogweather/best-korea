//
//  NewsDetailViewController.h
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController

@property id detailItem;
@property (weak) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)startShare:(id)sender;

@end
