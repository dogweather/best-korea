//
//  RSSItem.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "RSSItem.h"
#import "GTMNSString+HTML.h"

@implementation RSSItem



- (NSURL *)resolvedUrl {
    NSString * proxyUrl = [self.link.absoluteString
                               stringByReplacingOccurrencesOfString:@"www.workers.org"
                               withString:@"proxy1.bestkoreaapp.com"];
    return [NSURL URLWithString:proxyUrl];
}


-(NSString *)shortRelativeTime {
    return [self formatShortRelativeTime:self.pubDate];
}


- (NSString*)formatShortRelativeTime:(NSDate *)pubDate {
    NSTimeInterval elapsed = abs([pubDate timeIntervalSinceNow]);
    
    int TT_MINUTE = 60;
    int TT_HOUR   = 60 * TT_MINUTE;
    int TT_DAY    = 24 * TT_HOUR;
    int TT_WEEK   = 7 * TT_DAY;
    
    if (elapsed < TT_MINUTE) {
        return @"<1m";
        
    } else if (elapsed < TT_HOUR) {
        int mins = (int)(elapsed / TT_MINUTE);
        return [NSString stringWithFormat:@"%dm", mins];
        
    } else if (elapsed < TT_DAY) {
        int hours = (int)((elapsed + TT_HOUR / 2) / TT_HOUR);
        return [NSString stringWithFormat:@"%dh", hours];
        
    } else if (elapsed < TT_WEEK) {
        int day = (int)((elapsed + TT_DAY / 2) / TT_DAY);
        return [NSString stringWithFormat:@"%dd", day];
        
    } else {
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        return [NSString stringWithFormat:@"on %@", [formatter stringFromDate:pubDate]];
    }
}




-(NSAttributedString*)cellMessage
{
    if (_cellMessage != nil) return _cellMessage;
    
    NSDictionary* boldStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:16.0]};
    NSDictionary* normalStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14.0]};
    
  
    // The article title
    NSMutableAttributedString* articleAbstract = [[NSMutableAttributedString alloc] initWithString:self.title];
    [articleAbstract setAttributes:boldStyle
                             range:NSMakeRange(0, self.title.length)];

    [articleAbstract appendAttributedString:
     [[NSAttributedString alloc] initWithString:@"\n"]
     ];

    // The publication name
    [articleAbstract appendAttributedString:
     [[NSAttributedString alloc] initWithString: self.publication]
     ];
    
    [articleAbstract setAttributes:normalStyle
                             range:NSMakeRange(self.title.length + 1, self.publication.length)];
    
    _cellMessage = articleAbstract;
    return _cellMessage;    
}

@end
