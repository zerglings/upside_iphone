//
//  TestSupport.h
//  ZergSupport
//
//  Created by Victor Costan on 1/17/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

// Main header file for the Zergling.Net Test Support.

// TestSupport repackages the minimum set of files needed to run unit tests on
// the iPhone, from the Google Toolbox for Mac. To use it, import TestSupport.h
// in your tests, and follow the instructions below to set up a test build:
// http://code.google.com/p/google-toolbox-for-mac/wiki/iPhoneUnitTesting
#import "GTMSenTestCase.h"
// LEGAL: These files are released by Google under the Apache License 2.0,
// reproduced in TestSupport/GTM/COPYING. The rest of TestSupport is copyright
// Zergling.Net, and licensed under the MIT license.


// TestSupport repackages the files needed to run OCMock tests on the iPhone,
// from the original OCMock source. Importing TestSupport.h gives access to
// OCMock for free.
#import "OCMock.h"
// LEGAL: These files are released by Mulle Kybernetik under the MIT license,
// reproduced in TestSupport/OCMock/License.txt. The rest of TestSupport is
// copyright Zergling.Net, and licensed under the MIT license.


// The Test Support features are documented in their respective headers.

#import "ZNSenTestCase+Fixtures.h"
