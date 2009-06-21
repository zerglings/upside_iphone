//
//  PortfolioCommController.h
//  StockPlay
//
//  Created by Victor Costan on 1/23/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ControllerSupport.h"


// Retrieves portfolio sync data.
@interface PortfolioCommController : ZNHttpJsonCommController {
}
-(void)sync;
@end
