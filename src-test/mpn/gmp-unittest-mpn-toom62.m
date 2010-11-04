#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom62_mul
#define mpn_toomMN_mul_itch mpn_toom62_mul_itch

#define MIN_AN 31
#define MIN_BN(an) (((an) + 11) / (size_t) 6)
#define MAX_BN(an) ((2*(an) - 7) / (size_t) 5)

@interface gmp_unittest_mpn_toom62 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom62

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

