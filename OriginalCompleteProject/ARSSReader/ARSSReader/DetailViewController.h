//
//  DetailViewController.h
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property id detailItem;
@property (weak) IBOutlet UILabel *detailDescriptionLabel;
- (IBAction)startShare:(id)sender;

@end
