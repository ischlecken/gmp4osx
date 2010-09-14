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


@end
