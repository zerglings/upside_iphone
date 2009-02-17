//
//  SenTestCase+Fixtures.h
//  ZergSupport
//
//  Created by Victor Costan on 2/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "GTMSenTestCase.h"

@interface SenTestCase (Fixtures)

// Loads fixtures (models) from the given file.  
-(NSArray*)fixturesFrom: (NSString*)fileName;

@end
