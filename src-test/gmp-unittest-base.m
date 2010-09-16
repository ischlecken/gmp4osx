//
//  first.m
//  gmp
//
//  Created by Feldmaus on 14.09.10.
//  Copyright 2010 Stefan Thomas. All rights reserved.
//
#import <stdio.h>
#import <stdlib.h>

#import "gmp.h"
#import "gmp-impl.h"
#import "longlong.h"
#import "tests.h"

#import "gmp-unittest-base.h"


@implementation GmpUnittestBase

/**
 *
 */
-(void) setUp
{
  tests_start ();
  mp_trace_base = -16;
  
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
-(void) testCheckData
{
#define M  MP_LIMB_T_MAX
  
  static const struct {
    mp_limb_t  want_dh,want_dl, mh,ml, sh,sl;
  } data[] = {
    { 0,0,  0,0,  0,0 },
    { 0,0,  0,1,  0,1 },
    { 0,0,  1,2,  1,2 },
    
    { 0,1,  0,2,  0,1 },
    { 0,M,  1,0,  0,1 },
    { M,M,  0,0,  0,1 },
    
    { M,M,  0,M-1,  0,M },
    { 0,0,  0,M-1,  0,M-1 },
    { 0,1,  0,M-1,  0,M-2 },
  };
  int  i;
  mp_limb_t  got_dh, got_dl;
  
  for (i = 0; i < numberof (data); i++)
  {
    sub_ddmmss (got_dh,got_dl, data[i].mh,data[i].ml, data[i].sh,data[i].sl);
    if (got_dh != data[i].want_dh || got_dl != data[i].want_dl)
    {
      printf ("check_data wrong at data[%d]\n", i);
      mp_limb_trace ("  mh", data[i].mh);
      mp_limb_trace ("  ml", data[i].ml);
      mp_limb_trace ("  sh", data[i].sh);
      mp_limb_trace ("  sl", data[i].sl);
      mp_limb_trace ("  want dh", data[i].want_dh);
      mp_limb_trace ("  want dl", data[i].want_dl);
      mp_limb_trace ("  got dh ", got_dh);
      mp_limb_trace ("  got dl ", got_dl);
      
      STFail(@"check_data wrong at data[%d].",i);
    }
  }
}

/**
 *
 */
-(void) testCheckRandom
{
  mp_limb_t  want_dh,want_dl, got_dh,got_dl, mh,ml, sh,sl;
  int  i;
  
  for (i = 0; i < 20; i++)
  {
    mh = urandom ();
    ml = urandom ();
    sh = urandom ();
    sl = urandom ();
    
    refmpn_sub_ddmmss (&want_dh,&want_dl, mh,ml, sh,sl);
    
    sub_ddmmss (got_dh,got_dl, mh,ml, sh,sl);
    
    if (got_dh != want_dh || got_dl != want_dl)
    {
      printf ("check_data wrong at data[%d]\n", i);
      mp_limb_trace ("  mh", mh);
      mp_limb_trace ("  ml", ml);
      mp_limb_trace ("  sh", sh);
      mp_limb_trace ("  sl", sl);
      mp_limb_trace ("  want dh", want_dh);
      mp_limb_trace ("  want dl", want_dl);
      mp_limb_trace ("  got dh ", got_dh);
      mp_limb_trace ("  got dl ", got_dl);
    
      STFail(@"check_data wrong at data[%d].",i);
    }
  }
}

/**
 *
 */
-(void) testPopC
{
  mp_limb_t  src, want, got;
  int        i;
  
  mp_trace_base = -16;
  
  for (i = 0; i < GMP_LIMB_BITS; i++)
  {
    src = CNST_LIMB(1) << i;
    want = 1;
    
    popc_limb (got, src);
    if (got != want)
    {
    error:
      printf ("popc_limb wrong result\n");
      mpn_trace ("  src ", &src,  (mp_size_t) 1);
      mpn_trace ("  want", &want, (mp_size_t) 1);
      mpn_trace ("  got ", &got,  (mp_size_t) 1);
      
      STFail(@"popc_limb wrong result.");
    }
  }
    
  for (i = 0; i < 100; i++)
  {
    mpn_random2 (&src, (mp_size_t) 1);
    want = ref_popc_limb (src);
    
    popc_limb (got, src);
    if (got != want)
      goto error;
  }
  

}


/**
 *
 */
-(void)checkOne :(int) want :(unsigned long)n
{
  int  got;
  ULONG_PARITY (got, n);
  if (got != want)
  {
    STFail(@"ULONG_PARITY wrong, n=%lX, want=%d, got=%d.",n,want,got);
  }
}

/**
 *
 */
-(void) testCheckVarious
{
  int  i;
  
  [self checkOne:0 :0L];
  [self checkOne:BITS_PER_ULONG & 1 :ULONG_MAX];
  [self checkOne:0 :0x11L];
  [self checkOne:1 :0x111L];
  [self checkOne:1 :0x3111L];
  
  for (i = 0; i < BITS_PER_ULONG; i++)
    [self checkOne:1 :1L << i]  ;
}

/**
 *
 */
-(void) oneInvertLimb:(mp_limb_t) n
{
  mp_limb_t  inv, prod;
  
  binvert_limb (inv, n);
  prod = (inv * n) & GMP_NUMB_MASK;
  if (prod != 1)
  {
    printf ("binvert_limb wrong\n");
    mp_limb_trace ("  n       ", n);
    mp_limb_trace ("  got     ", inv);
    mp_limb_trace ("  product ", prod);
    
    STFail(@"binvert_limb wrong.");
  }
}

/**
 *
 */
-(void) testSomeInvertLimb
{
  int  i;
  for (i = 0; i < 10000; i++)
    [self oneInvertLimb: (refmpn_random_limb () | 1)];
}

/**
 *
 */
-(void) testHighToMask
{
  STAssertTrue (LIMB_HIGHBIT_TO_MASK (0) == 0,@"LIMB_HIGHBIT_TO_MASK (0) != 0");
  STAssertTrue (LIMB_HIGHBIT_TO_MASK (GMP_LIMB_HIGHBIT) == MP_LIMB_T_MAX,@"LIMB_HIGHBIT_TO_MASK (GMP_LIMB_HIGHBIT) != MP_LIMB_T_MAX");
  STAssertTrue (LIMB_HIGHBIT_TO_MASK (MP_LIMB_T_MAX) == MP_LIMB_T_MAX,@"LIMB_HIGHBIT_TO_MASK (MP_LIMB_T_MAX) != MP_LIMB_T_MAX");
  STAssertTrue (LIMB_HIGHBIT_TO_MASK (GMP_LIMB_HIGHBIT >> 1) == 0,@"LIMB_HIGHBIT_TO_MASK (GMP_LIMB_HIGHBIT >> 1) != 0");
  STAssertTrue (LIMB_HIGHBIT_TO_MASK (MP_LIMB_T_MAX >> 1) == 0,@"LIMB_HIGHBIT_TO_MASK (MP_LIMB_T_MAX >> 1) != 0");
    
}



/**
 *
 */
-(void) testGmpUIntMax
{
#ifdef UINT_MAX
  if (__GMP_UINT_MAX != UINT_MAX)
  { 
    STFail(@"__GMP_UINT_MAX incorrect:  __GMP_UINT_MAX  %u  0x%X   UINT_MAX        %u  0x%X", __GMP_UINT_MAX, __GMP_UINT_MAX, UINT_MAX, UINT_MAX);    
  }
#endif
}

/**
 *
 */
-(void) testGmpULongMax
{
    /* gcc 2.95.2 limits.h on solaris 2.5.1 incorrectly selects a 64-bit
 LONG_MAX, leading to some integer overflow in ULONG_MAX and a spurious
 __GMP_ULONG_MAX != ULONG_MAX.  Casting ULONG_MAX to unsigned long is a
 workaround.  */
#ifdef ULONG_MAX
  if (__GMP_ULONG_MAX != (unsigned long) ULONG_MAX)
  {
    STFail(@"__GMP_ULONG_MAX incorrect  __GMP_ULONG_MAX  %lu  0x%lX   ULONG_MAX        %lu  0x%lX", __GMP_ULONG_MAX, __GMP_ULONG_MAX, ULONG_MAX, ULONG_MAX);
  }
#endif
}

/**
 *
 */
-(void) testGmpUShortMax
{
#ifdef USHRT_MAX
  if (__GMP_USHRT_MAX != USHRT_MAX)
  {
    STFail(@"__GMP_USHRT_MAX incorrect  __GMP_USHRT_MAX  %hu  0x%hX   USHRT_MAX        %hu  0x%hX", __GMP_USHRT_MAX, __GMP_USHRT_MAX, USHRT_MAX, USHRT_MAX);
  }
#endif
}

/**
 *
 */
-(void) check_clz:(int) want  :(mp_limb_t) n
{
  int  got;
  count_leading_zeros (got, n);
  
  if (got != want)
  {
    printf        ("count_leading_zeros wrong\n");
    mp_limb_trace ("  n    ", n);
    printf        ("  want %d\n", want);
    printf        ("  got  %d\n", got);
    STFail(@"count_leading_zeros wrong");
  }
}

/**
 *
 */
-(void) check_ctz:(int) want :(mp_limb_t) n
{
  int  got;
  count_trailing_zeros (got, n);
  if (got != want)
  {
    printf ("count_trailing_zeros wrong\n");
    mpn_trace ("  n    ", &n, (mp_size_t) 1);
    printf    ("  want %d\n", want);
    printf    ("  got  %d\n", got);
    STFail(@"count_trailing_zeros wrong");
  }
}

/**
 *
 */
-(void) testCheckVariousClzCtz
{
  int        i;
  
#ifdef COUNT_LEADING_ZEROS_0
  [self check_clz:COUNT_LEADING_ZEROS_0  :CNST_LIMB(0);
#endif
  
  for (i=0; i < GMP_LIMB_BITS; i++)
  {
    [self check_clz:i :CNST_LIMB(1) << (GMP_LIMB_BITS-1-i)];
    [self check_ctz:i :CNST_LIMB(1) << i];
    
    [self check_ctz:i :MP_LIMB_T_MAX << i];
    [self check_clz:i :MP_LIMB_T_MAX >> i];
  }
}

/**
 *
 */
-(void) testBSwap
{
  mp_limb_t  src, want, got;
  int        i;
  
  mp_trace_base = -16;
  
  for (i = 0; i < 1000; i++)
  {
    mpn_random (&src, (mp_size_t) 1);
    
    want = ref_bswap_limb (src);
    
    BSWAP_LIMB (got, src);
    if (got != want)
    {
      printf ("BSWAP_LIMB wrong result\n");
    error:
      mpn_trace ("  src ", &src,  (mp_size_t) 1);
      mpn_trace ("  want", &want, (mp_size_t) 1);
      mpn_trace ("  got ", &got,  (mp_size_t) 1);
      STFail(@"BSWAP_LIMB wrong result");
    }
    
    BSWAP_LIMB_FETCH (got, &src);
    if (got != want)
    {
      printf ("BSWAP_LIMB_FETCH wrong result\n");
      goto error;
    }
    
    BSWAP_LIMB_STORE (&got, src);
    if (got != want)
    {
      printf ("BSWAP_LIMB_STORE wrong result\n");
      goto error;
    }
  }
  
   
}
   

@end
