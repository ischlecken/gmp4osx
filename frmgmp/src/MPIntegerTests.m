//
//  MPIntegerTests.m
//  MPIntegerTests
//
//  Created by Stefan Thomas on 22.07.12.
//  Copyright (c) 2012 ischlecken. All rights reserved.
//

#import "MPIntegerTests.h"

#if TARGET_OS_EMBEDDED
  #import <iosgmp/MPInteger.h>
#else
  #import <osxgmp/MPInteger.h>
#endif

@implementation MPIntegerTests

- (void)setUp
{
  [super setUp];
}

- (void)tearDown
{  [super tearDown];
}

/**
 *
 */
- (void)testMPAdd
{ MPInteger* i = [MPInteger mpIntegerWithString:@"9999999999999999999999999999999999999999"];
  MPInteger* k = [MPInteger mpIntegerWithString:@"2"];
  MPInteger* r = [i add:k];
  
  STAssertTrue( [r isEqual:@"10000000000000000000000000000000000000001"],@"" );
}

/**
 *
 */
- (void)testMPSub
{ MPInteger* i = [MPInteger mpIntegerWithString:@"10000000000000000000000000000000000000001"];
  MPInteger* k = [MPInteger mpIntegerWithString:@"2"];
  MPInteger* r = [i sub:k];
  
  STAssertTrue( [r isEqual:@"9999999999999999999999999999999999999999"],@"" );
}

/**
 *
 */
- (void)testMPMul
{ MPInteger* i = [MPInteger mpIntegerWithString:@"10000000000000000000000000000000000000000"];
  MPInteger* k = [MPInteger mpIntegerWithString:@"2"];
  
  MPInteger* r = [i mul:k];
  
  STAssertTrue( [r isEqual:@"20000000000000000000000000000000000000000"],@"" );
}

/**
 *
 */
- (void)testMPDiv
{ MPInteger* i = [MPInteger mpIntegerWithString:@"10000000000000000000000000000000000000000"];
  MPInteger* k = [MPInteger mpIntegerWithString:@"2"];
  
  MPInteger* r = [i div:k];
  
  STAssertTrue( [r isEqual:@"5000000000000000000000000000000000000000"],@"" );
}

/**
 *
 */
- (void)testMPMod
{ MPInteger* i = [MPInteger mpIntegerWithString:@"10000000000000000000000000000000000000001"];
  MPInteger* k = [MPInteger mpIntegerWithString:@"2"];
  
  MPInteger* r = [i mod:k];
  
  STAssertTrue( [r isEqual:@"1"],@"" );
}

/**
 *
 */
- (void)testMPPowm
{ MPInteger* i = [MPInteger mpIntegerWithString:@"10000000000000000000000000000000000000000"];
  MPInteger* e = [MPInteger mpIntegerWithString:@"2"];
  MPInteger* m = [MPInteger mpIntegerWithString:@"13"];
  
  MPInteger* r = [i powm:e using:m];
  
  STAssertTrue( [r isEqual:@"9"],@"" );
}

/**
 *
 */
- (void)testExpression
{ MPInteger* i = [MPInteger mpIntegerWithString:@"3"];
  MPInteger* k = [MPInteger mpIntegerWithString:@"2"];
  
  MPInteger* r = [[[[i mul:k] add:k] sub:k] div:[MPInteger mpIntegerWithString:@"2"]];
  
  STAssertTrue( [r isEqual:@"3"],@"" );
}
@end
