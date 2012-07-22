//
//  osxgmpTests.m
//  osxgmpTests
//
//  Created by Stefan Thomas on 22.07.12.
//  Copyright (c) 2012 ischlecken. All rights reserved.
//

#import "osxgmpTests.h"
#import <osxgmp/MPInteger.h>

@implementation osxgmpTests

- (void)setUp
{
  [super setUp];
}

- (void)tearDown
{  [super tearDown];
}

- (void)testMPAdd
{
  MPInteger* i = [[MPInteger alloc] initWithString:@"9999999999999999999999999999999999999999"];
  MPInteger* k = [[MPInteger alloc] initWithString:@"2"];
  
  [i add:k];
  
  NSString* result = [i stringValue];
  
  STAssertTrue( [result isEqualToString:@"10000000000000000000000000000000000000001"],@"" );
}

@end
