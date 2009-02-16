//
//  SenTestCase+Fixtures.h
//  upside
//
//  Created by Victor Costan on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GTMSenTestCase.h"

@interface SenTestCase (Fixtures)

// Loads fixtures (models) from the given file.  
-(NSArray*)fixturesFrom: (NSString*)fileName;

@end
