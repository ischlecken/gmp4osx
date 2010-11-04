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
#import "gmp-unittest-mpq-get-str.h"


@implementation gmp_unittest_mpq_get_str

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
-(void) checkOne:(mpq_srcptr) q :(int) base :(const char *) want
{
  char    *str, *ret;
  size_t  str_alloc;
  
  MPQ_CHECK_FORMAT (q);
  mp_trace_base = base;
  
  str_alloc =
  mpz_sizeinbase (mpq_numref(q), ABS(base)) +
  mpz_sizeinbase (mpq_denref(q), ABS(base)) + 3;
  
  str = mpq_get_str (NULL, base, q);
  if (strlen(str)+1 > str_alloc)
  {
    printf ("mpq_get_str size bigger than should be (passing NULL)\n");
    printf ("  base %d\n", base);
    printf ("  got  size %lu \"%s\"\n", (unsigned long)  strlen(str)+1, str);
    printf ("  want size %lu\n", (unsigned long) str_alloc);
    STFail(@"testCheckMonotonic()");
  }
  if (strcmp (str, want) != 0)
  {
    printf ("mpq_get_str wrong (passing NULL)\n");
    printf ("  base %d\n", base);
    printf ("  got  \"%s\"\n", str);
    printf ("  want \"%s\"\n", want);
    mpq_trace ("  q", q);
    STFail(@"testCheckMonotonic()");
  }
  (*__gmp_free_func) (str, strlen (str) + 1);
  
  str = (char *) (*__gmp_allocate_func) (str_alloc);
  
  ret = mpq_get_str (str, base, q);
  if (str != ret)
  {
    printf ("mpq_get_str wrong return value (passing non-NULL)\n");
    printf ("  base %d\n", base);
    printf ("  got  %p\n", ret);
    printf ("  want %p\n", want);
    STFail(@"testCheckMonotonic()");
  }
  if (strcmp (str, want) != 0)
  {
    printf ("mpq_get_str wrong (passing non-NULL)\n");
    printf ("  base %d\n", base);
    printf ("  got  \"%s\"\n", str);
    printf ("  want \"%s\"\n", want);
    STFail(@"testCheckMonotonic()");
  }
  (*__gmp_free_func) (str, str_alloc);
}

/**
 *
 */
-(void) checkAll:(mpq_srcptr) q :(int) base :(const char *) want
{
  char  *s;
  
  [self checkOne:q :base :want];
  
  s = __gmp_allocate_strdup (want);
  strtoupper (s);
  [self checkOne:q :-base :s];
  (*__gmp_free_func) (s, strlen(s)+1);
}

/**
 *
 */
-(void) testCheckData
{
  static const struct {
    int         base;
    const char  *num;
    const char  *den;
    const char  *want;
  } data[] = {
    { 10, "0", "1", "0" },
    { 10, "1", "1", "1" },
    
    { 16, "ffffffff", "1", "ffffffff" },
    { 16, "ffffffffffffffff", "1", "ffffffffffffffff" },
    
    { 16, "1", "ffffffff", "1/ffffffff" },
    { 16, "1", "ffffffffffffffff", "1/ffffffffffffffff" },
    { 16, "1", "10000000000000003", "1/10000000000000003" },
    
    { 10, "12345678901234567890", "9876543210987654323",
      "12345678901234567890/9876543210987654323" },
  };
  
  mpq_t  q;
  int    i;
  
  mpq_init (q);
  for (i = 0; i < numberof (data); i++)
  {
    mpz_set_str_or_abort (mpq_numref(q), data[i].num, data[i].base);
    mpz_set_str_or_abort (mpq_denref(q), data[i].den, data[i].base);
    
    [self checkAll:q :data[i].base :data[i].want];
  }
  mpq_clear (q);
}


@end