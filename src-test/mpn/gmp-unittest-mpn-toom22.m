#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom22_mul
#define mpn_toomMN_mul_itch mpn_toom22_mul_itch
#define MIN_AN 2

#define MIN_BN(an)				\
  ((an) >= 2*MUL_TOOM22_THRESHOLD		\
   ? (an) + 2 - MUL_TOOM22_THRESHOLD		\
   : ((an)+1)/2 + 1)

@interface gmp_unittest_mpn_toom22 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom22

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
