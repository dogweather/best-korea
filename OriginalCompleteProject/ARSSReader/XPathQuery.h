//
//  XPathQuery.h
//  FuelFinder
//
//  Created by Matt Gallagher on 4/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#define TFHppleErrorDomain								@"TFHppleErrorDomain"
#define TFHppleErrorCodeUnableToEvaluateOrParse			100
#define TFHppleErrorCodeUnableToCreateParsingContext	101

typedef enum : NSInteger {
	TFHppleFetchRawContentNever,
	TFHppleFetchRawContentTopLevelNodesOnly,
	TFHppleFetchRawContentTopLevelAndChildNodes,		// Excludes grandchildren
	TFHppleFetchRawContentAllNodes
} TFHppleFetchRawContent;

NSArray *PerformHTMLXPathQuery(NSData *document, NSString *query, TFHppleFetchRawContent wantsRawContent, NSError **error);
NSArray *PerformXMLXPathQuery(NSData *document, NSString *query, TFHppleFetchRawContent wantsRawContent, NSError **error);
