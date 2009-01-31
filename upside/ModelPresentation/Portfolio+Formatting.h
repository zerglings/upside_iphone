//
//  Portfolio+Formatting.h
//  StockPlay
//
//  Created by Victor Costan on 1/30/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "Portfolio.h"


// Presentation aspect for portfolio information.
@interface Portfolio (Formatting)

// Format the available cash in the portfolio.
- (NSString*)formattedCash;

// The color showing the available cash in the portfolio.
- (UIColor*)colorForCash;
@end
