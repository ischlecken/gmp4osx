#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom33_mul
#define mpn_toomMN_mul_itch mpn_toom33_mul_itch

/* Smaller sizes not supported; may lead to recursive calls to
   toom22_mul with invalid input size. */
#define MIN_AN MUL_TOOM33_THRESHOLD
#define MIN_BN(an) (1 + 2*(((an)+2)/(size_t) 3))

#define COUNT 1000

@interface gmp_unittest_mpn_toom33 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom33

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
