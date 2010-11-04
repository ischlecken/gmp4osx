#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom53_mul
#define mpn_toomMN_mul_itch mpn_toom53_mul_itch

#define MIN_AN 17
#define MIN_BN(an) (1 + 2*(((an) + 4) / (size_t) 5))
#define MAX_BN(an) ((3*(an) - 11) >> 2)

@interface gmp_unittest_mpn_toom53 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom53

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
