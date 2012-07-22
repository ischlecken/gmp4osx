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
-(MPInteger*) add:(MPInteger*)a
{ if( a!=nil )
    mpz_add(_number,_number,a->_number);
  
  return self;
}
@end
