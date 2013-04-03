//
//  Video.h
//  bestkorea
//
//  Created by Robb Shecter on 3/22/13.
//  Copyright (c) 2013 Srsly.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property NSString* title;
@property NSString* url;
@property NSString* shareUrl;
@property NSString* source;
@property NSString* pubDate;
@property UIImage*  image;

-(NSString *) imageUrl;

@end
