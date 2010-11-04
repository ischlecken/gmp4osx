#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom32_mul
#define mpn_toomMN_mul_itch mpn_toom32_mul_itch

#define MIN_AN 6
#define MIN_BN(an) (((an) + 8) / (size_t) 3)
#define MAX_BN(an) ((an) - 2)

@interface gmp_unittest_mpn_toom32 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom32

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
