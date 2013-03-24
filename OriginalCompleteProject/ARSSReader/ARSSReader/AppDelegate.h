//
//  AppDelegate.h
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import <UIKit/UIKit.h>

#define NORMAL_STYLE    @"uiss"
#define ALTERNATE_STYLE @"uiss-alternative"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void) setLookAndFeel;
- (void) setMyTitle: (UINavigationItem*) navItem;

@end
