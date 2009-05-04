//
//  ZNDictionaryJsonParser.m
//  ZergSupport
//
//  Created by Victor Costan on 5/1/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNDictionaryJsonParser.h"

#import "ZNFormFieldFormatter.h"

#pragma mark JSON Parsing Core

// Singleton instance of the NSNumberFormatter used to parse JSON numbers.
static NSNumberFormatter* jsonNumberParser = nil;

// Holds the context required for JSON parsing.
typedef struct ZNJsonParseContext {
  ZNFormFieldFormatter* keyFormatter;
  const uint8_t* bytes;
  const uint8_t* endOfBytes;
} ZNJsonParseContext;

// Parses a JSON value. The cursor is at the value's beginning, plus whitespace.
static NSObject* ZNJSONParseValue(ZNJsonParseContext* context);

// Advances the cursor skipping over whitespace.
static void ZNJSONSkipWhiteSpace(ZNJsonParseContext* context) {
  while (context->bytes < context->endOfBytes) {
    uint8_t byte = *context->bytes;
    if (!isspace(byte)) {
      break;
    }
    context->bytes++;
  }
}

// Advances the cursor skipping over commas.
static void ZNJSONSkipComma(ZNJsonParseContext* context) {
  ZNJSONSkipWhiteSpace(context);
  if (context->bytes < context->endOfBytes && *context->bytes == ',') {
    context->bytes++;
  }
}

// Parses an JSON string. The cursor is right after the opening " or '.
//
// The terminator argument indicates whether the string ends with ' or ".
static NSString* ZNJSONParseString(ZNJsonParseContext* context,
                                   uint8_t terminator) {
  const uint8_t* stringStart = context->bytes;
  BOOL escapes = NO;  // Set to YES when escape sequences are detected.
  while (context->bytes < context->endOfBytes &&
         *context->bytes != terminator) {
    if (*context->bytes == '\\') {
      escapes = YES;
      context->bytes++;  // skip over whatever the next character is
    }
    context->bytes++;
  }
  if (context->bytes >= context->endOfBytes) {
    return nil;
  }
  NSUInteger stringLength = context->bytes - stringStart;
  if (escapes) {
    // Escape sequences detected. Slow code path.
    NSMutableString* string = [[NSMutableString alloc]
                               initWithCapacity:stringLength];
    while (stringStart < context->bytes) {
      // Parse escape-less sequence.
      const uint8_t* plainStart = stringStart;
      while (stringStart < context->bytes && *stringStart != '\\')
        stringStart++;
      if (plainStart != stringStart) {
        NSString* stringPiece =
            [[NSString alloc] initWithBytes:plainStart
                                     length:(stringStart - plainStart)
                                   encoding:NSUTF8StringEncoding];
        [string appendString:stringPiece];
        [stringPiece release];
      }

      // Parse escape sequence.
      stringStart++;
      if (stringStart < context->bytes) {
        switch (*stringStart) {
          case 'b':
            [string appendString:@"\b"];
            stringStart++;
            break;
          case 'f':
            [string appendString:@"\f"];
            stringStart++;
            break;
          case 'n':
            [string appendString:@"\n"];
            stringStart++;
            break;
          case 'r':
            [string appendString:@"\r"];
            stringStart++;
            break;
          case 't':
            [string appendString:@"\t"];
            stringStart++;
            break;
          case 'u': {  // Unicode character
            unichar character = 0;
            for (int i = 0; i < 4; i++) {
              stringStart++;
              if (stringStart >= context->bytes)
                break;
              character <<= 4;
              character |= (*stringStart <= '9') ? (*stringStart - '0') :
                  ((*stringStart <= 'Z') ? (*stringStart - 'A' + 10) :
                   (*stringStart - 'a' + 10));
            }
            NSString* stringPiece = [[NSString alloc]
                                     initWithCharacters:&character length:1];
            [string appendString:stringPiece];
            [stringPiece release];
            stringStart++;
            break;
          }
          default: {  // ', ", \ or /
            NSString* stringPiece =
                [[NSString alloc] initWithBytes:stringStart
                                         length:1
                                       encoding:NSUTF8StringEncoding];
            [string appendString:stringPiece];
            [stringPiece release];
            stringStart++;
          }
        }
      }
    }
    context->bytes++;
    NSString* returnValue = [[NSString alloc] initWithString:string];
    [string release];
    return returnValue;
  }
  else {
    // No escape sequences. Fast code path.
    context->bytes++;
    return [[NSString alloc] initWithBytes:stringStart
                                    length:stringLength
                                  encoding:NSUTF8StringEncoding];
  }
}

// Parses an expected JSON primitive. Cursor is at the primitive's beginning.
static NSObject* ZNJSONParsePrimitive(ZNJsonParseContext* context,
                                      char* expectedText,
                                      NSUInteger expectedLength,
                                      NSObject* primitive) {
  if (context->bytes + expectedLength > context->endOfBytes ||
      memcmp(context->bytes, expectedText, expectedLength)) {
    return nil;
  }
  context->bytes += expectedLength;

  return primitive;
}

// Parses a JSON number. The cursor is at the first character.
static NSNumber* ZNJSONParseNumber(ZNJsonParseContext* context) {
  const uint8_t* numberStart = context->bytes;
  while (context->bytes < context->endOfBytes) {
    switch(*context->bytes) {
      case 'e':
      case 'E':
      case '.':
        // If we ever need a float flag, flip here and break.
      case '-':
        // If we ever need a sign flag, flip here and break.
      case '+':
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
        break;
      default:
        goto breakOutOfWhile;  // Breaks out of the enclosing while.
    }
    context->bytes++;
  }
breakOutOfWhile:

  {
    NSUInteger numberLength = context->bytes - numberStart;
    if (numberLength == 0) {
      return nil;
    }
    NSString* numberString =
      [[NSString alloc] initWithBytes:numberStart
                               length:numberLength
                             encoding:NSUTF8StringEncoding];
    NSNumber* number = [jsonNumberParser numberFromString:numberString];
    [numberString release];
    [number retain];
    return number;
  }
}

// Parses an JSON array. The cursor is right after the opening [.
//
// Returns a NSArray representing the array, owned by the caller.
static NSArray* ZNJSONParseArray(ZNJsonParseContext* context) {
  NSMutableArray* array = [[NSMutableArray alloc] init];

  while (true) {
    ZNJSONSkipWhiteSpace(context);
    if (context->bytes >= context->endOfBytes) {
      [array release];
      return nil;
    }
    if (*context->bytes == ']') {
      context->bytes++;
      break;
    }

    NSObject* object = ZNJSONParseValue(context);
    if (!object) {
      [array release];
      return nil;
    }
    [array addObject:object];

    ZNJSONSkipComma(context);
  }

  NSArray* returnValue = [[NSArray alloc] initWithArray:array];
  [array release];
  return returnValue;
}

// Parses an JSON object. The cursor is right after the opening {.
//
// Returns a NSDictionary representing the object, owned by the caller.
static NSDictionary* ZNJSONParseObject(ZNJsonParseContext* context) {
  NSMutableDictionary* object = [[NSMutableDictionary alloc] init];

  while (true) {
    // Whitespace
    ZNJSONSkipWhiteSpace(context);
    if (context->bytes >= context->endOfBytes) {
      [object release];
      return nil;
    }
    // End of object?
    if (*context->bytes == '}') {
      context->bytes++;
      break;
    }

    if (*context->bytes != '"' && *context->bytes != '\'') {
      [object release];
      return nil;
    }

    // Property name.
    NSString* rawName = ZNJSONParseString(context, *context->bytes++);
    if (!rawName) {
      [object release];
      return nil;
    }
    NSString* name = [context->keyFormatter copyFormattedName:rawName];
    [rawName release];

    // : separator
    ZNJSONSkipWhiteSpace(context);
    if (context->bytes >= context->endOfBytes || *context->bytes != ':') {
      [name release];
      [object release];
      return nil;
    }
    context->bytes++;

    // Value
    NSObject* value = ZNJSONParseValue(context);
    if (!value) {
      [name release];
      [object release];
      return nil;
    }
    [object setValue:value forKey:name];
    [value release];

    // Potential , separator
    ZNJSONSkipComma(context);
  }
  NSDictionary* returnValue = [[NSDictionary alloc] initWithDictionary:object];
  [object release];
  return returnValue;
}

// Parses a JSON value. The cursor is at the value's beginning, plus whitespace.
static NSObject* ZNJSONParseValue(ZNJsonParseContext* context) {
  ZNJSONSkipWhiteSpace(context);
  if (context->bytes >= context->endOfBytes) {
    return nil;
  }

  switch (*context->bytes) {
    case '"':  // String.
    case '\'':
      return ZNJSONParseString(context, *(context->bytes++));

    case '[':  // Array.
      context->bytes++;
      return ZNJSONParseArray(context);

    case '{':  // Object
      context->bytes++;
      return ZNJSONParseObject(context);

    case 't':  // true
      return ZNJSONParsePrimitive(context, "true", 4,
                                  [[NSNumber alloc] initWithBool:YES]);

    case 'f':  // false
      return ZNJSONParsePrimitive(context, "false", 5,
                                  [[NSNumber alloc] initWithBool:NO]);

    case 'n':  // null
      return ZNJSONParsePrimitive(context, "null", 4, [[NSNull alloc] init]);

    default:  // number
      return ZNJSONParseNumber(context);
  }
}

static NSDictionary *ZNJSONParseData(ZNJsonParseContext* context) {
  // Skip everything up to { to account for JSONP et al.
  while (context->bytes < context->endOfBytes && *context->bytes != '{') {
    context->bytes++;
  }

  // No JSON.
  if (context->bytes == context->endOfBytes)
    return NO;

  context->bytes++;
  return ZNJSONParseObject(context);
}

#pragma mark Objective C Interface

@implementation ZNDictionaryJsonParser

@synthesize context, delegate;

+(void)setupParsers {
  @synchronized([ZNDictionaryJsonParser class]) {
    if (jsonNumberParser == nil) {
      jsonNumberParser = [[NSNumberFormatter alloc] init];
      [jsonNumberParser setPositiveFormat:@"###0.##"];
      [jsonNumberParser setNegativeFormat:@"-###0.##"];
    }
  }
}

-(id)init {
  return [self initWithKeyFormatter:[ZNFormFieldFormatter identityFormatter]];
}

-(id)initWithKeyFormatter:(ZNFormFieldFormatter*)theKeyFormatter {
  if ((self = [super init])) {
    [ZNDictionaryJsonParser setupParsers];
    keyFormatter = [theKeyFormatter retain];
  }
  return self;
}

-(void)dealloc {
  [keyFormatter release];
  [super dealloc];
}

-(BOOL)parseData:(NSData*)data {
  ZNJsonParseContext parseContext;
  parseContext.keyFormatter = keyFormatter;
  parseContext.bytes = [data bytes];
  parseContext.endOfBytes = parseContext.bytes + [data length];

  NSDictionary* jsonData = ZNJSONParseData(&parseContext);
  if (!jsonData) {
    return NO;
  }
  [delegate parsedJson:jsonData context:context];
  return YES;
}


+(NSObject*)parseValue:(NSString*)jsonValue {
  [ZNDictionaryJsonParser setupParsers];

  NSData* data = [jsonValue dataUsingEncoding:NSUTF8StringEncoding];
  ZNJsonParseContext parseContext;
  parseContext.keyFormatter = [ZNFormFieldFormatter identityFormatter];
  parseContext.bytes = [data bytes];
  parseContext.endOfBytes = parseContext.bytes + [data length];

  return ZNJSONParseValue(&parseContext);
}

@end
