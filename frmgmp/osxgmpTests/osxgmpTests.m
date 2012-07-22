//
//  osxgmpTests.m
//  osxgmpTests
//
//  Created by Stefan Thomas on 22.07.12.
//  Copyright (c) 2012 ischlecken. All rights reserved.
//

#import "osxgmpTests.h"
#import <libgmp/gmp.h>

@implementation osxgmpTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
   
  mpz_t n;
  
  mpz_init (n);
  
  STAssertFalse(mpz_set_str (n, "12345", 0) ,@"format error");
  
  int class = mpz_probab_prime_p (n, 5);
  
  NSLog(@"prime class=%d",class);
}

@end
