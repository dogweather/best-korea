//
//  MapViewController.h
//  bestkorea
//
//  Created by Robb Shecter on 4/11/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController
{
    CGFloat previousScale;
    CGFloat previousRotation;
    CGFloat beginX;
    CGFloat beginY;
}
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;
@property NSString *mapFileName;

@end
