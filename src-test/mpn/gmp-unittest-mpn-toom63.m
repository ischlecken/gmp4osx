#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom63_mul
#define mpn_toomMN_mul_itch mpn_toom63_mul_itch

#define MIN_AN 49
#define MIN_BN(an) (2*(((an) + 23) / (size_t) 6))	/* 2/6 */
#define MAX_BN(an) ((3*(an) - 23)  / (size_t) 5)	/* 3/5 */

@interface gmp_unittest_mpn_toom63 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom63

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
