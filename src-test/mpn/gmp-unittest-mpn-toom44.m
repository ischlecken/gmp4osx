#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom44_mul
#define mpn_toomMN_mul_itch mpn_toom44_mul_itch

/* Smaller sizes not supported; may lead to recursive calls to
   toom22_mul or toom33_mul with invalid input size. */
#define MIN_AN MUL_TOOM44_THRESHOLD
#define MIN_BN(an) (1 + 3*(((an)+3)>>2))

#define COUNT 1000

@interface gmp_unittest_mpn_toom44 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom44

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
