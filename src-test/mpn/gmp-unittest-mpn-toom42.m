#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom42_mul
#define mpn_toomMN_mul_itch mpn_toom42_mul_itch

#define MIN_AN 10
#define MIN_BN(an) (((an) + 7) >> 2)
#define MAX_BN(an) ((2*(an)-5) / (size_t) 3)

@interface gmp_unittest_mpn_toom42 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom42

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

