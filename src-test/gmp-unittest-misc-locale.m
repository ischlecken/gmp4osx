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

#define _GNU_SOURCE    /* for DECIMAL_POINT in glibc langinfo.h */

#include "config.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if HAVE_NL_TYPES_H
#include <nl_types.h>  /* for nl_item (on netbsd 1.4.1 at least) */
#endif

#if HAVE_LANGINFO_H
#include <langinfo.h>  /* for nl_langinfo */
#endif

#if HAVE_LOCALE_H
#include <locale.h>    /* for lconv */
#endif

#include "gmp.h"
#include "gmp-impl.h"
#include "tests.h"
#import "gmp-unittest-misc-locale.h"

char *decimal_point;

/* Replace the libc localeconv with one we can manipulate. */
#if HAVE_LOCALECONV
struct lconv *
localeconv (void)
{
  static struct lconv  l;
  l.decimal_point = decimal_point;
  return &l;
}
#endif

/* Replace the libc nl_langinfo with one we can manipulate. */
#if HAVE_NL_LANGINFO
char *
nl_langinfo (nl_item n)
{
#if defined (DECIMAL_POINT)
  if (n == DECIMAL_POINT)
    return decimal_point;
#endif
#if defined (RADIXCHAR)
  if (n == RADIXCHAR)
    return decimal_point;
#endif
  return "";
}
#endif

@implementation gmp_unittest_misc_locale

/**
 *
 */
-(void) setUp
{
  tests_memory_start ();
  
  
  
}

/**
 *
 */
-(void) tearDown
{
  tests_memory_end ();
  
  decimal_point = ".";
}

-(void) testCheckInput 
{
  {
    mpf_t  f;
    char   buf[128];
    mpf_init (f);
    decimal_point = ",";
    mpf_set_d (f, 1.5);
    gmp_snprintf (buf, sizeof(buf), "%.1Ff", f);
    mpf_clear (f);
    if (strcmp (buf, "1,5") != 0)
    {
      printf ("Test skipped, replacing localeconv/nl_langinfo doesn't work\n");
      return;
    }
  }  
  
  static char *point[] = {
    ".", ",", "WU", "STR", "ZTV***"
  };
  
  static const struct {
    const char  *str;
    double      d;
  } data[] = {
    
    { "1%s",   1.0 },
    { "1%s0",  1.0 },
    { "1%s00", 1.0 },
    
    { "%s5",    0.5 },
    { "0%s5",   0.5 },
    { "00%s5",  0.5 },
    { "00%s50", 0.5 },
    
    { "1%s5",    1.5 },
    { "1%s5e1", 15.0 },
  };
  
  int     i, j, neg, ret;
  char    str[128];
  mpf_t   f;
  double  d;
  
  mpf_init (f);
  
  for (i = 0; i < numberof (point); i++)
  {
    decimal_point = point[i];
    
    for (neg = 0; neg <= 1; neg++)
    {
      for (j = 0; j < numberof (data); j++)
      {
        strcpy (str, neg ? "-" : "");
        sprintf (str+strlen(str), data[j].str, decimal_point);
        
        d = data[j].d;
        if (neg)
          d = -d;
        
        mpf_set_d (f, 123.0);
        if (mpf_set_str (f, str, 10) != 0)
        {
          printf ("mpf_set_str error\n");
          printf ("  point  %s\n", decimal_point);
          printf ("  str    %s\n", str);
          STFail(@"testCheckLocale()");
        }
        if (mpf_cmp_d (f, d) != 0)
        {
          printf    ("mpf_set_str wrong result\n");
          printf    ("  point  %s\n", decimal_point);
          printf    ("  str    %s\n", str);
          mpf_trace ("  f", f);
          printf    ("  d=%g\n", d);
          STFail(@"testCheckLocale()");
        }
        
        mpf_set_d (f, 123.0);
        ret = gmp_sscanf (str, "%Ff", f);
        if (ret != 1)
        {
          printf ("gmp_sscanf wrong return value\n");
          printf ("  point  %s\n", decimal_point);
          printf ("  str    %s\n", str);
          printf ("  ret    %d\n", ret);
          STFail(@"testCheckLocale()");
        }
        if (mpf_cmp_d (f, d) != 0)
        {
          printf    ("gmp_sscanf wrong result\n");
          printf    ("  point  %s\n", decimal_point);
          printf    ("  str    %s\n", str);
          mpf_trace ("  f", f);
          printf    ("  d=%g\n", d);
          STFail(@"testCheckLocale()");
        }
      }
    }
  }
  mpf_clear (f);
}

@end
