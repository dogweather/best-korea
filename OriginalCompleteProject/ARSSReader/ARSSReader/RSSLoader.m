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

//
// Retrieve the RSS feed and parse into RSSItem objects.
//
-(void)fetchRssWithURL:(NSURL*)url complete:(RSSLoaderCompleteBlock)c
{
    dispatch_async(kBgQueue, ^{
        RXMLElement *rss   = [RXMLElement elementFromURL: url];
        if (! rss.isValid) {
            c(@[]);
        } else {
            NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO];
            NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
            NSMutableArray* results = [NSMutableArray arrayWithCapacity:10];
            
            NSArray *items          = [[rss child:@"channel"] children:@"item"];
            
            for (RXMLElement *e in items) {
                // iterate over the articles
                RSSItem* item  = [[RSSItem alloc] init];
                item.link      = [NSURL URLWithString: [[e child:@"link"] text]];
                item.pubDate   = [RSSLoader dateFromRFC822:[[e child:@"pubDate"] text]];

                NSString *guid = [[e child:@"guid"] text];
                if ([guid rangeOfString:@"google.com"].location != NSNotFound) {
                    // Google format
                    NSString *rawTitle = [[e child:@"title"] text];
                    item.title       = [[rawTitle componentsSeparatedByString:@" - "] objectAtIndex:0];
                    item.publication = [[rawTitle componentsSeparatedByString:@" - "] lastObject];
                    item.imageUrl    = [self imageUrlFromGoogleDescription:[[e child:@"description"] text]];
                } else {
                    // Other "standard" rss
                    item.title       = [[e child:@"title"] text];
                    item.publication = [[e child:@"srsly-source"] text];
                }
                
                [results addObject: item];
            }
            c([results sortedArrayUsingDescriptors:descriptors]);
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


+ (NSDateFormatter *)rfc822Formatter {
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
    	formatter = [[NSDateFormatter alloc] init];
    	NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    	[formatter setLocale:enUS];
    	[formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
    }
    return formatter;
}

+ (NSDate *)dateFromRFC822:(NSString *)date {
    NSDateFormatter *formatter = [self rfc822Formatter];
    return [formatter dateFromString:date];
}

@end
