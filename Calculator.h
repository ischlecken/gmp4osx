//
//  Calculator.h
//  gmp-calc
//
//  Created by Feldmaus on 18.09.10.
//  Copyright 2010 ischlecken.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <gmp/gmp.h>

@interface Calculator : NSObject 
{
/*
  mpz_t operandA;
  mpz_t operandB;
  mpz_t operandC;
*/
  NSString* operandA;
  NSString* operandB;
  NSString* operandC;
  
}

-(void) setOperandA:(NSString*) opA;
-(NSString*) operandA;

-(void) setOperandB:(NSString*) opB;
-(NSString*) operandB;


-(NSString*) operandC;

-(void) add;
-(void) sub;
-(void) times;
-(void) divide;
-(void) power;

@end
