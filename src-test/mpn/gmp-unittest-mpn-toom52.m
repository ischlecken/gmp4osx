#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom52_mul
#define mpn_toomMN_mul_itch mpn_toom52_mul_itch

#define MIN_AN 32
#define MIN_BN(an) (((an) + 9) / (size_t) 5)
#define MAX_BN(an) (((an) - 3) >> 1)

@interface gmp_unittest_mpn_toom52 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom52

/**
 *
 */
-(void) setUp
{
  tests_start ();
}

/**
 *
 */
-(void) tearDown
{
  tests_end ();
}

#include "toom-shared.h"
@end
