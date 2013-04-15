//
//  AppDelegate.h
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "RNCachingURLProtocol.h"

#define NORMAL_STYLE_FILE    @"uiss"
#define ALTERNATE_STYLE_FILE @"uiss-alternative"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property int party_placeholders;

- (void) setLookAndFeel;
- (void) setMyTitle: (UINavigationItem*)navItem andFont: (UIViewController*)controller;
- (void) toggleRealityFor: (UIViewController*) controller;
- (void) setAlternateRealityTo:(BOOL)alternate for:(UIViewController*)controller;

// Methods views use to store and find out which
// of their content has already been seen.
-(void)markAsSeen:(NSString *)url;
-(BOOL)wasSeen:(NSString *)url;


@end
