/* Test mpq_cmp.
 
 Copyright 1996, 2001 Free Software Foundation, Inc.
 
 This file is part of the GNU MP Library.
 
 The GNU MP Library is free software; you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as published by
 the Free Software Foundation; either version 3 of the License, or (at your
 option) any later version.
 
 The GNU MP Library is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 License for more details.
 
 You should have received a copy of the GNU Lesser General Public License
 along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.  */

#include <stdio.h>
#include <stdlib.h>

#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"
#import "gmp-unittest-mpq-cmp.h"

#define NUM(x) (&((x)->_mp_num))
#define DEN(x) (&((x)->_mp_den))

#define SGN(x) ((x) < 0 ? -1 : (x) > 0 ? 1 : 0)



@implementation gmp_unittest_mpq_cmp
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

/**
 *
 */
-(int) ref_mpq_cmp:(mpq_t) a :(mpq_t) b
{
  mpz_t ai, bi;
  int cc;
  
  mpz_init (ai);
  mpz_init (bi);
  
  mpz_mul (ai, NUM (a), DEN (b));
  mpz_mul (bi, NUM (b), DEN (a));
  cc = mpz_cmp (ai, bi);
  mpz_clear (ai);
  mpz_clear (bi);
  return cc;
}

#ifndef SIZE
#define SIZE 8	/* increasing this lowers the probabilty of finding an error */
#endif

/**
 *
 */
-(void) testMpqCmp
{
  mpq_t a, b;
  mp_size_t size;
  int reps = 10000;
  int i;
  int cc, ccref;
    
  mpq_init (a);
  mpq_init (b);
  
  for (i = 0; i < reps; i++)
  {
    size = urandom () % SIZE - SIZE/2;
    mpz_random2 (NUM (a), size);
    do
    {
      size = urandom () % SIZE - SIZE/2;
      mpz_random2 (DEN (a), size);
    }
    while (mpz_cmp_ui (DEN (a), 0) == 0);
    
    size = urandom () % SIZE - SIZE/2;
    mpz_random2 (NUM (b), size);
    do
    {
      size = urandom () % SIZE - SIZE/2;
      mpz_random2 (DEN (b), size);
    }
    while (mpz_cmp_ui (DEN (b), 0) == 0);
    
    mpq_canonicalize (a);
    mpq_canonicalize (b);
    
    ccref = [self ref_mpq_cmp:a :b];
    cc = mpq_cmp (a, b);
    
    if (SGN (ccref) != SGN (cc))
      STFail(@"testMpqCmp(): SGN (ccref) != SGN (cc)");
  }
  
  mpq_clear (a);
  mpq_clear (b);
}


@end
