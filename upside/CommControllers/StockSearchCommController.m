//
//  StockSearchCommController.m
//  upside
//
//  Created by Victor Costan on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StockSearchCommController.h"

#import "NetworkProgress.h"
#import "WebSupport.h"


@implementation StockSearchCommController
-(id)initWithTarget:(id)theTarget action:(SEL)theAction {
  if ((self = [super init])) {
    target = theTarget;
    action = theAction;
    
    responseQueries = [[NSArray alloc] initWithObjects:
                       [StockSearchData class], @"/*/Result/?", nil];
  }
  return self;
}

-(void)dealloc {
  [responseQueries release];
  [super dealloc];
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
  [NetworkProgress connectionStarted];
  [ZNJsonHttpRequest callService:service
                          method:kZNHttpMethodPost
                            data:requestData
                 responseQueries:responseQueries
                          target:self
                          action:@selector(processResponse:)];
  [requestData release];
}

-(void)processResponse:(NSObject*)response {
  [NetworkProgress connectionDone];
  [target performSelector:action withObject:response];
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
