//
//  StockSearchCommController.m
//  StockPlay
//
//  Created by Victor Costan on 5/3/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "StockSearchCommController.h"

#import "ControllerSupport.h"
#import "WebSupport.h"


@implementation StockSearchCommController

+(NSArray*)copyResponseQueries {
  return [[NSArray alloc] initWithObjects:
          [StockSearchData class], @"/*/Result/?", nil];
}

-(void)startTickerSearch:(NSString*)queryString {
  if ([queryString length] == 0) {
    // short-circuit
    [target performSelector:action withObject:[NSArray array]];
    return;
  }

  NSString* service = @"http://autoc.finance.yahoo.com/autoc";
  NSDictionary* requestData = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"YAHOO.Finance.SymbolSuggest.ssCallback",
                               @"callback", queryString, @"query", nil];
  [self callService:service
             method:kZNHttpMethodPost
               data:requestData];
  [requestData release];
}
@end


@implementation StockSearchData
@synthesize symbol, name, exch, exchDisp, type;

-(void)dealloc {
  [symbol release];
  [name release];
  [exch release];
  [exchDisp release];
  [type release];
  [super dealloc];
}
@end
