#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom43_mul
#define mpn_toomMN_mul_itch mpn_toom43_mul_itch

#define MIN_AN 25
#define MIN_BN(an) (1 + 2*(((an)+3) >> 2))
#define MAX_BN(an) ((an)-3)

@interface gmp_unittest_mpn_toom43 : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom43

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
