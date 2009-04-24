//
//  ActivationState+Signature.m
//  StockPlay
//
//  Created by Victor Costan on 1/29/09.
//  Copyright Zergling.Net. All rights reserved.
//

#import "CryptoSupport.h"

#import "ActivationState+Signature.h"
#import "Device.h"


@implementation ActivationState (Signature)

// The only bits protecting from widespread piracy of our service.
// Treat accordingly.
static const int8_t kDeviceSecret[] =
    "\245\023\240\237\324\362\311\021:C\232\243LI\"m";

static const NSString* kDeviceSignatureVersion = @"1";

-(NSDictionary*)requestSignature {
  NSString* udid = deviceInfo ? [deviceInfo uniqueId] :
      [Device currentDeviceId];
  
  // Compute the signature
  NSMutableData* signBytes = [[NSMutableData alloc] init];
  [signBytes appendData:[udid dataUsingEncoding:NSUTF8StringEncoding]];
  [signBytes appendBytes:kDeviceSecret length:(sizeof(kDeviceSecret) - 1)];
	NSString* hexDigest = [ZNSha2Digest copyHexDigest:signBytes];
  [signBytes release];
    
  // Web-ready signature data.
  NSDictionary* signature = [NSDictionary dictionaryWithObjectsAndKeys:
                             udid, @"uniqueID",
                             hexDigest, @"deviceSig",
                             kDeviceSignatureVersion, @"deviceSigV", nil];
  [hexDigest release];
  return signature;
}

@end
