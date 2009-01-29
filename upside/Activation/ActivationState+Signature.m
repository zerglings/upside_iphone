//
//  ActivationState+Signature.m
//  upside
//
//  Created by Victor Costan on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActivationState+Signature.h"
#import "Device.h"

#import <CommonCrypto/CommonDigest.h>

@implementation ActivationState (Signature)

// The only bits protecting from widespread piracy of our service.
// Treat accordingly.
static const int8_t kDeviceSecret[] =
    "\245\023\240\237\324\362\311\021:C\232\243LI\"m";

static const NSString* kDeviceSignatureVersion = @"1";

- (NSDictionary*) requestSignature {
  NSString* udid = deviceInfo ? [deviceInfo uniqueId] :
      [Device currentDeviceId];
  
  // Compute the signature
	uint8_t digestBuffer[CC_SHA256_DIGEST_LENGTH];
  NSMutableData* signBytes = [[NSMutableData alloc] init];
  [signBytes appendData:[udid dataUsingEncoding:NSUTF8StringEncoding]];
  [signBytes appendBytes:kDeviceSecret length:(sizeof(kDeviceSecret) - 1)];
	CC_SHA256([signBytes bytes], [signBytes length], digestBuffer);
  [signBytes release];
  
  // Convert the signature to hexdigest format
	NSMutableString* hexDigest = [[NSMutableString alloc] init];
	for (NSUInteger i = 0;
       i < sizeof(digestBuffer) / sizeof(*digestBuffer);
       i++) {
		[hexDigest appendFormat:@"%02x", digestBuffer[i]];
	}
  
  // Web-ready signature data.
  NSDictionary* signature = [NSDictionary dictionaryWithObjectsAndKeys:
                             udid, @"uniqueID",
                             hexDigest, @"deviceSig",
                             kDeviceSignatureVersion, @"deviceSigV", nil];
  [hexDigest release];
  return signature;
}

@end
