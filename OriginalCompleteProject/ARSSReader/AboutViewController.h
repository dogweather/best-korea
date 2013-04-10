//
//  AboutViewController.h
//  bestkorea
//
//  Created by Robb Shecter on 3/26/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "RealityUpdateListener.h"

@interface AboutViewController : UIViewController <RealityUpdateListener>

-(void)loadTheContent;
@property NSString *htmlString;
- (IBAction)shareBestKorea:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *share_button;

@end
