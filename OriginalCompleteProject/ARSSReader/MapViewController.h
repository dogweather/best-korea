//
//  MapViewController.h
//  bestkorea
//
//  Created by Robb Shecter on 4/11/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"

@interface MapViewController : UIViewController<UIScrollViewDelegate>

@property NSString *mapFileName;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
