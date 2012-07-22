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
{ MPInteger* i = [[MPInteger alloc] initWithString:@"9999999999999999999999999999999999999999"];
  MPInteger* k = [[MPInteger alloc] initWithString:@"2"];
  
  [i add:k];
  
  NSString* result = [i stringValue];
  
  STAssertTrue( [result isEqualToString:@"10000000000000000000000000000000000000001"],@"" );
}

/**
 *
 */
- (void)testMPSub
{ MPInteger* i = [[MPInteger alloc] initWithString:@"10000000000000000000000000000000000000001"];
  MPInteger* k = [[MPInteger alloc] initWithString:@"2"];
  
  [i sub:k];
  
  NSString* result = [i stringValue];
  
  STAssertTrue( [result isEqualToString:@"9999999999999999999999999999999999999999"],@"" );
}

/**
 *
 */
- (void)testMPMul
{ MPInteger* i = [[MPInteger alloc] initWithString:@"10000000000000000000000000000000000000000"];
  MPInteger* k = [[MPInteger alloc] initWithString:@"2"];
  
  [i mul:k];
  
  NSString* result = [i stringValue];
  
  STAssertTrue( [result isEqualToString:@"20000000000000000000000000000000000000000"],@"" );
}
@end
