//
//  ZNXmlHttpRequest.m
//  ZergSupport
//
//  Created by Victor Costan on 1/16/09.
//  Copyright Zergling.Net. Licensed under the MIT license.
//

#import "ZNXmlHttpRequest.h"

#import "ModelSupport.h"
#import "ZNDictionaryXmlParser.h"
#import "ZNFormFieldFormatter.h"


@interface ZNXmlHttpRequest () <ZNDictionaryXmlParserDelegate> 
+(NSDictionary*)copyParserSchemaFor: (NSDictionary*)responseModels
                               casing: (ZNFormatterCasing)responseCasing;
@end

@implementation ZNXmlHttpRequest

#pragma mark Lifecycle

-(id)initWithURLRequest: (NSURLRequest*)theRequest
           responseModels: (NSDictionary*)theResponseModels
           responseCasing: (ZNFormatterCasing)responseCasing
                   target: (NSObject*)theTarget
                   action: (SEL)theAction {
	if ((self = [super initWithURLRequest:theRequest
                                 target:theTarget
                                 action:theAction])) {
		response = [[NSMutableArray alloc] init];
    NSDictionary* parserSchema =
        [ZNXmlHttpRequest copyParserSchemaFor:theResponseModels
                                       casing:responseCasing];
		responseParser = [[ZNDictionaryXmlParser alloc]
                      initWithSchema:parserSchema];
		responseParser.delegate = self;
    [parserSchema release];
		responseModels = [theResponseModels retain];		
	}
	return self;
}

-(void)dealloc {
	[response release];
	[responseParser release];
	[responseModels release];
	[super dealloc];
}

+(void)callService: (NSString*)service
              method: (NSString*)method
                data: (NSDictionary*)data
         fieldCasing: (ZNFormatterCasing)fieldCasing
      responseModels: (NSDictionary*)responseModels
      responseCasing: (ZNFormatterCasing)responseCasing
              target: (NSObject*)target
              action: (SEL)action {
	NSURLRequest* urlRequest = [self newURLRequestToService:service
                                                   method:method
                                                     data:data
                                              fieldCasing:fieldCasing];
	ZNXmlHttpRequest* request =
  [[ZNXmlHttpRequest alloc] initWithURLRequest:urlRequest
                                responseModels:responseModels
                                responseCasing:responseCasing
                                        target:target
                                        action:action];
	[request start];
	[urlRequest release];
	[request release];
}

+(void)callService: (NSString*)service
              method: (NSString*)method
                data: (NSDictionary*)data
      responseModels: (NSDictionary*)responseModels
              target: (NSObject*)target
              action: (SEL)action {
  return [self callService:service
                    method:method
                      data:data
               fieldCasing:kZNFormatterSnakeCase
            responseModels:responseModels
            responseCasing:kZNFormatterSnakeCase
                    target:target
                    action:action];
}

#pragma mark ZNDictionaryXmlParser Delegate

-(void)parsedItem: (NSDictionary*)itemData
               name: (NSString*)itemName
            context: (id)context {
	id modelClass = [responseModels objectForKey:itemName];
	if ([ZNModel isModelClass:modelClass]) {
		NSObject* responseModel = [[modelClass alloc]
                               initWithModel:nil properties:itemData];
		[response addObject:responseModel];
		[responseModel release];
	}
	else {
		[response addObject:itemData];
	}
}

+(NSDictionary*)copyParserSchemaFor: (NSDictionary*)responseModels
                               casing: (ZNFormatterCasing)responseCasing {
  ZNFormFieldFormatter* formatter =
      [ZNFormFieldFormatter formatterToPropertiesFrom:responseCasing];
  NSMutableArray* keys = [[NSMutableArray alloc]
                          initWithCapacity:[responseModels count]];
  NSMutableArray* values = [[NSMutableArray alloc]
                            initWithCapacity:[responseModels count]];
  for (NSString* modelName in responseModels) {
    [keys addObject:modelName];
    NSArray* directions = [[NSArray alloc] initWithObjects:
                           formatter, [responseModels objectForKey:modelName],
                           nil];
    [values addObject:directions];
    [directions release];
  }
  NSDictionary* schema = [[NSDictionary alloc] initWithObjects:values
                                                       forKeys:keys];
  [keys release];
  [values release];
  return schema;
}

#pragma mark Delegate Invocation

-(void)reportData {
	NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
	[responseParser parseData:responseData];
	[arp release];
	[target performSelector:action withObject:response];	
}

@end
