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
