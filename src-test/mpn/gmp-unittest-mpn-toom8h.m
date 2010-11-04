#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"

#include <stdlib.h>
#include <stdio.h>
#import <SenTestingKit/SenTestingKit.h>

#define mpn_toomMN_mul mpn_toom8h_mul
#define mpn_toomMN_mul_itch mpn_toom8h_mul_itch

/* Smaller sizes not supported; may lead to recursive calls to
   toom{22,33,44,6h}_mul with invalid input size. */
#define MIN_AN MUL_TOOM8H_THRESHOLD

#if GMP_NUMB_BITS <= 10*3
#define MIN_BN(an) (MAX ((an*6)/10, 86) )
#else
#if GMP_NUMB_BITS <= 11*3
#define MIN_BN(an) (MAX ((an*5)/11, 86) )
#else
#if GMP_NUMB_BITS <= 12*3
#define MIN_BN(an) (MAX ((an*4)/12, 86) )
#else
#define MIN_BN(an) (MAX ((an*4)/13, 86) )
#endif
#endif
#endif

@interface gmp_unittest_mpn_toom8h : SenTestCase 
{
}
@end

@implementation gmp_unittest_mpn_toom8h

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
