/*
 *  gmp-calc.c
 *  gmp
 *
 *  Created by Feldmaus on 16.09.10.
 *  Copyright 2010 Stefan Thomas. All rights reserved.
 *
 */

#include "gmp-calc.h"


int main (int argc, char **argv)
{
  mpz_t a,b,c;
  
  mpz_init(a);
  mpz_init(b);
  mpz_init(c);
  
  if( argc>=3 )
  {
    long al = atol(argv[1]);
    long bl = atol(argv[2]);
    
    mpz_set_ui(a,al);
    mpz_set_ui(b,bl);
    
    mpz_mul(c,a,b);
    
    gmp_printf ("%Zd * %Zd = %Zd\n", a,b,c);
  } // of if
  
} // of main()
//================END-OF-FILE=================