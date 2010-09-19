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
  int   repeatCount=1;
  
  mpz_init(a);
  mpz_init(b);
  mpz_init(c);
  
  if( argc>=3 )
  {
    mpz_set_str(a,argv[1],10);
    mpz_set_str(b,argv[2],10);
    
    if( argc>=4 )
      repeatCount = atoi(argv[3]);
    
    for (int i=0; i<repeatCount; i++) 
    { mpz_mul(c,a,b);
    }
    
    gmp_printf ("%d: %Zd * %Zd = %Zd\n", repeatCount, a,b,c);
  } // of if
  
  mpz_clear(a);
  mpz_clear(b);
  mpz_clear(c);
  
} // of main()
//================END-OF-FILE=================