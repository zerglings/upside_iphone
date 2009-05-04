//
//  StockSearchCommController.h
//  upside
//
//  Created by Victor Costan on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelSupport.h"


// Communication controller for performing ticker search.
//
// Currently uses the JSONP interface from the Yahoo Finance Website.
@interface StockSearchCommController : NSObject {
  NSArray* responseQueries;
  SEL action;
  id target;
}

-(id)initWithTarget:(id)target action:(SEL)action;

-(void)startTickerSearch:(NSString*)queryString;
@end


// Model for the results returned by the ticker search controller.
@interface StockSearchData : ZNModel {
  NSString* symbol;
  NSString* name;
  NSString* exch;
  NSString* exchDisp;
  NSString* type;
}
// Ticker symbol. (e.g. AAPL)
@property (nonatomic,readonly,retain) NSString* symbol;
// Company name. (e.g. Apple Inc.)
@property (nonatomic,readonly,retain) NSString* name;
// Exchange. (e.g. NMS)
@property (nonatomic,readonly,retain) NSString* exch;
// Dispatch exchange? (e.g. NASDAQ)
@property (nonatomic,readonly,retain) NSString* exchDisp;
// Commodity type? (e.g. S - probably meaning stock)
@property (nonatomic,readonly,retain) NSString* type;
@end
