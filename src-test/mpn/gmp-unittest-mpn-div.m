/* Copyright 2006, 2007, 2009, 2010 Free Software Foundation, Inc.

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see http://www.gnu.org/licenses/.  */


#include <stdlib.h>		/* for strtol */
#include <stdio.h>		/* for printf */

#include "gmp.h"
#include "gmp-impl.h"
#include "longlong.h"
#include "tests/tests.h"

#import "gmp-unittest-mpn-div.h"

static void
dumpyxx (mp_srcptr p, mp_size_t n)
{
  mp_size_t i;
  if (n > 20)
    {
      for (i = n - 1; i >= n - 4; i--)
	{
	  printf ("%0*lx", (int) (2 * sizeof (mp_limb_t)), p[i]);
	  printf (" ");
	}
      printf ("... ");
      for (i = 3; i >= 0; i--)
	{
	  printf ("%0*lx", (int) (2 * sizeof (mp_limb_t)), p[i]);
	  printf (" " + (i == 0));
	}
    }
  else
    {
      for (i = n - 1; i >= 0; i--)
	{
	  printf ("%0*lx", (int) (2 * sizeof (mp_limb_t)), p[i]);
	  printf (" " + (i == 0));
	}
    }
  puts ("");
}

/* These are *bit* sizes. */
#ifndef SIZE_LOG
#define SIZE_LOG 17
#endif
#define MAX_DN (1L << SIZE_LOG)
#define MAX_NN (1L << (SIZE_LOG + 1))

#define COUNT 200

static mp_limb_t
random_wordxxx (gmp_randstate_ptr rs)
{
  mpz_t x;
  mp_limb_t r;
  TMP_DECL;
  TMP_MARK;
  
  MPZ_TMP_INIT (x, 2);
  mpz_urandomb (x, rs, 32);
  r = mpz_get_ui (x);
  TMP_FREE;
  return r;
}

static unsigned long test;

@implementation gmp_unittest_mpn_div

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



-(void) check_one:(mp_ptr) qp
                 :(mp_srcptr) rp
                 :(mp_srcptr) np
                 :(mp_size_t) nn
                 :(mp_srcptr) dp
                 :(mp_size_t) dn
                 :(char *) fname
                 :(mp_limb_t) q_allowed_err
{
  mp_size_t qn = nn - dn + 1;
  mp_ptr tp;
  const char *msg;
  const char *tvalue;
  mp_limb_t i;
  TMP_DECL;
  TMP_MARK;
  
  tp = TMP_ALLOC_LIMBS (nn + 1);
  if (dn >= qn)
    refmpn_mul (tp, dp, dn, qp, qn);
  else
    refmpn_mul (tp, qp, qn, dp, dn);
  
  for (i = 0; i < q_allowed_err && (tp[nn] > 0 || mpn_cmp (tp, np, nn) > 0); i++)
    ASSERT_NOCARRY (refmpn_sub (tp, tp, nn+1, dp, dn));
  
  if (tp[nn] > 0 || mpn_cmp (tp, np, nn) > 0)
  {
    msg = "q too large";
    tvalue = "Q*D";
  error:
    printf ("\r*******************************************************************************\n");
    printf ("%s failed test %lu: %s\n", fname, test, msg);
    printf ("N=    "); dumpyxx (np, nn);
    printf ("D=    "); dumpyxx (dp, dn);
    printf ("Q=    "); dumpyxx (qp, qn);
    if (rp)
    { printf ("R=    "); dumpyxx (rp, dn); }
    printf ("%5s=", tvalue); dumpyxx (tp, nn+1);
    printf ("nn = %ld, dn = %ld, qn = %ld\n", nn, dn, qn);
    STFail(@"check_one failed.");
  }
  
  ASSERT_NOCARRY (refmpn_sub_n (tp, np, tp, nn));
  tvalue = "N-Q*D";
  if (!mpn_zero_p (tp + dn, nn - dn) || mpn_cmp (tp, dp, dn) >= 0)
  {
    msg = "q too small";
    goto error;
  }
  
  if (rp && mpn_cmp (rp, tp, dn) != 0)
  {
    msg = "r incorrect";
    goto error;
  }
  
  TMP_FREE;
}

-(void) testDiv
{
  gmp_randstate_ptr rands;
  unsigned long maxnbits, maxdbits, nbits, dbits;
  mpz_t n, d, q, r, tz;
  mp_size_t maxnn, maxdn, nn, dn, clearn, i;
  mp_ptr np, dp, qp, rp;
  mp_limb_t t;
  gmp_pi1_t dinv;
  int count = COUNT;
  mp_ptr scratch;
  mp_limb_t ran;
  mp_size_t alloc, itch;
  mp_limb_t rran0, rran1, qran0, qran1;
  TMP_DECL;
  
  maxdbits = MAX_DN;
  maxnbits = MAX_NN;
  
  rands = RANDS;
  
  mpz_init (n);
  mpz_init (d);
  mpz_init (q);
  mpz_init (r);
  mpz_init (tz);
  
  maxnn = maxnbits / GMP_NUMB_BITS + 1;
  maxdn = maxdbits / GMP_NUMB_BITS + 1;
  
  TMP_MARK;
  
  qp = TMP_ALLOC_LIMBS (maxnn + 2) + 1;
  rp = TMP_ALLOC_LIMBS (maxnn + 2) + 1;
  
  alloc = 1;
  scratch = __GMP_ALLOCATE_FUNC_LIMBS (alloc);
  
  for (test = 0; test < count;)
  {
    do
    {
      nbits = random_wordxxx (rands) % (maxnbits - GMP_NUMB_BITS) + 2 * GMP_NUMB_BITS;
      if (maxdbits > nbits)
        dbits = random_wordxxx (rands) % nbits + 1;
      else
        dbits = random_wordxxx (rands) % maxdbits + 1;
    }
    while (nbits < dbits);
    
#if RAND_UNIFORM
#define RANDFUNC mpz_urandomb
#else
#define RANDFUNC mpz_rrandomb
#endif
    
    do
      RANDFUNC (d, rands, dbits);
    while (mpz_sgn (d) == 0);
    dn = SIZ (d);
    dp = PTR (d);
    dp[dn - 1] |= GMP_NUMB_HIGHBIT;
    
    if (test % 2 == 0)
    {
      RANDFUNC (n, rands, nbits);
      nn = SIZ (n);
      ASSERT_ALWAYS (nn >= dn);
    }
    else
    {
      do
	    {
	      RANDFUNC (q, rands, random_wordxxx (rands) % (nbits - dbits + 1));
	      RANDFUNC (r, rands, random_wordxxx (rands) % mpz_sizeinbase (d, 2));
	      mpz_mul (n, q, d);
	      mpz_add (n, n, r);
	      nn = SIZ (n);
	    }
      while (nn > maxnn || nn < dn);
    }
    
    ASSERT_ALWAYS (nn <= maxnn);
    ASSERT_ALWAYS (dn <= maxdn);
    
    np = PTR (n);
    
    mpz_urandomb (tz, rands, 32);
    t = mpz_get_ui (tz);
    
    if (t % 17 == 0)
      dp[dn - 1] = GMP_NUMB_MAX;
    
    switch (t % 16)
    {
      case 0:
        clearn = random_wordxxx (rands) % nn;
        for (i = clearn; i < nn; i++)
          np[i] = 0;
        break;
      case 1:
        mpn_sub_1 (np + nn - dn, dp, dn, random_wordxxx (rands));
        break;
      case 2:
        mpn_add_1 (np + nn - dn, dp, dn, random_wordxxx (rands));
        break;
    }
    
    test++;
    
    invert_pi1 (dinv, dp[dn - 1], dp[dn - 2]);
    
    rran0 = random_wordxxx (rands);
    rran1 = random_wordxxx (rands);
    qran0 = random_wordxxx (rands);
    qran1 = random_wordxxx (rands);
    
    qp[-1] = qran0;
    qp[nn - dn + 1] = qran1;
    rp[-1] = rran0;
    
    ran = random_wordxxx (rands);
    
    if ((double) (nn - dn) * dn < 1e5)
    {
      /* Test mpn_sbpi1_div_qr */
      if (dn > 2)
	    {
	      MPN_COPY (rp, np, nn);
	      if (nn > dn)
          MPN_ZERO (qp, nn - dn);
	      qp[nn - dn] = mpn_sbpi1_div_qr (qp, rp, nn, dp, dn, dinv.inv32);
	      [self check_one:qp: rp: np: nn: dp: dn: "mpn_sbpi1_div_qr": 0];
	    }
      
      /* Test mpn_sbpi1_divappr_q */
      if (dn > 2)
	    {
	      MPN_COPY (rp, np, nn);
	      if (nn > dn)
          MPN_ZERO (qp, nn - dn);
	      qp[nn - dn] = mpn_sbpi1_divappr_q (qp, rp, nn, dp, dn, dinv.inv32);
	      [self check_one:qp: NULL: np: nn: dp: dn: "mpn_sbpi1_divappr_q": 1];
	    }
      
      /* Test mpn_sbpi1_div_q */
      if (dn > 2)
	    {
	      MPN_COPY (rp, np, nn);
	      if (nn > dn)
          MPN_ZERO (qp, nn - dn);
	      qp[nn - dn] = mpn_sbpi1_div_q (qp, rp, nn, dp, dn, dinv.inv32);
	      [self check_one:qp: NULL: np: nn: dp: dn: "mpn_sbpi1_div_q": 0];
	    }
    }
    
    /* Test mpn_dcpi1_div_qr */
    if (dn >= 6 && nn - dn >= 3)
    {
      MPN_COPY (rp, np, nn);
      if (nn > dn)
        MPN_ZERO (qp, nn - dn);
      qp[nn - dn] = mpn_dcpi1_div_qr (qp, rp, nn, dp, dn, &dinv);
      ASSERT_ALWAYS (qp[-1] == qran0);  ASSERT_ALWAYS (qp[nn - dn + 1] == qran1);
      ASSERT_ALWAYS (rp[-1] == rran0);
      [self check_one:qp: rp: np: nn: dp: dn: "mpn_dcpi1_div_qr": 0];
    }
    
    /* Test mpn_dcpi1_divappr_q */
    if (dn >= 6 && nn - dn >= 3)
    {
      MPN_COPY (rp, np, nn);
      if (nn > dn)
        MPN_ZERO (qp, nn - dn);
      qp[nn - dn] = mpn_dcpi1_divappr_q (qp, rp, nn, dp, dn, &dinv);
      ASSERT_ALWAYS (qp[-1] == qran0);  ASSERT_ALWAYS (qp[nn - dn + 1] == qran1);
      ASSERT_ALWAYS (rp[-1] == rran0);
      [self check_one:qp: NULL: np: nn: dp: dn: "mpn_dcpi1_divappr_q": 1];
    }
    
    /* Test mpn_dcpi1_div_q */
    if (dn >= 6 && nn - dn >= 3)
    {
      MPN_COPY (rp, np, nn);
      if (nn > dn)
        MPN_ZERO (qp, nn - dn);
      qp[nn - dn] = mpn_dcpi1_div_q (qp, rp, nn, dp, dn, &dinv);
      ASSERT_ALWAYS (qp[-1] == qran0);  ASSERT_ALWAYS (qp[nn - dn + 1] == qran1);
      ASSERT_ALWAYS (rp[-1] == rran0);
      [self check_one:qp: NULL: np: nn: dp: dn: "mpn_dcpi1_div_q": 0];
    }
    
    /* Test mpn_mu_div_qr */
    if (nn - dn > 2 && dn >= 2)
    {
      itch = mpn_mu_div_qr_itch (nn, dn, 0);
      if (itch + 1 > alloc)
	    {
	      scratch = __GMP_REALLOCATE_FUNC_LIMBS (scratch, alloc, itch + 1);
	      alloc = itch + 1;
	    }
      scratch[itch] = ran;
      MPN_ZERO (qp, nn - dn);
      MPN_ZERO (rp, dn);
      rp[dn] = rran1;
      qp[nn - dn] = mpn_mu_div_qr (qp, rp, np, nn, dp, dn, scratch);
      ASSERT_ALWAYS (ran == scratch[itch]);
      ASSERT_ALWAYS (qp[-1] == qran0);  ASSERT_ALWAYS (qp[nn - dn + 1] == qran1);
      ASSERT_ALWAYS (rp[-1] == rran0);  ASSERT_ALWAYS (rp[dn] == rran1);
      [self check_one:qp: rp: np: nn: dp: dn: "mpn_mu_div_qr": 0];
    }
    
    /* Test mpn_mu_divappr_q */
    if (nn - dn > 2 && dn >= 2)
    {
      itch = mpn_mu_divappr_q_itch (nn, dn, 0);
      if (itch + 1 > alloc)
	    {
	      scratch = __GMP_REALLOCATE_FUNC_LIMBS (scratch, alloc, itch + 1);
	      alloc = itch + 1;
	    }
      scratch[itch] = ran;
      MPN_ZERO (qp, nn - dn);
      qp[nn - dn] = mpn_mu_divappr_q (qp, np, nn, dp, dn, scratch);
      ASSERT_ALWAYS (ran == scratch[itch]);
      ASSERT_ALWAYS (qp[-1] == qran0);  ASSERT_ALWAYS (qp[nn - dn + 1] == qran1);
      [self check_one:qp: NULL: np: nn: dp: dn: "mpn_mu_divappr_q": 4];
    }
    
    /* Test mpn_mu_div_q */
    if (nn - dn > 2 && dn >= 2)
    {
      itch = mpn_mu_div_q_itch (nn, dn, 0);
      if (itch + 1> alloc)
	    {
	      scratch = __GMP_REALLOCATE_FUNC_LIMBS (scratch, alloc, itch + 1);
	      alloc = itch + 1;
	    }
      scratch[itch] = ran;
      MPN_ZERO (qp, nn - dn);
      qp[nn - dn] = mpn_mu_div_q (qp, np, nn, dp, dn, scratch);
      ASSERT_ALWAYS (ran == scratch[itch]);
      ASSERT_ALWAYS (qp[-1] == qran0);  ASSERT_ALWAYS (qp[nn - dn + 1] == qran1);
      [self check_one:qp: NULL: np: nn: dp: dn: "mpn_mu_div_q": 0];
    }
    
    
    if (1)
    {
      itch = nn + 1;
      if (itch + 1> alloc)
	    {
	      scratch = __GMP_REALLOCATE_FUNC_LIMBS (scratch, alloc, itch + 1);
	      alloc = itch + 1;
	    }
      scratch[itch] = ran;
      mpn_div_q (qp, np, nn, dp, dn, scratch);
      ASSERT_ALWAYS (ran == scratch[itch]);
      ASSERT_ALWAYS (qp[-1] == qran0);  ASSERT_ALWAYS (qp[nn - dn + 1] == qran1);
      [self check_one:qp: NULL: np: nn: dp: dn: "mpn_div_q": 0];
    }
    
    /* Finally, test mpn_div_q without msb set.  */
    dp[dn - 1] &= ~GMP_NUMB_HIGHBIT;
    if (dp[dn - 1] == 0)
      continue;
    
    itch = nn + 1;
    if (itch + 1> alloc)
    {
      scratch = __GMP_REALLOCATE_FUNC_LIMBS (scratch, alloc, itch + 1);
      alloc = itch + 1;
    }
    scratch[itch] = ran;
    mpn_div_q (qp, np, nn, dp, dn, scratch);
    ASSERT_ALWAYS (ran == scratch[itch]);
    ASSERT_ALWAYS (qp[-1] == qran0);  ASSERT_ALWAYS (qp[nn - dn + 1] == qran1);
    [self check_one:qp: NULL: np: nn: dp: dn: "mpn_div_q": 0];
  }
  
  __GMP_FREE_FUNC_LIMBS (scratch, alloc);
  
  TMP_FREE;
  
  mpz_clear (n);
  mpz_clear (d);
  mpz_clear (q);
  mpz_clear (r);
  mpz_clear (tz);
}
@end

