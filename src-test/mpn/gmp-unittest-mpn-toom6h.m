#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>


#define mpn_toomMN_mul mpn_toom6h_mul
#define mpn_toomMN_mul_itch mpn_toom6h_mul_itch

/* Smaller sizes not supported; may lead to recursive calls to
   toom22_mul, toom33_mul, or toom44_mul with invalid input size. */
#define MIN_AN MUL_TOOM6H_THRESHOLD
#define MIN_BN(an) (MAX ((an*3)>>3, 42) )



@interface gmp_unittest_mpn_toom6h : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom6h

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
