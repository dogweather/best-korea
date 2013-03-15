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

-(NSAttributedString*)cellMessage
{
    if (_cellMessage != nil) return _cellMessage;
    
    NSDictionary* boldStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:16.0]};
    NSDictionary* normalStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14.0]};
    
  
    // The article title
    NSString* the_title = [[self.title componentsSeparatedByString:@" - "] objectAtIndex:0];
    NSMutableAttributedString* articleAbstract = [[NSMutableAttributedString alloc] initWithString:the_title];
    [articleAbstract setAttributes:boldStyle
                             range:NSMakeRange(0, the_title.length)];

    [articleAbstract appendAttributedString:
     [[NSAttributedString alloc] initWithString:@"\n"]
     ];

    // The publication name
    NSString* publication = [[self.title componentsSeparatedByString:@" - "] lastObject];
    [articleAbstract appendAttributedString:
     [[NSAttributedString alloc] initWithString: publication]
     ];
    
    [articleAbstract setAttributes:normalStyle
                             range:NSMakeRange(the_title.length + 1, publication.length)];
    
    _cellMessage = articleAbstract;
    return _cellMessage;    
}

@end
