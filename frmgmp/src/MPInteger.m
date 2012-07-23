//
//  MPInteger.m
//  frmgmp
//
//  Created by Stefan Thomas on 22.07.12.
//  Copyright (c) 2012 volt delta international. All rights reserved.
//

#import "MPInteger.h"
#import <libgmp/gmp.h>

@interface MPInteger()
{
@private
  mpz_t _number;
  
}

@end

@implementation MPInteger

/**
 *
 */
-(id)          init
{ self = [super init];
  
  if( self!=nil )
    mpz_init(_number);
  
  return self;
}

/**
 *
 */
-(id)          initWithString:(NSString*)str
{ self = [self init];
  
  if( self!=nil && mpz_set_str (_number,[str UTF8String], 0)!=0 )
    self = nil;
  
  return self;
}

/**
 *
 */
-(id)          initWithInteger:(NSInteger)i
{ self = [self init];
  
  if( self!=nil )
    mpz_set_si(_number,i);
  
  return self;
}

/**
 *
 */
-(id)          initWithUnsignedInteger:(NSUInteger)i
{ self = [self init];
  
  if( self!=nil )
    mpz_set_ui(_number,i);
  
  return self;
}

/**
 *
 */
-(id)          initWithNumber:(NSNumber*)i
{ self = [self init];
  
  if( self!=nil )
    mpz_set_ui(_number,[i unsignedLongValue]);
  
  return self;
}

/**
 *
 */
-(void) dealloc
{ mpz_clear(_number);
}

/**
 *
 */
-(NSString*) description
{ NSMutableString* result = [NSMutableString stringWithCapacity:60];
  
  [result appendFormat:@"MPInteger:%@",[self stringValue]];
  
  return result;
}

/**
 *
 */
+(MPInteger*) mpIntegerWithString:(NSString*)s
{ MPInteger* result = [[MPInteger alloc] initWithString:s];
  
  return result;
}

/**
 *
 */
-(BOOL) isEqual:(id)object 
{ BOOL result = NO;
  
  if( object==self )
    result = YES;
  else if( [object isKindOfClass:[MPInteger class]] && mpz_cmp( self->_number,((MPInteger*)object)->_number)==0 )
    result = YES;
  else if( [object isKindOfClass:[NSString class]] && [[self stringValue] isEqualToString:(NSString*)object] )
    result = YES;
  
  return result;
}

/**
 *
 */
-(NSString*) stringValue
{ NSString* result = nil;
  int       strLen = mpz_sizeinbase (_number, 10) + 2;
  char*     str    = calloc(sizeof(char), strLen);
  
  mpz_get_str(str,10,_number);
  
  result = [[NSString alloc] initWithUTF8String:str];
  
  free(str);
  
  return result;
}

/**
 *
 */
-(unsigned long) uintValue
{ unsigned long result = mpz_get_ui(self->_number);
  
  return result;
}

/**
 *
 */
-(long) intValue
{ long result = mpz_get_si(self->_number);
  
  return result;
}

/**
 *
 */
-(double) doubleValue
{ double result = mpz_get_d(self->_number);
  
  return result;
}

/**
 *
 */
-(MPInteger*) add:(MPInteger*)a
{ MPInteger* result = [[MPInteger alloc] init];
  
  if( a!=nil )
    mpz_add(result->_number,_number,a->_number);
  
  return result;
}

/**
 *
 */
-(MPInteger*) sub:(MPInteger*)a
{ MPInteger* result = [[MPInteger alloc] init];
  
  if( a!=nil )
    mpz_sub(result->_number,_number,a->_number);
  
  return result;
}

/**
 *
 */
-(MPInteger*) mul:(MPInteger*)a
{ MPInteger* result = [[MPInteger alloc] init];
  
  if( a!=nil )
    mpz_mul(result->_number,_number,a->_number);
  
  return result;
}

/**
 *
 */
-(MPInteger*) div:(MPInteger*)d
{ MPInteger* result = [[MPInteger alloc] init];
  
  if( d!=nil )
    mpz_tdiv_q(result->_number,self->_number,d->_number);
  
  return result;
}

/**
 *
 */
-(MPInteger*) mod:(MPInteger*)d
{ MPInteger* result = [[MPInteger alloc] init];
  
  if( d!=nil )
    mpz_tdiv_r(result->_number,self->_number,d->_number);
  
  return result;
}

/**
 *
 */
-(MPInteger*) powm:(MPInteger*)exp using:(MPInteger*)mod
{ MPInteger* result = [[MPInteger alloc] init];
  
  if( exp!=nil && mod!=nil )
    mpz_powm_sec(result->_number,self->_number,exp->_number,mod->_number);
  
  return result;
}

/**
 *
 */
-(MPInteger*) pow:(unsigned long)exp
{ MPInteger* result = [[MPInteger alloc] init];
  
  mpz_pow_ui(result->_number,self->_number,exp);
  
  return result;
}
@end
