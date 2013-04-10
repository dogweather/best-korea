//
//  RSSItem.h
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* publication;
@property (strong, nonatomic) NSURL*    link;
@property (strong, nonatomic) NSString* imageUrl;
@property (strong, nonatomic) UIImage*  image;
@property NSDate *pubDate;
@property (strong, nonatomic) NSAttributedString* cellMessage;

-(NSURL *) resolvedUrl;
-(NSString *) shortRelativeTime;
-(BOOL) isFromToday;
-(BOOL) isFromYesterday;

@end