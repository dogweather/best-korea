//
//  RSSLoader.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "RSSLoader.h"
#import "RXMLElement.h"
#import "RSSItem.h"
#import "TFHpple.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@implementation RSSLoader

-(void)fetchRssWithURL:(NSURL*)url complete:(RSSLoaderCompleteBlock)c
{
    dispatch_async(kBgQueue, ^{
        RXMLElement *rss   = [RXMLElement elementFromURL: url];
        if (! rss.isValid) {
            c(@[]);
        } else {
            NSArray *items     = [[rss child:@"channel"] children:@"item"];
          
            NSMutableArray* results = [NSMutableArray arrayWithCapacity:items.count];
            
            for (RXMLElement *e in items) {
                //iterate over the articles
                RSSItem* item = [[RSSItem alloc] init];
                NSString *rawTitle = [[e child:@"title"] text];

                item.title       = [[rawTitle componentsSeparatedByString:@" - "] objectAtIndex:0];
                item.link        = [NSURL URLWithString: [[e child:@"link"] text]];
                item.publication = [[rawTitle componentsSeparatedByString:@" - "] lastObject];
                item.imageUrl    = [self imageUrlFromGoogleDescription:[[e child:@"description"] text]];
                [results addObject: item];
            }
            c(results);
        }
    });
}


// Parse Google's proprietary RSS Description element, which is HTML.
// Retrieve the contained image url if any.
// Return nil if no image url is found.
-(NSString*) imageUrlFromGoogleDescription:(NSString*)description {
    NSString * result = nil;
    NSString * xpath  = @"//table/tr/td/font/a/img";  // Last checked 2013-03-24
    
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:[description dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *nodes  = [parser searchWithXPathQuery:xpath];
    if ([nodes count] == 1) {
        result = [[nodes objectAtIndex:0] objectForKey:@"src"];
        result = [@"https:" stringByAppendingString:result];
    }
    
    return result;
}

@end
