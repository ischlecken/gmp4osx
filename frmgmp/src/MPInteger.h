//
//  MPInteger.h
//  frmgmp
//
//  Created by Stefan Thomas on 22.07.12.
//  Copyright (c) 2012 volt delta international. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPInteger : NSObject

-(id) initWithString:(NSString*)str;
-(id) initWithInteger:(NSInteger)i;
-(id) initWithUnsignedInteger:(NSUInteger)i;
-(id) initWithNumber:(NSNumber*)i;

+(MPInteger*) mpIntegerWithString:(NSString*)s;

-(NSString*)     stringValue;
-(unsigned long) uintValue;
-(long)          intValue;
-(double)        doubleValue;

-(MPInteger*) add:(MPInteger*)a;
-(MPInteger*) sub:(MPInteger*)a;
-(MPInteger*) mul:(MPInteger*)a;
-(MPInteger*) div:(MPInteger*)d;
-(MPInteger*) mod:(MPInteger*)d;
-(MPInteger*) pow:(unsigned long)exp;
-(MPInteger*) powm:(MPInteger*)exp using:(MPInteger*)mod;
@end
