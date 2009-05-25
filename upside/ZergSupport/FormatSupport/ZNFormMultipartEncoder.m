//
//  ZNFormMultipartEncoder.m
//  ZergSupport
//
//  Created by Victor Costan on 5/24/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNFormMultipartEncoder.h"

#import "ZNFormFieldFormatter.h"

@interface ZNFormMultipartEncoder ()
@property (nonatomic, readonly, retain) NSData* boundary;
@end


@implementation ZNFormMultipartEncoder
@synthesize boundary;

#pragma mark Boundary

static char kBoundaryCharacters[] =
    "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_!@";
static const NSUInteger kBoundaryLength = 16;

// Randomly-generated boundary string.
+(NSData*)newRandomBoundary {
  const size_t kBoundaryCharCount = sizeof(kBoundaryCharacters) - 1;
  char boundary[kBoundaryLength];
  for(size_t i = 0; i < kBoundaryLength; i++) {
    boundary[i] = kBoundaryCharacters[rand() % kBoundaryCharCount];
  }
  return [[NSData alloc] initWithBytes:boundary length:kBoundaryLength];
}

#pragma mark Lifecycle

-(id)initWithFieldFormatter:(ZNFormFieldFormatter*)theFieldFormatter {
  if ((self = [super initWithFieldFormatter:theFieldFormatter])) {
    boundary = [[self class] newRandomBoundary];
    boundaryBytes = [boundary bytes];
    boundaryLength = [boundary length];
    NSAssert(boundaryLength == kBoundaryLength, @"Wrong boundary length");
  }
  return self;
}
-(void)dealloc {
  [boundary release];
  [super dealloc];
}

+(NSData*)copyEncodingFor:(NSDictionary*)dictionary
      usingFieldFormatter:(ZNFormFieldFormatter*)formatter {
  // The encoder will set its output to nil if the randomly generated boundary
  // is contained inside the encoded data. If that happens, the encoding is
  // re-started, with another randomly generated boundary.
  //
  // The chance of a collision is abysmall (close to the chance of
  // an encryption key being randomly contained in a binary), but it's nice to
  // know there's a backup for that case.
  while(true) {
    ZNFormMultipartEncoder* encoder =
        [[self alloc] initWithFieldFormatter:formatter];
    [encoder encode:dictionary];
    NSMutableData* output = [[encoder output] retain];
    [output appendBytes:"--" length:2];
    [output appendData:[encoder boundary]];
    [output appendBytes:"--\r\n" length:4];
    [encoder release];
    if (output) {
      return output;
    }
  }
}

#pragma mark Encoding

// Checks if the boundary is contained in the given data;
-(BOOL)boundaryContainedIn:(NSData*)data {
  const uint8_t* dataBytes = [data bytes];
  NSUInteger dataLength = [data length];
  if (dataLength < boundaryLength) {
    return NO;
  }

  // NOTE: this can be much improved, if anyone cares
  for (NSUInteger loopTimes = dataLength - boundaryLength + 1;
       loopTimes != 0; loopTimes--, dataBytes++) {
    if (!memcmp(boundaryBytes, dataBytes, boundaryLength)) {
      return YES;
    }
  }
  return NO;
}

-(void)outputValue:(NSString*)value forKey:(NSString*)key {
  NSData* encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
  NSData* encodedValue = [value dataUsingEncoding:NSUTF8StringEncoding];
  if ([self boundaryContainedIn:encodedKey] ||
      [self boundaryContainedIn:encodedValue]) {
    [output release];
    output = nil;
    return;
  }

  [output appendBytes:"--" length:2];
  [output appendData:boundary];
  [output appendBytes:"\r\nContent-Disposition: form-data; name=\"" length:40];
  [output appendData:encodedKey];
  [output appendBytes:"\"\r\nContent-Type: text-plain; charset=utf8;\r\n\r\n"
               length:46];
  [output appendData:encodedValue];
  [output appendBytes:"\r\n" length:2];
}

+(NSString*)copyContentTypeFor:(NSData*)encodedData {
  const NSUInteger prefixLength = 30;
  char contentTypeBuffer[prefixLength + kBoundaryLength];

  const uint8_t* dataBytes = [encodedData bytes];
  NSUInteger i = 2;
  while (dataBytes[i] != '\r' && dataBytes[i] != '-') {
    i++;
  }
  memcpy(contentTypeBuffer, "multipart/form-data; boundary=", prefixLength);
  memcpy(contentTypeBuffer + prefixLength, dataBytes + 2, i - 2);

  return [[NSString alloc] initWithBytes:contentTypeBuffer
                                  length:(prefixLength + i - 2)
                                encoding:NSUTF8StringEncoding];
}

@end
